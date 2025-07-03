local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Trading = {}

local MeOffering = require(ReplicatedStorage:WaitForChild("Source").TradingApp.MeOffering)
local PartnerOffering = require(ReplicatedStorage:WaitForChild("Source").TradingApp.PartnerOffering)
local partnerId = ReplicatedStorage:WaitForChild("TradingApp").PartnerId

local partner = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Cover.Container.Trading
local me = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.Trading

local declineTradeRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").DeclineTrade
local updateCoinsRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").UpdateCoins
local acceptTradeRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").AcceptTrade

local function fillInfo()
	me.Coins.TextLabel.Text = MeOffering.coins
	partner.Partner.Coins.Text = PartnerOffering.coins

	pcall(function()
		partner.Partner.Username.Text = "@" .. Players:GetNameFromUserIdAsync(partnerId.Value)
	end)
end

function Trading.Init()
	fillInfo()
end

declineTradeRemoteEvent.OnClientEvent:Connect(function()
	partnerId.Value = 0
end)

updateCoinsRemoteEvent.OnClientEvent:Connect(function(coins)
	PartnerOffering.coins = coins
	partner.Partner.Coins.Text = coins
end)

acceptTradeRemoteEvent.OnClientEvent:Connect(function()
	partnerId.Value = 0

	MeOffering.coins = 0
	MeOffering.items = {}

	PartnerOffering.coins = 0
	PartnerOffering.items = {}

	fillInfo()
end)

return Trading
