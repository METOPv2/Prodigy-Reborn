local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)
local TradingItems = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.PhoneApps.TradingItems)

local TradingOptions = {}

local tradingOptions = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.TradingOptions
local declineButton = tradingOptions.Buttons.Decline
local itemsButton = tradingOptions.Buttons.Items
local coinsButton = tradingOptions.Buttons.Coins

local declineTradeRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").DeclineTrade

local partnerId = ReplicatedStorage:WaitForChild("TradingApp").PartnerId

function TradingOptions.Decline()
	declineTradeRemoteEvent:FireServer(partnerId.Value)
end

function TradingOptions.OfferCoins()
	Phone.OpenApp("TradingCoins")
end

function TradingOptions.OfferItems()
	Phone.OpenApp("TradingItems")
	TradingItems.Refresh()
end

declineButton.Activated:Connect(TradingOptions.Decline)
coinsButton.Activated:Connect(TradingOptions.OfferCoins)
itemsButton.Activated:Connect(TradingOptions.OfferItems)

return TradingOptions
