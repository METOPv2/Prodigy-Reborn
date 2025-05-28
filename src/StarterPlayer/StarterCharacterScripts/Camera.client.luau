local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Settings = require(ReplicatedStorage:WaitForChild("Source").Settings.Camera)

local tweenInfo = TweenInfo.new(Settings.AnimationSpeed, Settings.AnimationStyle, Settings.AnimationDirection)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local primaryPart = character:WaitForChild("HumanoidRootPart") :: BasePart

local cameraPosition = primaryPart.CFrame.Position + Settings.CameraOffset

local camera = workspace.CurrentCamera
camera.CFrame = CFrame.new(
    cameraPosition,
    Vector3.new(cameraPosition.X + Settings.CameraOffset.X, cameraPosition.Y, cameraPosition.X + Settings.CameraOffset.Z)
) * CFrame.Angles(0, math.rad(180), 0)
camera.FieldOfView = Settings.CameraFOV
camera.CameraType = Enum.CameraType.Scriptable

local function MoveCamera()
    local primaryPartPosition = primaryPart.CFrame.Position
    local camOffset = Settings.CameraOffset

    local delta = primaryPartPosition + camOffset - cameraPosition

    local halfDeadzoneWidth = Settings.CameraDeadzoneSize.X / 2
    local halfDeadzoneHeight = Settings.CameraDeadzoneSize.Y / 2

    if math.abs(delta.X) > halfDeadzoneWidth then
        if delta.X > 0 then
            cameraPosition = Vector3.new(primaryPartPosition.X + camOffset.X - halfDeadzoneWidth, cameraPosition.Y, cameraPosition.Z)
        else
            cameraPosition = Vector3.new(primaryPartPosition.X + camOffset.X + halfDeadzoneWidth, cameraPosition.Y, cameraPosition.Z)
        end
    end
    if math.abs(delta.Y) > halfDeadzoneHeight then
        if delta.Y > 0 then
            cameraPosition = Vector3.new(cameraPosition.X, primaryPartPosition.Y + camOffset.Y - halfDeadzoneHeight, cameraPosition.Z)
        else
            cameraPosition = Vector3.new(cameraPosition.X, primaryPartPosition.Y + camOffset.Y + halfDeadzoneHeight, cameraPosition.Z)
        end
    end

    cameraPosition = Vector3.new(cameraPosition.X, cameraPosition.Y, primaryPartPosition.Z + camOffset.Z)

    TweenService:Create(camera, tweenInfo, {
        CFrame = CFrame.new(cameraPosition, Vector3.new(cameraPosition.X + camOffset.X, cameraPosition.Y, cameraPosition.X + camOffset.Z))
            * CFrame.Angles(0, math.rad(180), 0),
    }):Play()
end

RunService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, MoveCamera)
