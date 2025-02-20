local ServerStorage = game:GetService("ServerStorage")
local PlayerDataManager = require(ServerStorage.Source.PlayerData.PlayerDataManager)

game.Players.PlayerAdded:Connect(function(player)
	PlayerDataManager.InitPlayer(player)
end)

game.Players.PlayerRemoving:Connect(function(player)
	PlayerDataManager.DeinitPlayer(player)
end)

game:BindToClose(function()
	while next(PlayerDataManager.Loaded) do
		task.wait()
	end
end)
