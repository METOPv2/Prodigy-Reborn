local ItemsData = require(game.ReplicatedStorage.Source.Inventory.Data.Items)
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local dropItemRemoveEvent = game.ReplicatedStorage.RemoteEvents.DropItem
local DropItemUI = game.Players.LocalPlayer.PlayerGui.DropItem
local InventoryUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Inventory")
local Holder = InventoryUI.Container.Container.Items.Container

local hoverZone = Instance.new("Frame")
hoverZone.BackgroundTransparency = 1
hoverZone.Size = UDim2.fromOffset(660, 510)
hoverZone.Position = UDim2.fromScale(0.5, 0.5)
hoverZone.AnchorPoint = Vector2.new(0.5, 0.5)
hoverZone.Parent = InventoryUI

local Item = {
	DefaultSlotSize = 69, -- pixels
	DefaultSlotPadding = 5, -- pixels
	Borders = { Top = 5, Right = 5, Bottom = 5, Left = 5 },
	ItemRemoved = Instance.new("BindableEvent"),
	Items = {},
}
Item.__index = Item

local dragScreenUI = Instance.new("ScreenGui")
dragScreenUI.Name = "DragScreenUI"
dragScreenUI.ResetOnSpawn = false
dragScreenUI.DisplayOrder = 10
dragScreenUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local function CreateSlot(name: string)
	local itemData = ItemsData[name]

	local slot = Instance.new("ImageButton")
	slot.Name = name
	slot.Image = "rbxassetid://77397559355938"
	slot.BackgroundTransparency = 1
	slot.Position = UDim2.fromOffset(Item.Borders.Left, Item.Borders.Top)
	slot.Size = UDim2.fromOffset(Item.DefaultSlotSize, Item.DefaultSlotSize)

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Image = itemData.Image
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel.Size = UDim2.fromOffset(50, 50)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = slot

	local amount = Instance.new("TextLabel")
	amount.Name = "Amount"
	amount.AnchorPoint = Vector2.new(1, 1)
	amount.Position = UDim2.new(1, -10, 1, -10)
	amount.BackgroundTransparency = 1
	amount.Size = UDim2.fromOffset(20, 20)
	amount.TextXAlignment = Enum.TextXAlignment.Right
	amount.TextSize = 24
	amount.Font = Enum.Font.FredokaOne
	amount.Text = "?"
	amount.TextColor3 = Color3.fromRGB(255, 255, 255)
	amount.TextStrokeTransparency = 1
	amount.Parent = slot

	slot.Parent = Holder
	return slot
end

