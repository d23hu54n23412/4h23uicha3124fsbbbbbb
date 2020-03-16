local shieldBypass = {
    Activated = false,
    Keybind = Enum.KeyCode.M,

    Chance = 50,
}

local UserInputService = game:GetService("UserInputService")

-- Creating a slider

gg.getShieldBypassData = function()
    return shieldBypass
end

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.shieldBypass.Slider, 0, 100, 0, true) -- min, max, round

newSlider:Bind(function(val)
    shieldBypass.Chance = val
end)

-- New Keybind

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.shieldBypass.Keybind, "Critical Hits")

newKeybind:Bind(function(key)
    shieldBypass.Keybind = key
end)

-- TODO // remake this section to be universal using Keybinds.lua

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == shieldBypass.Keybind then
        if shieldBypass.Activated == false then
            if label then
                label:Destroy()
                label = nil
            end

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Shield Bypass"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            if label then
                label:Destroy()
                label = nil
            end
        end
        shieldBypass.Activated = not shieldBypass.Activated
    end
end)

return shieldBypass