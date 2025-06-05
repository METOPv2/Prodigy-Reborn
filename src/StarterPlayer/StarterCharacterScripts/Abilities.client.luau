--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AbilitiesManager = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.AbilitiesManager)
local Input = require(ReplicatedStorage:WaitForChild("Source").Utils.Input)

local character = script:FindFirstAncestorOfClass("Model") :: Model
local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

humanoid.StateChanged:Connect(function(_: Enum.HumanoidStateType, new: Enum.HumanoidStateType)
    if new == Enum.HumanoidStateType.Landed then
        AbilitiesManager.Landed()
    end
end)

Input.Pressed(Enum.KeyCode.Up):Connect(AbilitiesManager.SpecialJump)
Input.Pressed(Enum.KeyCode.LeftAlt):Connect(AbilitiesManager.Dash)
