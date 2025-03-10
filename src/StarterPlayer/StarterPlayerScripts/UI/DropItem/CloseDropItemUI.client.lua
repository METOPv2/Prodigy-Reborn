local DropItemUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("DropItem")
local CloseUI: ImageButton = DropItemUI:FindFirstChild("CloseUI", true)

CloseUI.Activated:Connect(function()
    DropItemUI.Enabled = false
end)
