local PlayerChats = require(game.ServerStorage.Source.ModuleScripts.PlayerChats)

game.ReplicatedStorage.RemoteFunctions.GetChats.OnServerInvoke = function(player)
	return PlayerChats[player.UserId]
end
