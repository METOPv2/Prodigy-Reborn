local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local Keybind = require(ReplicatedStorage:WaitForChild("Source").Packages.Keybind)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

local walkLeftAction = Keybind.GetAction("WalkLeft", Enum.KeyCode.Left)
local walkRightAction = Keybind.GetAction("WalkRight", Enum.KeyCode.Right)
local jumpAction = Keybind.GetAction("Jump", Enum.KeyCode.LeftAlt)
local shiftToRunAction = Keybind.GetAction("ShiftToRun", Enum.KeyCode.LeftShift)

local moveDirection = Vector3.zero

walkLeftAction.Pressed:Connect(function()
    moveDirection += Vector3.new(-1, 0, 0)
end)

walkLeftAction.Released:Connect(function()
    moveDirection += Vector3.new(1, 0, 0)
end)

walkRightAction.Pressed:Connect(function()
    moveDirection += Vector3.new(1, 0, 0)
end)

walkRightAction.Released:Connect(function()
    moveDirection += Vector3.new(-1, 0, 0)
end)

jumpAction.Pressed:Connect(function()
    local state = humanoid:GetState()
    if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

shiftToRunAction.Pressed:Connect(function()
    humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed * 2
end)

shiftToRunAction.Released:Connect(function()
    humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
end)

RunService.RenderStepped:Connect(function()
    humanoid:Move(moveDirection, false)
end)
