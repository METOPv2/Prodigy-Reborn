--!strict
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui
local phoneBackground = phoneGui:FindFirstChild("Background") :: ImageLabel
local phoneCover = phoneBackground:FindFirstChild("Cover") :: ImageLabel

local coverOpenSound: Sound = SoundService:WaitForChild("SFX").CoverOpen
local coverClosedSound: Sound = SoundService:WaitForChild("SFX").CoverClosed

local coverClosePosition = phoneCover:GetAttribute("ClosePosition") :: UDim2
local coverPreOpenPosition = phoneCover:GetAttribute("PreOpenPosition") :: UDim2
local coverOpenPosition = phoneCover:GetAttribute("OpenPosition") :: UDim2

local phoneClosePosition = phoneBackground:GetAttribute("ClosePosition") :: UDim2
local phoneOpenPosition = phoneBackground:GetAttribute("OpenPosition") :: UDim2

local preOpenCoverTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local generalTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local openPhoneTween = TweenService:Create(phoneBackground, generalTweenInfo, { Position = phoneOpenPosition })
local closePhoneTween = TweenService:Create(phoneBackground, generalTweenInfo, { Position = phoneClosePosition })

local openPhoneCoverTweenPart1 = TweenService:Create(phoneCover, preOpenCoverTweenInfo, { Position = coverPreOpenPosition, Rotation = 90 })
local openPhoneCoverTweenPart2 = TweenService:Create(phoneCover, generalTweenInfo, { Position = coverOpenPosition, Rotation = 180 })
local closePhoneCoverTween = TweenService:Create(phoneCover, generalTweenInfo, { Position = coverClosePosition, Rotation = 0 })

phoneBackground.Position = phoneClosePosition
phoneCover.Position = coverClosePosition

phoneGui.Enabled = true

local isPhoneOpen = false
local isCoverOpen = false

openPhoneCoverTweenPart1.Completed:Connect(function()
    if isCoverOpen then
        coverOpenSound:Play()
    else
        coverClosedSound:Play()
    end
end)

local Phone = {}

function Phone.TogglePhone(): ()
    if not isPhoneOpen then
        isPhoneOpen = true
        openPhoneTween:Play()
        openPhoneTween.Completed:Once(function()
            if isPhoneOpen and not isCoverOpen then
                isCoverOpen = true
                openPhoneCoverTweenPart1:Play()
                openPhoneCoverTweenPart1.Completed:Wait()
                openPhoneCoverTweenPart2:Play()
            end
        end)
    else
        if isCoverOpen then
            isCoverOpen = false
            phoneBackground.Position = phoneOpenPosition
            openPhoneCoverTweenPart1:Play()
            openPhoneCoverTweenPart1.Completed:Wait()
            closePhoneCoverTween:Play()
            closePhoneCoverTween.Completed:Once(function()
                if isPhoneOpen and not isCoverOpen then
                    isPhoneOpen = false
                    closePhoneTween:Play()
                end
            end)
        else
            isPhoneOpen = false
            phoneBackground.Position = phoneOpenPosition
            closePhoneTween:Play()
        end
    end
end

function Phone.ToggleCover(): ()
    if not isPhoneOpen then
        return
    end

    if not isCoverOpen then
        isCoverOpen = true
        openPhoneCoverTweenPart1:Play()
        openPhoneCoverTweenPart1.Completed:Wait()
        openPhoneCoverTweenPart2:Play()
    else
        isCoverOpen = false
        openPhoneCoverTweenPart1:Play()
        openPhoneCoverTweenPart1.Completed:Wait()
        closePhoneCoverTween:Play()
    end
end

return Phone
