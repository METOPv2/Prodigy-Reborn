--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LevelManager = require(ReplicatedStorage.Source.ModuleScripts.LevelManager)

local circleTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local interfaceGui = playerGui:WaitForChild("Interface") :: ScreenGui
local interfaceBackground = interfaceGui:FindFirstChild("Background") :: ImageLabel
local expCircle = interfaceBackground:FindFirstChild("XpCircle") :: Frame
local leftCircleSide = expCircle:FindFirstChild("Left") :: Frame
local leftCircleSideTextlabel = leftCircleSide:FindFirstChild("ImageLabel") :: ImageLabel
local leftSide = leftCircleSideTextlabel:FindFirstChild("UIGradient") :: UIGradient
local rightCircleSide = expCircle:FindFirstChild("Right") :: Frame
local rightCircleSideTextlabel = rightCircleSide:FindFirstChild("ImageLabel") :: ImageLabel
local rightSide = rightCircleSideTextlabel:FindFirstChild("UIGradient") :: UIGradient

local playerData = player:WaitForChild("PlayerData") :: Folder
local exp = playerData:FindFirstChild("EXP") :: IntValue
local level = playerData:FindFirstChild("Level") :: IntValue

local function updateCircle(newExp: number)
    local expGoal = LevelManager:CalculateExpGoal(level.Value)
    local alpha = newExp / expGoal

    if alpha > 0.5 then
        rightSide.Rotation = (alpha - 0.5) / 0.5 * 180
        leftSide.Rotation = 0
    else
        leftSide.Rotation = (1 - math.clamp(alpha / 0.5, 0, 1)) * -180
        rightSide.Rotation = 0
    end
end

updateCircle(exp.Value) -- Initial run

local animatedExpValue = Instance.new("NumberValue")
animatedExpValue.Name = "AnimatedExpValue"
animatedExpValue.Value = exp.Value
animatedExpValue.Parent = interfaceGui

local function expChanged(newExp: number)
    local tween = TweenService:Create(animatedExpValue, circleTweenInfo, { Value = newExp })
    tween:Play()
end

exp.Changed:Connect(expChanged)
animatedExpValue.Changed:Connect(updateCircle)
