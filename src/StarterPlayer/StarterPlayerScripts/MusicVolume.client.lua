--!strict
local Players: Players = game:GetService("Players")
local SoundService: SoundService = game:GetService("SoundService")

local player: Player = Players.LocalPlayer
local playerData = player:WaitForChild("PlayerData") :: Folder & {
    MusicVolume: NumberValue,
}
local musicVolume: NumberValue = playerData.MusicVolume

local musicGroup = SoundService:WaitForChild("Music") :: SoundGroup

local function updateMusicVolume(): ()
    musicGroup.Volume = musicVolume.Value
end

updateMusicVolume()
musicVolume.Changed:Connect(updateMusicVolume)
