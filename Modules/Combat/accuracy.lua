local accuracy = {
    Activated = false,
    Keybind = Enum.KeyCode.L,
}

local UserInputService = game:GetService("UserInputService")

function accuracy:On()
    
end

function accuracy:Off()
    
end

-- Creating a keybind handler

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.accuracy.Keybind, "Team Kill")

newKeybind:Bind(function(key)
    accuracy.Keybind = key
end)

-- Binding an input connection

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == accuracy.Keybind then
        if accuracy.Activated == false then
            accuracy:On()

            if label then
                label:Destroy()
                label = nil
            end

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Accuracy"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            accuracy:Off()

            if label then
                label:Destroy()
                label = nil
            end
        end
        accuracy.Activated = not accuracy.Activated
    end
end)

return accuracy