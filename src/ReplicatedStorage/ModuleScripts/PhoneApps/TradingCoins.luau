local Players = game:GetService("Players")

local TradingCoins = {}

local money = Players.LocalPlayer:WaitForChild("PlayerData").Money

local tradingCoins = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.TradingCoins
local coinsTextBox = tradingCoins.Coins
local coinsBalance = tradingCoins.Balance

function TradingCoins.Refresh()
	coinsTextBox.Text = ""
	coinsBalance.Text = string.format("Balance: %d", money.Value)
end

money.Changed:Connect(TradingCoins.Refresh)

return TradingCoins
