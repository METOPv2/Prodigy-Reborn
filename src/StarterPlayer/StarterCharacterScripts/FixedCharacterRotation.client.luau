local RunService = game:GetService("RunService")

local character = script:FindFirstAncestorOfClass("Model")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local lastDirection = 1

local function updateRotation()
    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        local newDirection = moveDir.X >= 0 and 1 or -1
        if newDirection ~= lastDirection then
            lastDirection = newDirection
            local yRot = (newDirection == 1) and 0 or math.rad(180)
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, yRot, 0)
        end
    end
end

RunService.RenderStepped:Connect(updateRotation)
