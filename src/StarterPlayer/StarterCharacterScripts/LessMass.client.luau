local character = script.Parent.Parent
local primaryPart = character.PrimaryPart :: BasePart

local density = 0.2
local elasticity = 0.5
local elasticityWeight = 1
local friction = 0.3
local frictionWeight = 1

primaryPart.CustomPhysicalProperties = PhysicalProperties.new(density, elasticity, elasticityWeight, friction, frictionWeight)
