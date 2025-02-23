local DropItemUI: ScreenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("DropItem")
local textBox: TextBox = DropItemUI.Container.InnerContainer.MoneyAmount.TextBox
local dropButton: ImageButton = DropItemUI.Container.Drop
local dropItemRemoveEvent = game.ReplicatedStorage.RemoteEvents.DropItem

dropButton.Activated:Connect(function()
	DropItemUI.Enabled = false
	local targetItem = DropItemUI:GetAttribute("TargetItem")
	if textBox.Text ~= "" and targetItem then
		local amount: number = tonumber(textBox.Text)
		if amount then
			dropItemRemoveEvent:FireServer(targetItem, amount)
		end
	end
end)
