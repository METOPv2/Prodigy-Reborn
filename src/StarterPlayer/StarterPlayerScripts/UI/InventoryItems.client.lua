-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local inventory = player:WaitForChild("Inventory")
local inventoryHolder = player.PlayerGui.Inventory.Container.Container.Items.Container
local inventoryItemSlotTemplate = ReplicatedStorage.Assets.InventoryItemSlotTemplate
local itemsData = require(ReplicatedStorage.Source.Data.Items)
local inventoryUI = Players.LocalPlayer.PlayerGui.Inventory
local itemSlotsCache = {}

-- Dragging Variables
local draggingItem = nil
local originalSlot = nil
local dragOffset = Vector2.new()
local ghostItem = nil -- This will be the item following the mouse

-- Function to create a copy of item for cursor
local function CreateGhostItem(slot)
	if ghostItem then
		ghostItem:Destroy()
	end
	ghostItem = slot:Clone()
	ghostItem.Parent = inventoryUI -- Move outside of grid layout
	ghostItem.Position = UDim2.fromOffset(
		UserInputService:GetMouseLocation().X,
		UserInputService:GetMouseLocation().Y
	)
	-- ghostItem.BackgroundTransparency = 1 -- Hide background
end

-- Function to make an item draggable
local function MakeDraggable(slot, itemName)
	local function onInputBegan(input, gameProcessed)
		if gameProcessed or input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		draggingItem = slot
		dragOffset = Vector2.new(
			input.Position.X - slot.AbsolutePosition.X,
			input.Position.Y - slot.AbsolutePosition.Y
		)

		-- Make ghost item follow cursor
		CreateGhostItem(slot)

		-- Darken slot while dragging
		TweenService:Create(slot, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()
	end

	local function onInputChanged(input)
		if draggingItem and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation()
			ghostItem.Position =
				UDim2.fromOffset(mousePos.X - dragOffset.X, mousePos.Y - dragOffset.Y)
		end
	end

	local function onInputEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Check if dropped outside inventory
			if
				ghostItem
					and ghostItem.AbsolutePosition.X < inventoryUI.Container.AbsolutePosition.X
				or ghostItem.AbsolutePosition.X > inventoryUI.Container.AbsolutePosition.X + inventoryUI.Container.AbsoluteSize.X
				or ghostItem.AbsolutePosition.Y < inventoryUI.Container.AbsolutePosition.Y
				or ghostItem.AbsolutePosition.Y
					> inventoryUI.Container.AbsolutePosition.Y + inventoryUI.Container.AbsoluteSize.Y
			then
				print("Dropped outside inventory:", itemName)
			else
				-- Check for item swapping
				for _, otherSlot in pairs(inventoryHolder:GetChildren()) do
					if otherSlot:IsA("Frame") and otherSlot ~= draggingItem then
						local otherSlotPosition = otherSlot.AbsolutePosition
						local mousePos = UserInputService:GetMouseLocation()

						if
							mousePos.X > otherSlotPosition.X
							and mousePos.X < otherSlotPosition.X + otherSlot.AbsoluteSize.X
							and mousePos.Y > otherSlotPosition.Y
							and mousePos.Y < otherSlotPosition.Y + otherSlot.AbsoluteSize.Y
						then
							-- Swap Positions
							local tempPosition = draggingItem.Position
							draggingItem.Position = otherSlot.Position
							otherSlot.Position = tempPosition
							print("Swapped", draggingItem.Name, "with", otherSlot.Name)
						end
					end
				end
			end

			-- Reset slot transparency
			TweenService:Create(draggingItem, TweenInfo.new(0.2), { BackgroundTransparency = 0 })
				:Play()
			draggingItem = nil
			if ghostItem then
				ghostItem:Destroy()
			end
		end
	end

	slot.InputBegan:Connect(onInputBegan)
	UserInputService.InputChanged:Connect(onInputChanged)
	UserInputService.InputEnded:Connect(onInputEnded)
end

-- Function to add an item to inventory
local function ItemAdded(item)
	local itemData = itemsData.FindItem(item.Name)
	local slot = inventoryItemSlotTemplate:Clone()
	slot.ImageLabel.Image = itemData.Image
	slot.ImageLabel.Size = UDim2.new(0, 50, 0, 50)
	slot.Parent = inventoryHolder
	itemSlotsCache[item] = slot

	-- Enable dragging
	MakeDraggable(slot, item.Name)
end

-- Load existing items
for _, item in pairs(inventory:GetChildren()) do
	ItemAdded(item)
end

inventory.ChildAdded:Connect(ItemAdded)
