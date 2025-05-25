<<<<<<< Updated upstream
local player = game.Players.LocalPlayer
local money = player:WaitForChild("PlayerData").Money
local label = player.PlayerGui:WaitForChild("Inventory").Container.Container.Coins.TextLabel

local function updateLabel()
    label.Text = string.format("%.2f", money.Value):gsub("%.", ",")
end

money.Changed:Connect(updateLabel)
=======
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NumberAbbreviation = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.NumberAbbreviation)

local player = Players.LocalPlayer
local money = player:WaitForChild("PlayerData").Money :: NumberValue
local label = player.PlayerGui:WaitForChild("Inventory").Container.Container.Coins.TextLabel :: TextLabel

local function updateLabel()
    label.Text = NumberAbbreviation:Comas(money.Value)
end

money.Changed:Connect(updateLabel)

>>>>>>> Stashed changes
updateLabel()
