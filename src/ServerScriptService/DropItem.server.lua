local dropItemRemoveEvent = game.ReplicatedStorage.RemoteEvents.DropItem
local itemDropTemplate = game.ReplicatedStorage.Assets.Drop.Item
local ItemData = require(game.ReplicatedStorage.Source.Inventory.Data.Items)
local RaritiesData = require(game.ReplicatedStorage.Source.Inventory.Data.Rarities)
local droppedItems = {}

local function onDropItem(player, targetItem, amount)
	local inventory = player.Inventory
	local itemsToDrop = {}

	for _, item in ipairs(inventory:GetChildren()) do
		if #itemsToDrop >= amount then
			break
		end
		if item.Name == targetItem then
			table.insert(itemsToDrop, item)
		end
	end

	if #itemsToDrop >= amount then
		for _, item in ipairs(itemsToDrop) do
			local itemData = ItemData[item.Name]

			local newItem = itemDropTemplate:Clone()
			newItem.BillboardGui.Background.Visible = false
			local billboardGui = newItem.BillboardGui:Clone()
			billboardGui.Background.ImageColor3 = RaritiesData[itemData.Rarity].Color
			billboardGui.Background.Visible = true
			billboardGui.Adornee = newItem
			billboardGui.Parent = player.PlayerGui.DropItemUI
			item.Parent = newItem

			if itemData.Class == "Item" then
				local imageLabel = Instance.new("ImageLabel")
				imageLabel.Size = UDim2.new(1, 0, 1, 0)
				imageLabel.BackgroundTransparency = 1
				imageLabel.Image = itemData.Image
				imageLabel.Parent = billboardGui

				local floatingEffectClone = billboardGui.FloatingEffect:Clone()
				floatingEffectClone.Enabled = true
				floatingEffectClone.Parent = imageLabel

				local floatingEffectClone2 = billboardGui.FloatingEffect:Clone()
				floatingEffectClone2.Enabled = true
				floatingEffectClone2.Parent = billboardGui.Background
			elseif itemData.Class == "Shoes" then
				local viewportFrame = Instance.new("ViewportFrame")
				viewportFrame.Size = UDim2.new(1, 0, 1, 0)
				viewportFrame.BackgroundTransparency = 1
				viewportFrame.Parent = billboardGui

				local camera = Instance.new("Camera")
				viewportFrame.CurrentCamera = camera
				camera.Parent = viewportFrame

				local shoesModel = itemData.Model:Clone()
				shoesModel.Parent = viewportFrame
				local modelCFrame = shoesModel:GetPivot()
				local modelSize = shoesModel:GetExtentsSize()

				local cameraDistance = math.max(modelSize.X, modelSize.Y, modelSize.Z) * 1.5
				camera.CFrame = CFrame.new(
					modelCFrame.Position + Vector3.new(0, modelSize.Y / 2, cameraDistance),
					modelCFrame.Position
				)

				local floatingEffectClone = billboardGui.FloatingEffect:Clone()
				floatingEffectClone.Enabled = true
				floatingEffectClone.Parent = viewportFrame

				local floatingEffectClone2 = billboardGui.FloatingEffect:Clone()
				floatingEffectClone2.Enabled = true
				floatingEffectClone2.Parent = billboardGui.Background
			end
			newItem.Position = player.Character:GetPivot().Position
				+ Vector3.new(math.random(-5, 5), 0, 0)
			newItem.Name = item.Name
			newItem.Parent = workspace
			newItem.Velocity = Vector3.new(math.random(-5, 5), math.random(5, 10), 0) * 2
			newItem.ProximityPrompt.Triggered:Connect(function(playerWhoPickedUp)
				item.Parent = playerWhoPickedUp.Inventory
				newItem:Destroy()
			end)
			table.insert(droppedItems, newItem)
		end
	else
		warn("Not enough items in inventory")
	end
end

local function onPlayerAdded(player)
	for _, droppedItem in ipairs(droppedItems) do
		local itemData = ItemData[droppedItem.Name]

		local newItem = droppedItem:Clone()
		newItem.Parent = workspace

		local billboardGui = newItem.BillboardGui:Clone()
		billboardGui.Background.ImageColor3 = RaritiesData[itemData.Rarity].Color
		billboardGui.Background.Visible = true
		billboardGui.Adornee = newItem
		billboardGui.Parent = player.PlayerGui.DropItemUI

		local viewportFrame = Instance.new("ViewportFrame")
		viewportFrame.Size = UDim2.new(1, 0, 1, 0)
		viewportFrame.BackgroundTransparency = 1
		viewportFrame.Parent = billboardGui

		local camera = Instance.new("Camera")
		viewportFrame.CurrentCamera = camera
		camera.Parent = viewportFrame

		local shoesModel = itemData.Model:Clone()
		shoesModel.Parent = viewportFrame
		local modelCFrame = shoesModel:GetPivot()
		local modelSize = shoesModel:GetExtentsSize()

		local cameraDistance = math.max(modelSize.X, modelSize.Y, modelSize.Z) * 1.5
		camera.CFrame = CFrame.new(
			modelCFrame.Position + Vector3.new(0, modelSize.Y / 2, cameraDistance),
			modelCFrame.Position
		)
	end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)
dropItemRemoveEvent.OnServerEvent:Connect(onDropItem)
