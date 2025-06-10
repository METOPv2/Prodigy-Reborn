--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local UsernameSettings = require(ReplicatedStorage:WaitForChild("Source").Settings.Username)

local textBoxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local progressBarTweenInfoIn = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local progressBarTweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local fadeAwayMenuTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local checkUsernameRemoteEvent = ReplicatedStorage:WaitForChild("RemoteFunctions").CheckUsername
local confirmUsernameRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").ConfirmUsername

local usernameGui = Players.LocalPlayer.PlayerGui:WaitForChild("Username") :: ScreenGui & {
    Container: Frame & {
        Username: TextBox & {
            Status: TextLabel,
        },
        StatusImage: ImageLabel,
        Confirm: TextButton,
        Progress: Frame & {
            ProgressBar: Frame,
        },
    },
    Background: Frame,
}
local usernameTextbox = usernameGui.Container.Username
local statusTextLabel = usernameTextbox.Status
local statusImage = usernameGui.Container.StatusImage
local confirmButton = usernameGui.Container.Confirm
local progressFrame = usernameGui.Container.Progress
local progressBar = usernameGui.Container.Progress.ProgressBar

local loadingIcon = "rbxassetid://73971253516364"
local checkIcon = "rbxassetid://110328068204817"
local errorIcon = "rbxassetid://119506650087528"

local usernameTextBoxTweenIn = TweenService:Create(usernameTextbox, textBoxTweenInfo, { Size = UDim2.new(1, -75, 0, 50) })
local usernameTextBoxTweenOut = TweenService:Create(usernameTextbox, textBoxTweenInfo, { Size = UDim2.new(1, -50, 0, 50) })
local imageStatusTweenIn = TweenService:Create(statusImage, textBoxTweenInfo, { ImageTransparency = 0 })
local imageStatusTweenOut = TweenService:Create(statusImage, textBoxTweenInfo, { ImageTransparency = 1 })

local progressBarTweenIn = TweenService:Create(progressBar, progressBarTweenInfoIn, { Size = UDim2.new(1, 0, 1, 0) })
local progressBarTweenOut = TweenService:Create(progressBar, progressBarTweenInfoOut, { Size = UDim2.new(0, 0, 1, 0) })

local fadeAwayMenuTween = TweenService:Create(usernameGui.Container, fadeAwayMenuTweenInfo, { Position = UDim2.new(0.5, 0, 1.5, 0), Rotation = 180 })
local fadeAwayBackgroundTween = TweenService:Create(usernameGui.Background, fadeAwayMenuTweenInfo, { BackgroundTransparency = 1 })

local lastChange = os.clock()
local isLoading = false
local loadingThread = nil
local confirming = false
local readyToConfirm = false
local canEdit = true

local function startLoading()
    if isLoading then
        return
    end

    if loadingThread then
        task.cancel(loadingThread)
    end

    isLoading = true
    statusImage.Image = loadingIcon
    statusImage.ImageColor3 = Color3.fromRGB(0, 0, 0)
    usernameTextbox.TextColor3 = Color3.fromRGB(0, 0, 0)
    statusTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    statusTextLabel.Text = "Checking username..."
    statusTextLabel.Visible = true
    imageStatusTweenIn:Play()
    usernameTextBoxTweenIn:Play()

    coroutine.wrap(function()
        while isLoading do
            statusImage.Rotation += 1
            task.wait()
        end
    end)()
end

local function stopLoading(success: boolean)
    if loadingThread then
        task.cancel(loadingThread)
    end

    isLoading = false
    statusImage.Rotation = 0

    if success then
        statusImage.Image = checkIcon
        statusImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
    else
        statusImage.Image = errorIcon
        statusImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end

    loadingThread = task.delay(3, function()
        imageStatusTweenOut:Play()
        usernameTextBoxTweenOut:Play()
    end)
end

