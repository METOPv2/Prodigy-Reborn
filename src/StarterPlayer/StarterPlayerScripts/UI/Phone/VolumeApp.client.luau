--!strict
local Players: Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player: Player = Players.LocalPlayer
local playerData = player:WaitForChild("PlayerData") :: Folder & {
    MusicVolume: NumberValue,
    SFXVolume: NumberValue,
}
local musicVolume: NumberValue = playerData.MusicVolume
local sfxVolume: NumberValue = playerData.SFXVolume

local changeVolumeRemoteEvent: RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").ChangeVolume

local playerGui: PlayerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageButton & {
        Menu: ImageLabel & {
            Container: ImageLabel & {
                Apps: Folder & {
                    Volume: Frame,
                },
            },
        },
    },
}

local volumeApp = phoneGui.Background.Menu.Container.Apps.Volume :: Frame & {
    Music: Frame & {
        Slider: Frame,
    },
    SFX: Frame & {
        Slider: Frame,
    },
}
local musicSlider = volumeApp.Music.Slider :: Frame & {
    Handle: Frame & {
        UIDragDetector: UIDragDetector,
    },
}
local musicSlideHandle: Frame & { UIDragDetector: UIDragDetector } = musicSlider.Handle
local musicDragDetector: UIDragDetector = musicSlideHandle.UIDragDetector
local sfxSlider = volumeApp.SFX.Slider :: Frame & {
    Handle: Frame & {
        UIDragDetector: UIDragDetector,
    },
}
local sfxSlideHandle: Frame & { UIDragDetector: UIDragDetector } = sfxSlider.Handle
local sfxDragDetector: UIDragDetector = sfxSlideHandle.UIDragDetector

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
