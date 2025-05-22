local function CharacterAdded(character: Model)
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CollisionGroup = "Player"
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    if not player.Character then
        player.CharacterAdded:Wait()
    end

    CharacterAdded(player.Character)
    player.CharacterAdded:Connect(CharacterAdded)
end)
