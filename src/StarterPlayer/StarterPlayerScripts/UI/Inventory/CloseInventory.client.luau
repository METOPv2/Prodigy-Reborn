--!strict
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local inventoryGui = playerGui:WaitForChild("Inventory") :: ScreenGui
local inventoryContainer = inventoryGui:FindFirstChild("Container") :: ImageLabel
local closeInventoryButton = inventoryContainer:FindFirstChild("CloseInventory") :: ImageButton

closeInventoryButton.Activated:Connect(function()
    inventoryGui.Enabled = false
    inventoryContainer.Position = UDim2.fromScale(0.5, 0.5)
end)
