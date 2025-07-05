local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ItemsData = require(ReplicatedStorage:WaitForChild("Source").Inventory.Data.Items)
local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)

local Trading = {}

local MeOffering = require(ReplicatedStorage:WaitForChild("Source").TradingApp.MeOffering)
local PartnerOffering = require(ReplicatedStorage:WaitForChild("Source").TradingApp.PartnerOffering)
local partnerIdInstance = ReplicatedStorage:WaitForChild("TradingApp").PartnerId
local itemTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.TradingApp.ItemTemplate

local partner = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Cover.Container.Trading
local me = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.Trading

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local declineTradeRemoteEvent = remoteEvents.DeclineTrade
local updateCoinsRemoteEvent = remoteEvents.UpdateCoins
local updateItemsRemoteEvent = remoteEvents.UpdateItems
local acceptTradeRemoteEvent = remoteEvents.AcceptTrade
local openTradeRemoteEvent = remoteEvents.OpenTrade

local function fillInfo()
	me.Coins.TextLabel.Text = MeOffering.coins
	partner.Partner.Coins.Text = PartnerOffering.coins
	partner.Partner.Username.Text = Players:GetPlayerByUserId(partnerIdInstance.Value):GetAttribute("Username")

	pcall(function()
		partner.Partner.Username.Text = "@" .. Players:GetNameFromUserIdAsync(partnerIdInstance.Value)
	end)
end

local function fillPartnerItems()
	for _, v in ipairs(partner.Items:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	for _, item in ipairs(PartnerOffering.items) do
		local itemData = ItemsData[item.Name]

		local clone = itemTemplate:Clone()
		clone.Item.Image = itemData.Image
		clone.Check:Destroy()
		clone.Parent = partner.Items
	end
end

local function fillMyItems()
	for _, v in ipairs(me.Items:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	for _, item in ipairs(MeOffering.items) do
		local itemData = ItemsData[item.Name]

		local clone = itemTemplate:Clone()
		clone.Item.Image = itemData.Image
		clone.Check:Destroy()
		clone.Parent = me.Items
	end
end

local function initTrade(partnerId)
	partnerIdInstance.Value = partnerId
	Trading.Init()
	Phone.OpenApp("Trading")
end

function Trading.Init()
	fillInfo()
	fillMyItems()
end

declineTradeRemoteEvent.OnClientEvent:Connect(function()
	partnerIdInstance.Value = 0
end)

updateCoinsRemoteEvent.OnClientEvent:Connect(function(coins)
	PartnerOffering.coins = coins
	partner.Partner.Coins.Text = coins
end)

updateItemsRemoteEvent.OnClientEvent:Connect(function(item)
	PartnerOffering.items = item
	fillPartnerItems()
end)

acceptTradeRemoteEvent.OnClientEvent:Connect(function()
	partnerIdInstance.Value = 0

	MeOffering.coins = 0
	MeOffering.items = {}

	PartnerOffering.coins = 0
	PartnerOffering.items = {}
end)

openTradeRemoteEvent.OnClientEvent:Connect(initTrade)

return Trading
