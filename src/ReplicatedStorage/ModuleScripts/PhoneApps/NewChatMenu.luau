local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NewChatMenu = {}

local openChatBindableEvent = ReplicatedStorage:WaitForChild("Binds").OpenChat

local chatPlayerTemplate = game.ReplicatedStorage:WaitForChild("Assets").UI.Phone.ChatPlayerTemplate
local phoneBackground = Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background
local peopleHolder = phoneBackground.Menu.Container.Apps.NewChatMenu.Holder
local searchBox = phoneBackground.Cover.Container.NewChatMenu.Search

local partnerId = game.ReplicatedStorage:WaitForChild("MessagesApp").PartnerId

local function createPlayerCard(player)
	local clone = chatPlayerTemplate:Clone()
	clone.Thumbnail.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size48x48)
	clone.DisplayName.Text = player.DisplayName
	clone.Thumbnail.IsFriend.Visible = player:IsFriendsWith(Players.LocalPlayer.UserId)
	clone.Status.Text = "In server"
	clone.Visible = player.Name:find(searchBox.Text)

	clone.TextButton.Activated:Connect(function()
		partnerId.Value = player.UserId
		openChatBindableEvent:Fire()
	end)

	clone.Parent = peopleHolder
end

function NewChatMenu.RefreshPlayerList()
	for _, v in ipairs(peopleHolder:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	for _, v in ipairs(Players:GetPlayers()) do
		if v == Players.LocalPlayer then
			continue
		end

		createPlayerCard(v)
	end
end

function NewChatMenu.Init()
	NewChatMenu.RefreshPlayerList()
end

Players.PlayerAdded:Connect(createPlayerCard)
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	for _, v in ipairs(peopleHolder:GetChildren()) do
		if not v:IsA("Frame") then
			continue
		end

		v.Visible = v.Name:find(searchBox.Text) ~= nil
	end
end)

return NewChatMenu
