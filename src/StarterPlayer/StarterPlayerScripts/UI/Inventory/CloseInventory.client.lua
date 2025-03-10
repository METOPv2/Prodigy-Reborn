local inventoryGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local closeButton: ImageButton = inventoryGui:FindFirstChild("CloseUI", true)

local function closeInventory()
    inventoryGui.Enabled = false
end

closeButton.Activated:Connect(closeInventory)
