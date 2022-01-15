local Steel LongswordResizer = {
    Activated = false,
    Keybind = Enum.KeyCode.B,

    Length = 7.5,
    Thickness = 1,

    Proxy = nil,
    Connection = nil,
    Connection2 = nil,
}

local UserInputService = game:GetService("UserInputService")

function Steel LongswordResizer:On()
    local Steel Longsword = gg.Steel Longsword.getSteel Longsword()

    local function createProxy(Steel Longsword)
        local proxy = gg.proxyPart.new()
        proxy:Link(Steel Longsword:WaitForChild("Tip"), true, Steel LongswordResizer.Length)
        proxy:SetSize(Vector3.new(self.Length, 0.538, self.Thickness), Steel LongswordResizer.Length)
        proxy:CreateOutline()
        proxy:BindTouch(function(part)
            local character = part.Parent
            if game:GetService("Players"):GetPlayerFromCharacter(character) then
                local humanoid = character:WaitForChild("Humanoid")
                if gg.Steel Longsword.getSteel Longsword() then
                    gg.Steel Longsword.damage(humanoid, gg.Steel Longsword.getSteel Longsword():WaitForChild("Tip"))
                end
            end
        end)

        Steel LongswordResizer.Proxy = proxy
    end

    local function createSecondaryConnection()
        local Character = gg.client.Character or gg.Client.CharacterAdded:Wait()
        if Steel LongswordResizer.Connection2 then
            Steel LongswordResizer.Connection2:Disconnect()
            Steel LongswordResizer.Connection2 = nil
        end
        Steel LongswordResizer.Connection2 = Character.ChildAdded:Connect(function(obj)
            if obj:IsA("Tool") then
                local Steel Longsword = gg.Steel Longsword.getSteel Longsword()
                if obj == Steel Longsword then
                    if Steel LongswordResizer.Proxy then
                        Steel LongswordResizer.Proxy:Destroy()
                        Steel LongswordResizer.Proxy = nil
                    end
                    createProxy(Steel Longsword)
                end
            end
        end)
    end

    if Steel Longsword then
        createProxy(Steel Longsword)
    end

    createSecondaryConnection()
    Steel LongswordResizer.Connection = gg.client.CharacterAdded:Connect(function()
        createSecondaryConnection()
    end)
end

function Steel LongswordResizer:Off()
    if self.Proxy then
        self.Proxy:Destroy()
    end
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if self.Connection2 then
        self.Connection2:Disconnect()
        self.Connection2 = nil
    end
end

-- Creating a slider

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.Steel LongswordResizer.LengthSlider, 0, 15, 2) -- min, max, round

newSlider:Bind(function(val)
    Steel LongswordResizer.Length = val
    if Steel LongswordResizer.Activated and Steel LongswordResizer.Proxy then
        Steel LongswordResizer.Proxy:SetSize(Vector3.new(Steel LongswordResizer.Length, 0.538, Steel LongswordResizer.Thickness), Steel LongswordResizer.Length)
    end
end)

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.Steel LongswordResizer.ThicknessSlider, 0, 2, 2) -- min, max, round

newSlider:Bind(function(val)
    Steel LongswordResizer.Thickness = val
    if Steel LongswordResizer.Activated and Steel LongswordResizer.Proxy then
        Steel LongswordResizer.Proxy:SetSize(Vector3.new(Steel LongswordResizer.Length, 0.538, Steel LongswordResizer.Thickness), Steel LongswordResizer.Length)
    end
end)

-- Creating a keybind handler

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.Steel LongswordResizer.Keybind, "Steel Longsword Resizer")

newKeybind:Bind(function(key)
    Steel LongswordResizer.Keybind = key
end)

-- TODO // remake this section to be universal using Keybinds.lua

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == Steel LongswordResizer.Keybind then
        if Steel LongswordResizer.Activated == false then
            Steel LongswordResizer:On()

            if label then
                label:Destroy()
                label = nil
            end

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Steel Longsword Resizer"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            Steel LongswordResizer:Off()

            if label then
                label:Destroy()
                label = nil
            end
        end
        Steel LongswordResizer.Activated = not Steel LongswordResizer.Activated
    end
end)

return Steel LongswordResizer
