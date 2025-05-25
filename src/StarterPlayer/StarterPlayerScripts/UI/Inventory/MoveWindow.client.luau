local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local inventoryUI = Players.LocalPlayer.PlayerGui:WaitForChild("Inventory") :: ScreenGui
local moveWindowButton = inventoryUI:FindFirstChild("MoveWindow", true)
local Window = moveWindowButton.Parent

local mouse = Players.LocalPlayer:GetMouse()

moveWindowButton.MouseButton1Down:Connect(function()
    local startingMousePoint = Vector2.new(mouse.X, mouse.Y)
    local startingWindowsPoint = Window.Position
    RunService:BindToRenderStep("InventoryWindowMovement", Enum.RenderPriority.Input.Value, function()
        Window.Position = startingWindowsPoint + UDim2.fromOffset(mouse.X - startingMousePoint.X, mouse.Y - startingMousePoint.Y)
    end)
end)

mouse.Button1Up:Connect(function()
    RunService:UnbindFromRenderStep("InventoryWindowMovement")
end)

moveWindowButton.MouseLeave:Connect(function()
    RunService:UnbindFromRenderStep("InventoryWindowMovement")
end)

moveWindowButton.MouseButton1Up:Connect(function()
    RunService:UnbindFromRenderStep("InventoryWindowMovement")
end)
