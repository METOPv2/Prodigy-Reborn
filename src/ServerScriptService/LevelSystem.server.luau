--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LevelManager = require(ReplicatedStorage.Source.ModuleScripts.LevelManager)
local connections = {}

Players.PlayerAdded:Connect(function(player)
    local playerData = player:WaitForChild("PlayerData") :: Folder
    local level = playerData:FindFirstChild("Level") :: IntValue
    local exp = playerData:FindFirstChild("EXP") :: IntValue
    local skillPoints = playerData:FindFirstChild("SkillPoints") :: IntValue

    local function expChanged(newExp)
        local expGoal = LevelManager:CalculateExpGoal(level.Value)
        if newExp >= expGoal then
            exp.Value = 0
            level.Value += 1
            skillPoints.Value += 10
        end
    end

    connections[player] = exp.Changed:Connect(expChanged)
end)

Players.PlayerRemoving:Connect(function(player)
    local expConnection = connections[player]
    if expConnection then
        expConnection:Disconnect()
        connections[player] = nil
    end
end)
