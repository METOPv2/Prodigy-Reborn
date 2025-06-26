local Phone = require(game.ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)
local apps = game.Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Cover.Container.Apps.Pages

for _, page in ipairs(apps:GetChildren()) do
	if not page:IsA("Frame") then
		continue
	end

	for _, app in ipairs(page:GetChildren()) do
		if not app:IsA("Frame") then
			continue
		end

		local button = app:FindFirstChild("TextButton")

		if not button then
			continue
		end

		button.Activated:Connect(function()
			Phone.OpenApp(app.Name)
		end)
	end
end
