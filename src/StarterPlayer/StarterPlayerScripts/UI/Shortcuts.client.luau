--!strict
local Players: Players = game:GetService("Players")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

local Input = require(ReplicatedStorage:WaitForChild("Source").Utils.Input)
local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)

local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui
local inventoryGui = playerGui:WaitForChild("Inventory") :: ScreenGui & { Container: ImageLabel }
local worldMapGui = playerGui:WaitForChild("WorldMap") :: ScreenGui & { Background: ImageLabel }
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui & { Background: ImageLabel }

local function toggleInventoryGui(): ()
    inventoryGui.Enabled = not inventoryGui.Enabled
    inventoryGui.Container.Position = UDim2.fromScale(0.5, 0.5)
end

local function toggleWorldMapGui(): ()
    worldMapGui.Enabled = not worldMapGui.Enabled
    worldMapGui.Background.Position = UDim2.fromScale(0.5, 0.5)
end

local function toggleBookGui(): ()
    bookGui.Enabled = not bookGui.Enabled
    bookGui.Background.Position = UDim2.fromScale(0.5, 0.5)
end

Input.Pressed(Enum.KeyCode.I):Connect(toggleInventoryGui)
Input.Pressed(Enum.KeyCode.W):Connect(toggleWorldMapGui)
Input.Pressed(Enum.KeyCode.B):Connect(toggleBookGui)
Input.Pressed(Enum.KeyCode.P):Connect(Phone.TogglePhone)
