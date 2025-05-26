--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")

local assets = ReplicatedStorage:WaitForChild("Assets") :: Folder
local animations = assets:FindFirstChild("Animations") :: Folder
local layAnimation = animations:FindFirstChild("Lay") :: Animation

local character = script:FindFirstAncestorOfClass("Model") :: Model
local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
local animator = humanoid:FindFirstChild("Animator") :: Animator

local layTrack = animator:LoadAnimation(layAnimation)
layTrack.Looped = true

layTrack.DidLoop:Connect(function()
    humanoid.WalkSpeed = 0
end)

layTrack.Stopped:Connect(function()
    humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
end)

local moveDirection = Vector3.zero
local isLaying = false

local function startWalkingRight()
    if isLaying then
        layTrack:Stop()
    end

    moveDirection += Vector3.new(1, 0, 0)
end

local function stopWalkingRight()
    if isLaying then
        layTrack:Play()
    end

    moveDirection -= Vector3.new(1, 0, 0)
end

local function startWalkingLeft()
    if isLaying then
        layTrack:Stop()
    end

    moveDirection -= Vector3.new(1, 0, 0)
end

local function stopWalkingLeft()
    if isLaying then
        layTrack:Play()
    end

    moveDirection += Vector3.new(1, 0, 0)
end

local function jump()
    if isLaying then
        return
    end

    local state = humanoid:GetState()
    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

local function startRunning()
    humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed * 2
end

local function stopRunning()
    humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
end

local function startLaying()
    humanoid.WalkSpeed = 0
    isLaying = true
    layTrack:Play()
end

local function stopLaying()
    isLaying = false
    layTrack:Stop()
end

local function inputBegan(input: InputObject, gameProcessed: boolean)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Right then
        startWalkingRight()
    elseif input.KeyCode == Enum.KeyCode.Left then
        startWalkingLeft()
    elseif input.KeyCode == Enum.KeyCode.LeftAlt then
        jump()
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        startRunning()
    elseif input.KeyCode == Enum.KeyCode.Down then
        startLaying()
    end
end

local function inputEnded(input: InputObject, gameProcessed: boolean)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Right then
        stopWalkingRight()
    elseif input.KeyCode == Enum.KeyCode.Left then
        stopWalkingLeft()
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        stopRunning()
    elseif input.KeyCode == Enum.KeyCode.Down then
        stopLaying()
    end
end

UserInputService.InputBegan:Connect(inputBegan)
UserInputService.InputEnded:Connect(inputEnded)

RunService.RenderStepped:Connect(function()
    humanoid:Move(moveDirection, false)
end)
