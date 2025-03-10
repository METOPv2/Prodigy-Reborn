local RunService = game:GetService("RunService")

local InventoryUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local MoveWindowButton = InventoryUI:FindFirstChild("MoveWindow", true)
local Window = MoveWindowButton.Parent

local mouse = game.Players.LocalPlayer:GetMouse()

MoveWindowButton.MouseButton1Down:Connect(function()
    local startingMousePoint = Vector2.new(mouse.X, mouse.Y)
    local startingWindowsPoint = Window.Position
    RunService:BindToRenderStep("InventoryWindowMovement", Enum.RenderPriority.Input.Value, function()
        Window.Position = startingWindowsPoint + UDim2.fromOffset(mouse.X - startingMousePoint.X, mouse.Y - startingMousePoint.Y)
    end)
end)

mouse.Button1Up:Connect(function()
    RunService:UnbindFromRenderStep("InventoryWindowMovement")
end)

MoveWindowButton.MouseLeave:Connect(function()
    RunService:UnbindFromRenderStep("InventoryWindowMovement")
end)

MoveWindowButton.MouseButton1Up:Connect(function()
    RunService:UnbindFromRenderStep("InventoryWindowMovement")
end)
