--!strict
local Players = game:GetService("Players")

local phoneGui = Players.LocalPlayer.PlayerGui:WaitForChild("Phone") :: ScreenGui & {
    Background: ImageLabel & {
        Cover: ImageLabel & {
            Container: CanvasGroup & {
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
local nextPageButton = phoneGui.Background.Cover.Container.Next.TextButton
local previousPageButton = phoneGui.Background.Cover.Container.Previous.TextButton
local uiPageLayout = phoneGui.Background.Cover.Container.Pages.UIPageLayout

local function nextPage(): ()
    uiPageLayout:Next()
end

local function previousPage(): ()
    uiPageLayout:Previous()
end

nextPageButton.Activated:Connect(nextPage)
previousPageButton.Activated:Connect(previousPage)
