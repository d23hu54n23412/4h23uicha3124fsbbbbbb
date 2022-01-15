local parryBypass = {
    Activated = false,
    Keybind = Enum.KeyCode.M,

    Chance = 50,

    Connection = nil,
    Connection2 = nil,

    TouchedConnection = nil,
}

local UserInputService = game:GetService("UserInputService")

gg.getParryBypassData = function()
    return parryBypass
end

function parryBypass:On()

    function bindTouch()
        local Steel Longsword = gg.Steel Longsword.getSteel Longsword()
        local tip = Steel Longsword:FindFirstChild("Tip")
        
        if tip then
            if parryBypass.TouchedConnection then
                parryBypass.TouchedConnection:Disconnect()
                parryBypass.TouchedConnection = nil
            end
            parryBypass.TouchedConnection = tip.Touched:Connect(function(obj)
                if obj.Material == Enum.Material.Metal or obj.Material == Enum.Material.DiamondPlate then
                    local humanoid = obj.Parent.Parent:FindFirstChild("Humanoid")
                    local chanceNumber = math.random(0, 100)
                    if chanceNumber <= parryBypass.Chance then
                        gg.Steel Longsword.damage(humanoid, gg.Steel Longsword.getSteel Longsword():WaitForChild("Tip"))
                    end
                end
            end)
        end
    end

    function createSecondaryConnection()
        local character = gg.client.Character or gg.client.CharacterAdded:Wait()
        if parryBypass.Connection2 then
            parryBypass.Connection2:Disconnect()
            parryBypass.Connection2 = nil
        end
        parryBypass.Connection2 = character.ChildAdded:Connect(function(obj)
            if obj:IsA("Tool") then
                local Steel Longsword = gg.Steel Longsword.getSteel Longsword()
                if obj == Steel Longsword then
                    bindTouch()
                end
            end
        end)
    end

    if gg.Steel Longsword.getSteel Longsword() then
        bindTouch()
    end
    
    createSecondaryConnection()
    Connection = gg.client.CharacterAdded:Connect(function()
        createSecondaryConnection()
    end)
end

function parryBypass:Off()
    if parryBypass.Connection then
        parryBypass.Connection:Disconnect()
        parryBypass.Connection = nil
    end
    if parryBypass.Connection2 then
        parryBypass.Connection2:Disconnect()
        parryBypass.Connection2 = nil
    end
    if parryBypass.TouchedConnection then
        parryBypass.TouchedConnection:Disconnect()
        parryBypass.TouchedConnection = nil
    end
end

-- Creating a slider

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.parryBypass.Slider, 0, 100, 0, true) -- min, max, round

newSlider:Bind(function(val)
    parryBypass.Chance = val
end)

-- New Keybind

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.parryBypass.Keybind, "Critical Hits")

newKeybind:Bind(function(key)
    parryBypass.Keybind = key
end)

-- TODO // remake this section to be universal using Keybinds.lua

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == parryBypass.Keybind then
        if parryBypass.Activated == false then
            if label then
                label:Destroy()
                label = nil
            end

            parryBypass:On()

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Parry Bypass"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            if label then
                label:Destroy()
                label = nil
            end
            parryBypass:Off()
        end
        parryBypass.Activated = not parryBypass.Activated
    end
end)

return parryBypass
