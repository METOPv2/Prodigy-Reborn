local Players = game:GetService("Players")

local InterfaceUI = Players.LocalPlayer.PlayerGui:WaitForChild("Interface")
local LevelFrame = InterfaceUI:FindFirstChild("Level", true)
local First = LevelFrame.First
local Second = LevelFrame.Second
local Third = LevelFrame.Third

local level = Players.LocalPlayer:WaitForChild("PlayerData").Level

local function UpdateUI()
    if level.Value < 1000 then
        Third.TextLabel.Text = level.Value % 10
        Second.TextLabel.Text = math.floor((level.Value % 100) / 10)
        First.TextLabel.Text = math.floor((level.Value % 1000) / 100)
    else
        Third.TextLabel.Text = "X"
        Second.TextLabel.Text = "A"
        First.TextLabel.Text = "M"
    end
end

UpdateUI()
level.Changed:Connect(UpdateUI)
