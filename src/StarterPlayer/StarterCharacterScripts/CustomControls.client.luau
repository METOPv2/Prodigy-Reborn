--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Input = require(ReplicatedStorage:WaitForChild("Source").Utils.Input)

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

local function updateWalkingState()
    local direction = 0

    if Input:IsKeyDown(Enum.KeyCode.Left) then
        direction -= 1
    end

    if Input:IsKeyDown(Enum.KeyCode.Right) then
        direction += 1
    end

    if isLaying then
        if direction == 0 then
            layTrack:Play()
        else
            layTrack:Stop()
        end
    end

    moveDirection = Vector3.new(direction, 0, 0)

    repeat
        task.wait()
        humanoid:Move(moveDirection)
    until humanoid.MoveDirection.X ~= direction
end

local function updateRunningState()
    if Input:IsKeyDown(Enum.KeyCode.LeftShift) then
        humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed * 2
    else
        humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
    end
end

local function updateLayingState()
    if Input:IsKeyDown(Enum.KeyCode.Down) then
        humanoid.WalkSpeed = 0
        isLaying = true
        layTrack:Play()
    else
        isLaying = false
        layTrack:Stop()
    end
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

Input.Pressed(Enum.KeyCode.Right):Connect(updateWalkingState).Released:Connect(updateWalkingState)
Input.Pressed(Enum.KeyCode.Left):Connect(updateWalkingState).Released:Connect(updateWalkingState)
Input.Pressed(Enum.KeyCode.LeftShift):Connect(updateRunningState).Released:Connect(updateRunningState)
Input.Pressed(Enum.KeyCode.Down):Connect(updateLayingState).Released:Connect(updateLayingState)
Input.Pressed(Enum.KeyCode.LeftAlt):Connect(jump)
