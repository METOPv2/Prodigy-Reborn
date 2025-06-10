--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local DataStoreService = game:GetService("DataStoreService")

local UsernamesStore = DataStoreService:GetGlobalDataStore("Usernames")

local checkUsernameRemoteFunction = ReplicatedStorage.RemoteFunctions.CheckUsername

checkUsernameRemoteFunction.OnServerInvoke = function(player, username: string)
    if not username or username == "" then
        return username, false, "Username cannot be empty."
    end

    if not TextService:FilterStringAsync(username, player.UserId, Enum.TextFilterContext.PublicChat) then
        return username, false, "Username could not be validated."
    end

    local success, result = pcall(function()
        return TextService:FilterStringAsync(username, player.UserId, Enum.TextFilterContext.PublicChat):GetNonChatStringForBroadcastAsync()
    end)

    if not success then
        return username, false, "Failed to check username appropriateness."
    end

    if result ~= username then
        return username, false, "Username contains inappropriate content."
    end

    local existingUsername = UsernamesStore:GetAsync(username:lower())
    if existingUsername then
        return username, false, `{username} is already taken.`
    end

    return username, true, "Username is available."
end
