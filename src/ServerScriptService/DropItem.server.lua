local DropItemRemoteEvent: RemoteEvent = game.ReplicatedStorage.RemoteEvents.DropItem
local ItemData = require(game.ReplicatedStorage.Source.Inventory.Data.Items)
local RaritiesData = require(game.ReplicatedStorage.Source.Inventory.Data.Rarities)

local function CreateDrop(player, item)
	local itemData = ItemData[item.Name]

	local drop = Instance.new("Part")
	drop.Name = item.Name
	drop.Transparency = 1
	drop.CanCollide = true
	drop.CanQuery = true
	drop.CanTouch = true
	drop.Anchored = false
	drop.Size = Vector3.one
	drop.Position = player.Character:GetPivot().Position + Vector3.new(0, 5, 0)
	drop.Velocity = Vector3.new(math.random(-5, 5), math.random(5, 10), 0) * 2
	drop.CollisionGroup = "Player"

	item.Parent = drop

	local proximityPrompt = Instance.new("ProximityPrompt")
	proximityPrompt.RequiresLineOfSight = false
	proximityPrompt.MaxActivationDistance = 3
	proximityPrompt.KeyboardKeyCode = Enum.KeyCode.Z
	proximityPrompt.Style = Enum.ProximityPromptStyle.Custom
	proximityPrompt.Parent = drop

	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Adornee = drop
	billboardGui.Size = UDim2.fromOffset(50, 50)
	billboardGui.MaxDistance = 100
	billboardGui.ClipsDescendants = false
	billboardGui.Parent = drop

	local dropBackground = Instance.new("ImageLabel")
	dropBackground.Image = itemData.Image
	dropBackground.ImageColor3 = RaritiesData[itemData.Rarity].Color
	dropBackground.BackgroundTransparency = 1
	dropBackground.Size = UDim2.fromScale(1, 1)
	dropBackground.Parent = billboardGui

	proximityPrompt.Triggered:Connect(function(playerWhoPickedUp: Player)
		item.Parent = playerWhoPickedUp.Inventory
		drop:Destroy()
	end)

	drop.Parent = workspace
end

local function onDropItem(player, name, amount)
	assert(typeof(name) == "string", "Name must be a string")
	assert(typeof(amount) == "number", "Amount must be a number")
	assert(amount > 0, "Amount must be greater than 0")

	local inventory = player.Inventory
	local itemsDropped = 0

	for _, item in ipairs(inventory:GetChildren()) do
		if itemsDropped >= amount then
			break
		end

		if item.Name == name then
			CreateDrop(player, item)
			itemsDropped += 1
		end
	end
end

DropItemRemoteEvent.OnServerEvent:Connect(onDropItem)
