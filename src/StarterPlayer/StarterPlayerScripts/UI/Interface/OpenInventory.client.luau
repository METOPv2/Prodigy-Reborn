local InventoryUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local InterfaceUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface")
local InventoryButton: ImageButton = InterfaceUI:FindFirstChild("Inventory", true)

InventoryButton.Activated:Connect(function()
    InventoryUI.Enabled = not InventoryUI.Enabled

    if not InventoryUI.Enabled then
        InventoryUI.Container.Position = UDim2.fromScale(0.5, 0.5)
    end
end)
