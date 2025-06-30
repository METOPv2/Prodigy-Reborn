local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Chat = {}

local partnerId = ReplicatedStorage:WaitForChild("MessagesApp").PartnerId
local sendMessageRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").SendMessage

local phoneBackground = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background
local textBox = phoneBackground.Cover.Container.Chat.TextBox
local chatHolder = phoneBackground.Menu.Container.Apps.Chat.Holder

local incomeMessageTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.IncomeMessageTemplate
local outcomeMessageTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.OutcomeMessageTemplate

function Chat.RefreshChat(chat)
	if not chat or partnerId.Value ~= chat.senderId and partnerId.Value ~= chat.receiverId then
		return
	end

	for _, v in ipairs(chatHolder:GetChildren()) do
		if v.ClassName == "Frame" then
			v:Destroy()
		end
	end

	for _, v in ipairs(chat.messages) do
		local frame = nil

		if v.senderId == Players.LocalPlayer.UserId then
			frame = outcomeMessageTemplate:Clone()
		else
			frame = incomeMessageTemplate:Clone()
		end

		-- frame.Thumbnail.Image = Players:GetUserThumbnailAsync(v.senderId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
		frame.Date.Text = os.date("%c", v.sent)
		frame.Message.Text = v.text
		frame.Parent = chatHolder
	end

	chatHolder.Info.Visible = #chat.messages == 0
end

function Chat.Message()
	if textBox.Text == "" or partnerId.Value == 0 then
		return
	end

	sendMessageRemoteEvent:FireServer(partnerId.Value, textBox.Text)

	textBox.Text = ""
end

sendMessageRemoteEvent.OnClientEvent:Connect(Chat.RefreshChat)

return Chat
