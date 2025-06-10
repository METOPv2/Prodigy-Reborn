--!strict
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageLabel & {
        Button1: Frame & {
            TextButton: TextButton,
            ImageLabel: ImageLabel,
        },
        Button2: Frame & {
            TextButton: TextButton,
            ImageLabel: ImageLabel,
        },
        Cover: ImageLabel & {
            Logo: CanvasGroup & {
                Gradient: ImageLabel,
                Logo: ImageLabel,
                LogoColorless: ImageLabel,
            },
            Container: CanvasGroup & {
                Next: Frame & {
                    TextButton: TextButton,
                },
                Pages: Frame & {
                    Page1: Frame & {
                        Friends: Frame & {
                            TextButton: TextButton,
                        },
                        Volume: Frame & {
                            TextButton: TextButton,
                        },
                    },
                },
                Previous: Frame & {
                    TextButton: TextButton,
                },
            },
        },
        Menu: ImageLabel & {
            Container: ImageLabel & {
                Apps: Folder & {
                    Friends: Frame,
                    Volume: Frame & {
                        SFX: Frame & {
                            Slider: Frame & {
                                Handle: Frame & { UIDragDetector: UIDragDetector },
                            },
                        },
                        Music: Frame & {
                            Slider: Frame & {
                                Handle: Frame & {
                                    UIDragDetector: UIDragDetector,
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}
local phoneBackground = phoneGui.Background
local phoneCover = phoneBackground.Cover
local phoneCoverContainer = phoneCover.Container

local phoneCoverLogoContainer = phoneCover.Logo
local phoneLogo = phoneCoverLogoContainer.Logo
local phoneLogoColorless = phoneCoverLogoContainer.LogoColorless
local phoneLogoGradient = phoneCoverLogoContainer.Gradient

local sfxGroup = SoundService:WaitForChild("SFX") :: SoundGroup & {
    CoverOpen: Sound,
    CoverClosed: Sound,
    PhoneTurnOn: Sound,
}
local coverOpenSound = sfxGroup.CoverOpen
local coverClosedSound = sfxGroup.CoverClosed
local phoneTurnOnSound = sfxGroup.PhoneTurnOn

local coverClosePosition = phoneCover:GetAttribute("ClosePosition") :: UDim2
local coverPreOpenPosition = phoneCover:GetAttribute("PreOpenPosition") :: UDim2
local coverOpenPosition = phoneCover:GetAttribute("OpenPosition") :: UDim2

local phoneClosePosition = phoneBackground:GetAttribute("ClosePosition") :: UDim2
local phoneOpenPosition = phoneBackground:GetAttribute("OpenPosition") :: UDim2

local preOpenCoverTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local generalTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local coinRollTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local coinGlowTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local gradientGlowTweenInfoIn = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local gradientGlowTweenInfoOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local colorlessLogoRollTweel = TweenService:Create(phoneLogoColorless, coinRollTweenInfo, { Rotation = 0, Position = UDim2.fromScale(0.5, 0.5) })
local coinGlowTween = TweenService:Create(phoneLogo, coinGlowTweenInfo, { ImageTransparency = 0 })
local gradientGlowTweenIn = TweenService:Create(phoneLogoGradient, gradientGlowTweenInfoIn, { ImageTransparency = 0 })
local gradientGlowTweenOut = TweenService:Create(phoneLogoGradient, gradientGlowTweenInfoOut, { ImageTransparency = 1 })

local openPhoneTween = TweenService:Create(phoneBackground, generalTweenInfo, { Position = phoneOpenPosition })
local closePhoneTween = TweenService:Create(phoneBackground, generalTweenInfo, { Position = phoneClosePosition })

local openPhoneCoverTweenPart1 = TweenService:Create(phoneCover, preOpenCoverTweenInfo, { Position = coverPreOpenPosition, Rotation = 90 })
local openPhoneCoverTweenPart2 = TweenService:Create(phoneCover, generalTweenInfo, { Position = coverOpenPosition, Rotation = 180 })
local closePhoneCoverTween = TweenService:Create(phoneCover, generalTweenInfo, { Position = coverClosePosition, Rotation = 0 })

phoneCoverContainer.Visible = false
phoneCoverLogoContainer.Visible = false
phoneBackground.Position = phoneClosePosition
phoneCover.Position = coverClosePosition
phoneGui.Enabled = true

local isPhoneOpen = false
local isCoverOpen = false
local initialAnimationLoaded = false
local isInitialAnimationPlaying = false

local Phone = {}

local function openCover()
    if not isPhoneOpen then
        return
    end

    isCoverOpen = true

    coverOpenSound:Play()
    openPhoneCoverTweenPart1:Play()
    openPhoneCoverTweenPart1.Completed:Wait()

    if not isCoverOpen then
        return
    end

    phoneCoverContainer.Rotation = 180
    phoneCoverLogoContainer.Visible = false
    phoneCoverContainer.Visible = true

    openPhoneCoverTweenPart2:Play()
end

local function getCoverAnimationTimeLength(): number
    return openPhoneCoverTweenPart1.TweenInfo.Time + closePhoneCoverTween.TweenInfo.Time
end

local function openPhone()
    isPhoneOpen = true
    openPhoneTween:Play()
    openPhoneTween.Completed:Wait()

    if not isPhoneOpen then
        return
    end

    openCover()
end

local function closeCover()
    if not isCoverOpen then
        return
    end

    isCoverOpen = false

    coverClosedSound:Play()
    openPhoneCoverTweenPart1:Play()
    openPhoneCoverTweenPart1.Completed:Wait()

    if isCoverOpen then
        return
    end

    phoneCoverContainer.Rotation = 0
    phoneCoverLogoContainer.Visible = true
    phoneCoverContainer.Visible = false

    closePhoneCoverTween:Play()
end

local function closePhone()
    isPhoneOpen = false
    phoneBackground.Position = phoneOpenPosition
    closeCover()
    task.wait(getCoverAnimationTimeLength())

    if isPhoneOpen then
        return
    end

    closePhoneTween:Play()
end

local function loadInitialAnimation()
    if isInitialAnimationPlaying then
        return
    end
    isInitialAnimationPlaying = true

    openPhoneTween:Play()
    openPhoneTween.Completed:Wait()

    phoneLogoColorless.Position = UDim2.fromScale(-0.5, 0.5)
    phoneLogoColorless.Rotation = -180
    phoneLogoColorless.Visible = true
    phoneLogo.ImageTransparency = 1
    phoneLogo.Visible = true
    phoneCoverLogoContainer.Visible = true

    colorlessLogoRollTweel:Play()
    colorlessLogoRollTweel.Completed:Wait()

    coinGlowTween:Play()
    gradientGlowTweenIn:Play()
    coinGlowTween.Completed:Wait()

    phoneTurnOnSound:Play()

    gradientGlowTweenOut:Play()
    gradientGlowTweenOut.Completed:Wait()

    isPhoneOpen = true

    task.wait(getCoverAnimationTimeLength() + 1)

    openCover()

    phoneCoverLogoContainer.Visible = false
    phoneCoverContainer.Visible = true

    initialAnimationLoaded = true
end

function Phone.TogglePhone()
    if not initialAnimationLoaded then
        return loadInitialAnimation()
    end

    if not isPhoneOpen then
        openPhone()
    else
        closePhone()
    end
end

function Phone.ToggleCover()
    if not isCoverOpen then
        openCover()
    else
        closeCover()
    end
end

return Phone
