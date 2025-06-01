--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local bookBackground = bookGui:FindFirstChild("Background") :: ImageLabel
local tabs = bookBackground:FindFirstChild("Tabs") :: Folder

local mouseEnterTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local mouseLeaveTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function mouseEnter(tab: Folder)
    local icon: ImageLabel

    for _, children in ipairs(tab:GetChildren()) do
        if children:IsA("ImageLabel") and children.Name:match("Icon$") then
            icon = children
            break
        end
    end

    local tween = TweenService:Create(icon, mouseEnterTweenInfo, { ImageTransparency = 0 })
    tween:Play()
end

local function mouseLeave(tab: Folder)
    local icon: ImageLabel

    for _, children in ipairs(tab:GetChildren()) do
        if children:IsA("ImageLabel") and children.Name:match("Icon$") then
            icon = children
            break
        end
    end

    local tween = TweenService:Create(icon, mouseLeaveTweenInfo, { ImageTransparency = 0.5 })
    tween:Play()
end

for _, tab in ipairs(tabs:GetChildren()) do
    if not tab:IsA("Folder") then
        continue
    end

    local textButton = tab:FindFirstChild("TextButton") :: TextButton

    textButton.MouseEnter:Connect(function()
        mouseEnter(tab)
    end)

    textButton.MouseLeave:Connect(function()
        mouseLeave(tab)
    end)
end
