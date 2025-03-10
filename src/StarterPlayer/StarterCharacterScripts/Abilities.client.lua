-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid

-- Module scripts
local AbilitiesManager = require(ReplicatedStorage.Source.ModuleScripts.AbilitiesManager)

-- Assets
local AnimationAssets = ReplicatedStorage.Assets.Animations
local Dash1Animation = AnimationAssets.Dash1
local Dash2Animation = AnimationAssets.Dash2
local LayAnimation = AnimationAssets.Lay

-- Animation tracks
local Dash1AnimationTrack = Humanoid:LoadAnimation(Dash1Animation)
Dash1AnimationTrack.Priority = Enum.AnimationPriority.Action4
Dash1AnimationTrack.Looped = false

local Dash2AnimationTrack = Humanoid:LoadAnimation(Dash2Animation)
Dash2AnimationTrack.Priority = Enum.AnimationPriority.Action4
Dash2AnimationTrack.Looped = false

local LayAnimationTrack = Humanoid:LoadAnimation(LayAnimation)
LayAnimationTrack.Priority = Enum.AnimationPriority.Action4
LayAnimationTrack.Looped = false

-- Dash direction variables
local lastDirection = nil
local keyToDirection = { [Enum.KeyCode.Left] = -1, [Enum.KeyCode.Right] = 1 }

-- Manage inputs
local function InputBegan(input: InputObject, isProcessed)
    if isProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then
        lastDirection = Vector3.new(keyToDirection[input.KeyCode], 0, 0)
        if input.UserInputState == Enum.UserInputState.Begin then
        else
            if lastDirection and lastDirection.X == keyToDirection[input.KeyCode] then
                lastDirection = nil
            end
        end
    elseif input.KeyCode == Enum.KeyCode.Up then
        AbilitiesManager.SpecialJump()
    elseif input.KeyCode == Enum.KeyCode.LeftAlt and lastDirection then
        -- TODO: Update animations AS WELL AS LAYING ANIMATION
        -- if math.random() < 0.5 then
        -- 	Dash1AnimationTrack:Play()
        -- else
        -- 	Dash2AnimationTrack:Play()
        -- end
        AbilitiesManager.Dash(lastDirection)
    elseif input.KeyCode == Enum.KeyCode.Down and Humanoid:GetState() == Enum.HumanoidStateType.Running then
        Humanoid.WalkSpeed = 0
        LayAnimationTrack:AdjustSpeed(1)
        LayAnimationTrack:Play()
        task.wait(LayAnimationTrack.Length * 0.95)
        LayAnimationTrack:AdjustSpeed(0)
    end
end

local function InputEnded(input: InputObject, isProcessed)
    if isProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then
        if lastDirection and lastDirection.X == keyToDirection[input.KeyCode] then
            lastDirection = nil
        end
    elseif input.KeyCode == Enum.KeyCode.Down then
        Humanoid.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed
        LayAnimationTrack:AdjustSpeed(3)
    end
end

-- Handle inputs
UserInputService.InputBegan:Connect(InputBegan)
UserInputService.InputEnded:Connect(InputEnded)
