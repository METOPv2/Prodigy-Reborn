--!strict
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local joinedForTheFirstTime = ReplicatedStorage:WaitForChild("RemoteEvents").JoinedForTheFirstTime

local playerGui = Players.LocalPlayer.PlayerGui
local usernameGui = playerGui:WaitForChild("Username") :: ScreenGui

local disabledGuis = {}

joinedForTheFirstTime.OnClientEvent:Connect(function()
    for _, screenGui in ipairs(playerGui:GetChildren()) do
        if not screenGui:IsA("ScreenGui") then
            continue
        end

        if screenGui.Enabled then
            screenGui.Enabled = false
            table.insert(disabledGuis, screenGui)
        end
    end

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    usernameGui.Enabled = true
end)

usernameGui.Destroying:Connect(function()
    for _, screenGui in ipairs(disabledGuis) do
        if screenGui and screenGui:IsA("ScreenGui") then
            screenGui.Enabled = true
        end
    end

    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
end)
