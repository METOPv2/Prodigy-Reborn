--!strict
local UserInputService = game:GetService("UserInputService")

local Input = {}

function Input.Pressed(input: Enum.KeyCode | { Enum.KeyCode })
    local bind = {}

    local pressedEvent = Instance.new("BindableEvent")
    local releasedEvent = Instance.new("BindableEvent")

    bind.Released = releasedEvent.Event

    local listenerConnection

    function bind:Connect(callback)
        listenerConnection = pressedEvent.Event:Connect(callback)

        return self
    end

    local pressedConnection = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
        if gameProcessed then
            return
        end

        if input == inputObject.KeyCode then
            pressedEvent:Fire()
        elseif type(input) == "table" then
            local keysPressed = true

            for _, key in ipairs(input) do
                if UserInputService:IsKeyDown(key) == false then
                    keysPressed = false
                    break
                end
            end

            if keysPressed then
                pressedEvent:Fire()
            end
        end
    end)

    local releasedConnection = UserInputService.InputEnded:Connect(function(inputObject, gameProcessed)
        if gameProcessed then
            return
        end

        if inputObject.KeyCode == input then
            releasedEvent:Fire()
        elseif type(input) == "table" then
            local keysReleased = false

            for _, key in ipairs(input) do
                if not UserInputService:IsKeyDown(key) then
                    keysReleased = true
                    break
                end
            end

            if keysReleased then
                releasedEvent:Fire()
            end
        end
    end)

    function bind:Disconnect()
        pressedEvent:Destroy()
        releasedEvent:Destroy()
        pressedConnection:Disconnect()
        releasedConnection:Disconnect()
        listenerConnection:Disconnect()
    end

    return bind
end

function Input.Released(input: Enum.KeyCode)
    local bind = {}

    local releasedEvent = Instance.new("BindableEvent")
    local listenerConnection

    function bind:Connect(callback)
        listenerConnection = releasedEvent.Event:Connect(callback)

        return self
    end

    local releasedConnection = UserInputService.InputEnded:Connect(function(inputObject, gameProcessed)
        if gameProcessed then
            return
        end

        if inputObject.KeyCode == input then
            releasedEvent:Fire()
        end
    end)

    function bind:Disconnect()
        releasedEvent:Destroy()
        releasedConnection:Disconnect()
        listenerConnection:Disconnect()
    end

    return bind
end

function Input:IsKeyDown(keycode: Enum.KeyCode): boolean
    return UserInputService:IsKeyDown(keycode)
end

return Input
