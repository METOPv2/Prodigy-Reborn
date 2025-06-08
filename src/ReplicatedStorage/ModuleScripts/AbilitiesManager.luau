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
local dashParticlesTemplate = particleAssets:FindFirstChild("Dash") :: BasePart

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

    local maxLifetime = 0
    for _, particleEmitter in ipairs(particlesAttachment:GetChildren()) do
        if particleEmitter:IsA("ParticleEmitter") then
            particleEmitter:Emit(1)

            if particleEmitter.Lifetime.Max > maxLifetime then
                maxLifetime = particleEmitter.Lifetime.Max
            end
        end
    end

    task.delay(maxLifetime, function()
        particles:Destroy()
    end)

    local characterMass = 0
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            characterMass += part.Mass
        end
    end

    primaryPart:ApplyImpulse(Vector3.new(0, CharacterMovementSettings.SpecialJumpStrength * characterMass, 0))

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
    dash1Track.Looped = false

    local dash2Track = animator:LoadAnimation(dash2Animation)
    dash2Track.Looped = false

    if math.random() < 0.5 then
        dash1Track:Play()
    else
        dash2Track:Play()
    end

    local characterMass = 0
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            characterMass += part.Mass
        end
    end

    local particles = dashParticlesTemplate:Clone()
    local particlesAttachment = particles:FindFirstChild("Attachment") :: Attachment
    particlesAttachment.Parent = primaryPart

    local maxLifetime = 0
    for _, particleEmitter in ipairs(particlesAttachment:GetChildren()) do
        if particleEmitter:IsA("ParticleEmitter") then
            particleEmitter.Rotation = NumberRange.new(lookDirection.X * -90)
            particleEmitter:Emit(10)

            if particleEmitter.Lifetime.Max > maxLifetime then
                maxLifetime = particleEmitter.Lifetime.Max
            end
        end
    end

    task.delay(maxLifetime, function()
        particles:Destroy()
    end)

    primaryPart:ApplyImpulse(dashDirection * Vector3.new(CharacterMovementSettings.DashSpeed * characterMass, 100, 0))

    local rootAttachment = primaryPart:FindFirstChild("RootAttachment") :: Attachment

    local vectorForce = Instance.new("VectorForce")
    vectorForce.ApplyAtCenterOfMass = true
    vectorForce.Force = Vector3.new(0, 80 * characterMass, 0)
    vectorForce.Attachment0 = rootAttachment

    local connection: RBXScriptConnection

    connection = humanoid.StateChanged:Connect(function(_: Enum.HumanoidStateType, new: Enum.HumanoidStateType)
        if new == Enum.HumanoidStateType.Landed then
            vectorForce:Destroy()
            connection:Disconnect()
        end
    end)

    task.delay(0.1, function()
        if not vectorForce then
            return
        end

        vectorForce.Parent = primaryPart

        coroutine.wrap(function()
            while connection do
                if vectorForce.Parent then
                    local decreasePerSecond = 80 * characterMass * 10
                    local decreasePerMillisecond = decreasePerSecond / 1000
                    local currentForce = vectorForce.Force
                    local newY = math.max(0, currentForce.Y - decreasePerMillisecond)
                    vectorForce.Force = Vector3.new(currentForce.X, newY, currentForce.Z)
                    if newY == 0 then
                        vectorForce:Destroy()
                        connection:Disconnect()
                        break
                    end
                else
                    break
                end

                task.wait()
            end
        end)()
    end)

    AbilitiesManager.dashesActivated += 1
end

function AbilitiesManager.Landed()
    AbilitiesManager.dashesActivated = 0
    AbilitiesManager.specialJumpActivated = false
end

return AbilitiesManager
