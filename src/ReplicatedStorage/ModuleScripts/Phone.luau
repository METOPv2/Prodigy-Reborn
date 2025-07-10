local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")

type PhoneGui = ScreenGui & {
	Background: ImageLabel & {
		Cover: ImageLabel,
		Menu: ImageLabel,
	},
}

local phoneGui = Players.LocalPlayer.PlayerGui:WaitForChild("Phone") :: PhoneGui
local phoneBackground = phoneGui.Background
local phoneCover = phoneBackground.Cover
local phoneMenu = phoneBackground.Menu

local Phone = {}

function Phone.init()
	print("Initializing the phone.")

	ContentProvider:PreloadAsync(
		{ phoneBackground.Image, phoneMenu.Image, phoneCover.Image },
		function(assetId: string, assetFetchStatus: Enum.AssetFetchStatus)
			print(assetId, assetFetchStatus)
		end
	)

	Phone.isBooted = false
	Phone.isOpen = false

	phoneGui.Enabled = true
	phoneBackground.Visible = true
	phoneCover.Visible = true
	phoneMenu.Visible = true

	phoneBackground.Position = phoneBackground:GetAttribute("ClosePosition")

	print("The phone is initialized.")
end

return Phone
