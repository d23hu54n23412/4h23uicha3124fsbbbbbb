--[[
    HitboxExtender.lua
--]]

local hitboxExtender = {
    Activated = false,
    Keybind = Enum.KeyCode.X,
    Parts = {},
    DiedBinds = {},
    Size = 10,
    Cooldown = tick(),
    CharacterAdded = {}
}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

function hitboxExtender:Off()
    if hitboxExtender.PlayerAdded then
        hitboxExtender.PlayerAdded:Disconnect()
        hitboxExtender.PlayerAdded = nil
    end
    for _, added in pairs(hitboxExtender.CharacterAdded) do
        added:Disconnect()
    end
    for _,func in pairs(hitboxExtender.DiedBinds) do
        func:Disconnect()
    end
    for _, proxy in pairs(hitboxExtender.Parts) do
        proxy:Destroy()
    end
    hitboxExtender.Parts = {}
    hitboxExtender.DiedBinds = {}
end

function hitboxExtender:On()

    local function createHitbox(player)
        if player == gg.client then
            return
        end
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        local proxy = gg.proxyPart.new()
        proxy:Link(humanoidRootPart)
        proxy:SetSize(Vector3.new(self.Size, self.Size, self.Size))
        proxy:CreateOutline()

        proxy:BindTouch(function(part)
            gg.Steel Longsword.damage(humanoid, part, .66)
        end)

        local deathBind = humanoid.Died:Connect(function()
            proxy:Destroy()
        end)

        table.insert(hitboxExtender.DiedBinds, deathBind)

        table.insert(hitboxExtender.Parts, proxy)
    end

    for _, player in pairs(Players:GetPlayers()) do
        createHitbox(player)
        local added = player.CharacterAdded:Connect(function()
            createHitbox(player)
        end)
        table.insert(hitboxExtender.CharacterAdded, added)
    end

    hitboxExtender.PlayerAdded = Players.PlayerAdded:connect(function(player)
        createHitbox(player)
        local added = player.CharacterAdded:Connect(function()
            createHitbox(player)
        end)
        table.insert(hitboxExtender.CharacterAdded, added)
    end)
end

-- Creating a keybind handler

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.hitboxExtender.Keybind, "Hitbox Extender")

newKeybind:Bind(function(key)
    hitboxExtender.Keybind = key
end)

-- Creating a slider

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Settings.hitboxExtender.Slider, 5, 15, 1) -- min, max, round

newSlider:Bind(function(val)
    hitboxExtender.Size = val
    for _,proxy in pairs(hitboxExtender.Parts) do
        proxy:SetSize(Vector3.new(hitboxExtender.Size, hitboxExtender.Size, hitboxExtender.Size))
    end
end)

-- TODO // remake this section to be universal using Keybinds.lua

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == hitboxExtender.Keybind then
        if hitboxExtender.Activated == false then
            hitboxExtender:On()

            if label then
                label:Destroy()
                label = nil
            end

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Hitbox Extender"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            hitboxExtender:Off()

            if label then
                label:Destroy()
                label = nil
            end
        end
        hitboxExtender.Activated = not hitboxExtender.Activated
    end
end)

return hitboxExtender
