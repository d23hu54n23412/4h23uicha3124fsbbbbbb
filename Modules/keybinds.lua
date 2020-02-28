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
    binds = {} -- @BINDS
}

-- @UserInputService.InputBegan
-- Upon input it checks if a binding exists for that key,
-- will then execute the desired function if needed.
-- @listens InputService#Began
UserInputService.InputBegan:connect(function(input)
    local keyCode = input.KeyCode
    if keyCode then -- Checking to see if the input exists
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

function keybinds:Bind(key, func)
    if not key or not func then
        return warn("Invalid keybind binding")
    end
    if not self.binds[key] then
        self.binds[key] = {}
    end
    table.insert(self.binds[key], func)
end

return keybinds