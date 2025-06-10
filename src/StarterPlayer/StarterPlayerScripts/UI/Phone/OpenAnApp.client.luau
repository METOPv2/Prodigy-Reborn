--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Phone = require(ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)

local phoneGui = Players.LocalPlayer.PlayerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageLabel & {
        Cover: ImageLabel & {
            Container: CanvasGroup & {
                Pages: Frame,
            },
        },
        Menu: ImageLabel & {
            Container: ImageLabel & {
                Apps: Folder,
            },
        },
    },
}
local apps = phoneGui.Background.Menu.Container.Apps
local pages = phoneGui.Background.Cover.Container.Pages

local function isItAnApp(instance: Instance): boolean
    return apps:FindFirstChild(instance.Name) ~= nil
end

for _, v in ipairs(pages:GetChildren()) do
    if not v:IsA("Frame") then
        continue
    end

    local page = v :: Frame & {
        [string]: Frame & {
            TextButton: TextButton,
        },
    }

    for _, v in ipairs(page:GetChildren()) do
        if not v:IsA("Frame") or not isItAnApp(v) then
            continue
        end

        local app = v :: Frame & {
            TextButton: TextButton,
        }

        app.TextButton.Activated:Connect(function()
            Phone.OpenAnApp(app.Name)
        end)
    end
end
