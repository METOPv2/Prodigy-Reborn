--!strict
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui
local phoneBackground = phoneGui:FindFirstChild("Background") :: ImageLabel
local moveZone1 = phoneBackground:FindFirstChild("MoveZone1") :: Frame
local moveZone2 = phoneBackground:FindFirstChild("MoveZone2") :: Frame
local cover = phoneBackground:FindFirstChild("Cover") :: ImageLabel

local dragging = false
local dragStart = Vector2.zero
local guiStartPos = UDim2.new(0, 0, 0, 0)

local mouse = player:GetMouse()

local function onInputBegan(input: InputObject)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = Vector2.new(mouse.X, mouse.Y)
        guiStartPos = phoneBackground.Position

        while dragging do
            task.wait()
            local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
            phoneBackground.Position =
                UDim2.new(guiStartPos.X.Scale, guiStartPos.X.Offset + delta.X, guiStartPos.Y.Scale, guiStartPos.Y.Offset + delta.Y)
        end
    end
end

local moveZones: { GuiObject } = { moveZone1, moveZone2, cover }
for _, zone: GuiObject in ipairs(moveZones) do
    zone.InputBegan:Connect(onInputBegan)
end

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
