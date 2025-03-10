local CurrencyModule = {}

local MoneyImages = require(game.ReplicatedStorage.Source.ModuleScripts.MoneyImages)
local MoneyBillboardUIAsset = game.ReplicatedStorage.Assets.BillboardUIs.MoneyDrop

function CurrencyModule.SpawnCash(position: Vector3, amount: number)
    local amountOfDrops = 1

    if amount % 2 == 0 then
        amountOfDrops = 2
    elseif amount % 3 == 0 then
        amountOfDrops = 3
    end

    for i = 1, amountOfDrops do
        local money = amount / amountOfDrops

        local part = Instance.new("Part")
        part.Size = Vector3.one
        part.Position = position
        part.BrickColor = BrickColor.Red()
        part.Velocity = Vector3.new(Random.new():NextNumber(-20, 20), 0, 0)
        part.CollisionGroup = "Player"
        part.Parent = workspace

        local billboard = MoneyBillboardUIAsset:Clone()
        if amount < 1000 then
            billboard.ImageLabel.Image = MoneyImages.Coin
        elseif amount < 100000 then
            billboard.ImageLabel.Image = MoneyImages.Cash
        else
            billboard.ImageLabel.Image = MoneyImages.MoneyBag
        end
        billboard.Parent = part

        local proximityPrompt = Instance.new("ProximityPrompt")
        proximityPrompt.ActionText = "Pick up"
        proximityPrompt.ObjectText = string.format("%.2f", money)
        proximityPrompt.RequiresLineOfSight = false
        proximityPrompt.HoldDuration = 0
        proximityPrompt.Triggered:Connect(function(playerWhoPickedUp)
            part:Destroy()
            playerWhoPickedUp.PlayerData.Money.Value += money
        end)
        proximityPrompt.Parent = part
    end
end

return CurrencyModule
