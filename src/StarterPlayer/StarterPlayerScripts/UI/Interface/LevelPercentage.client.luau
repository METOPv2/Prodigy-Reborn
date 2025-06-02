--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LevelManager = require(ReplicatedStorage.Source.ModuleScripts.LevelManager)

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local interfaceGui = playerGui:WaitForChild("Interface") :: ScreenGui
local interfaceBackground = interfaceGui:FindFirstChild("Background") :: ImageLabel
local frontCircle = interfaceBackground:FindFirstChild("FrontCircle") :: ImageLabel
local percentageLabel = frontCircle:FindFirstChild("Percentage") :: TextLabel

local playerData = player:WaitForChild("PlayerData") :: Folder
local level = playerData:FindFirstChild("Level") :: IntValue
local exp = playerData:FindFirstChild("EXP") :: IntValue

local function updateTextLabel()
    percentageLabel.Text = string.format("%.1f%%", (exp.Value / LevelManager:CalculateExpGoal(level.Value)) * 100)
end

updateTextLabel()
exp.Changed:Connect(updateTextLabel)
level.Changed:Connect(updateTextLabel)
