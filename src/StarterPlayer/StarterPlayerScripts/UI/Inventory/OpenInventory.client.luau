--!strict
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local inventoryGui = playerGui:WaitForChild("Inventory") :: ScreenGui
local inventoryContainer = inventoryGui:FindFirstChild("Container") :: ImageLabel
local interfaceGui = playerGui:WaitForChild("Interface") :: ScreenGui
local interfaceBackground = interfaceGui:FindFirstChild("Background") :: ImageLabel
local openInventoryButton = interfaceBackground:FindFirstChild("Inventory") :: ImageButton

openInventoryButton.Activated:Connect(function()
    inventoryGui.Enabled = not inventoryGui.Enabled
    inventoryContainer.Position = UDim2.fromScale(0.5, 0.5)
end)
