local kopisResizer = {
    Activated = false,
    Keybind = Enum.KeyCode.B,

    Length = 3,
    Thickness = 1,

    Proxy = nil,
    Connection = nil,
}

local UserInputService = game:GetService("UserInputService")

function kopisResizer:On()
    local kopis = gg.kopis.getKopis()
    if kopis then
        local proxy = gg.proxyPart.new()
        proxy:Link(kopis:WaitForChild("Tip"))
        proxy:SetSize(Vector3.new(self.Length, 0.538, self.Thickness))
        proxy:CreateOutline()

        kopisResizer.Proxy = proxy
    end
    Connection = gg.client.CharacterAdded:Connect(function()
        local Character = gg.client.Character or gg.Client.CharacterAdded:Wait()
        Character.ChildAdded:Connect(function(obj)
            if obj:IsA("Tool") then
                local kopis = gg.kopis.getKopis()
                if obj == kopis then
                    if kopisResizer.Proxy then
                        kopisResizer.Proxy:Destroy()
                        kopisResizer.Proxy = nil
                    end
                    local proxy = gg.proxyPart.new()
                    proxy:Link(kopis:WaitForChild("Tip"))
                    proxy:SetSize(Vector3.new(kopisResizer.Length, 0.538, kopisResizer.Thickness))
                    proxy:CreateOutline()

                    kopisResizer.Proxy = proxy
                end
            end
        end)
    end)
end

function kopisResizer:Off()
    if self.Proxy then
        self.Proxy:Destroy()
    end
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

-- Creating a slider

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.kopisResizer.LengthSlider, 0, 15, 2) -- min, max, round

newSlider:Bind(function(val)
    kopisResizer.Length = val
    if kopisResizer.Activated and kopisResizer.Proxy then
        kopisResizer.Proxy:SetSize(Vector3.new(kopisResizer.Length, 0.538, kopisResizer.Thickness))
    end
end)

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.kopisResizer.ThicknessSlider, 0, 2, 2) -- min, max, round

newSlider:Bind(function(val)
    kopisResizer.Thickness = val
    if kopisResizer.Activated and kopisResizer.Proxy then
        kopisResizer.Proxy:SetSize(Vector3.new(kopisResizer.Length, 0.538, kopisResizer.Thickness))
    end
end)

-- Creating a keybind handler

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.kopisResizer.Keybind, "Kopis Resizer")

newKeybind:Bind(function(key)
    kopisResizer.Keybind = key
end)

-- TODO // remake this section to be universal using Keybinds.lua

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == kopisResizer.Keybind then
        if kopisResizer.Activated == false then
            kopisResizer:On()

            if label then
                label:Destroy()
                label = nil
            end

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Kopis Resizer"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            kopisResizer:Off()

            if label then
                label:Destroy()
                label = nil
            end
        end
        kopisResizer.Activated = not kopisResizer.Activated
    end
end)

return kopisResizer