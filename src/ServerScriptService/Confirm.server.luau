--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local TextService = game:GetService("TextService")

local UsernamesStore = DataStoreService:GetGlobalDataStore("Usernames")
local ValuesDataStore = DataStoreService:GetDataStore("Player", "Values")

local confirmUsernameRemoteEvent = ReplicatedStorage.RemoteEvents.ConfirmUsername

confirmUsernameRemoteEvent.OnServerEvent:Connect(function(player, username: string)
    if not username or username == "" then
        return
    end

    if not TextService:FilterStringAsync(username, player.UserId, Enum.TextFilterContext.PublicChat) then
        return
    end

    local success, result = pcall(function()
        return TextService:FilterStringAsync(username, player.UserId, Enum.TextFilterContext.PublicChat):GetNonChatStringForBroadcastAsync()
    end)

    if not success then
        return
    end

    if result ~= username then
        return
    end

    local existingUsername = UsernamesStore:GetAsync(username)
    if existingUsername then
        return
    end

    UsernamesStore:SetAsync(username:lower(), player.UserId)
    pcall(function()
        return ValuesDataStore:UpdateAsync("Player_" .. tostring(player.UserId), function(data)
            data.Username = username
            return data
        end)
    end)
    player:SetAttribute("Username", username)
end)
