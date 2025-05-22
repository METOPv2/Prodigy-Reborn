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

-- Binding
local changePlatformState = Instance.new("BindableEvent")

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

-- Change a platform's state
changePlatformState.Event:Connect(function(state)
    for _, platform in ipairs(workspace:GetDescendants()) do
        if platform:GetAttribute("IsPlatform") == true and platform:IsA("Model") then
            for _, part in ipairs(platform:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = state
                end
            end
        end
    end
end)

-- Monitor Humanoid state changes
Humanoid.StateChanged:Connect(function(_, newState)
    if newState ~= Enum.HumanoidStateType.Freefall then
        return changePlatformState:Fire(true)
    end

    -- Start monitoring vertical velocity
    while Humanoid:GetState() == Enum.HumanoidStateType.Freefall do
        local velocity = PrimaryPart.Velocity
        if velocity.Y > 0 then
            changePlatformState:Fire(false)
        elseif not downPressed then
            changePlatformState:Fire(true)
        end
        task.wait()
    end
end)
