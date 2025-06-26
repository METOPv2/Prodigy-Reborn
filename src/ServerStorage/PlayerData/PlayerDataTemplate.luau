-- These are default values that will be loaded when player first time joins the game.

return {
	Inventory = {
		--[[
			List items there as:
			"ItemName",
			"ItemName",
			"ItemName",
			...
		]]
	},
	Values = {
		Money = 0,
		EXP = 0,
		Level = 0,
		SkillPoints = 50,
		MusicVolume = 0.5,
		SFXVolume = 0.5,
		Username = "",
		LastOnline = os.clock(),
		MusicEnabled = true,
		SFXEnabled = true,
	},
	Stats = {
		HP = 30,
		MP = 30,
		STR = 30,
		DEX = 30,
		LUK = 30,
		INT = 30,
	},
}
