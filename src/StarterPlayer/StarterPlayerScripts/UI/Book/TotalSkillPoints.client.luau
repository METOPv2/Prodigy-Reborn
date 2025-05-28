--!strict
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerData = player:WaitForChild("PlayerData") :: Folder
local skillPoints = playerData:WaitForChild("SkillPoints") :: IntValue

local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local bookBackground = bookGui:FindFirstChild("Background") :: ImageLabel
local statsUi = bookBackground:FindFirstChild("Stats") :: Frame
local totalSkillPointsTextLabel = statsUi:FindFirstChild("TotalSkillPoints") :: TextLabel

local function updateUi()
    totalSkillPointsTextLabel.Text = string.format("Skill Points: %d", skillPoints.Value)
end

skillPoints.Changed:Connect(updateUi)
updateUi()
