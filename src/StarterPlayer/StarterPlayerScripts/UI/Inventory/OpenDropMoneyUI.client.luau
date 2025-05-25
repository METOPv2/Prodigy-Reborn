local DropMoneyUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("DropMoney")
local InventoryUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local OpenMoneyUIButton = InventoryUI:FindFirstChild("OpenMoneyUI", true)

OpenMoneyUIButton.Activated:Connect(function()
    DropMoneyUI.Enabled = true
    DropMoneyUI:FindFirstChild("TextBox", true):CaptureFocus()
end)
