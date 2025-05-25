local LevelManager = {}

function LevelManager:CalculateExpGoal(level: number)
    return level * 10 + 10
end

return LevelManager
