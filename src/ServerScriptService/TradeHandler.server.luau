local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local sendTradeRequestRemoteEvent = ReplicatedStorage.RemoteEvents.SendTradeRequest
local answerTradeRemoteEvent = ReplicatedStorage.RemoteEvents.AnswerTrade
local openTradeRemoteEvent = ReplicatedStorage.RemoteEvents.OpenTrade
local declineTradeRemoteEvent = ReplicatedStorage.RemoteEvents.DeclineTrade
local updateCoinsRemoteEvent = ReplicatedStorage.RemoteEvents.UpdateCoins
local acceptTradeRemoteEvent = ReplicatedStorage.RemoteEvents.AcceptTrade
local activeRequests = {}

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
		activeRequests[tostring(senderId) .. tostring(receiver.UserId)] = {
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

	for id, session in pairs(activeRequests) do
		if id:find(tostring(player.UserId)) then
			session.coins[player.UserId] = coins
			updateCoinsRemoteEvent:FireClient(
				Players:GetPlayerByUserId(session.player1 == player.UserId and session.player2 or session.player1),
				coins
			)
			break
		end
	end
end)

acceptTradeRemoteEvent.OnServerEvent:Connect(function(player)
	for id, session in pairs(activeRequests) do
		if id:find(tostring(player.UserId)) then
			if session.player1 == player.UserId then
				session.isPlayer1Ready = not session.isPlayer1Ready
			else
				session.isPlayer2Ready = not session.isPlayer2Ready
			end

			if session.isPlayer1Ready and session.isPlayer2Ready then
				local partner = Players:GetPlayerByUserId(session.player1 == player.UserId and session.player2 or session.player1)

				player.PlayerData.Money.Value += session.coins[partner.UserId]
				partner.PlayerData.Money.Value += session.coins[player.UserId]

				activeRequests[id] = nil

				acceptTradeRemoteEvent:FireClient(partner)
				acceptTradeRemoteEvent:FireClient(player)
			end
		end
	end
end)
