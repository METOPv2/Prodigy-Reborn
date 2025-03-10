local items = require(game.ReplicatedStorage.Source.Inventory.Data.Items)
game.ReplicatedStorage.RemoteEvents.GetAllItems_Test.OnServerEvent:Connect(function(player)
	local inventory = player.Inventory
	for itemName, itemData in pairs(items) do
		for i = 1, 5 do
			local newItem = Instance.new("StringValue")
			newItem.Name = itemName
			newItem.Parent = inventory
		end
	end
end)

game.ReplicatedStorage.RemoteEvents.GetMoney_Test.OnServerEvent:Connect(function(player)
	player.PlayerData.Money.Value += 1000
end)
