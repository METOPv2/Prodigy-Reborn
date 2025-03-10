-- Services
local Players = game:GetService("Players")

-- Character
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid

-- UI
local PlayerGui = Player.PlayerGui
local HealthBar = PlayerGui:WaitForChild("Interface").Background.HealthBar
local ProgressFrame = HealthBar.Progress.Frame
local ProgressText = HealthBar.TextLabel

-- Functions
local function UpdateUI()
    ProgressFrame.Size = UDim2.fromScale(1 - Humanoid.Health / Humanoid.MaxHealth, 1)
    ProgressText.Text = string.format(
        "<stroke color='#000000' joins='miter' thickness='2'><font color='#ba0000'>[</font>%d/%d<font color='#ba0000'>]</font></stroke>",
        Humanoid.Health,
        Humanoid.MaxHealth
    )
end

-- Initialize UI
UpdateUI()

-- Events
Humanoid.HealthChanged:Connect(UpdateUI)
