-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Module scripts
local Settings = require(ReplicatedStorage.Source.Settings.Camera)

-- Tween service
local tweenInfo = TweenInfo.new(Settings.AnimationSpeed, Settings.AnimationStyle, Settings.AnimationDirection)

-- Character
local Player = Players.LocalPlayer
local Character = Player.Character
local PrimaryPart = Character.PrimaryPart

-- Camera
local Camera = workspace.CurrentCamera
Camera.FieldOfView = Settings.CameraFOV
Camera.CameraType = Enum.CameraType.Scriptable
Camera.CFrame = CFrame.lookAt(PrimaryPart.CFrame.Position + Settings.CameraOffset, PrimaryPart.CFrame.Position)

-- Functions
local function MoveCamera()
    TweenService:Create(Camera, tweenInfo, {
        CFrame = CFrame.lookAt(PrimaryPart.CFrame.Position + Settings.CameraOffset, PrimaryPart.CFrame.Position),
    }):Play()
end

-- Events
RunService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, MoveCamera)
