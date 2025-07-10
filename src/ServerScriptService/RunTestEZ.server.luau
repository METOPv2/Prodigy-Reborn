local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ = require(ReplicatedStorage.Source.Dependencies.TestEZ)

TestEZ.TestBootstrap:run(ReplicatedStorage.Source.Tests:GetChildren())