function Item.new(name: string)
	assert(ItemsData[name], "Item does not exist")

	local itemData = ItemsData[name]

	-- Check if the item already exists in the inventory
	if Holder:FindFirstChild(name) then
		-- Increase the stack of the existing item
		Item.Items[name]:IncreaseStack()
		return Item.Items[name]
	else
		-- Create a new item
		local self = setmetatable({}, Item)
		self.Name = name
		self.DisplayName = itemData.DisplayName
		self.Position = 0
		self.Stack = 1
		self.IsDragging = false
		self.Slot = CreateSlot(name)
		self.Connections = {
			self.ItemRemoved.Event:Connect(function(item)
				if item.Position < self.Position and item ~= self then
					self:SetPosition(self.Position - 1)
				end
			end),
			self.Slot.MouseButton1Down:Connect(function()
				self:StartDragging()
			end),
			UserInputService.InputChanged:Connect(function(input)
				if not self.IsDragging then
					return
				end

				self.DraggableSlot:TweenPosition(
					UDim2.fromOffset(input.Position.X, input.Position.Y),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					0.1,
					true
				)
			end),
			UserInputService.InputEnded:Connect(function(input)
				if
					not self.IsDragging
					or input.UserInputType ~= Enum.UserInputType.MouseButton1
				then
					return
				end

				if self:IsDraggingOverInventory(input) then
					local isDraggingOverItem, item = self:IsDraggingOverItem(input)

					if isDraggingOverItem then
						self:SwipePositionsWithOtherItem(item)
						self:StopDragging()
					else
						self.DraggableSlot:TweenPosition(
							UDim2.fromOffset(
								self.Slot.AbsolutePosition.X + self.Slot.AbsoluteSize.X / 2,
								self.Slot.AbsolutePosition.Y + self.Slot.AbsoluteSize.Y / 2
							),
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quad,
							0.1,
							true,
							function()
								self:StopDragging()
							end
						)
					end
				else
					if self.Stack > 1 then
						DropItemUI.Enabled = true
						DropItemUI:SetAttribute("TargetItem", self.Name)
					else
						dropItemRemoveEvent:FireServer(self.Name, 1)
					end
					self:StopDragging()
				end
				self.IsDragging = false
			end),
		}
		self:SetPosition(#Holder:GetChildren())
		Item.Items[name] = self
		return self
	end
end

function Item:StartDragging()
	assert(not self.IsDragging, "Item is already being dragged")
	self.IsDragging = true

	local mouseLocation = UserInputService:GetMouseLocation()
	local topbarInset = GuiService.TopbarInset.Height

	-- Create a draggable slot
	self.DraggableSlot = self.Slot:Clone()
	self.DraggableSlot.AnchorPoint = Vector2.new(0.5, 0.5)
	self.DraggableSlot.ImageTransparency = 1
	self.DraggableSlot.ImageLabel.ImageTransparency = 0.5
	self.DraggableSlot.Amount:Destroy()
	self.DraggableSlot.Position = UDim2.fromOffset(mouseLocation.X, mouseLocation.Y - topbarInset)
	self.DraggableSlot.Parent = dragScreenUI

	-- Hide the original slot
	self.Slot.ImageLabel.ImageTransparency = 1
	self.Slot.Amount.TextTransparency = 0.5
	self.Slot.Amount.AnchorPoint = Vector2.new(0.5, 0.5)
	self.Slot.Amount.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.Slot.Amount.TextXAlignment = Enum.TextXAlignment.Center
	self.Slot.Amount.Size = UDim2.new(1, 0, 1, 0)
end

function Item:SwipePositionsWithOtherItem(otherItem)
	local tempPosition = self.Position
	self:SetPosition(otherItem.Position)
	otherItem:SetPosition(tempPosition)
end

function Item:StopDragging()
	self.IsDragging = false

	-- Reset slot properties to default
	self.Slot.ImageLabel.ImageTransparency = 0
	self.Slot.Amount.TextTransparency = 0
	self.Slot.Amount.AnchorPoint = Vector2.new(1, 1)
	self.Slot.Amount.Position = UDim2.new(1, -10, 1, -10)
	self.Slot.Amount.TextXAlignment = Enum.TextXAlignment.Right
	self.Slot.Amount.Size = UDim2.new(0, 20, 0, 20)

	-- Remove draggable slot
	if self.DraggableSlot then
		self.DraggableSlot:Destroy()
		self.DraggableSlot = nil
	end
end

function Item:IsDraggingOverInventory(input: InputObject)
	assert(self.IsDragging, "Item is not being dragged")
	local hoverZoneSize: Vector2 = hoverZone.AbsoluteSize
	local hoverZonePosition: Vector2 = hoverZone.AbsolutePosition
	local inputPosition = input.Position
	return inputPosition.X >= hoverZonePosition.X
		and inputPosition.X <= hoverZonePosition.X + hoverZoneSize.X
		and inputPosition.Y >= hoverZonePosition.Y
		and inputPosition.Y <= hoverZonePosition.Y + hoverZoneSize.Y
end

function Item:IsDraggingOverItem(input: InputObject)
	assert(self.IsDragging, "Item is not being dragged")

	for _, item in pairs(Item.Items) do
		if item == self then
			continue
		end

		local itemPosition = item.Slot.AbsolutePosition
		local itemSize = item.Slot.AbsoluteSize
		local inputPosition = input.Position

		if
			inputPosition.X >= itemPosition.X
			and inputPosition.X <= itemPosition.X + itemSize.X
			and inputPosition.Y >= itemPosition.Y
			and inputPosition.Y <= itemPosition.Y + itemSize.Y
		then
			return true, item
		end
	end

	return false, nil
end

function Item:SetPosition(position: number)
	self.Position = position
	local itemsPerRow = math.floor(
		(Holder.AbsoluteSize.X - self.Borders.Left - self.Borders.Right + self.DefaultSlotPadding)
			/ (self.Slot.Size.X.Offset + self.DefaultSlotPadding)
	)
	local row = math.ceil(position / itemsPerRow)
	local x = ((position - 1) % itemsPerRow) * (self.Slot.Size.X.Offset + self.DefaultSlotPadding)
	local y = (row - 1) * (self.Slot.Size.Y.Offset + self.DefaultSlotPadding)
	self.Slot:TweenPosition(
		UDim2.fromOffset(x, y),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.1,
		true
	)
end

function Item:IncreaseStack()
	self.Stack += 1
	self.Slot.Amount.Text = self.Stack
	self.Slot.Amount.Visible = self.Stack > 1
end

function Item:DecreaseStack()
	self.Stack -= 1
	self.Slot.Amount.Text = self.Stack
	self.Slot.Amount.Visible = self.Stack > 1
end

function Item:Destroy()
	if self.Stack > 1 then
		self:DecreaseStack()
	else
		self.Slot:Destroy()
		self.ItemRemoved:Fire(self)
		Item.Items[self.Name] = nil
	end
end

return Item
