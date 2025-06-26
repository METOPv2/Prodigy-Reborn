local changeSettingsRemoteEvent = game.ReplicatedStorage.RemoteEvents.ChangeSettings

changeSettingsRemoteEvent.OnServerEvent:Connect(function(player, settingName, settingValue)
	if type(settingName) ~= "string" then
		return
	end

	if settingName == "Music" and type(settingValue) == "boolean" then
		player.PlayerData.MusicEnabled.Value = settingValue
	elseif settingName == "SFX" and type(settingValue) == "boolean" then
		player.PlayerData.SFXEnabled.Value = settingValue
	end
end)
