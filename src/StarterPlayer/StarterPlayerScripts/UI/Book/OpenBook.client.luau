--!strict
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local interfaceGui = playerGui:WaitForChild("Interface") :: ScreenGui
local background = interfaceGui:WaitForChild("Background") :: ImageLabel
local bookButton = background:FindFirstChild("Book") :: ImageButton

local function activated()
    bookGui.Enabled = not bookGui.Enabled
end

bookButton.Activated:Connect(activated)
