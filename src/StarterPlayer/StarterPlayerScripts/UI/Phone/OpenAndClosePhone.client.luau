--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local interfaceGui = playerGui:WaitForChild("Interface") :: ScreenGui
local interfaceBackground = interfaceGui:FindFirstChild("Background") :: ImageLabel
local phoneButton = interfaceBackground:FindFirstChild("Phone") :: ImageButton

phoneButton.MouseButton1Click:Connect(Phone.TogglePhone)
phoneButton.MouseButton2Click:Connect(Phone.ToggleCover)
