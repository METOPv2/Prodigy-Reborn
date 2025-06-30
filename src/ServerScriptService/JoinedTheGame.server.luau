local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	if not BadgeService:UserHasBadgeAsync(player.UserId, 377000058433746) then
		BadgeService:AwardBadge(player.UserId, 377000058433746)
	end
end)
