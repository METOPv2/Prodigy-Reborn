local InterfaceUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface")
local FrontCircle = InterfaceUI:FindFirstChild("FrontCircle", true)
local PercentageLabel = FrontCircle.Percentage

local Level = game.Players.LocalPlayer:WaitForChild("PlayerData").Level
local EXP = game.Players.LocalPlayer:WaitForChild("PlayerData").EXP

local LevelManager = require(game.ReplicatedStorage.Source.ModuleScripts.LevelManager)

local function UpdateUI()
    PercentageLabel.Text = string.format("%.1f%%", (EXP.Value / LevelManager:CalculateExpGoal(Level.Value)) * 100)
end

UpdateUI()
EXP.Changed:Connect(UpdateUI)
Level.Changed:Connect(UpdateUI)
