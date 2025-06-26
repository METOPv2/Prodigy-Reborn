local player = game.Players.LocalPlayer
local phoneBackground = player.PlayerGui:WaitForChild("Phone").Background
local mouse = player:GetMouse()

local dragging = false
local dragStart = Vector2.zero
local guiStartPos = UDim2.new(0, 0, 0, 0)

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

for _, zone: GuiObject in ipairs({ phoneBackground.Cover, phoneBackground }) do
    zone.InputBegan:Connect(onInputBegan)
end

game.UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
