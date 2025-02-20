game.ReplicatedStorage.RemoteEvents.RemoveAllItems.OnServerEvent:Connect(function(player)
	player.Inventory:ClearAllChildren()
end)
