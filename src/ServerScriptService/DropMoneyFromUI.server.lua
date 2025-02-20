local dropMoneyEvent = game.ReplicatedStorage.RemoteEvents.DropMoney
local currentModule = require(game.ServerStorage.CurrencyModule)

dropMoneyEvent.OnServerEvent:Connect(function(player: Player, amount: number)
	local playersMoney = player.PlayerData.Money
	if playersMoney.Value < amount then
		return
	end
	currentModule.SpawnCash(player, player.Character:GetPivot().Position, amount)
	playersMoney.Value -= amount
end)
