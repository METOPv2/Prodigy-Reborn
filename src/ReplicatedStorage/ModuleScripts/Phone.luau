local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local MeOffering = require(ReplicatedStorage.Source.TradingApp.MeOffering)
local AppSideButtons = require(game.ReplicatedStorage:WaitForChild("Source").Settings.AppSideButtons)
local phoneApps = ReplicatedStorage:WaitForChild("Source").ModuleScripts.PhoneApps
local FriendsApp = require(phoneApps.Friends)
local NewChatMenu = require(phoneApps.NewChatMenu)
local ChatApp = require(phoneApps.Chat)
local Trading = require(phoneApps.Trading)

local openChatBindableEvent = ReplicatedStorage:WaitForChild("Binds").OpenChat

local declineTradeRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").DeclineTrade
local updateCoinsRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").UpdateCoins
local updateItemsRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").UpdateItems
local acceptTradeRemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvents").AcceptTrade

local background = game.Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background
local button1 = background.Button1
local button2 = background.Button2
local cover = background.Cover
local apps = background.Menu.Container.Apps
local trading = apps.Trading
local tradingCoins = apps.TradingCoins.Coins

local coverContainer = cover.Container
local bootUi = coverContainer.Boot
local appsUi = coverContainer.Apps

local sfx = game.SoundService.SFX
local bootPhoneSFX = sfx.PhoneTurnOn
local openCoverSFX = sfx.OpenCover
local closeCoverSFX = sfx.CloseCover

local phoneTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local logoTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local colorlessLogoTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local lightTweenInfoIn = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local lightTweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local preOpenCoverTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local coverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local openPhoneTween = TweenService:Create(background, phoneTweenInfo, { Position = background:GetAttribute("OpenPosition") })
local closePhoneTween = TweenService:Create(background, phoneTweenInfo, { Position = background:GetAttribute("ClosePosition") })
local colorlessLogoRollTween =
	TweenService:Create(bootUi.ColorlessLogo, colorlessLogoTweenInfo, { Rotation = 0, Position = UDim2.fromScale(0.5, 0.5) })
local logoTween = TweenService:Create(bootUi.Logo, logoTweenInfo, { ImageTransparency = 0 })
local lightTweenIn = TweenService:Create(bootUi.Light, lightTweenInfoIn, { ImageTransparency = 0 })
local lightTweenOut = TweenService:Create(bootUi.Light, lightTweenInfoOut, { ImageTransparency = 1 })
local preOpenCoverTween = TweenService:Create(cover, preOpenCoverTweenInfo, { Position = cover:GetAttribute("PreOpenPosition"), Rotation = 90 })
local openCoverTween = TweenService:Create(cover, coverTweenInfo, { Position = cover:GetAttribute("OpenPosition"), Rotation = 180 })
local closeCoverTween = TweenService:Create(cover, coverTweenInfo, { Position = cover:GetAttribute("ClosePosition"), Rotation = 0 })

local Phone = {}
local isOpen = false
local isBooted = false
local isBooting = false
local isCoverOpen = false
local buttonConnections = {}

local function openCover()
	if not isOpen or isCoverOpen then
		return
	end

	isCoverOpen = true

	openCoverSFX:Play()

	preOpenCoverTween:Play()
	preOpenCoverTween.Completed:Wait()

	if not isCoverOpen then
		return
	end

	for _, v in ipairs(coverContainer:GetChildren()) do
		v.Visible = v.Name == "Apps"
	end

	coverContainer.Rotation = 180

	openCoverTween:Play()
end

local function closeAllApps()
	for _, app in ipairs(apps:GetChildren()) do
		Phone.CloseApp(app.Name)
	end

	for _, app in ipairs(coverContainer:GetChildren()) do
		app.Visible = false
	end
end

local function closeCover()
	if not isCoverOpen then
		return
	end

	isCoverOpen = false

	closeCoverSFX:Play()

	preOpenCoverTween:Play()
	preOpenCoverTween.Completed:Wait()

	if isCoverOpen then
		return
	end

	for _, v in ipairs(coverContainer:GetChildren()) do
		v.Visible = v.Name == "Boot"
	end

	coverContainer.Rotation = 0

	closeCoverTween:Play()
	closeCoverTween.Completed:Wait()

	if isCoverOpen then
		return
	end

	closeAllApps()
end

function Phone.ForceClose()
	if not isOpen then
		return
	end

	isOpen = false

	background.Position = background:GetAttribute("OpenPosition")

	closeCover()
	task.wait(preOpenCoverTweenInfo.Time + coverTweenInfo.Time)

	if isOpen then
		return
	end

	closePhoneTween:Play()
end

function Phone.Boot()
	if isBooting then
		return
	end

	isBooting = true

	ContentProvider:PreloadAsync(background:GetDescendants())

	for _, v in ipairs(coverContainer:GetChildren()) do
		v.Visible = v.Name == "Boot"
	end

	openPhoneTween:Play()
	openPhoneTween.Completed:Wait()

	if not game:GetService("RunService"):IsStudio() then
		colorlessLogoRollTween:Play()
		colorlessLogoRollTween.Completed:Wait()

		logoTween:Play()
		lightTweenIn:Play()
		task.wait(math.max(logoTweenInfo.Time, lightTweenInfoIn.Time))

		bootPhoneSFX:Play()

		lightTweenOut:Play()
		lightTweenOut.Completed:Wait()

		task.wait(0.5)
	end

	bootUi.Visible = false
	appsUi.Visible = true

	isBooted = true
	isBooting = false
	isOpen = true

	openCover()
