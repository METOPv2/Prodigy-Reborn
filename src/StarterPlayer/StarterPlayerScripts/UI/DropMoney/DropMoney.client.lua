local DropMoneyRemoteEvent = game.ReplicatedStorage:WaitForChild("RemoteEvents").DropMoney
local DropMoneyUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("DropMoney")
local DropButton = DropMoneyUI:FindFirstChild("Drop", true)
local TextBox = DropMoneyUI:FindFirstChild("TextBox", true)

DropButton.Activated:Connect(function()
    if not tonumber(TextBox.Text) then
        return
    end

    DropMoneyRemoteEvent:FireServer(tonumber(TextBox.Text))
    DropMoneyUI.Enabled = false
end)
