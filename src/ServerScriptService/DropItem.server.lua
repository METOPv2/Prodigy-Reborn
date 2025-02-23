local dropItemRemoveEvent: RemoteEvent = game.ReplicatedStorage.RemoteEvents.DropItem
local itemDropTemplate: Part = game.ReplicatedStorage.Assets.Drop.Item
local ItemData = require(game.ReplicatedStorage.Source.Inventory.Data.Items)

dropItemRemoveEvent.OnServerEvent:Connect(
	function(player: Player, targetItem: string, amount: number)
		local inventory: Folder = player.Inventory
		local items = inventory:GetChildren()
		local itemsToDrop = {}

		for _, item in ipairs(items) do
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
				newItem.BillboardGui.ImageLabel.Image = itemData.Image
				newItem.Position = player.Character:GetPivot().Position
					+ Vector3.new(math.random(-5, 5), 0, 0)
				newItem.Parent = workspace
				item.Parent = newItem
				newItem.ProximityPrompt.Triggered:Connect(function(playerWhoPickedUp)
					item.Parent = playerWhoPickedUp.Inventory
					newItem:Destroy()
				end)

				local throwDirection = Vector3.new(math.random(-5, 5), math.random(5, 10), 0) * 2
				newItem.Velocity = throwDirection
			end
			table.clear(itemsToDrop)
		else
			warn("Not enough items in inventory")
		end
	end
)
