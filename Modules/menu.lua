--[[
    menu.lua
    The handler for the main menu
    @author NodeSupport
--]]

local menu = {
    ui = gg.ui:WaitForChild("Menu"),
    Modules = {},
}

local required = false

gg.keybinds:Bind(Enum.KeyCode.E, function()
    if menu.ui.Visible == true then
        menu.ui.Visible = false
    else
        menu.ui.Visible = true
    end

    if required == false then
        gg.load("Modules/Combat/hitboxExtender")
    end

    required = true
    --local newSlider = gg.slider.new(menu.ui.Menu.Slider, 10, 1)

    --[[newSlider:Bind(function(val)
        
    end)

    gg.keybinds.newButton(menu.ui.Menu.Keybind, "Hitbox Extender")]]
end)

return menu