local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local CharacterMovementSettings = require(ReplicatedStorage:WaitForChild("Source").Settings.CharacterMovement :: ModuleScript)
local Keybind = require(ReplicatedStorage:WaitForChild("Source").Packages.Keybind)

local specialJumpUpArrowAction = Keybind.GetAction("SpecialJumpUpArrow", Enum.KeyCode.Up)

local player = Players.LocalPlayer

local assets = ReplicatedStorage:WaitForChild("Assets") :: Folder
local animations = assets:FindFirstChild("Animations") :: Folder
local dash1Animation = animations:FindFirstChild("Dash1") :: Animation
local dash2Animation = animations:FindFirstChild("Dash2") :: Animation
local layAnimation = animations:FindFirstChild("Lay") :: Animation

export type Constructor = {
    specialJumpActivated: boolean,
    dashesActivated: number,
    SpecialJump: () -> nil,
    Dash: () -> nil,
    Lay: () -> () -> nil,
    Landed: () -> nil,
}

local AbilitiesManager = {
    specialJumpActivated = false,
    dashesActivated = 0,
}

function AbilitiesManager.SpecialJump()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    local primaryPart = character.PrimaryPart :: BasePart

    if AbilitiesManager.specialJumpActivated or humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or not specialJumpUpArrowAction:GetState() then
        return
    end

    primaryPart.Velocity = Vector3.new(0, CharacterMovementSettings.SpecialJumpStrength * primaryPart.Mass, 0)
    AbilitiesManager.specialJumpActivated = true
end

function AbilitiesManager.Dash()
    local character = player.Character or player.CharacterAdded:Wait()
    local primaryPart = character.PrimaryPart :: BasePart
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    local moveDirection = humanoid.MoveDirection

    if
        (humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping)
        or AbilitiesManager.dashesActivated >= CharacterMovementSettings.MaxDashes
        or (moveDirection ~= Vector3.new(-1, 0, 0) and moveDirection ~= Vector3.new(1, 0, 0))
    then
        return
    end

    local animator = humanoid:WaitForChild("Animator") :: Animator

    local dash1Track = animator:LoadAnimation(dash1Animation)
    dash1Track.Priority = Enum.AnimationPriority.Action4
    dash1Track.Looped = false

    local dash2Track = animator:LoadAnimation(dash2Animation)
    dash2Track.Priority = Enum.AnimationPriority.Action4
    dash2Track.Looped = false

    if math.random() < 0.5 then
        dash1Track:Play()
    else
        dash2Track:Play()
    end

    primaryPart:ApplyImpulse(moveDirection * Vector3.new(CharacterMovementSettings.DashSpeed, 100, 0))

    AbilitiesManager.dashesActivated += 1
end

function AbilitiesManager.Lay()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    local animator = humanoid:WaitForChild("Animator") :: Animator

    local layTrack = animator:LoadAnimation(layAnimation)
    layTrack.Priority = Enum.AnimationPriority.Idle
    layTrack.Looped = false

    humanoid.WalkSpeed = 0
    layTrack:Play()

    return function()
        humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
        layTrack:Stop()
    end
end

function AbilitiesManager.Landed()
    AbilitiesManager.dashesActivated = 0
    AbilitiesManager.specialJumpActivated = false
end

return AbilitiesManager
