local Data = {
	{
		Name = "NebulaOrb",
		DisplayName = "Nebula Orb",
		Image = "rbxassetid://105316741105719",
	},
	{
		Name = "MedallionTiger",
		DisplayName = "Medallion Tiger",
		Image = "rbxassetid://92390685016112",
	},
	{
		Name = "MedallionShark",
		DisplayName = "Medallion Shark",
		Image = "rbxassetid://91714249972584",
	},
	{
		Name = "MedallionMosquito",
		DisplayName = "Medallion Mosquito",
		Image = "rbxassetid://102673775383822",
	},
	{
		Name = "MedallionJellyfish",
		DisplayName = "Medallion Jellyfish",
		Image = "rbxassetid://109597987624466",
	},
	{
		Name = "MedallionHawk",
		DisplayName = "Medallion Hawk",
		Image = "rbxassetid://115326385132458",
	},
	{
		Name = "MedallionFroghopper",
		DisplayName = "Medallion Froghopper",
		Image = "rbxassetid://76645989344410",
	},
	{
		Name = "MedallionElephant",
		DisplayName = "Medallion Elephant",
		Image = "rbxassetid://103895985412285",
	},
	{
		Name = "MedallionBear",
		DisplayName = "Medallion Bear",
		Image = "rbxassetid://131363926799582",
	},
	{
		Name = "MedallionAxolotl",
		DisplayName = "Medallion Axolotl",
		Image = "rbxassetid://114226439122993",
	},
	{
		Name = "MedallionAnimals",
		DisplayName = "Medallion Animals",
		Image = "rbxassetid://139098524570712",
	},
	{
		Name = "GoldDiamond",
		DisplayName = "Gold Diamond",
		Image = "rbxassetid://84928570291523",
	},
}

function FindItem(name: string)
	for _, v in ipairs(Data) do
		if v.Name == name then
			return v
		end
	end
end

function DoesItemExists(name: string)
	return FindItem(name) ~= nil
end

return {
	Data = Data,
	FindItem = FindItem,
	DoesItemExists = DoesItemExists,
}