local function prepareConfirmButton()
    if confirming then
        return
    end

    confirming = true

    progressFrame.Visible = true

    progressBarTweenIn:Play()
    progressBarTweenIn.Completed:Once(function()
        if confirming then
            readyToConfirm = true
            confirmButton.Visible = true
            confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

local function stopPrepareConfirmButton()
    if not confirming then
        return
    end

    readyToConfirm = false
    confirming = false

    confirmButton.Visible = false
    confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    progressBarTweenOut:Play()
    progressBarTweenOut.Completed:Once(function()
        if not confirming then
            progressFrame.Visible = false
            return
        end
    end)
end

local function hasSpaces(text: string): boolean
    return text:match("%s") ~= nil
end

local function hasSpecialCharacters(text: string): boolean
    return text:match("[^%w_]+$") ~= nil
end

local function hasOnlyLettersAndNumbers(text: string): boolean
    return text:match("^[%w_]+$") ~= nil
end

local function hasUnderscore(text: string): boolean
    return text:match("_") ~= nil
end

local function textChanged()
    if not canEdit then
        return
    end

    lastChange = os.clock()

    local text = usernameTextbox.Text
    local len = text:len()

    if len < UsernameSettings.MinimumCharacters then
        usernameTextbox.TextColor3 = Color3.fromRGB(0, 0, 0)
        statusTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        statusTextLabel.Text = string.format(UsernameSettings.MinimumCharactersWarningMessage, UsernameSettings.MinimumCharacters)
        statusTextLabel.Visible = true
        return
    elseif len > UsernameSettings.MaximumCharacter then
        usernameTextbox.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.Text = UsernameSettings.MaximumCharactersWarningMessage
        statusTextLabel.Visible = true
        return
    elseif hasUnderscore(text) then
        usernameTextbox.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.Text = UsernameSettings.UnderscoreWarningMessage
        statusTextLabel.Visible = true
        return
    elseif hasSpaces(text) then
        usernameTextbox.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.Text = UsernameSettings.SpaceWarningMessage
        statusTextLabel.Visible = true
        return
    elseif hasSpecialCharacters(text) or not hasOnlyLettersAndNumbers(text) then
        usernameTextbox.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.TextColor3 = Color3.fromRGB(196, 0, 0)
        statusTextLabel.Text = UsernameSettings.SpecialCharactersWarningMessage
        statusTextLabel.Visible = true
        return
    else
        usernameTextbox.TextColor3 = Color3.fromRGB(0, 0, 0)
        statusTextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
        statusTextLabel.Visible = false
    end

    startLoading()
    stopPrepareConfirmButton()

    task.delay(0.5, function()
        if os.clock() - lastChange >= 0.5 then
            local username, success, message = checkUsernameRemoteEvent:InvokeServer(text)

            if username ~= usernameTextbox.Text then
                return stopLoading(false)
            end

            if not success then
                usernameTextbox.TextColor3 = Color3.fromRGB(196, 0, 0)
                statusTextLabel.TextColor3 = Color3.fromRGB(196, 0, 0)
                statusTextLabel.Text = message or "An error occurred while checking the username."
                statusTextLabel.Visible = true
                return stopLoading(false)
            else
                usernameTextbox.TextColor3 = Color3.fromRGB(0, 196, 0)
                statusTextLabel.TextColor3 = Color3.fromRGB(0, 196, 0)
                statusTextLabel.Text = message
                statusTextLabel.Visible = true
            end

            stopLoading(true)
            prepareConfirmButton()
        end
    end)
end

usernameTextbox:GetPropertyChangedSignal("Text"):Connect(textChanged)
usernameTextbox.FocusLost:Connect(function()
    if statusTextLabel.Visible then
        statusTextLabel.Visible = false
    end
end)

confirmButton.Activated:Connect(function()
    if not readyToConfirm then
        return
    end

    canEdit = false

    confirming = false
    readyToConfirm = false
    statusTextLabel.Visible = false
    usernameTextbox.TextColor3 = Color3.fromRGB(0, 0, 0)

    progressBarTweenOut:Play()
    progressBarTweenOut.Completed:Once(function()
        progressFrame.Visible = false
        confirmButton.Visible = false

        fadeAwayMenuTween:Play()
        fadeAwayMenuTween.Completed:Wait()

        fadeAwayBackgroundTween:Play()
        fadeAwayBackgroundTween.Completed:Once(function()
            usernameGui:Destroy()
            confirmUsernameRemoteEvent:FireServer(usernameTextbox.Text)
        end)
    end)
end)
