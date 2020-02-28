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

    gg.slider.new(menu.ui.Menu.Slider, 10)
end)

return menu