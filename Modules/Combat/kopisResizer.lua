local kopisResizer = {
    Activated = false,
    Keybind = Enum.KeyCode.B,

    Length = 7.5,
    Thickness = 1,

    Proxy = nil,
    Connection = nil,
    Connection2 = nil,
}

local UserInputService = game:GetService("UserInputService")

function kopisResizer:On()
    local kopis = gg.kopis.getKopis()

    local function createProxy(kopis)
        local proxy = gg.proxyPart.new()
        proxy:Link(kopis:WaitForChild("Tip"), true, kopisResizer.Length)
        proxy:SetSize(Vector3.new(self.Length, 0.538, self.Thickness), kopisResizer.Length)
        proxy:CreateOutline()
        proxy:BindTouch(function(part)
            local character = part.Parent
            if game:GetService("Players"):FindPlayerFromCharacter(character) then
                local humanoid = character:WaitForChild("Humanoid")
                gg.kopis.damage(humanoid, gg.kopis.getKopis():WaitForChild("Tip"))
            end
        end)

        kopisResizer.Proxy = proxy
    end

    local function createSecondaryConnection()
        local Character = gg.client.Character or gg.Client.CharacterAdded:Wait()
        if kopisResizer.Connection2 then
            kopisResizer.Connection2:Disconnect()
            kopisResizer.Connection2 = nil
        end
        kopisResizer.Connection2 = Character.ChildAdded:Connect(function(obj)
            if obj:IsA("Tool") then
                local kopis = gg.kopis.getKopis()
                if obj == kopis then
                    if kopisResizer.Proxy then
                        kopisResizer.Proxy:Destroy()
                        kopisResizer.Proxy = nil
                    end
                    createProxy(kopis)
                end
            end
        end)
    end

    if kopis then
        createProxy(kopis)
    end

    createSecondaryConnection()
    kopisResizer.Connection = gg.client.CharacterAdded:Connect(function()
        createSecondaryConnection()
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
    if self.Connection2 then
        self.Connection2:Disconnect()
        self.Connection2 = nil
    end
end

-- Creating a slider

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.kopisResizer.LengthSlider, 0, 15, 2) -- min, max, round

newSlider:Bind(function(val)
    kopisResizer.Length = val
    if kopisResizer.Activated and kopisResizer.Proxy then
        kopisResizer.Proxy:SetSize(Vector3.new(kopisResizer.Length, 0.538, kopisResizer.Thickness), kopisResizer.Length)
    end
end)

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.kopisResizer.ThicknessSlider, 0, 2, 2) -- min, max, round

newSlider:Bind(function(val)
    kopisResizer.Thickness = val
    if kopisResizer.Activated and kopisResizer.Proxy then
        kopisResizer.Proxy:SetSize(Vector3.new(kopisResizer.Length, 0.538, kopisResizer.Thickness), kopisResizer.Length)
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