local Inventory: Folder = game.Players.LocalPlayer:WaitForChild("Inventory")
local Item = require(game.ReplicatedStorage.Source.Inventory.Classes.Item)
local items = {}

local function addItem(instance)
	items[instance] = Item.new(instance.Name)
end

local function removeItem(instance)
	if items[instance] then
		items[instance]:Destroy()
		items[instance] = nil
	end
end

for _, item in ipairs(Inventory:GetChildren()) do
	addItem(item)
end

Inventory.ChildAdded:Connect(addItem)
Inventory.ChildRemoved:Connect(removeItem)
