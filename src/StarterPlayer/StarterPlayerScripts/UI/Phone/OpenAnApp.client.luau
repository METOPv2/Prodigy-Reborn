--!strict
local Players: Players = game:GetService("Players")

local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageLabel & {
        Menu: ImageLabel & {
            Container: ImageLabel & {
                Apps: Folder & { Frame },
                Pages: Frame,
            },
        },
    },
}
local apps: Frame = phoneGui.Background.Menu.Container.Apps
local pages: Frame = phoneGui.Background.Menu.Container.Pages

local function isItAnApp(instance: Instance): boolean
    return apps:FindFirstChild(instance.Name) ~= nil
end

local function openAnApp(appName: string): ()
    local app = apps:FindFirstChild(appName) :: Frame
    app.Visible = true

    phoneGui:SetAttribute("CurrentApp", appName)
end

for _, v: Instance in ipairs(pages:GetChildren()) do
    if not v:IsA("Frame") then
        continue
    end

    local page = v :: Frame & {
        UIGridLayout: UIGradient,
        [string]: Frame & {
            TextButton: TextButton,
        },
    }

    for _, v: Instance in ipairs(page:GetChildren()) do
        if not v:IsA("Frame") or not isItAnApp(v) then
            continue
        end

        local app = v :: Frame & {
            TextButton: TextButton,
        }

        app.TextButton.Activated:Connect(function()
            openAnApp(app.Name)
        end)
    end
end
