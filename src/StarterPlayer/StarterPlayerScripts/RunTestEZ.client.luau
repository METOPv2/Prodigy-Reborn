local ReplicatedStorage = game:GetService("ReplicatedStorage")

local source = ReplicatedStorage:WaitForChild("Source")

local TestEZ = require(source.Dependencies.TestEZ)

TestEZ.TestBootstrap:run(source.Tests:GetChildren())
