local ContextActionService = game:GetService("ContextActionService")

local character = script.Parent.Parent
local humanoid = character:WaitForChild("Humanoid")

local function shiftToRun(name, state)
    if name ~= "ShiftToRun" then
        return
    end

    if state == Enum.UserInputState.Begin then
        humanoid.WalkSpeed = 32
    else
        humanoid.WalkSpeed = 16
    end
end

ContextActionService:BindAction("ShiftToRun", shiftToRun, false, Enum.KeyCode.LeftShift)
