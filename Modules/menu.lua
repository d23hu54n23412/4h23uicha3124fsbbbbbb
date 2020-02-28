--[[
    menu.lua
    The handler for the main menu
    @author NodeSupport
--]]

local menu = {
    ui = gg.ui:WaitForChild("Menu")
}

gg.keybinds:Bind(Enum.KeyCode.E, function()
    if not gg.slider then
        gg.slider = gg.load("Modules/slider")
    end
    menu.ui.Visible = not menu.ui.Visible

    gg.slider.new(menu.ui.Menu.Slider)
end)

return menu