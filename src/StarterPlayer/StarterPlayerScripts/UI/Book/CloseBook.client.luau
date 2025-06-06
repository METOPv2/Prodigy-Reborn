--!strict
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local bookBackground = bookGui:FindFirstChild("Background") :: ImageLabel
local closeButton = bookBackground:FindFirstChild("CloseButton") :: TextButton

closeButton.Activated:Connect(function()
    bookGui.Enabled = false
    bookBackground.Position = UDim2.fromScale(0.5, 0.5)
end)
