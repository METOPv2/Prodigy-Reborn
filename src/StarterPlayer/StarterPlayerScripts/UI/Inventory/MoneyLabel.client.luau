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

updateLabel()
