local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")

local PlayerChats = require(ServerStorage.Source.ModuleScripts.PlayerChats)
local Chats = require(ServerStorage.Source.ModuleScripts.Chats)

local ChatModule = {}

function ChatModule.CreateChat(senderId, receiverId)
	local chat = {
		senderId = senderId,
		receiverId = receiverId,
		messages = {},
		created = os.time(),
		id = HttpService:GenerateGUID(false),
	}

	table.insert(PlayerChats[senderId], chat.id)
	table.insert(PlayerChats[receiverId], chat.id)

	Chats[chat.id] = chat

	return chat
end

function ChatModule.GetChatId(senderId, receiverId)
	for _, id in ipairs(PlayerChats[senderId]) do
		if table.find(PlayerChats[receiverId], id) then
			return id
		end
	end

	return
end

function ChatModule.ChattedBefore(senderId, receiverId)
	return ChatModule.GetChatId(senderId, receiverId) ~= nil
end

function ChatModule.GetChat(chatId)
	return Chats[chatId]
end

return ChatModule
