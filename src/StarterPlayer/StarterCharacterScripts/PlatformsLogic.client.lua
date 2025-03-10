-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Character
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PrimaryPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Raycasting
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.FilterDescendantsInstances = { Character }

-- Switches
local downPressed = false

-- Manage input
local function InputBegan(input: InputObject, isProcessed)
    if isProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Down then
        downPressed = true
    end
end

local function InputEnded(input: InputObject, isProcessed)
    if isProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Down then
        downPressed = false
    end
end

-- Handle input
UserInputService.InputBegan:Connect(InputBegan)
UserInputService.InputEnded:Connect(InputEnded)

-- Function to enable platform collisions
local function EnablePlatformCollisions()
    local platformsFolder = workspace:WaitForChild("CurrentMap"):WaitForChild("Platforms")
    for _, platform in ipairs(platformsFolder:GetChildren()) do
        if platform:IsA("BasePart") then
            platform.CanCollide = true
        end
    end
end

-- Function to disable platform collisions
local function DisablePlatformCollisions()
    local platformsFolder = workspace:WaitForChild("CurrentMap"):WaitForChild("Platforms")
    for _, platform in ipairs(platformsFolder:GetChildren()) do
        if platform:IsA("BasePart") then
            platform.CanCollide = false
        end
    end
end

-- Monitor Humanoid state changes
Humanoid.StateChanged:Connect(function(_, newState)
    if newState ~= Enum.HumanoidStateType.Freefall then
        return EnablePlatformCollisions()
    end

    -- Start monitoring vertical velocity
    while Humanoid:GetState() == Enum.HumanoidStateType.Freefall do
        local velocity = PrimaryPart.Velocity
        if velocity.Y > 0 then
            DisablePlatformCollisions()
        elseif not downPressed then
            EnablePlatformCollisions()
        end
        task.wait()
    end
end)
