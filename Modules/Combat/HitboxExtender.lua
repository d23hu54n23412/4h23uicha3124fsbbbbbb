--[[
    HitboxExtender.lua
--]]

local HitboxExtender = {
    Activated = false,
    Keybind = Enum.Keybind.X,
    Parts = {},
}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function HitboxExtender:Off()
    
end

function HitboxExtender:On()

end

UserInputService.InputBegan:connect(function(input)
    local KeyCode = input.KeyCode
    if KeyCode == HitboxExtender.Keybind then
        if HitboxExtender.Activated == false then
            HitboxExtender:On()
        else
            HitboxExtender:Off()
        end
        HitboxExtender.Activated = not HitboxExtender.Activated
    end
end)

return HitBoxExtender