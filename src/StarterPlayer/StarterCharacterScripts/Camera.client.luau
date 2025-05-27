local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Module scripts
local Settings = require(ReplicatedStorage:WaitForChild("Source").Settings.Camera)

-- Tween service
local tweenInfo = TweenInfo.new(Settings.AnimationSpeed, Settings.AnimationStyle, Settings.AnimationDirection)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local primaryPart = character:WaitForChild("HumanoidRootPart") :: BasePart

-- Camera
local Camera = workspace.CurrentCamera
Camera.FieldOfView = Settings.CameraFOV
Camera.CameraType = Enum.CameraType.Scriptable

-- Camera state
local cameraPosition = primaryPart.CFrame.Position + Settings.CameraOffset

local function MoveCamera()
    local primaryPartPosition = primaryPart.CFrame.Position
    local camOffset = Settings.CameraOffset

    local delta = primaryPartPosition + camOffset - cameraPosition

    local deltaX, deltaY = delta.X, delta.Y

    local halfDeadzoneWidth = Settings.CameraDeadzoneSize.X / 2
    local halfDeadzoneHeight = Settings.CameraDeadzoneSize.Y / 2

    if math.abs(deltaX) > halfDeadzoneWidth then
        if deltaX > 0 then
            cameraPosition = Vector3.new(primaryPartPosition.X + camOffset.X - halfDeadzoneWidth, cameraPosition.Y, cameraPosition.Z)
        else
            cameraPosition = Vector3.new(primaryPartPosition.X + camOffset.X + halfDeadzoneWidth, cameraPosition.Y, cameraPosition.Z)
        end
    end
    if math.abs(deltaY) > halfDeadzoneHeight then
        if deltaY > 0 then
            cameraPosition = Vector3.new(cameraPosition.X, primaryPartPosition.Y + camOffset.Y - halfDeadzoneHeight, cameraPosition.Z)
        else
            cameraPosition = Vector3.new(cameraPosition.X, primaryPartPosition.Y + camOffset.Y + halfDeadzoneHeight, cameraPosition.Z)
        end
    end

    cameraPosition = Vector3.new(cameraPosition.X, cameraPosition.Y, primaryPartPosition.Z + camOffset.Z)

    TweenService
        :Create(Camera, tweenInfo, {
            CFrame = CFrame.lookAt(cameraPosition, Vector3.new(cameraPosition.X + camOffset.X, cameraPosition.Y, cameraPosition.X + camOffset.Z)),
        })
        :Play()
end

RunService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, MoveCamera)
