-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Movement variables
local moveDirection = Vector3.new(0, 0, 0)
local jumpRequested = false
local keyToDirection = { [Enum.KeyCode.Left] = -1, [Enum.KeyCode.Right] = 1 }

-- Manage inputs
local function InputBegan(input: InputObject, isProcessed)
    if isProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.LeftAlt and Humanoid:GetState() == Enum.HumanoidStateType.Running then
        jumpRequested = true
    elseif keyToDirection[input.KeyCode] then
        moveDirection = Vector3.new(keyToDirection[input.KeyCode], 0, 0)
    end
end

local function InputEnded(input: InputObject, isProcessed)
    if isProcessed then
        return
    end

    if keyToDirection[input.KeyCode] then
        moveDirection = keyToDirection[input.KeyCode] == moveDirection.X and Vector3.zero or moveDirection
    end
end

-- Handle inputs
UserInputService.InputBegan:Connect(InputBegan)
UserInputService.InputEnded:Connect(InputEnded)

-- Update movement and jumping
RunService.Heartbeat:Connect(function()
    Humanoid:Move(moveDirection)
    if jumpRequested and Humanoid.FloorMaterial ~= Enum.Material.Air then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        jumpRequested = false
    end
end)
