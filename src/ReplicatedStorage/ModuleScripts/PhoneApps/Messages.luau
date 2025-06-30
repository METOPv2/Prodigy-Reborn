local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)
local ChatApp = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.PhoneApps.Chat)

local messagesApp = game.Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.Messages
local chatsHolder = messagesApp.Holder
local loading = messagesApp.Loading
local chatTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.ChatTemplate

local sendMessageRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").SendMessage
local partnerId = ReplicatedStorage.MessagesApp.PartnerId

local Messages = {}
local isLoading = false

local function startLoading()
	isLoading = true
	loading.ImageLabel.Rotation = 0
	loading.Visible = true

	coroutine.wrap(function()
		while isLoading do
			task.wait(0.1)
			loading.ImageLabel.Rotation += 15
		end

		loading.Visible = false
	end)()
end

local function stopLoading()
	isLoading = false
end

local chats = {}

function Messages.RefreshChatsList()
	chatsHolder.Info.Visible = false
	startLoading()

	for _, frame in ipairs(chatsHolder:GetChildren()) do
		if frame:IsA("Frame") then
			frame:Destroy()
		end
	end

	if #chats > 0 then
		for _, chat in pairs(chats) do
			local clone = chatTemplate:Clone()
			-- clone.Thumbnail.Image = Players:GetUserThumbnailAsync(chat.receiverId, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size48x48)
			-- clone.Username.Text = Players:GetNameFromUserIdAsync(chat.receiverId)
			clone.TextButton.Activated:Connect(function()
				partnerId.Value = chat.receiverId == Players.LocalPlayer.UserId and chat.senderId or chat.receiverId
				ChatApp.RefreshChat(chat)
				Phone.OpenApp("Chat")
			end)
			clone.Parent = chatsHolder
		end
	end

	chatsHolder.Info.Visible = #chats == 0

	stopLoading()
end

function Messages.Init()
	Messages.RefreshChatsList()
end

local function addChat(chat)
	local replaced = false

	for i, v in ipairs(chats) do
		if v.id == chat.id then
			replaced = true
			chats[i] = chat
			break
		end
	end

	if not replaced then
		table.insert(chats, chat)
	end

	Messages.RefreshChatsList()
end

sendMessageRemoteEvent.OnClientEvent:Connect(addChat)

return Messages
