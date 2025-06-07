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

    for _ = 1, amountOfDrops do
        local money = amount / amountOfDrops

        local part = Instance.new("Part")
        part.Size = Vector3.one
        part.Position = position
        part.BrickColor = BrickColor.Red()
        part.Velocity = Vector3.new(Random.new():NextNumber(-20, 20), 0, 0)
        part.CollisionGroup = "Player"
        part.Transparency = 1
        part.Parent = workspace

        local billboard = MoneyBillboardUIAsset:Clone()
        if amount < 1000 then
            billboard.ImageLabel.Image = MoneyImages.Coin
        elseif amount < 100000 then
            billboard.ImageLabel.Image = MoneyImages.Cash
            billboard.Size = UDim2.new(0, 40, 0, 40)
        else
            billboard.ImageLabel.Image = MoneyImages.MoneyBag
            billboard.Size = UDim2.new(0, 50, 0, 50)
        end
        billboard.Parent = part

        -- TODO: rewrite picking up of items system
        local proximityPrompt = Instance.new("ProximityPrompt")
        proximityPrompt.RequiresLineOfSight = false
        proximityPrompt.HoldDuration = 0
        proximityPrompt.MaxActivationDistance = 3
        proximityPrompt.KeyboardKeyCode = Enum.KeyCode.Z
        proximityPrompt.Style = Enum.ProximityPromptStyle.Custom
        proximityPrompt.Parent = part

        proximityPrompt.Triggered:Connect(function(playerWhoPickedUp)
            part:Destroy()
            playerWhoPickedUp.PlayerData.Money.Value += money
        end)
        proximityPrompt.Parent = part
    end
end

return CurrencyModule
