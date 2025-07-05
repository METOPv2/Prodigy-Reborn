local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemsData = require(ReplicatedStorage:WaitForChild("Source").Inventory.Data.Items)
local MeOffering = require(ReplicatedStorage:WaitForChild("Source").TradingApp.MeOffering)

local TradingItems = {}

local player = Players.LocalPlayer
local holder = player.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.TradingItems.Holder
local inventory = player:WaitForChild("Inventory")
local template = ReplicatedStorage:WaitForChild("Assets").UI.Phone.TradingApp.ItemTemplate

function TradingItems.Refresh()
	for _, v in ipairs(holder:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	MeOffering.items = {}

	for _, item in ipairs(inventory:GetChildren()) do
		local itemData = ItemsData[item.Name]

		if not itemData then
			continue
		end

		local clone = template:Clone()
		clone.Item.Image = itemData.Image
		clone.Name = item.Name
		clone.TextButton.Activated:Connect(function()
			local index = table.find(MeOffering.items, item)
			local selected = false

			if index then
				selected = false
				table.remove(MeOffering.items, index)
			else
				selected = true
				table.insert(MeOffering.items, item)
			end

			clone.Check.UIStroke.Color = selected and Color3.fromRGB(0, 225, 0) or Color3.fromRGB(255, 0, 0)
			clone.Check.BackgroundTransparency = selected and 0 or 1
		end)
		clone.Parent = holder
	end
end

inventory.ChildAdded:Connect(function(child)
	table.insert(MeOffering.items, child)
end)

inventory.ChildRemoved:Connect(function(child)
	local index = table.find(MeOffering.items, child)
	if index then
		table.remove(MeOffering.items, index)
	end
end)

return TradingItems
