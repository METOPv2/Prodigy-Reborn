local tagTemplate = game.ReplicatedStorage.TagTemplate
local gmTemplate = game.ReplicatedStorage.GMTemplate
local GMs = require(game.ReplicatedStorage.GMs)

local function CharacterAdded(character)
	local usernameTag = tagTemplate:Clone()
	usernameTag.TextLabel.Text = character.Name
	usernameTag.Parent = character.PrimaryPart

	local player = game.Players:GetPlayerFromCharacter(character)
	if table.find(GMs, player.UserId) then
		local gmTag = gmTemplate:Clone()
		gmTag.StudsOffsetWorldSpace = Vector3.new(0, character:GetExtentsSize().Y / 2, 0)
		gmTag.Parent = character.PrimaryPart
	end
end

game.Players.PlayerAdded:Connect(function(player)
	if not player.Character then
		player.CharacterAdded:Wait()
	end

	CharacterAdded(player.Character)
	player.CharacterAdded:Connect(CharacterAdded)
end)
