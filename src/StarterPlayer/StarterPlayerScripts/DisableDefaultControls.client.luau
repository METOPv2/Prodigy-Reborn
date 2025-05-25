local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Get player control module
local playerScripts = player:WaitForChild("PlayerScripts") :: Folder
local playerModule = playerScripts:WaitForChild("PlayerModule") :: Folder
local controlModule = require(playerModule:WaitForChild("ControlModule") :: ModuleScript)

-- Disable default player controls
controlModule:Disable()
