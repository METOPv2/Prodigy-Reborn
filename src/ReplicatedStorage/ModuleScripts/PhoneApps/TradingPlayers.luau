local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)
local Trading = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.PhoneApps.Trading)

local TradingPlayers = {}

local tradingPartnerTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.TradingPartnerTemplate
local tradeRequestTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.TradeRequestTemplate
local playersHolder = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.TradingPlayers.Holder
local sendTradeRequestRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").SendTradeRequest
local answerTradeRemoteEvnet = ReplicatedStorage:WaitForChild("RemoteEvents").AnswerTrade
local openTradeRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").OpenTrade
local tradeReqestHolder = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Cover.Container.TradingPlayers.Holder

local partnerIdInstance = ReplicatedStorage:WaitForChild("TradingApp").PartnerId

local function createPlayer(player)
	local clone = tradingPartnerTemplate:Clone()
	clone.Thumbnail.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
	clone.Username.Text = player:GetAttribute("Username")
	clone.TextButton.Activated:Connect(function()
		sendTradeRequestRemoteEvent:FireServer(player.UserId)
	end)
	clone.Name = player.Name
	clone.Parent = playersHolder
end

local function createTradeRequest(senderId)
	local clone = tradeRequestTemplate:Clone()
	clone.Thumbnail.Image = Players:GetUserThumbnailAsync(senderId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
	clone.Accept.TextButton.Activated:Once(function()
		answerTradeRemoteEvnet:FireServer(senderId, true)
		clone:Destroy()
	end)
	clone.Decline.TextButton.Activated:Once(function()
		answerTradeRemoteEvnet:FireServer(senderId, false)
		clone:Destroy()
	end)
	clone.Parent = tradeReqestHolder
end

function TradingPlayers.Init()
	for _, player in ipairs(Players:GetPlayers()) do
		if player == Players.LocalPlayer then
			continue
		end

		createPlayer(player)
	end
end

local function initTrade(partnerId)
	partnerIdInstance.Value = partnerId
	Trading.Init()
	Phone.OpenApp("Trading")
end

Players.PlayerAdded:Connect(createPlayer)
Players.PlayerRemoving:Connect(function(child)
	local panel = playersHolder:FindFirstChild(child.Name)
	if panel then
		panel:Destroy()
	end
end)
sendTradeRequestRemoteEvent.OnClientEvent:Connect(createTradeRequest)
openTradeRemoteEvent.OnClientEvent:Connect(initTrade)

return TradingPlayers
