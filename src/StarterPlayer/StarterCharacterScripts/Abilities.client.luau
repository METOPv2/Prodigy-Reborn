--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local AbilitiesManager = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.AbilitiesManager)

local character = script:FindFirstAncestorOfClass("Model") :: Model
local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

local specialJumpInitialized = false

humanoid.StateChanged:Connect(function(_: Enum.HumanoidStateType, new: Enum.HumanoidStateType)
    if new == Enum.HumanoidStateType.Landed then
        AbilitiesManager.Landed()
    end
end)

local function inputBegan(input: InputObject, gameProcessed: boolean)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.LeftAlt then
        if specialJumpInitialized then
            AbilitiesManager.SpecialJump()
        else
            AbilitiesManager.Dash()
        end
    elseif input.KeyCode == Enum.KeyCode.Up then
        specialJumpInitialized = true
        AbilitiesManager.SpecialJump()
    end
end

local function inputEnded(input: InputObject, gameProcessed: boolean)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Up then
        specialJumpInitialized = false
    end
end

UserInputService.InputBegan:Connect(inputBegan)
UserInputService.InputEnded:Connect(inputEnded)
