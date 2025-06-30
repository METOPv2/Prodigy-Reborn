local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local ChatModule = require(game.ServerStorage.Source.ModuleScripts.ChatModule)

local sendMessageRemoteEvent = game.ReplicatedStorage.RemoteEvents.SendMessage

sendMessageRemoteEvent.OnServerEvent:Connect(function(sender, receiverId, message)
	if type(receiverId) ~= "number" or type(message) ~= "string" then
		return
	end

	local chattedBefore = ChatModule.ChattedBefore(sender.UserId, receiverId)
	local chat = nil

	if chattedBefore then
		chat = ChatModule.GetChat(ChatModule.GetChatId(sender.UserId, receiverId))
	else
		chat = ChatModule.CreateChat(sender.UserId, receiverId)
	end

	local formattedMessage = {
		text = message,
		senderId = sender.UserId,
		sent = os.time(),
		id = HttpService:GenerateGUID(false),
	}

	table.insert(chat.messages, formattedMessage)

	sendMessageRemoteEvent:FireClient(sender, chat)
	sendMessageRemoteEvent:FireClient(Players:GetPlayerByUserId(receiverId), chat)
end)
