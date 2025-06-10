--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)

local interfaceGui = Players.LocalPlayer.PlayerGui:WaitForChild("Interface") :: ScreenGui & {
    Background: ImageLabel & {
        Phone: ImageButton,
    },
}
local phoneButton = interfaceGui.Background.Phone

phoneButton.MouseButton1Click:Connect(Phone.TogglePhone)
phoneButton.MouseButton2Click:Connect(Phone.ToggleCover)
