-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Character
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local PrimaryPart = Character.PrimaryPart

-- Module scripts
local CharacterMovementSettings = require(ReplicatedStorage:WaitForChild("Source").Settings.CharacterMovement)

-- Abilities Manager
local AbilitiesManager = {
    doubleJumpActivated = false,
    dashesActivated = 0,
}

-- Function to handle the Special Jump ability
function AbilitiesManager.SpecialJump()
    if AbilitiesManager.doubleJumpActivated or Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        return
    end

    PrimaryPart.Velocity = Vector3.new(0, CharacterMovementSettings.SpecialJumpStrength, 0)
    AbilitiesManager.doubleJumpActivated = true
end

-- Function to handle the Dash ability
function AbilitiesManager.Dash(direction)
    if Humanoid:GetState() == Enum.HumanoidStateType.Freefall and AbilitiesManager.dashesActivated < CharacterMovementSettings.MaxDashes then
        AbilitiesManager.dashesActivated += 1
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        Character.PrimaryPart:ApplyImpulse(direction * CharacterMovementSettings.DashSpeed)
    end
end

-- Reset dashes when the character lands
Humanoid.StateChanged:Connect(function(_, new)
    if new == Enum.HumanoidStateType.Landed then
        AbilitiesManager.dashesActivated = 0
        AbilitiesManager.doubleJumpActivated = false
    end
end)

return AbilitiesManager
