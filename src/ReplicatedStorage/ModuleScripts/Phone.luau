--!strict
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local SideButtonsForEachApp = require(ReplicatedStorage:WaitForChild("Source").Settings.SideButtonsForApps)

local getFriendDataRemoteFunction = ReplicatedStorage:WaitForChild("RemoteFunctions").GetFriendData

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
            FriendInfo: CanvasGroup & {
                Main: Frame & {
                    InGameName: TextLabel,
                    ClassType: TextLabel,
                    LastOnline: TextLabel,
                    Username: TextLabel,
                    Level: TextLabel,
                },
                Thumbnail: ImageLabel,
            },
            Mute: Frame,
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
                    Friends: Frame & {
                        Holder: ScrollingFrame & {
                            NoFriends: TextLabel,
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
local muteScreen = phoneCover.Mute

local phoneCoverLogoContainer = phoneCover.Logo
local phoneLogo = phoneCoverLogoContainer.Logo
local phoneLogoColorless = phoneCoverLogoContainer.LogoColorless
local phoneLogoGradient = phoneCoverLogoContainer.Gradient

type FriendTemplate = Frame & {
    OpeningContainer: Frame & {
        TextButton: TextButton,
    },
    Thumbnail: ImageLabel,
    DisplayName: TextLabel,
    OnlineStatus: TextLabel,
    UserName: TextLabel,
    UIStroke: UIStroke,
}

local assets = ReplicatedStorage:WaitForChild("Assets") :: Folder & {
    UI: Folder & {
        Phone: Folder & {
            FriendTemplate: FriendTemplate,
        },
    },
}
local friendTemplate = assets.UI.Phone.FriendTemplate
local friendsHolder = phoneBackground.Menu.Container.Apps.Friends.Holder
local noFriendsLabel = friendsHolder.NoFriends
local friendInfo = phoneCover.FriendInfo
local friendInfoMain = friendInfo.Main
local friendInfoThumbnail = friendInfo.Thumbnail

local isFriendsListRefreshing = false

friendInfo.Rotation = 180

local apps = phoneBackground.Menu.Container.Apps
local button1 = phoneBackground.Button1
local button2 = phoneBackground.Button2
local buttonConnections = {}
local currentApp = ""

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
local coinRollTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local coinGlowTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local gradientGlowTweenInfoIn = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local gradientGlowTweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

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
    closePhoneCoverTween.Completed:Wait()

    Phone.CloseAllApps()
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

    ContentProvider:PreloadAsync({ phoneLogoColorless })

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

    ContentProvider:PreloadAsync({ phoneLogoGradient, phoneLogo })

    coinGlowTween:Play()
    gradientGlowTweenIn:Play()
    coinGlowTween.Completed:Wait()

    phoneTurnOnSound:Play()

    gradientGlowTweenOut:Play()
    gradientGlowTweenOut.Completed:Wait()

    isPhoneOpen = true

    task.wait(getCoverAnimationTimeLength() + 0.5)

    openCover()

    phoneCoverLogoContainer.Visible = false
    phoneCoverContainer.Visible = true

    initialAnimationLoaded = true
end

local function getInGameFriendData(friendId: number)
    return getFriendDataRemoteFunction:InvokeServer(friendId)
end

local currentPlayerProfile = nil

local function openPlayerProfile(playerFrame)
    muteScreen.Visible = true

    local userId = playerFrame.Name
    local sucess, data = getInGameFriendData(userId)

    if not sucess then
        warn(data)
        return
    end

    if currentPlayerProfile == userId then
        muteScreen.Visible = false
        friendInfo.Visible = false
        return
    end

    currentPlayerProfile = userId

    friendInfoThumbnail.Image = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size60x60)
    friendInfoMain.InGameName.Text = string.format("In-game name: %s", data.Username)
    friendInfoMain.Username.Text = string.format("Username: %s", Players:GetNameFromUserIdAsync(userId))
    friendInfoMain.ClassType.Text = string.format("Class Type: %s", data.ClassType)
    friendInfoMain.LastOnline.Text = string.format("Last Online: %s", data.LastOnline)
    friendInfoMain.Level.Text = string.format("Level: %d", data.Level)

    muteScreen.Visible = false
    friendInfo.Visible = true
end

local function initializePlayerFrame(playerFrame)
    local openProfileButton = playerFrame.OpeningContainer.TextButton
    openProfileButton.Activated:Connect(function()
        openPlayerProfile(playerFrame)
    end)
end

function Phone.RefreshFriendsList()
    if isFriendsListRefreshing then
        return
    end

    isFriendsListRefreshing = true

    for _, friendFrame in ipairs(friendsHolder:GetChildren()) do
        if friendFrame:IsA("Frame") then
            friendFrame:Destroy()
        end
    end

    local friends = player:GetFriendsOnline()

    for _, friend in ipairs(friends) do
        local friendFrame = friendTemplate:Clone()
        friendFrame.Name = friend.VisitorId
        friendFrame.Thumbnail.Image = Players:GetUserThumbnailAsync(friend.VisitorId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
        friendFrame.UserName.Text = friend.UserName
        friendFrame.DisplayName.Text = friend.DisplayName

        if friend.IsOnline then
            if friend.LocationType == 1 or friend.LocationType == 4 or friend.LocationType == 5 then
                friendFrame.OnlineStatus.Text = friend.GameId == game.GameId and "Playing RP" or "Other"
                friendFrame.UIStroke.Color = Color3.fromRGB(0, 199, 0)
                friendFrame.OnlineStatus.TextColor3 = Color3.fromRGB(0, 199, 0)
            elseif friend.LocationType == 3 or friend.LocationType == 6 then
                friendFrame.OnlineStatus.Text = "In Studio"
                friendFrame.UIStroke.Color = Color3.fromRGB(255, 153, 0)
                friendFrame.OnlineStatus.TextColor3 = Color3.fromRGB(255, 153, 0)
            elseif friend.LocationType == 0 or friend.LocationType == 2 then
                friendFrame.OnlineStatus.Text = "Online"
                friendFrame.UIStroke.Color = Color3.fromRGB(0, 47, 255)
                friendFrame.OnlineStatus.TextColor3 = Color3.fromRGB(0, 47, 255)
            end
        else
            friendFrame.OnlineStatus.Text = "Offline"
            friendFrame.UIStroke.Color = Color3.fromRGB(13, 13, 13)
            friendFrame.OnlineStatus.TextColor3 = Color3.fromRGB(30, 30, 30)
        end

        friendFrame.Parent = friendsHolder

        initializePlayerFrame(friendFrame)
    end

    local function iterPageItems(pages)
        return coroutine.wrap(function()
            local pagenum = 1
            while true do
                for _, item in ipairs(pages:GetCurrentPage()) do
                    if friendsHolder:FindFirstChild(item.Id) then
                        continue
                    end

                    coroutine.yield(item, pagenum)
                end
                if pages.IsFinished then
                    break
                end
                pages:AdvanceToNextPageAsync()
                pagenum = pagenum + 1
            end
        end)
    end

    local friendPages = Players:GetFriendsAsync(player.UserId)
    local items = {}
    for item, _pageNo in iterPageItems(friendPages) do
        table.insert(items, item)
    end

    if #items == 0 then
        noFriendsLabel.Visible = true
        noFriendsLabel.Text = "No friends online"
        return
    else
        noFriendsLabel.Visible = false
    end

    for _, friend in ipairs(items) do
        local friendFrame = friendTemplate:Clone()
        friendFrame.Name = friend.Id
        friendFrame.UserName.Text = friend.Username
        friendFrame.DisplayName.Text = friend.DisplayName
        friendFrame.Thumbnail.Image = Players:GetUserThumbnailAsync(friend.Id, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
        friendFrame.OnlineStatus.Text = "Offline"
        friendFrame.Parent = friendsHolder

        initializePlayerFrame(friendFrame)
    end

    isFriendsListRefreshing = false
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

local function setupSideButtonsForAnApp(app: string)
    local buttonsData = SideButtonsForEachApp[app:lower()]
    if buttonsData.button1 then
        button1.ImageLabel.Image = buttonsData.button1.ImageId
        button1.BackgroundColor3 = buttonsData.button1.BackgroundColor
        button1.Visible = true
    else
        button1.Visible = false
    end

    if buttonsData.button2 then
        button2.ImageLabel.Image = buttonsData.button2.ImageId
        button2.BackgroundColor3 = buttonsData.button2.BackgroundColor
        button2.Visible = true
    else
        button2.Visible = false
    end

    if app == "Volume" then
        local closeConnection = button1.TextButton.Activated:Once(function()
            Phone.CloseAnApp(app)
        end)

        table.insert(buttonConnections, closeConnection)
    elseif app == "Friends" then
        local closeConnection = button1.TextButton.Activated:Once(function()
            Phone.CloseAnApp(app)
        end)

        local refreshConnection = button2.TextButton.Activated:Once(function()
            Phone.RefreshFriendsList()
        end)

        table.insert(buttonConnections, closeConnection)
        table.insert(buttonConnections, refreshConnection)
    end
end

function Phone.OpenAnApp(name: string)
    local anApp = apps:FindFirstChild(name) :: Frame

    if not anApp then
        return
    end

    if currentApp == name then
        Phone.CloseAnApp(currentApp)
        return
    elseif currentApp then
        Phone.CloseAnApp(currentApp)
    end

    currentApp = name
    anApp.Visible = true
    setupSideButtonsForAnApp(name)
end

function Phone.CloseAnApp(name: string)
    local anApp = apps:FindFirstChild(name) :: Frame

    if not anApp then
        return
    end

    if currentApp == name then
        currentApp = ""
    end

    anApp.Visible = false
    button1.Visible = false
    button2.Visible = false

    for _, connection: RBXScriptConnection in ipairs(buttonConnections) do
        connection:Disconnect()
    end
end

function Phone.CloseAllApps()
    currentApp = ""

    for _, app in ipairs(apps:GetChildren()) do
        if not app:IsA("Frame") then
            continue
        end

        Phone.CloseAnApp(app.Name)
    end
end

return Phone
