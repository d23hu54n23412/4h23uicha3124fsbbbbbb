local teamKill = {
    Activated = false,
    Keybind = Enum.KeyCode.C,
}

local UserInputService = game:GetService("UserInputService")

function teamKill:On()
    gg.kopis.teamKill = true
end

function teamKill:Off()
    gg.kopis.teamKill = false
end

-- Creating a keybind handler

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.teamKill.Keybind, "Team Kill")

newKeybind:Bind(function(key)
    teamKill.Keybind = key
end)

-- Binding an input connection

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == teamKill.Keybind then
        if teamKill.Activated == false then
            teamKill:On()
        else
            teamKill:Off()
        end
        teamKill.Activated = not teamKill.Activated
    end
end)

return teamKill