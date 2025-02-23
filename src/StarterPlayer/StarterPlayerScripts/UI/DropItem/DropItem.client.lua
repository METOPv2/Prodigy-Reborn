local player = game.Players.LocalPlayer
local DropItemUI = player.PlayerGui:WaitForChild("DropItem")
local textBox = DropItemUI.Container.InnerContainer.MoneyAmount.TextBox
local dropButton = DropItemUI.Container.Drop
local dropItemRemoveEvent = game.ReplicatedStorage.RemoteEvents.DropItem

local function onDropButtonActivated()
	DropItemUI.Enabled = false
	local targetItem = DropItemUI:GetAttribute("TargetItem")
	if targetItem and textBox.Text ~= "" then
		local amount = tonumber(textBox.Text)
		if amount then
			dropItemRemoveEvent:FireServer(targetItem, amount)
		end
	end
end

dropButton.Activated:Connect(onDropButtonActivated)
