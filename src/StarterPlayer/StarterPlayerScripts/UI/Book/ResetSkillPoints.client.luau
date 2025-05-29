--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local source = ReplicatedStorage:WaitForChild("Source")
local DeveloperProducts = require(source.Settings.DeveloperProducts)

local resetSkillPointsProductId = DeveloperProducts.ResetSkillPoints

local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local bookGui = playerGui:WaitForChild("Book") :: ScreenGui
local bookBackground = bookGui:FindFirstChild("Background") :: ImageLabel
local statsTab = bookBackground:FindFirstChild("Stats") :: Frame
local resetSkillPointsButton = statsTab:FindFirstChild("ResetSkillPoints") :: TextButton

local function promptResetSkillPointsProductPurchcase()
    MarketplaceService:PromptProductPurchase(player, resetSkillPointsProductId)
end

resetSkillPointsButton.Activated:Connect(promptResetSkillPointsProductPurchcase)
