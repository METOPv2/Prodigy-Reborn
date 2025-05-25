local Players = game:GetService("Players")

local dropMoneyUI = Players.LocalPlayer.PlayerGui:WaitForChild("DropMoney")
local inventoryUI = Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local OpenMoneyUIButton = inventoryUI:FindFirstChild("OpenMoneyUI", true)

OpenMoneyUIButton.Activated:Connect(function()
    dropMoneyUI.Enabled = true
    dropMoneyUI:FindFirstChild("TextBox", true):CaptureFocus()
end)
