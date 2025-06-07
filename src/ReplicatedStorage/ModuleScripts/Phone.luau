--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui
local phoneBackground = phoneGui:FindFirstChild("Background") :: ImageLabel
local phoneCover = phoneBackground:FindFirstChild("Cover") :: ImageLabel

local coverClosePosition = phoneCover:GetAttribute("ClosePosition") :: UDim2
local coverOpenPosition = phoneCover:GetAttribute("OpenPosition") :: UDim2

local phoneClosePosition = phoneBackground:GetAttribute("ClosePosition") :: UDim2
local phoneOpenPosition = phoneBackground:GetAttribute("OpenPosition") :: UDim2

local generalTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local openPhoneTween = TweenService:Create(phoneBackground, generalTweenInfo, { Position = phoneOpenPosition })
local closePhoneTween = TweenService:Create(phoneBackground, generalTweenInfo, { Position = phoneClosePosition })

local openPhoneCoverTween = TweenService:Create(phoneCover, generalTweenInfo, { Position = coverOpenPosition })
local closePhoneCoverTween = TweenService:Create(phoneCover, generalTweenInfo, { Position = coverClosePosition })

phoneBackground.Position = phoneClosePosition
phoneCover.Position = coverClosePosition

phoneGui.Enabled = true

local isPhoneOpen = false
local isCoverOpen = false

local Phone = {}

function Phone.TogglePhone(): ()
    if not isPhoneOpen then
        isPhoneOpen = true
        openPhoneTween:Play()
        openPhoneTween.Completed:Once(function()
            if isPhoneOpen and not isCoverOpen then
                isCoverOpen = true
                openPhoneCoverTween:Play()
            end
        end)
    else
        if isCoverOpen then
            isCoverOpen = false
            phoneBackground.Position = phoneOpenPosition
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
        openPhoneCoverTween:Play()
    else
        isCoverOpen = false
        closePhoneCoverTween:Play()
    end
end

return Phone
