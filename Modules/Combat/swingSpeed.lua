local swingSpeed = {
    Activated = false,
    Keybind = Enum.KeyCode.V,

    SwingSpeed = 1,
    HitCooldown = 0.55,
}

local UserInputService = game:GetService("UserInputService")

function setSwingSpeed(speed)
    local currentSwingSpeed = gg.kopis.getSwingSpeed()
    if not currentSwingSpeed then
        return
    end
    if type(speed) == "number" then
        for i,v in pairs(currentSwingSpeed) do
            currentSwingSpeed[i] = speed
        end
    else
        for i,v in pairs(currentSwingSpeed) do
            currentSwingSpeed[i] = speed[i]
        end
    end
end

function setSwingCooldown(val)
    local currentDelay = gg.kopis.getSlashDelay()
    if currentDelay then
        currentDelay.slash = val
    end
end

function swingSpeed:On()
    setSwingSpeed(swingSpeed.SwingSpeed)
    setSwingCooldown(swingSpeed.HitCooldown)
end

function swingSpeed:Off()
    setSwingSpeed(gg.kopis.getDefaultSwingSpeeds())
    setSwingCooldown(0.55)
end

-- Creating a slider

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.swingSpeed.SwingSlider, 0, 2, 2) -- min, max, round

newSlider:Bind(function(val)
    swingSpeed.SwingSpeed = val
    if swingSpeed.Activated then
        setSwingSpeed(val)
    end
end)

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.swingSpeed.DelaySlider, 0, 1, 3) -- min, max, round

newSlider:Bind(function(val)
    swingSpeed.HitCooldown = val
    if swingSpeed.Activated then
        setSwingCooldown(val)
    end
end)
--

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == swingSpeed.Keybind then
        if swingSpeed.Activated == false then
            swingSpeed:On()

            if label then
                label:Destroy()
                label = nil
            end

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Swing Modifier"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            swingSpeed:Off()

            if label then
                label:Destroy()
                label = nil
            end
        end
        swingSpeed.Activated = not swingSpeed.Activated
    end
end)

return swingSpeed