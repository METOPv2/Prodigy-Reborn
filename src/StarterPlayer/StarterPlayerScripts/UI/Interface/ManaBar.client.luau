local InterfaceUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface")
local ManaBar = InterfaceUI:FindFirstChild("ManaBar", true)
local ProgressFrame = ManaBar.Progress.Frame
local ManaText = ManaBar.TextLabel

local CurrentStamina = game.ReplicatedStorage.Stamina.CurrentStamina
local MaxStamina = game.ReplicatedStorage.Stamina.MaxStamina

local function UpdateUI()
    ProgressFrame.Size = UDim2.fromScale(1 - CurrentStamina.Value / MaxStamina.Value, 1)
    ManaText.Text = string.format(
        "<stroke color='#000000' joins='miter' thickness='2'><font color='#0e83de'>[</font>%d/%d<font color='#0e83de'>]</font></stroke>",
        CurrentStamina.Value,
        MaxStamina.Value
    )
end

UpdateUI()
CurrentStamina.Changed:Connect(UpdateUI)
MaxStamina.Changed:Connect(UpdateUI)
