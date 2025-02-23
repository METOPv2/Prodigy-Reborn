local inventory = game.Players.LocalPlayer:WaitForChild("Inventory")
local Item = require(game.ReplicatedStorage.Source.Inventory.Classes.Item)
local items = {}

local function ItemAdded(instance)
	items[instance] = Item.new(instance.Name)
end

local function ItemRemoved(instance)
	items[instance]:Destroy()
end

for _, item in ipairs(inventory:GetChildren()) do
	ItemAdded(item)
end

inventory.ChildAdded:Connect(ItemAdded)
inventory.ChildRemoved:Connect(ItemRemoved)
