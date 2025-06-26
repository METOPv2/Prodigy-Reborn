local Volume = {}

local player = game.Players.LocalPlayer
local playerData = player:WaitForChild("PlayerData")
local musicVolume = playerData.MusicVolume
local sfxVolume = playerData.SFXVolume

local changeVolumeRemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").ChangeVolume

local volumeApp = player.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.Volume
local musicSlider = volumeApp.Music.Slider
local musicSlideHandle = musicSlider.Handle
local musicDragDetector = musicSlideHandle.UIDragDetector
local sfxSlider = volumeApp.SFX.Slider
local sfxSlideHandle = sfxSlider.Handle
local sfxDragDetector = sfxSlideHandle.UIDragDetector

function Volume.Init()
	musicSlideHandle.Position = UDim2.new(
		0,
		math.clamp(
			musicVolume.Value * musicSlider.AbsoluteSize.X,
			musicSlideHandle.Size.X.Offset / 2,
			musicSlider.AbsoluteSize.X - musicSlideHandle.Size.X.Offset / 2
		),
		0.5,
		0
	)
	sfxSlideHandle.Position = UDim2.new(
		0,
		math.clamp(
			sfxVolume.Value * sfxSlider.AbsoluteSize.X,
			sfxSlideHandle.Size.X.Offset / 2,
			sfxSlider.AbsoluteSize.X - sfxSlideHandle.Size.X.Offset / 2
		),
		0.5,
		0
	)
end

musicDragDetector.DragContinue:Connect(function()
	musicVolume.Value = math.round(math.clamp(musicSlideHandle.Position.X.Offset / (musicSlider.AbsoluteSize.X - 10), 0, 1) * 10) / 10
end)

musicDragDetector.DragEnd:Connect(function()
	changeVolumeRemoteEvent:FireServer("Music", musicVolume.Value)
end)

sfxDragDetector.DragContinue:Connect(function()
	sfxVolume.Value = math.round(math.clamp(sfxSlideHandle.Position.X.Offset / (sfxSlider.AbsoluteSize.X - 10), 0, 1) * 10) / 10
end)

sfxDragDetector.DragEnd:Connect(function()
	changeVolumeRemoteEvent:FireServer("SFX", sfxVolume.Value)
end)

return Volume
