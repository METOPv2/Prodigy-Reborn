local player = game.Players.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local playerModule = playerScripts:WaitForChild("PlayerModule")
local controlModule = require(playerModule:WaitForChild("ControlModule"))

-- Disable the default controls
controlModule:Disable()
