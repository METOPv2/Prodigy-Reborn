--!strict
local DataStoreService = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")

local InventoryDataStore = DataStoreService:GetDataStore("Player", "Inventory")
local ValuesDataStore = DataStoreService:GetDataStore("Player", "Values")
local StatsStore = DataStoreService:GetDataStore("Player", "Stats")

local PlayerDataTemplate = require(ServerStorage.Source.PlayerData.PlayerDataTemplate)
local PlayerDataStoreSettings = require(ServerStorage.Source.Settings.PlayerDataStore)

local PlayerDataManager = {}
local Loaded = {}

function PlayerDataManager.InitPlayer(player: Player)
    local playerData = Instance.new("Folder")
    playerData.Name = "PlayerData"

    local valuesSuccess, savedValues = pcall(function()
        return ValuesDataStore:GetAsync("Player_" .. tostring(player.UserId))
    end)

    if valuesSuccess then
        savedValues = savedValues or PlayerDataTemplate.Values

        local level = Instance.new("IntValue")
        level.Name = "Level"
        level.Value = savedValues.Level
        level.Parent = playerData

        local exp = Instance.new("IntValue")
        exp.Name = "EXP"
        exp.Value = savedValues.EXP
        exp.Parent = playerData

        local money = Instance.new("IntValue")
        money.Name = "Money"
        money.Value = savedValues.Money
        money.Parent = playerData

        local skillPoints = Instance.new("IntValue")
        skillPoints.Name = "SkillPoints"
        skillPoints.Value = savedValues.SkillPoints
        skillPoints.Parent = playerData

        playerData.Parent = player
    else
        player:Kick(PlayerDataStoreSettings.ErrorMessages.Values)
        return
    end

    local inventorySuccess, savedInventory = pcall(function()
        return InventoryDataStore:GetAsync("Player_" .. tostring(player.UserId))
    end)

    if inventorySuccess then
        savedInventory = savedInventory or PlayerDataTemplate.Inventory

        local inventory = Instance.new("Folder")
        inventory.Name = "Inventory"

        for _, item in ipairs(savedInventory) do
            local newItem = Instance.new("StringValue")
            newItem.Name = item.Name

            for n, v in pairs(item) do
                if n ~= "Name" then
                    newItem:SetAttribute(n, v)
                end
            end

            newItem.Parent = inventory
        end

        inventory.Parent = player
    else
        player:Kick(PlayerDataStoreSettings.ErrorMessages.Inventory)
        return
    end

    local statsSuccess, savedStats = pcall(function()
        return StatsStore:GetAsync("Player_" .. tostring(player.UserId))
    end)

    if statsSuccess then
        savedStats = savedStats or PlayerDataTemplate.Stats

        local stats = Instance.new("Folder")
        stats.Name = "Stats"

        for name, value in pairs(savedStats) do
            local statsValue = Instance.new("IntValue")
            statsValue.Name = name
            statsValue.Value = value
            statsValue.Parent = stats
        end

        stats.Parent = player
    else
        player:Kick(PlayerDataStoreSettings.ErrorMessages.Stats)
        return
    end

    Loaded[player] = true
end

function PlayerDataManager.DeinitPlayer(player: Player)
    if not Loaded[player] then
        return
    end

    local inventory = {}
    local playerInventory = player:FindFirstChild("Inventory") :: Folder

    for _, item in ipairs(playerInventory:GetChildren()) do
        local itemToSave = {
            Name = item.Name,
        }

        for attName, attValue in pairs(item:GetAttributes()) do
            itemToSave[attName] = attValue
        end

        table.insert(inventory, itemToSave)
    end

    local success, attempt = false, 0

    repeat
        attempt += 1
        success = pcall(function()
            return InventoryDataStore:SetAsync("Player_" .. tostring(player.UserId), inventory)
        end)
    until success or attempt == 5

    local playerData = player:FindFirstChild("PlayerData") :: Folder
    local playerMoney = playerData:FindFirstChild("Money") :: NumberValue
    local playerLevel = playerData:FindFirstChild("Level") :: IntValue
    local playerEXP = playerData:FindFirstChild("EXP") :: IntValue
    local playerSkillPoints = playerData:FindFirstChild("SkillPoints") :: IntValue

    local values = {
        Money = playerMoney.Value,
        Level = playerLevel.Value,
        EXP = playerEXP.Value,
        SkillPoints = playerSkillPoints.Value,
    }

    success = false
    attempt = 0

    repeat
        attempt += 1
        success = pcall(function()
            return ValuesDataStore:SetAsync("Player_" .. tostring(player.UserId), values)
        end)
    until success or attempt == 5

    local stats = player:FindFirstChild("Stats") :: Folder
    local statValues = {}

    for name: string, value: number in pairs(PlayerDataTemplate.Stats) do
        local playerStat = stats:FindFirstChild(name) :: IntValue
        statValues[name] = playerStat.Value or value
    end

    success = false
    attempt = 0

    repeat
        attempt += 1
        success = pcall(function()
            return StatsStore:SetAsync("Player_" .. tostring(player.UserId), statValues)
        end)
    until success or attempt == 5

    Loaded[player] = nil
end

return PlayerDataManager
