--!strict
local Players: Players = game:GetService("Players")
local SoundService: SoundService = game:GetService("SoundService")

local player: Player = Players.LocalPlayer
local playerData = player:WaitForChild("PlayerData") :: Folder & {
    SFXVolume: NumberValue,
}
local sfxVolume: NumberValue = playerData.SFXVolume

local sfxGroup = SoundService:WaitForChild("SFX") :: SoundGroup

local function updateSfxVolume(): ()
    sfxGroup.Volume = sfxVolume.Value
end

updateSfxVolume()
sfxVolume.Changed:Connect(updateSfxVolume)
