local DataStoreService = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")
local InventoryDataStore = DataStoreService:GetDataStore("Player", "Inventory")
local ValuesDataStore = DataStoreService:GetDataStore("Player", "Values")
local Templates = require(ServerStorage.Source.PlayerData.PlayerDataTemplate)
local PlayerDataManager = {
	Loaded = {},
}

function PlayerDataManager.InitPlayer(player: Player)
	local playerData = Instance.new("Folder")
	playerData.Name = "PlayerData"

	local valuesSuccess, savedValues = pcall(function()
		return ValuesDataStore:GetAsync("Player_" .. tostring(player.UserId))
	end)

	if valuesSuccess then
		savedValues = savedValues or Templates.Values

		local level = Instance.new("IntValue")
		level.Name = "Level"
		level.Value = savedValues.Level
		level.Parent = playerData

		local exp = Instance.new("IntValue")
		exp.Name = "EXP"
		exp.Value = savedValues.EXP
		exp.Parent = playerData

		local money = Instance.new("NumberValue")
		money.Name = "Money"
		money.Value = savedValues.Money
		money.Parent = playerData
	else
		return player:Kick("Failed to load values. Please rejoin or join later.")
	end

	playerData.Parent = player

	local inventorySuccess, savedInventory = pcall(function()
		return InventoryDataStore:GetAsync("Player_" .. tostring(player.UserId))
	end)

	if inventorySuccess then
		savedInventory = savedInventory or Templates.Inventory

		local inventory = Instance.new("Folder")
		inventory.Name = "Inventory"

		if savedInventory then
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
		end

		inventory.Parent = player
	else
		player:Kick("Failed to load your data. Rejoin or join later, please.")
	end

	PlayerDataManager.Loaded[player] = true
end

function PlayerDataManager.DeinitPlayer(player: Player)
	if not PlayerDataManager.Loaded[player] then
		return
	end

	local inventory = {}

	for _, item: StringValue in ipairs(player.Inventory:GetChildren()) do
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

	success = false
	attempt = 0
	local values = {
		Money = player.PlayerData.Money.Value,
		Level = player.PlayerData.Level.Value,
		EXP = player.PlayerData.EXP.Value,
	}

	repeat
		attempt += 1
		success = pcall(function()
			return ValuesDataStore:SetAsync("Player_" .. tostring(player.UserId), values)
		end)
	until success or attempt == 5

	PlayerDataManager.Loaded[player] = nil
end

return PlayerDataManager
