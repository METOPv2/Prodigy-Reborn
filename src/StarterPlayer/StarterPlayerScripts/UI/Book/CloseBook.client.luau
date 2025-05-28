local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local background = bookGui:WaitForChild("Background") :: ImageLabel
local closeButton = background.CloseButton :: TextButton

local function activated()
    bookGui.Enabled = false
end

closeButton.Activated:Connect(activated)
