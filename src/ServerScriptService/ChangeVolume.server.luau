--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local changeVolumeRemoteEvent: RemoteEvent = ReplicatedStorage.RemoteEvents.ChangeVolume

local names = {
    sfx = "SFXVolume",
    music = "MusicVolume",
}

changeVolumeRemoteEvent.OnServerEvent:Connect(function(player: Player, name: string, value: number)
    local valueName = names[name:lower()]

    if not valueName then
        return
    end

    value = math.clamp(value, 0, 1)

    local playerData = player:FindFirstChild("PlayerData") :: Folder
    local instanceValue = playerData:FindFirstChild(valueName) :: NumberValue
    instanceValue.Value = value
end)
