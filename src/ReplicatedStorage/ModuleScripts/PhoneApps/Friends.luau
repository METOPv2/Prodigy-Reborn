local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local getFriendDataRemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunctions").GetFriendData

local player = Players.LocalPlayer
local phoneBackground = player.PlayerGui:WaitForChild("Phone").Background
local friendsHolder = phoneBackground.Menu.Container.Apps.Friends.Holder
local searchBox = phoneBackground.Cover.Container.Friends.SearchBox
local noFriendsLabel = friendsHolder.NoFriends
local muteScreen = phoneBackground.Cover.Container.Mute
local friendInfo = phoneBackground.Cover.Container.FriendInfo
local friendInfoMain = friendInfo.Main

local friendTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.FriendTemplate

local Friends = {}
local currentPlayerProfile = nil

local function openPlayerProfile(playerFrame)
	muteScreen.Visible = true

	local userId = playerFrame.Name
	local success, data = getFriendDataRemoteFunction:InvokeServer(userId)

	if not success then
		warn(data)
		muteScreen.Visible = false
		return
	end

	if currentPlayerProfile == userId then
		muteScreen.Visible = false
		friendInfo.Visible = false
		return
	end

	currentPlayerProfile = userId

	friendInfo.Thumbnail.Image = game.Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size60x60)
	friendInfoMain.InGameName.Text = string.format("In-game name: %s", data.Username)
	friendInfoMain.Username.Text = string.format("Username: %s", game.Players:GetNameFromUserIdAsync(userId))
	friendInfoMain.ClassType.Text = string.format("Class Type: %s", data.ClassType)
	friendInfoMain.LastOnline.Text = string.format("Last Online: %s", data.LastOnline)
	friendInfoMain.Level.Text = string.format("Level: %d", data.Level)

	muteScreen.Visible = false
	friendInfo.Visible = true
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local text = searchBox.Text

	for _, v in ipairs(friendsHolder:GetChildren()) do
		if not v:IsA("Frame") then
			continue
		end

		if searchBox.Text ~= text then
			break
		end

		v.Visible = v.UserName.Text:lower():find(text:lower()) ~= nil or v.DisplayName.Text:lower():find(text:lower()) ~= nil
	end
end)

function Friends.Refresh()
	for _, v in ipairs(friendsHolder:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	for _, friend in ipairs(player:GetFriendsOnline()) do
		local playerFrame = friendTemplate:Clone()
		playerFrame.Name = friend.VisitorId
		playerFrame.Thumbnail.Image = Players:GetUserThumbnailAsync(friend.VisitorId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
		playerFrame.UserName.Text = friend.UserName
		playerFrame.DisplayName.Text = friend.DisplayName

		if friend.IsOnline then
			if friend.LocationType == 1 or friend.LocationType == 4 or friend.LocationType == 5 then
				playerFrame.OnlineStatus.Text = friend.GameId == game.GameId and "Playing RP" or "Other"
				playerFrame.UIStroke.Color = Color3.fromRGB(0, 199, 0)
				playerFrame.OnlineStatus.TextColor3 = Color3.fromRGB(0, 199, 0)
			elseif friend.LocationType == 3 or friend.LocationType == 6 then
				playerFrame.OnlineStatus.Text = "In Studio"
				playerFrame.UIStroke.Color = Color3.fromRGB(255, 153, 0)
				playerFrame.OnlineStatus.TextColor3 = Color3.fromRGB(255, 153, 0)
			elseif friend.LocationType == 0 or friend.LocationType == 2 then
				playerFrame.OnlineStatus.Text = "Online"
				playerFrame.UIStroke.Color = Color3.fromRGB(0, 47, 255)
				playerFrame.OnlineStatus.TextColor3 = Color3.fromRGB(0, 47, 255)
			end
		else
			playerFrame.OnlineStatus.Text = "Offline"
			playerFrame.UIStroke.Color = Color3.fromRGB(13, 13, 13)
			playerFrame.OnlineStatus.TextColor3 = Color3.fromRGB(30, 30, 30)
		end

		playerFrame.OpeningContainer.TextButton.Activated:Connect(function()
			openPlayerProfile(playerFrame)
		end)
		playerFrame.Visible = friend.UserName:lower():find(searchBox.Text:lower()) ~= nil
			or friend.DisplayName:lower():find(searchBox.Text:lower()) ~= nil
		playerFrame.Parent = friendsHolder
	end

	local function iterPageItems(pages)
		return coroutine.wrap(function()
			local pagenum = 1
			while true do
				for _, item in ipairs(pages:GetCurrentPage()) do
					if friendsHolder:FindFirstChild(item.Id) then
						continue
					end

					coroutine.yield(item, pagenum)
				end
				if pages.IsFinished then
					break
				end
				pages:AdvanceToNextPageAsync()
				pagenum = pagenum + 1
			end
		end)
	end

	local friendPages = game.Players:GetFriendsAsync(player.UserId)
	local items = {}
	for item, _pageNo in iterPageItems(friendPages) do
		table.insert(items, item)
	end

	if #items == 0 then
		noFriendsLabel.Visible = true
		noFriendsLabel.Text = "No friends online"
		return
	else
		noFriendsLabel.Visible = false
	end

	for _, friend in ipairs(items) do
		local friendFrame = friendTemplate:Clone()
		friendFrame.Name = friend.Id
		friendFrame.UserName.Text = friend.Username
		friendFrame.DisplayName.Text = friend.DisplayName
		friendFrame.Thumbnail.Image = game.Players:GetUserThumbnailAsync(friend.Id, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
		friendFrame.OnlineStatus.Text = "Offline"

		friendFrame.OpeningContainer.TextButton.Activated:Connect(function()
			openPlayerProfile(friendFrame)
		end)

		friendFrame.Visible = friendFrame.UserName.Text:lower():find(searchBox.Text:lower()) ~= nil
			or friend.DisplayName:lower():find(searchBox.Text:lower()) ~= nil
		friendFrame.Parent = friendsHolder
	end
end

return Friends
