--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local DeveloperProducts = require(ReplicatedStorage.Source.Settings.DeveloperProducts)
local PlayerDataTemplate = require(ServerStorage.Source.PlayerData.PlayerDataTemplate)

local productFunctions = {
    [DeveloperProducts.ResetSkillPoints] = function(userId: number)
        local player = Players:GetPlayerByUserId(userId)

        if not player then
            return false
        end

        local stats = player:FindFirstChild("Stats") :: Folder

        for _, stat in ipairs(stats:GetChildren()) do
            if stat:IsA("IntValue") then
                stat.Value = 0
            end
        end

        local playerData = player:FindFirstChild("PlayerData") :: Folder
        local skillPoints = playerData:FindFirstChild("SkillPoints") :: IntValue

        skillPoints.Value = PlayerDataTemplate.Values.SkillPoints

        return true
    end,
}

MarketplaceService.ProcessReceipt = function(receipt)
    local userId = receipt.PlayerId
    local productId = receipt.ProductId

    if not productFunctions[productId] then
        warn(`No functions found for {productId}. Please add a function for the product in order to make it do something.`)
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local succses = productFunctions[productId](userId)

    if succses then
        return Enum.ProductPurchaseDecision.PurchaseGranted
    else
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
end
