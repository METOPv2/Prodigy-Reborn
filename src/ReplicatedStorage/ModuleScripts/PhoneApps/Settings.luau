local TweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local changeSettingsRemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").ChangeSettings

local settingsApp = game.Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Menu.Container.Apps.Settings
local musicToggle = settingsApp.Music.Toggle
local musicToggleButton = musicToggle.TextButton
local sfxToggle = settingsApp.SFX.Toggle
local sfxToggleButton = sfxToggle.TextButton

local playerData = game.Players.LocalPlayer:WaitForChild("PlayerData")
local musicEnabled = playerData.MusicEnabled
local sfxEnabled = playerData.SFXEnabled

local musicGroup = game.SoundService:WaitForChild("Music")
local sfxGroup = game.SoundService:WaitForChild("SFX")

musicEnabled.Changed:Connect(function(value)
	for _, v in ipairs(musicGroup:GetChildren()) do
		v.Volume = value and 0.5 or 0
	end
end)

sfxEnabled.Changed:Connect(function(value)
	for _, v in ipairs(sfxGroup:GetChildren()) do
		v.Volume = value and 0.5 or 0
	end
end)

local toggles = {
	Music = musicToggle,
	SFX = sfxToggle,
}

local values = {
	Music = musicEnabled,
	SFX = sfxEnabled,
}

local function switchToggle(name, init)
	local state = nil

	if init then
		state = values[name].Value
	else
		state = not values[name].Value
	end

	if state then
		TweenService:Create(toggles[name].Pointer, tweenInfo, { Position = UDim2.new(1, -toggles[name].Pointer.Size.X.Offset - 2, 0, 2) }):Play()
		TweenService:Create(toggles[name], tweenInfo, { BackgroundColor3 = Color3.fromRGB(3, 243, 55) }):Play()
	else
		TweenService:Create(toggles[name].Pointer, tweenInfo, { Position = UDim2.fromOffset(2, 2) }):Play()
		TweenService:Create(toggles[name], tweenInfo, { BackgroundColor3 = Color3.fromRGB(243, 3, 3) }):Play()
	end

	values[name].Value = state

	changeSettingsRemoteEvent:FireServer(name, state)
end

local Settings = {}

function Settings.Init()
	if not musicEnabled.Value then
		for _, v in ipairs(musicGroup:GetChildren()) do
			v.Volume = 0
		end
	end

	if not sfxEnabled.Value then
		for _, v in ipairs(sfxGroup:GetChildren()) do
			v.Volume = 0
		end
	end

	switchToggle("Music", true)
	switchToggle("SFX", true)
end

musicToggleButton.Activated:Connect(function()
	switchToggle("Music")
end)

sfxToggleButton.Activated:Connect(function()
	switchToggle("SFX")
end)

return Settings
