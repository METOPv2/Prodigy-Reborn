local Players = game:GetService("Players")

local PlayerChats = require(game.ServerStorage.Source.ModuleScripts.PlayerChats)

Players.PlayerAdded:Connect(function(player)
	PlayerChats[player.UserId] = {}
end)

Players.PlayerRemoving:Connect(function(player)
	PlayerChats[player.UserId] = {}
end)
