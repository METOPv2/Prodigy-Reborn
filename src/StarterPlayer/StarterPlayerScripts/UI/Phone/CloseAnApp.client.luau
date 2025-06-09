--!strict
local Players: Players = game:GetService("Players")

local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageButton & {
        Close: Frame & {
            TextButton: TextButton,
        },
        Menu: ImageLabel & {
            Container: ImageLabel & {
                Apps: Folder & { Frame },
            },
        },
    },
}
local closeApp: Frame & { TextButton: TextButton } = phoneGui.Background.Close
local closeAppButton: TextButton = closeApp.TextButton
local apps: Frame = phoneGui.Background.Menu.Container.Apps

closeApp.Visible = false

phoneGui:GetAttributeChangedSignal("CurrentApp"):Connect(function()
    closeApp.Visible = phoneGui:GetAttribute("CurrentApp") ~= ""
end)

local function closeAnApp(): ()
    local currentAppName = phoneGui:GetAttribute("CurrentApp") :: string
    local app = apps:FindFirstChild(currentAppName) :: Frame
    app.Visible = false
    phoneGui:SetAttribute("CurrentApp", "")
end

closeAppButton.Activated:Connect(closeAnApp)
