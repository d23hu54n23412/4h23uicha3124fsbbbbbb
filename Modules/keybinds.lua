local UserInputService = game:GetService("UserInputService")

local keybinds = {
    binds = {}
}

UserInputService.InputBegan:connect(function(input)
    local keyCode = input.KeyCode
    if keyCode then
        local funcs = keybinds.binds[keyCode]
        if funcs then
            for _, func in pairs(funcs) do
                func()
            end
        end
    end
end)

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