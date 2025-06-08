--!strict
local Players: Players = game:GetService("Players")

local player: Player = Players.LocalPlayer
local playerGui: PlayerGui = player.PlayerGui
local phoneGui = playerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageLabel & {
        Menu: ImageLabel & {
            Container: ImageLabel & {
                Pages: Frame & {
                    UIPageLayout: UIPageLayout,
                },
                Previous: Frame & {
                    TextButton: TextButton,
                },
                Next: Frame & {
                    TextButton: TextButton,
                },
            },
        },
    },
}
local nextPageButton: TextButton = phoneGui.Background.Menu.Container.Next.TextButton
local previousPageButton: TextButton = phoneGui.Background.Menu.Container.Previous.TextButton
local pages: Frame & {
    UIPageLayout: UIPageLayout,
} = phoneGui.Background.Menu.Container.Pages
local uiPageLayout: UIPageLayout = pages.UIPageLayout

local function nextPage(): ()
    uiPageLayout:Next()
end

local function previousPage(): ()
    uiPageLayout:Previous()
end

nextPageButton.Activated:Connect(nextPage)
previousPageButton.Activated:Connect(previousPage)
