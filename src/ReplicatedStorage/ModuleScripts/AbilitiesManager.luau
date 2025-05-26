--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterMovementSettings = require(ReplicatedStorage:WaitForChild("Source").Settings.CharacterMovement)

local player = Players.LocalPlayer

local assets = ReplicatedStorage:WaitForChild("Assets") :: Folder
local animations = assets:FindFirstChild("Animations") :: Folder
local dash1Animation = animations:FindFirstChild("Dash1") :: Animation
local dash2Animation = animations:FindFirstChild("Dash2") :: Animation

local particleAssets = assets:FindFirstChild("Particles") :: Folder
local specialJumpParticlesTemplate = particleAssets:FindFirstChild("SpecialJump") :: BasePart

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

    if AbilitiesManager.specialJumpActivated or humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or AbilitiesManager.dashesActivated > 0 then
        return
    end

    local particles = specialJumpParticlesTemplate:Clone()
    local particlesAttachment = particles:FindFirstChild("Attachment") :: Attachment
    particlesAttachment.Parent = primaryPart

    for _, particleEmitter in ipairs(particlesAttachment:GetChildren()) do
        if particleEmitter:IsA("ParticleEmitter") then
            particleEmitter:Emit(1)
        end
    end

    primaryPart:ApplyImpulse(Vector3.new(0, CharacterMovementSettings.SpecialJumpStrength * primaryPart.Mass, 0))

    AbilitiesManager.specialJumpActivated = true
end

function AbilitiesManager.Dash()
    local character = player.Character or player.CharacterAdded:Wait()
    local primaryPart = character.PrimaryPart :: BasePart
    local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

    local lookDirection = primaryPart.CFrame.LookVector
    local dashDirection = Vector3.new(lookDirection.X < 0 and -1 or 1, 0, 0)

    if
        (humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping)
        or AbilitiesManager.dashesActivated >= CharacterMovementSettings.MaxDashes
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

    primaryPart:ApplyImpulse(dashDirection * Vector3.new(CharacterMovementSettings.DashSpeed, 100, 0))

    AbilitiesManager.dashesActivated += 1
end

function AbilitiesManager.Landed()
    AbilitiesManager.dashesActivated = 0
    AbilitiesManager.specialJumpActivated = false
end

return AbilitiesManager
