--!strict
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local bookBackground = bookGui:FindFirstChild("Background") :: ImageLabel
local interfaceGui = playerGui:WaitForChild("Interface") :: ScreenGui
local interfaceBackground = interfaceGui:FindFirstChild("Background") :: ImageLabel
local openBookButton = interfaceBackground:FindFirstChild("Book") :: ImageButton

openBookButton.Activated:Connect(function()
    bookGui.Enabled = not bookGui.Enabled
    bookBackground.Position = UDim2.fromScale(0.5, 0.5)
end)
