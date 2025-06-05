--!strict
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local interfaceGui = playerGui:WaitForChild("Interface") :: ScreenGui
local interfaceBackground = interfaceGui:FindFirstChild("Background") :: ImageLabel
local manaBar = interfaceBackground:FindFirstChild("ManaBar") :: Frame
local manaProgressBar = manaBar:FindFirstChild("Progress") :: ImageLabel
local manaProgressFrame = manaProgressBar:FindFirstChild("Frame") :: Frame
local manaTextLabel = manaBar:FindFirstChild("TextLabel") :: TextLabel

local playerData = player:WaitForChild("PlayerData") :: Folder
local maxStamina = playerData:FindFirstChild("MaxStamina") :: IntValue
local currentStamina = playerData:FindFirstChild("CurrentStamina") :: IntValue

local function updateManaBar()
    manaProgressFrame.Size = UDim2.fromScale(1 - currentStamina.Value / maxStamina.Value, 1)
    manaTextLabel.Text = string.format(
        "<stroke color='#000000' joins='miter' thickness='2'><font color='#0e83de'>[</font>%d/%d<font color='#0e83de'>]</font></stroke>",
        currentStamina.Value,
        maxStamina.Value
    )
end

updateManaBar() -- Initial update

currentStamina.Changed:Connect(updateManaBar)
maxStamina.Changed:Connect(updateManaBar)
