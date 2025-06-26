local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ValuesDataStore = DataStoreService:GetDataStore("Player", "Values")

local getFriendsDataRemoteFunction = ReplicatedStorage.RemoteFunctions.GetFriendData

getFriendsDataRemoteFunction.OnServerInvoke = function(_, friendUserId)
	if not tonumber(friendUserId) then
		return
	end

	local friend = Players:GetPlayerByUserId(friendUserId)
	if friend then
		return true,
			{
				Username = friend:GetAttribute("Username"),
				ClassType = "Warrior", -- change
				LastOnline = "Now",
				Level = friend.PlayerData and (friend.PlayerData.Level and friend.PlayerData.Level.Value) or 0,
			}
	else
		local valuesSuccess, savedValues = pcall(function()
			return ValuesDataStore:GetAsync("Player_" .. tostring(friendUserId))
		end)

		if valuesSuccess then
			if savedValues then
				return true,
					{
						Username = savedValues.Username,
						ClassType = "Warrior", -- change,
						LastOnline = savedValues.LastOnline and os.clock() - savedValues.LastOnline or "Unknown",
						Level = savedValues.Level,
					}
			else
				return false, "The player never joined the game."
			end
		else
			return false, "Failed to load player's data."
		end
	end
end
