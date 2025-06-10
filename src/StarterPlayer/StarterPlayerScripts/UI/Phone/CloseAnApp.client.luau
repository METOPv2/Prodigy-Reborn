--!strict
local Players = game:GetService("Players")

local phoneGui = Players.LocalPlayer.PlayerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageButton & {
        Button1: Frame & {
            TextButton: TextButton,
        },
        Menu: ImageLabel & {
            Container: ImageLabel & {
                Apps: Folder & { Frame },
            },
        },
    },
}
local closeApp = phoneGui.Background.Button1
local closeAppButton = closeApp.TextButton
local apps = phoneGui.Background.Menu.Container.Apps

closeApp.Visible = false

phoneGui:GetAttributeChangedSignal("CurrentApp"):Connect(function()
    closeApp.Visible = phoneGui:GetAttribute("CurrentApp") ~= ""
end)

local function closeAnApp()
    local currentAppName = phoneGui:GetAttribute("CurrentApp") :: string
    local app = apps:FindFirstChild(currentAppName) :: Frame
    app.Visible = false
    phoneGui:SetAttribute("CurrentApp", "")
end

closeAppButton.Activated:Connect(closeAnApp)
