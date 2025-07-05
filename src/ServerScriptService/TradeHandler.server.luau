local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteEvents = ReplicatedStorage.RemoteEvents
local sendTradeRequestRemoteEvent = remoteEvents.SendTradeRequest
local answerTradeRemoteEvent = remoteEvents.AnswerTrade
local openTradeRemoteEvent = remoteEvents.OpenTrade
local declineTradeRemoteEvent = remoteEvents.DeclineTrade
local updateCoinsRemoteEvent = remoteEvents.UpdateCoins
local updateItemsRemoteEvent = remoteEvents.UpdateItems
local acceptTradeRemoteEvent = remoteEvents.AcceptTrade

local ItemsData = require(ReplicatedStorage.Source.Inventory.Data.Items)

local activeRequests = {}

local function getSessionByUserId(userId)
	local userIdString = tostring(userId)

	for id, session in pairs(activeRequests) do
		if id:find(userIdString) then
			return session
		end
	end

	return
end

sendTradeRequestRemoteEvent.OnServerEvent:Connect(function(sender, receiverId)
	if activeRequests[tostring(sender.UserId) .. tostring(receiverId)] then
		return
	end

	sendTradeRequestRemoteEvent:FireClient(Players:GetPlayerByUserId(receiverId), sender.UserId)
end)

answerTradeRemoteEvent.OnServerEvent:Connect(function(receiver, senderId, answer)
	if type(senderId) ~= "number" or type(answer) ~= "boolean" then
		return
	end

	if answer then
		local id = tostring(senderId) .. tostring(receiver.UserId)

		activeRequests[id] = {
			coins = {
				[senderId] = 0,
				[receiver.UserId] = 0,
			},
			items = {
				[senderId] = {},
				[receiver.UserId] = {},
			},
			player1 = senderId,
			player2 = receiver.UserId,
			isPlayer1Ready = false,
			isPlayer2Ready = false,
			id = id,
		}

		openTradeRemoteEvent:FireClient(Players:GetPlayerByUserId(senderId), receiver.UserId)
		openTradeRemoteEvent:FireClient(receiver, Players:GetPlayerByUserId(senderId).UserId)
	else
		activeRequests[tostring(senderId) .. tostring(receiver.UserId)] = nil
	end
end)

declineTradeRemoteEvent.OnServerEvent:Connect(function(player, partnerId)
	if type(partnerId) ~= "number" then
		return
	end

	activeRequests[tostring(player.UserId) .. tostring(partnerId)] = nil
	activeRequests[tostring(partnerId) .. tostring(player.UserId)] = nil

	declineTradeRemoteEvent:FireClient(player)
	declineTradeRemoteEvent:FireClient(Players:GetPlayerByUserId(partnerId))
end)

updateCoinsRemoteEvent.OnServerEvent:Connect(function(player, coins)
	if not tonumber(coins) or coins > player.PlayerData.Money.Value or coins < 0 or coins ~= coins then
		return
	end

	local session = getSessionByUserId(player.UserId)

	session.coins[player.UserId] = coins
	updateCoinsRemoteEvent:FireClient(Players:GetPlayerByUserId(session.player1 == player.UserId and session.player2 or session.player1), coins)
end)

updateItemsRemoteEvent.OnServerEvent:Connect(function(player, items)
	if type(items) ~= "table" then
		return
	end

	for _, item in ipairs(items) do
		if not ItemsData[item.Name] then
			return
		end
	end

	local session = getSessionByUserId(player.UserId)

	session.items[player.UserId] = items
	updateItemsRemoteEvent:FireClient(Players:GetPlayerByUserId(session.player1 == player.UserId and session.player2 or session.player1), items)
end)

acceptTradeRemoteEvent.OnServerEvent:Connect(function(player)
	local session = getSessionByUserId(player.UserId)

	if session.player1 == player.UserId then
		session.isPlayer1Ready = not session.isPlayer1Ready
	else
		session.isPlayer2Ready = not session.isPlayer2Ready
	end

	if session.isPlayer1Ready and session.isPlayer2Ready then
		local partner = Players:GetPlayerByUserId(session.player1 == player.UserId and session.player2 or session.player1)

		player.PlayerData.Money.Value += session.coins[partner.UserId]
		partner.PlayerData.Money.Value += session.coins[player.UserId]

		for _, v in ipairs(session.items[player.UserId]) do
			local item = player.Inventory:FindFirstChild(v.Name)
			if item then
				item:Destroy()
			end
		end

		for i, v in ipairs(session.items[player.UserId]) do
			local newItem = Instance.new("StringValue")
			newItem.Name = v.Name

			for name, value in pairs(v:GetAttributes()) do
				if name ~= "Name" then
					newItem:SetAttribute(name, value)
				end
			end

			newItem.Parent = partner.Inventory

			session.items[player.UserId][i] = nil
		end

		for _, v in ipairs(session.items[partner.UserId]) do
			local item = partner.Inventory:FindFirstChild(v.Name)
			if item then
				item:Destroy()
			end
		end

		for i, v in ipairs(session.items[partner.UserId]) do
			local newItem = Instance.new("StringValue")
			newItem.Name = v.Name

			for name, value in pairs(v:GetAttributes()) do
				if name ~= "Name" then
					newItem:SetAttribute(name, value)
				end
			end

			newItem.Parent = player.Inventory

			session.items[partner.UserId][i] = nil
		end

		activeRequests[session.id] = nil

		acceptTradeRemoteEvent:FireClient(partner)
		acceptTradeRemoteEvent:FireClient(player)
	end
end)
