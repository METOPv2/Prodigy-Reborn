local Phone = require(game.ReplicatedStorage:WaitForChild("Source").ModuleScripts.Phone)
local togglePhoneButton = game.Players.LocalPlayer.PlayerGui:WaitForChild("Interface").Background.Phone

togglePhoneButton.Activated:Connect(Phone.TogglePhone)
