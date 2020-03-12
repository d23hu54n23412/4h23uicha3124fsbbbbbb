--[[
    keybinds.lua
    The main handler recognized by "gg.keybinds", bind, unbind, change
    binding functions, etc..

    @author NodeSupport
--]]

local UserInputService = game:GetService("UserInputService")

-- Returning table, ie; Modular setup, contains the users
-- bindings as well as the functions to change binds
local keybinds = {
    binds = {}, -- @BINDS
    functionNames = {} -- @NAMES
}

local Button = {}

local bindingKey = nil

function Button:Bind(func)
    table.insert(self.Bindings, func)
end

function keybinds.newButton(ui, value)
    local newButton = setmetatable({
        Function = nil,
        Bindings = {}
    }, {
        __index = Button
    })
    newButton.Function = ui.Keybind.MouseButton1Down:Connect(function()
        if not ui then
            return warn("Invalid UI whilst creating new Keybind Button")
        end
        
        local alert = gg.ui.Menu.Alert
        alert.Text = "Press any key to bind ".. value .."."
        alert.Visible = true

        --local currentKeybind = Enum.KeyCode[ui.Keybind.Text]
        bindingKey = {ui, newButton}
    end)
    return newButton
end

-- @UserInputService.InputBegan
-- Upon input it checks if a binding exists for that key,
-- will then execute the desired function if needed.
-- @listens InputService#Began
UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local keyCode = input.KeyCode
    if keyCode and bindingKey and keyCode ~= Enum.KeyCode.Unknown then
        local ui = bindingKey[1]
        local meta = bindingKey[2]
        if ui then
            if gg.ui.Menu.Alert.Visible == true then
                gg.ui.Menu.Alert.Visible = false
            end
            ui.Keybind.Text = UserInputService:GetStringForKeyCode(keyCode)
            bindingKey = nil

            if meta then
                for _, func in pairs(meta.Bindings) do
                    func(keyCode)
                end
            end
        end
    elseif keyCode then -- Checking to see if the input exists
        local funcs = keybinds.binds[keyCode]
        if funcs then
            for _, func in pairs(funcs) do
                func() -- Executing each function for the given bind
            end
        end
    end
end)

-- @keybinds:Bind()
-- Binds the specified key to the given function when pressed,
-- the function will be ran.
-- @params {key Enum#KeyCode, func Callback}
-- @returns {nil}

function keybinds:Bind(key, func, functionName)
    if not key or not func then
        return warn("Invalid keybind binding")
    end
    if functionName and not self.functionNames[functionName] then
        self.functionNames[functionName] = key
    end
    if not self.binds[key] then
        self.binds[key] = {}
    end
    table.insert(self.binds[key], func)
end

return keybinds