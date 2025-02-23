local money = game.Players.LocalPlayer:WaitForChild("PlayerData").Money
local label = game.Players.LocalPlayer.PlayerGui.Inventory.Container.Container.Coins.TextLabel

local function UpdateUI()
	label.Text = string.format("%.2f", money.Value):gsub("%.", ",")
end

UpdateUI()
money.Changed:Connect(UpdateUI)
