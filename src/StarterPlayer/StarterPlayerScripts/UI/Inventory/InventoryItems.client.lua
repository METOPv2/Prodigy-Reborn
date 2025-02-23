local player = game.Players.LocalPlayer
local inventory = player:WaitForChild("Inventory")
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

inventory.ChildAdded:Connect(addItem)
inventory.ChildRemoved:Connect(removeItem)

for _, item in ipairs(inventory:GetChildren()) do
	addItem(item)
end
