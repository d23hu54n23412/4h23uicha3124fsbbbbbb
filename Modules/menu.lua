--[[
    menu.lua
    The handler for the main menu
    @author NodeSupport
--]]

local menu = {
    ui = gg.ui:WaitForChild("Menu"),
    Modules = {},
    loadedButtons = {}
}

local loaded = false

function bindButtons()
    local side = menu.ui.Side
    local combatButtons = side.Combat
    for _,button in pairs(combatButtons:GetChildren()) do
        if button:IsA("TextButton") then
            if not loadedButtons[button] then
                local succ = gg.load("Modules/Combat/"..tostring(button.Name))
                if succ then
                    local settings = menu.ui.Settings
                    button.MouseButton1Down:Connect(function()
                        if settings:FindFirstChild(button.Name) then
                            for _,v in pairs(settings:GetChildren()) do
                                v.Visible = false
                            end
                            settings:FindFirstChild(button.Name).Visible = true
                            print("Debug-1")
                        end
                    end)
                    loadedButtons[button] = true
                end
            end
        end
    end
end

gg.keybinds:Bind(Enum.KeyCode.E, function()
    menu.ui.Visible = not menu.ui.Visible
    if loaded == false then
        gg.kopis = gg.load("Modules/Utilities/kopis")
        gg.load("Modules/Combat/hitboxExtender")
        menu.loadedButtons[menu.ui.Side.Combat.hitboxExtender] = true
        bindButtons()
    end
    loaded = true
end)

return menu