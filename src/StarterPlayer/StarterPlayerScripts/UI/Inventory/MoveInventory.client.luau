--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local inventoryGui = playerGui:WaitForChild("Inventory") :: ScreenGui
local inventoryContainer = inventoryGui:FindFirstChild("Container") :: ImageLabel
local moveWindowButton = inventoryContainer:FindFirstChild("MoveWindow") :: TextButton

local dragging = false
local dragStart = Vector2.zero
local guiStartPos = UDim2.new(0, 0, 0, 0)

local mouse = player:GetMouse()

local function onInputBegan(input: InputObject)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = Vector2.new(mouse.X, mouse.Y)
        guiStartPos = inventoryContainer.Position

        while dragging do
            task.wait()
            local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
            inventoryContainer.Position =
                UDim2.new(guiStartPos.X.Scale, guiStartPos.X.Offset + delta.X, guiStartPos.Y.Scale, guiStartPos.Y.Offset + delta.Y)
        end
    end
end

moveWindowButton.InputBegan:Connect(onInputBegan)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
