--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AbilitiesManager = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.AbilitiesManager)
local Keybind = require(ReplicatedStorage:WaitForChild("Source").Packages.Keybind)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid") :: Humanoid

humanoid.StateChanged:Connect(function(_: Enum.HumanoidStateType, new: Enum.HumanoidStateType)
    if new == Enum.HumanoidStateType.Landed then
        AbilitiesManager.Landed()
    end
end)

local dashAction = Keybind.GetAction("Dash", Enum.KeyCode.LeftAlt)
local specialJumpAction = Keybind.GetAction("SpecialJump", Enum.KeyCode.LeftAlt)
local layAction = Keybind.GetAction("Lay", Enum.KeyCode.Down)

dashAction.Pressed:Connect(AbilitiesManager.Dash)
specialJumpAction.Pressed:Connect(AbilitiesManager.SpecialJump)
layAction.Pressed:Connect(function()
    local stand = AbilitiesManager.Lay()
    layAction.Released:Wait()
    stand()
end)
