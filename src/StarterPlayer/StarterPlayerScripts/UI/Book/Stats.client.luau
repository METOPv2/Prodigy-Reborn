--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents") :: Folder
local increaseStatsRemoteEvent = remoteEvents:FindFirstChild("IncreaseStats") :: RemoteEvent

local player = Players.LocalPlayer
local playerStats = player:WaitForChild("Stats") :: Folder

local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local bookBackground = bookGui:FindFirstChild("Background") :: ImageLabel
local statsTab = bookBackground:FindFirstChild("Stats") :: Frame
local statsHolder = statsTab:WaitForChild("Holder") :: Frame

for _, statFrame in ipairs(statsHolder:GetChildren()) do
    if not statFrame:IsA("Frame") then
        continue
    end

    local playerStat = playerStats:FindFirstChild(statFrame.Name) :: IntValue

    local textLabel = statFrame:FindFirstChild("TextLabel") :: TextLabel
    textLabel.Text = string.format("%s: %d", statFrame.Name, playerStat.Value)

    local buttons = statFrame:FindFirstChild("Buttons") :: Frame
    local downButton = buttons:FindFirstChild("Down") :: Frame
    local downTextButton = downButton:FindFirstChild("TextButton") :: TextButton
    downTextButton.Activated:Connect(function()
        increaseStatsRemoteEvent:FireServer(playerStat.Name, -1)
    end)

    local upButton = buttons:FindFirstChild("Up") :: Frame
    local upTextButton = upButton:FindFirstChild("TextButton") :: TextButton
    upTextButton.Activated:Connect(function()
        increaseStatsRemoteEvent:FireServer(playerStat.Name, 1)
    end)

    playerStat.Changed:Connect(function()
        textLabel.Text = string.format("%s: %d", statFrame.Name, playerStat.Value)
    end)
end
