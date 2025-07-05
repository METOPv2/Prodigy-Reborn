local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TradeRequests = {}

local phoneAssets = ReplicatedStorage:WaitForChild("Assets").assets.UI.Phone
local tradingPartnerTemplate = phoneAssets.TradingPartnerTemplate
local tradeRequestTemplate = phoneAssets.TradeRequestTemplate

local phoneBackground = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background
local playersHolder = phoneBackground.Menu.Container.Apps.TradingPlayers.Holder
local tradeReqestHolder = phoneBackground.Cover.Container.TradingPlayers.Holder

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local sendTradeRequestRemoteEvent = remoteEvents.SendTradeRequest
local answerTradeRemoteEvnet = remoteEvents.AnswerTrade

local function initPlayer(player)
	local clone = tradingPartnerTemplate:Clone()
	clone.Thumbnail.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
	clone.Username.Text = player:GetAttribute("Username")
	clone.TextButton.Activated:Connect(function()
		sendTradeRequestRemoteEvent:FireServer(player.UserId)
	end)
	clone.Name = player.Name
	clone.Parent = playersHolder
end

local function deinitPlayer(player)
	playersHolder:FindFirstChild(player.Name):Destroy()
end

local function createTradeRequest(senderId)
	local connection = nil

	local clone = tradeRequestTemplate:Clone()
	clone.Thumbnail.Image = Players:GetUserThumbnailAsync(senderId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
	clone.Accept.TextButton.Activated:Once(function()
		answerTradeRemoteEvnet:FireServer(senderId, true)
		clone:Destroy()
		connection:Disconnect()
	end)
	clone.Decline.TextButton.Activated:Once(function()
		answerTradeRemoteEvnet:FireServer(senderId, false)
		clone:Destroy()
		connection:Disconnect()
	end)
	clone.Parent = tradeReqestHolder

	connection = Players:GetPlayerByUserId(senderId).Destroying:Connect(function()
		clone:Destroy()
		connection:Disconnect()
	end)
end

function TradeRequests.Init()
	for _, player in ipairs(Players:GetPlayers()) do
		if player == Players.LocalPlayer then
			continue
		end

		initPlayer(player)
	end
end

Players.PlayerAdded:Connect(initPlayer)
Players.PlayerRemoving:Connect(deinitPlayer)
sendTradeRequestRemoteEvent.OnClientEvent:Connect(createTradeRequest)

return TradeRequests
