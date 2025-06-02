--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Items = require(ReplicatedStorage.Source.Inventory.Data.Items)
local LevelManager = require(ReplicatedStorage.Source.ModuleScripts.LevelManager)

local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents") :: Folder
local getAllItemsRemoteEvent = remoteEvents:FindFirstChild("GetAllItems_Test") :: RemoteEvent
local getMoneyRetemoEvent = remoteEvents:FindFirstChild("GetMoney_Test") :: RemoteEvent
local getSkillPointsRemoteEvent = remoteEvents:FindFirstChild("GetSkillPoints_Test") :: RemoteEvent
local levelUp_Test = remoteEvents:FindFirstChild("LevelUp_Test") :: RemoteEvent

getAllItemsRemoteEvent.OnServerEvent:Connect(function(player)
    local inventory = player:FindFirstChild("Inventory") :: Folder

    for itemName: string, _ in pairs(Items) do
        for _ = 1, 5 do
            local newItem = Instance.new("StringValue")
            newItem.Name = itemName
            newItem.Parent = inventory
        end
    end
end)

getMoneyRetemoEvent.OnServerEvent:Connect(function(player)
    local playerData = player:FindFirstChild("PlayerData") :: Folder
    local playerMoney = playerData:FindFirstChild("Money") :: IntValue
    playerMoney.Value += 100000000
end)

getSkillPointsRemoteEvent.OnServerEvent:Connect(function(player)
    local playerData = player:FindFirstChild("PlayerData") :: Folder
    local playerSkillPoints = playerData:FindFirstChild("SkillPoints") :: IntValue
    playerSkillPoints.Value += 100
end)

levelUp_Test.OnServerEvent:Connect(function(player)
    local playerData = player:FindFirstChild("PlayerData") :: Folder
    local level = playerData:FindFirstChild("Level") :: IntValue
    local exp = playerData:FindFirstChild("EXP") :: IntValue
    local expGoal = LevelManager:CalculateExpGoal(level.Value)

    exp.Value += expGoal - exp.Value
end)
