local Players = game:GetService("Players")
local tagTemplate = game.ReplicatedStorage.Assets.BillboardUIs.TagTemplate
local gmTemplate = game.ReplicatedStorage.Assets.BillboardUIs.GMTemplate
local GMs = require(game.ReplicatedStorage.Source.ModuleScripts.GMs)

local connections = {}

local function CharacterAdded(character)
    local player = Players:GetPlayerFromCharacter(character)
    local connection = connections[player]

    if connection then
        connection:Disconnect()
        connection = nil
    end

    repeat
        task.wait()
    until player:GetAttribute("Username") ~= nil

    local usernameTag = tagTemplate:Clone()
    usernameTag.TextLabel.Text = player:GetAttribute("Username")
    usernameTag.Parent = character.PrimaryPart

    connection = player:GetAttributeChangedSignal("Username"):Connect(function()
        usernameTag.TextLabel.Text = player:GetAttribute("Username")
    end)

    connections[player] = connection

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
