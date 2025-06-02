--!strict
export type Constructor = {
    CalculateExpGoal: (level: number) -> number,
}

local LevelManager = {}

function LevelManager:CalculateExpGoal(level: number)
    return level * 10 + 10
end

return LevelManager