end

function Phone.ForceOpen()
	if isOpen then
		return
	end

	isOpen = true

	openPhoneTween:Play()
	openPhoneTween.Completed:Wait()

	if isOpen then
		openCover()
	end
end

function Phone.TogglePhone()
	if isBooting then
		return
	end

	if not isBooted then
		return Phone.Boot()
	end

	if isOpen then
		return Phone.ForceClose()
	else
		return Phone.ForceOpen()
	end
end

local function openAppsMenu()
	closeAllApps()

	coverContainer.Apps.Visible = true
end

local function initSideButtons(appName)
	for _, connection: RBXScriptConnection in ipairs(buttonConnections) do
		connection:Disconnect()
	end

	local buttonsData = AppSideButtons[appName:lower()]

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

	if appName == "Volume" or appName == "Settings" or appName == "TradingPlayers" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.CloseApp(appName)
			openAppsMenu()
		end)

		table.insert(buttonConnections, closeConnection)
	elseif appName == "Friends" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.CloseApp(appName)
			openAppsMenu()
		end)

		local refreshConnection = button2.TextButton.Activated:Connect(FriendsApp.Refresh)

		table.insert(buttonConnections, closeConnection)
		table.insert(buttonConnections, refreshConnection)
	elseif appName == "Messages" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.CloseApp(appName)
			openAppsMenu()
		end)

		local newChatMenuConnection = button2.TextButton.Activated:Once(function()
			Phone.OpenApp("NewChatMenu")
		end)

		table.insert(buttonConnections, closeConnection)
		table.insert(buttonConnections, newChatMenuConnection)
	elseif appName == "NewChatMenu" then
		NewChatMenu.RefreshPlayerList()

		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.OpenApp("Messages")
		end)

		local refreshConnection = button2.TextButton.Activated:Connect(NewChatMenu.RefreshPlayerList)

		table.insert(buttonConnections, closeConnection)
		table.insert(buttonConnections, refreshConnection)
	elseif appName == "Chat" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.OpenApp("Messages")
		end)

		local sendMessageConnection = button2.TextButton.Activated:Connect(ChatApp.Message)

		table.insert(buttonConnections, closeConnection)
		table.insert(buttonConnections, sendMessageConnection)
	elseif appName == "Trading" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.OpenApp("TradingOptions")
		end)

		local acceptTradeConnection = button2.TextButton.Activated:Connect(function()
			acceptTradeRemoteEvent:FireServer()
		end)

		table.insert(buttonConnections, closeConnection)
		table.insert(buttonConnections, acceptTradeConnection)
	elseif appName == "TradingOptions" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.OpenApp("Trading")
		end)

		table.insert(buttonConnections, closeConnection)
	elseif appName == "TradingCoins" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.OpenApp("TradingOptions")
		end)

		local updateCoinsConnection = button2.TextButton.Activated:Connect(function()
			local coins = tonumber(tradingCoins.Text)

			if not coins or coins < 0 or coins ~= coins then
				return
			end

			coins = coins > Players.LocalPlayer.PlayerData.Money.Value and Players.LocalPlayer.PlayerData.Money.Value or coins

			trading.Coins.TextLabel.Text = tostring(coins)

			tradingCoins.Text = ""

			Trading.Init()
			Phone.OpenApp("Trading")
			updateCoinsRemoteEvent:FireServer(coins)
		end)

		table.insert(buttonConnections, closeConnection)
		table.insert(buttonConnections, updateCoinsConnection)
	elseif appName == "TradingItems" then
		local closeConnection = button1.TextButton.Activated:Once(function()
			Phone.OpenApp("TradingOptions")
		end)

		local updateItemsConnection = button2.TextButton.Activated:Connect(function()
			Phone.OpenApp("Trading")
			Trading.Init()
			updateItemsRemoteEvent:FireServer(MeOffering.items)
		end)

		table.insert(buttonConnections, closeConnection)
		table.insert(buttonConnections, updateItemsConnection)
	end
end

function Phone.OpenApp(appName)
	closeAllApps()

	local menuPart = apps:FindFirstChild(appName)

	if not menuPart then
		return
	end

	menuPart.Visible = true

	local coverPart = coverContainer:FindFirstChild(appName) or coverContainer.Blank
	coverPart.Visible = true

	initSideButtons(appName)
end

function Phone.CloseApp(appName)
	local menuPart = apps:FindFirstChild(appName)

	if not menuPart then
		return
	end

	menuPart.Visible = false

	local coverPart = coverContainer:FindFirstChild(appName) or coverContainer.Blank
	coverPart.Visible = false

	button1.Visible = false
	button2.Visible = false

	for _, connection: RBXScriptConnection in ipairs(buttonConnections) do
		connection:Disconnect()
	end
end

openChatBindableEvent.Event:Connect(function()
	Phone.OpenApp("Chat")
end)

declineTradeRemoteEvent.OnClientEvent:Connect(openAppsMenu)
acceptTradeRemoteEvent.OnClientEvent:Connect(openAppsMenu)
tradingCoins.FocusLost:Connect(function()
	local coins = tonumber(tradingCoins.Text)

	if not coins or coins < 0 or coins ~= coins then
		return
	end

	coins = coins > Players.LocalPlayer.PlayerData.Money.Value and Players.LocalPlayer.PlayerData.Money.Value or coins

	MeOffering.coins = coins
end)

Phone.Boot()
Phone.OpenApp("TradingPlayers")

return Phone
