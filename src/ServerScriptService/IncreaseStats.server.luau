--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents") :: Folder
local increaseStatsRemoteEvent = remoteEvents:FindFirstChild("IncreaseStats") :: RemoteEvent

increaseStatsRemoteEvent.OnServerEvent:Connect(function(player: Player, statName: string, amount: number)
    if not statName or type(statName) ~= "string" or not amount or type(amount) ~= "number" or amount == 0 then
        return
    end

    local playerStats = player:FindFirstChild("Stats") :: Folder
    local playerStat = playerStats:FindFirstChild(statName) :: IntValue

    if not playerStat or playerStat.ClassName ~= "IntValue" then
        return
    end

    local playerData = player:FindFirstChild("PlayerData") :: Folder
    local skillPoints = playerData:FindFirstChild("SkillPoints") :: IntValue

    if amount > 0 and skillPoints.Value >= amount then
        playerStat.Value += amount
        skillPoints.Value -= amount
    elseif amount < 0 and playerStat.Value >= amount and playerStat.Value > 0 then
        playerStat.Value -= math.abs(amount)
        skillPoints.Value += math.abs(amount)
    end
end)
