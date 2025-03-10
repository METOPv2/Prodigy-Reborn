local dropMoneyEvent = game.ReplicatedStorage.RemoteEvents.DropMoney
local CurrencyModule = require(game.ServerStorage.Source.ModuleScripts.CurrencyModule)

dropMoneyEvent.OnServerEvent:Connect(function(player: Player, amount: number)
    local playersMoney = player.PlayerData.Money
    if playersMoney.Value < amount then
        return
    end
    CurrencyModule.SpawnCash(player.Character:GetPivot().Position, amount)
    playersMoney.Value -= amount
end)
