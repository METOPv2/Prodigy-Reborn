local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local getFriendDataRemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunctions").GetFriendData

local player = Players.LocalPlayer
local phoneBackground = player.PlayerGui:WaitForChild("Phone").Background
local friendsHolder = phoneBackground.Menu.Container.Apps.Friends.Holder

local noFriendsLabel = friendsHolder.NoFriends
local coverContainer = phoneBackground.Cover.Container
local muteScreen = coverContainer.Mute
local friendInfo = coverContainer.FriendInfo
local friendInfoMain = friendInfo.Main
local friendsCover = coverContainer.Friends
local searchBox = friendsCover.SearchBox
local filter = friendsCover.Filter
local failedToOpenPlayerProfile = friendsCover.FailedToOpenPlayerProfile

local friendTemplate = ReplicatedStorage:WaitForChild("Assets").UI.Phone.FriendTemplate

local Friends = {}
local refreshedTimes = 0
local showOnlyWhoJoined = false

friendsHolder.ChildAdded:Connect(function()
	noFriendsLabel.Visible = #friendsHolder:GetChildren() == 3
end)

friendsHolder.ChildRemoved:Connect(function()
	noFriendsLabel.Visible = #friendsHolder:GetChildren() == 3
end)

local function updateFrameVisibility(frame)
	if showOnlyWhoJoined then
		frame.Visible = frame.Thumbnail.JoinedTheGame.Visible
	else
		frame.Visible = true
	end

	if searchBox.Text ~= "" then
		frame.Visible = frame.DisplayName:lower():find(searchBox.Text:lower()) ~= nil
	end
end

filter.OnlyPlayersWhoJoined.ImageButton.ImageLabel.Visible = false
filter.OnlyPlayersWhoJoined.ImageButton.Activated:Connect(function()
	showOnlyWhoJoined = not showOnlyWhoJoined
	filter.OnlyPlayersWhoJoined.ImageButton.ImageLabel.Visible = showOnlyWhoJoined

	for _, v in ipairs(friendsHolder:GetChildren()) do
		if not v:IsA("Frame") then
			continue
		end

		updateFrameVisibility(v)
	end
end)

local function abbreviateSeconds(seconds)
	if seconds < 60 then
		return tostring(math.floor(seconds)) .. "s"
	elseif seconds < 3600 then
		return tostring(math.floor(seconds / 60)) .. "m"
	elseif seconds < 86400 then
		return tostring(math.floor(seconds / 3600)) .. "h"
	elseif seconds < 604800 then
		return tostring(math.floor(seconds / 86400)) .. "d"
	elseif seconds < 2592000 then
		return tostring(math.floor(seconds / 604800)) .. "w"
	elseif seconds < 31536000 then
		return tostring(math.floor(seconds / 2592000)) .. "mo"
	else
		return "more than a year"
	end
end

local function openPlayerProfile(playerFrame)
	local userId = playerFrame.Name
	if friendInfo:GetAttribute("CurrentPlayer") == userId then
		friendInfo:SetAttribute("CurrentPlayer", nil)
		friendInfo.Visible = false
		return
	else
		muteScreen.Visible = true
	end

	local success, data = getFriendDataRemoteFunction:InvokeServer(userId)

	if not success then
		failedToOpenPlayerProfile.TextLabel.Text = data
		failedToOpenPlayerProfile.TextButton.Activated:Once(function()
			failedToOpenPlayerProfile.Visible = false
		end)
		failedToOpenPlayerProfile.Visible = true
		muteScreen.Visible = false
		return
	end

	friendInfo:SetAttribute("CurrentPlayer", userId)

	friendInfo.Thumbnail.Image = game.Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size60x60)
	friendInfoMain.InGameName.Text = string.format("%s", data.Username)
	friendInfoMain.Username.Text = string.format("@%s", game.Players:GetNameFromUserIdAsync(userId))
	friendInfoMain.ClassType.Text = string.format("Class: %s", data.ClassType)
	friendInfoMain.LastOnline.Text =
		string.format("Online: %s", type(data.LastOnline) == "number" and abbreviateSeconds(data.LastOnline) .. " ago" or data.LastOnline)
	friendInfoMain.Level.Text = string.format("Lvl: %d", data.Level)

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

		v.Visible = v.DisplayName.Text:lower():find(text:lower()) ~= nil
	end
end)

function Friends.Refresh()
	refreshedTimes += 1

	local startedRefreshingAt = refreshedTimes

	for _, v in ipairs(friendsHolder:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	for _, friend in ipairs(player:GetFriendsOnline()) do
		if refreshedTimes ~= startedRefreshingAt then
			break
		end

		local success, data = getFriendDataRemoteFunction:InvokeServer(friend.VisitorId)

		local playerFrame = friendTemplate:Clone()
		playerFrame.Name = friend.VisitorId
		playerFrame.Thumbnail.Image = Players:GetUserThumbnailAsync(friend.VisitorId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
		playerFrame.DisplayName.Text = data and data.Username or friend.DisplayName
		playerFrame.Thumbnail.JoinedTheGame.Visible = success

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

		updateFrameVisibility(playerFrame)

		playerFrame.OpeningContainer.TextButton.Activated:Connect(function()
			openPlayerProfile(playerFrame)
		end)

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
		if refreshedTimes ~= startedRefreshingAt then
			break
		end

		table.insert(items, item)
	end

	for _, friend in ipairs(items) do
		if refreshedTimes ~= startedRefreshingAt then
			break
		end

		local success, data = getFriendDataRemoteFunction:InvokeServer(friend.Id)

		local playerFrame = friendTemplate:Clone()
		playerFrame.Name = friend.Id
		playerFrame.DisplayName.Text = data and data.Username or friend.DisplayName
		playerFrame.Thumbnail.Image = game.Players:GetUserThumbnailAsync(friend.Id, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
		playerFrame.OnlineStatus.Text = "Offline"
		playerFrame.Thumbnail.JoinedTheGame.Visible = success

		playerFrame.OpeningContainer.TextButton.Activated:Connect(function()
			openPlayerProfile(playerFrame)
		end)

		updateFrameVisibility(playerFrame)

		playerFrame.Parent = friendsHolder
	end
end

return Friends
