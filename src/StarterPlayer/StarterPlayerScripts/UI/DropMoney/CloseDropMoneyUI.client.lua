local DropMoneyUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("DropMoney")
local closeUIButton: ImageButton = DropMoneyUI:FindFirstChild("CloseUI", true)

closeUIButton.Activated:Connect(function()
    DropMoneyUI.Enabled = false
end)
