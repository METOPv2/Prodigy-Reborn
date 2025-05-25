-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Stamina
local StaminaFolder = ReplicatedStorage:WaitForChild("Stamina")
local CurrentStamina = StaminaFolder.CurrentStamina
local MaxStamina = StaminaFolder.MaxStamina

-- Module scripts
local StaminaSettings = require(ReplicatedStorage:WaitForChild("Source").Settings.Stamina)

-- Stamina manager
local StaminaManager = {
    lastChanged = os.clock(),
}

function StaminaManager:Increment(amount)
    CurrentStamina.Value = math.min(CurrentStamina.Value + amount, MaxStamina.Value)
    StaminaManager.lastChanged = os.clock()
end

-- Stamina regenerator
task.spawn(function()
    while true do
        while CurrentStamina.Value < MaxStamina.Value and os.clock() - StaminaManager.lastChanged >= 2 do
            CurrentStamina.Value = math.min(CurrentStamina.Value + StaminaSettings.RegenStaminaPerSecond * task.wait(), MaxStamina.Value)
        end

        if CurrentStamina.Value == MaxStamina.Value then
            CurrentStamina.Changed:Wait()
        else
            task.wait(2 - (os.clock() - StaminaManager.lastChanged))
        end
    end
end)

return StaminaManager
