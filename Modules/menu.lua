--[[
    menu.lua
    The handler for the main menu
    @author NodeSupport
--]]

local menu = {
    ui = gg.ui:WaitForChild("Menu")
}

gg.keybinds:Bind(Enum.KeyCode.E, function()
    menu.ui.Visible = not menu.ui.Visible

    local newSlider = gg.slider.new(menu.ui.Menu.Slider, 10, 1)

    local keybindChange = gg.keybinds.newButton(menu.ui.Menu.Keybind, "Hitbox Extender")
end)

return menu