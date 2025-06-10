--!strict
local DataStoreService = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")

local InventoryDataStore = DataStoreService:GetDataStore("PlayerData")
local ValuesDataStore = DataStoreService:GetDataStore("Player", "Values")
local StatsStore = DataStoreService:GetDataStore("Player", "Stats")

local PlayerDataTemplate = require(ServerStorage.Source.PlayerData.PlayerDataTemplate)
local PlayerDataStoreSettings = require(ServerStorage.Source.Settings.PlayerDataStore)

local PlayerDataManager = {}
local Loaded = {}

local function initPlayerData(player: Player)
    local playerData = Instance.new("Folder")
    playerData.Name = "PlayerData"

    local valuesSuccess, savedValues = pcall(function()
        return ValuesDataStore:GetAsync("Player_" .. tostring(player.UserId))
    end)

    if valuesSuccess then
        savedValues = savedValues or PlayerDataTemplate.Values

        for name, value in pairs(PlayerDataTemplate.Values) do
            if not savedValues[name] then
                savedValues[name] = value
            end
        end

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

        local maxStamina = Instance.new("IntValue")
        maxStamina.Name = "MaxStamina"
        maxStamina.Value = 100
        maxStamina.Parent = playerData

        local musicVolume = Instance.new("NumberValue")
        musicVolume.Name = "MusicVolume"
        musicVolume.Value = savedValues.MusicVolume
        musicVolume.Parent = playerData

        local sfxVolume = Instance.new("NumberValue")
        sfxVolume.Name = "SFXVolume"
        sfxVolume.Value = savedValues.SFXVolume
        sfxVolume.Parent = playerData

        local currentStamina = Instance.new("IntValue")
        currentStamina.Name = "CurrentStamina"
        -- currentStamina.Value = savedValues.Stamina or 0
        currentStamina.Parent = playerData

        if savedValues.Stamina then
            currentStamina.Value = savedValues.Stamina
        else
            currentStamina.Value = maxStamina.Value
        end

        playerData.Parent = player
    else
        player:Kick(PlayerDataStoreSettings.ErrorMessages.Values)
        return
    end
end

local function initInventory(player: Player)
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
end

local function initStats(player: Player)
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
end

local function saveInventory(player: Player)
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
end

local function savePlayerData(player: Player)
    local playerData = player:FindFirstChild("PlayerData") :: Folder
    local playerMoney = playerData:FindFirstChild("Money") :: NumberValue
    local playerLevel = playerData:FindFirstChild("Level") :: IntValue
    local playerEXP = playerData:FindFirstChild("EXP") :: IntValue
    local playerSkillPoints = playerData:FindFirstChild("SkillPoints") :: IntValue
    local currentStamina = playerData:FindFirstChild("CurrentStamina") :: IntValue
    local musicVolume = playerData:FindFirstChild("MusicVolume") :: NumberValue
    local sfxVolume = playerData:FindFirstChild("SFXVolume") :: NumberValue

    local values = {
        Money = playerMoney.Value,
        Level = playerLevel.Value,
        EXP = playerEXP.Value,
        SkillPoints = playerSkillPoints.Value,
        Stamina = currentStamina.Value,
        MusicVolume = musicVolume.Value,
        SFXVolume = sfxVolume.Value,
    }

    local success = false
    local attempt = 0

    repeat
        attempt += 1
        success = pcall(function()
            return ValuesDataStore:SetAsync("Player_" .. tostring(player.UserId), values)
        end)
    until success or attempt == 5
end

local function saveStats(player: Player)
    local stats = player:FindFirstChild("Stats") :: Folder
    local statValues = {}

    for name: string, value: number in pairs(PlayerDataTemplate.Stats) do
        local playerStat = stats:FindFirstChild(name) :: IntValue
        statValues[name] = playerStat.Value or value
    end

    local success = false
    local attempt = 0

    repeat
        attempt += 1
        success = pcall(function()
            return StatsStore:SetAsync("Player_" .. tostring(player.UserId), statValues)
        end)
    until success or attempt == 5
end

function PlayerDataManager.InitPlayer(player: Player)
    if Loaded[player] then
        return
    end

    initInventory(player)
    initPlayerData(player)
    initStats(player)

    Loaded[player] = true
end

function PlayerDataManager.DeinitPlayer(player: Player)
    if not Loaded[player] then
        return
    end

    saveInventory(player)
    savePlayerData(player)
    saveStats(player)

    Loaded[player] = nil
end

return PlayerDataManager
