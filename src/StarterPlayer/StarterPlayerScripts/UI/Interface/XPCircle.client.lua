local InterfaceUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface")
local XPCircle = InterfaceUI:FindFirstChild("XpCircle", true)
local left = XPCircle.Left.ImageLabel.UIGradient
local right = XPCircle.Right.ImageLabel.UIGradient

local exp = game.Players.LocalPlayer:WaitForChild("PlayerData").EXP
local level = game.Players.LocalPlayer:WaitForChild("PlayerData").Level

local LevelManager = require(game.ReplicatedStorage.Source.ModuleScripts.LevelManager)

local function UpdateUI()
    local expGoal = LevelManager:CalculateExpGoal(level.Value)
    local alpha = exp.Value / expGoal

    if alpha > 0.5 then
        right.Rotation = (alpha - 0.5) / 0.5 * 180
    else
        left.Rotation = math.clamp(alpha / 0.5, 0, 1) * 180 + 180
    end
end

UpdateUI()
exp.Changed:Connect(UpdateUI)
level.Changed:Connect(UpdateUI)
