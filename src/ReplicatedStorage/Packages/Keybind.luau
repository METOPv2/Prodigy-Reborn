--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = ReplicatedStorage:WaitForChild("Assets") :: Folder
local inputActionSystem = assets:WaitForChild("InputActionSystem") :: Folder
local actionTemplate = inputActionSystem:WaitForChild("ActionTemplate") :: InputAction

type KeybindImpl = {
    CurrentContext: string,
    EnableContext: (context: string) -> (),
    GetAction: (actionName: string, keyboardBinding: Enum.KeyCode) -> InputAction,
}

type KeybindContext = {
    parent: InputContext,
    actions: { [string]: InputAction },
}

-- module table:
local Keybind = {
    CurrentContext = "",
} :: KeybindImpl

-- constant variables
local ACTION_TEMPLATE = actionTemplate

-- Private variables
local keybinds: { [string]: KeybindContext } = {}

-- Private functions
local function getContext(name: string): KeybindContext
    if keybinds[name] == nil then
        local context = Instance.new("InputContext")
        context.Enabled = true
        context.Name = name
        context.Parent = ReplicatedStorage:WaitForChild("InputContext")

        keybinds[name] = {
            parent = context,
            actions = {},
        }
    end

    return keybinds[name]
end

local function getEmptyAction(): InputAction
    return ACTION_TEMPLATE:Clone()
end

local function doesActionExist(actionContext: KeybindContext, actionName: string): boolean
    for otherActionName, _ in pairs(actionContext.actions) do
        if otherActionName == actionName then
            return true
        end
    end

    return false
end

-- Global methods
function Keybind.GetAction(actionName: string, keyboardKeybind: Enum.KeyCode)
    local context = getContext(actionName)

    local action

    if doesActionExist(context, actionName) then
        action = context.actions[actionName]
    else
        action = getEmptyAction()
        action.Name = actionName
        action.Parent = context.parent
        context.actions[actionName] = action
    end

    local keyboardBinding = action:FindFirstChild("KeyboardBinding") :: InputBinding
    keyboardBinding.KeyCode = keyboardKeybind

    return action
end

return Keybind
