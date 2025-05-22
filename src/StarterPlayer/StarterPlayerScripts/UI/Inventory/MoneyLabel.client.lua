local player = game.Players.LocalPlayer
local money = player:WaitForChild("PlayerData").Money
local label = player.PlayerGui:WaitForChild("Inventory").Container.Container.Coins.TextLabel
local numberAbbreviation = require(game.ReplicatedStorage:WaitForChild("Source").ModuleScripts.NumberAbbreviation)

local function updateLabel(amount)
    label.Text = numberAbbreviation:Comas(amount)
end

money.Changed:Connect(updateLabel)

updateLabel(money.Value)
