local container = game.Players.LocalPlayer.PlayerGui:WaitForChild("Phone").Background.Cover.Container.Apps
local uiPageLayout = container.Pages.UIPageLayout

container.Next.TextButton.Activated:Connect(function()
    uiPageLayout:Next()
end)

container.Previous.TextButton.Activated:Connect(function()
    uiPageLayout:Previous()
end)
