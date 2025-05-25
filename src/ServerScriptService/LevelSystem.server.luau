local levelManager = require(game.ReplicatedStorage.Source.ModuleScripts.LevelManager)
local connections = {}

game.Players.PlayerAdded:Connect(function(player)
    local level: IntValue = player:WaitForChild("PlayerData").Level
    local exp: IntValue = player:WaitForChild("PlayerData").EXP

    local connectionExp = exp.Changed:Connect(function(newValue)
        if newValue >= levelManager:CalculateExpGoal(level.Value) then
            exp.Value = 0
            level.Value += 1
        end
    end)

    table.insert(connections, connectionExp)
end)

game.Players.PlayerRemoving:Connect(function(player)
    if connections[player] then
        for _, connection: RBXScriptConnection in ipairs(connections[player]) do
            connection:Disconnect()
        end
        connections[player] = nil
    end
end)
