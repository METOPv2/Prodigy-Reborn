-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Character
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character.Humanoid

-- Module scripts
local CharacterMovementSettings = require(ReplicatedStorage:WaitForChild("Source").Settings.CharacterMovement)

-- Abilities Manager
local AbilitiesManager = {
    doubleJumpActivated = false,
    dashesActivated = 0,
    currentDashForce = nil,
}

-- Function to handle the Special Jump ability
function AbilitiesManager.SpecialJump()
    if AbilitiesManager.doubleJumpActivated or Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        return
    end

    local PrimaryPart = Character.PrimaryPart

    Character.PrimaryPart.Velocity = Vector3.new(0, CharacterMovementSettings.SpecialJumpStrength * PrimaryPart.Mass, 0)
    AbilitiesManager.doubleJumpActivated = true
end

-- Function to handle the Dash ability
function AbilitiesManager.Dash(direction)
    if
        (Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall and Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping)
        or AbilitiesManager.dashesActivated >= CharacterMovementSettings.MaxDashes
        or (direction ~= Vector3.new(-1, 0, 0) and direction ~= Vector3.new(1, 0, 0))
    then
        return
    end

    local PrimaryPart = Character.PrimaryPart

    -- Clean up existing dash force
    if AbilitiesManager.currentDashForce then
        AbilitiesManager.currentDashForce:Destroy()
        AbilitiesManager.currentDashForce = nil
    end

    AbilitiesManager.dashesActivated += 1

    -- Store current Y position to maintain height
    local currentY = PrimaryPart.Position.Y

    -- Apply upward boost for multi-dashes
    if AbilitiesManager.dashesActivated > 1 then
        currentY = currentY + CharacterMovementSettings.DashUpwardBoost
        PrimaryPart.Velocity = PrimaryPart.Velocity + Vector3.new(0, CharacterMovementSettings.DashUpwardBoost, 0)
    end

    -- Use BodyPosition to maintain exact height and horizontal movement
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Name = "DashBodyPosition"
    bodyPosition.MaxForce = Vector3.new(4000, math.huge, 0)
    bodyPosition.P = 10000 -- High power for responsiveness
    bodyPosition.D = 2000 -- High damping to prevent oscillation

    -- Calculate target position (maintaining Y level)
    local dashDistance = CharacterMovementSettings.DashSpeed * CharacterMovementSettings.DashDuration
    local targetPosition = PrimaryPart.Position + Vector3.new(direction.X * dashDistance, 0, 0)
    targetPosition = Vector3.new(targetPosition.X, currentY, 0)

    bodyPosition.Position = targetPosition
    bodyPosition.Parent = PrimaryPart

    AbilitiesManager.currentDashForce = bodyPosition

    -- Clean up after dash duration
    task.delay(CharacterMovementSettings.DashDuration, function()
        if bodyPosition and bodyPosition.Parent then
            bodyPosition:Destroy()
            AbilitiesManager.currentDashForce = nil
        end
    end)
end

-- Reset abilities when landing
Humanoid.StateChanged:Connect(function(_, new)
    if new == Enum.HumanoidStateType.Landed then
        AbilitiesManager.dashesActivated = 0
        AbilitiesManager.doubleJumpActivated = false
        if AbilitiesManager.currentDashForce and AbilitiesManager.currentDashForce.Parent then
            AbilitiesManager.currentDashForce:Destroy()
            AbilitiesManager.currentDashForce = nil
        end
    end
end)

return AbilitiesManager
