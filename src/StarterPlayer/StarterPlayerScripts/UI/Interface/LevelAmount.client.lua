local InterfaceUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface")
local LevelFrame = InterfaceUI:FindFirstChild("Level", true)
local First = LevelFrame.First
local Second = LevelFrame.Second
local Third = LevelFrame.Third

local Level = game.Players.LocalPlayer:WaitForChild("PlayerData").Level

local function UpdateUI()
    if Level.Value < 1000 then
        Third.TextLabel.Text = Level.Value % 10
        Second.TextLabel.Text = math.floor((Level.Value % 100) / 10)
        First.TextLabel.Text = math.floor((Level.Value % 1000) / 100)
    else
        Third.TextLabel.Text = "X"
        Second.TextLabel.Text = "A"
        First.TextLabel.Text = "M"
    end
end

UpdateUI()
Level.Changed:Connect(UpdateUI)
