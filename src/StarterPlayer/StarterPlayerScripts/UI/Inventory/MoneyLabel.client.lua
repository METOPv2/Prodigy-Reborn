local player = game.Players.LocalPlayer
local money = player:WaitForChild("PlayerData").Money
local label = player.PlayerGui:WaitForChild("Inventory").Container.Container.Coins.TextLabel

local function updateLabel()
    label.Text = string.format("%.2f", money.Value):gsub("%.", ",")
end

money.Changed:Connect(updateLabel)
updateLabel()
