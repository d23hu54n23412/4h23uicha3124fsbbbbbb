--[[
    HitboxExtender.lua
--]]

local hitboxExtender = {
    Activated = false,
    Keybind = Enum.KeyCode.X,
    Parts = {},
    Size = 10,
}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

function hitboxExtender:Off()
    if hitboxExtender.PlayerAdded then
        hitboxExtender.PlayerAdded:Disconnect()
        hitboxExtender.PlayerAdded = nil
    end
    for _, proxy in pairs(hitboxExtender.Parts) do
        proxy:Destroy()
    end
end

function hitboxExtender:On()

    local function createHitbox(player)
        if player == gg.client then
            return
        end
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local proxy = gg.proxyPart.new()
        proxy:Link(humanoidRootPart)
        proxy:SetSize(Vector3.new(self.Size, self.Size, self.Size))
        proxy:CreateOutline()

        proxy:BindTouch(function(part)
            local tool = part.Parent
            if tool:IsA("Tool") then
                local tip = tool:FindFirstChild("Tip")
                if tip then
                    local character = tool.Parent
                    local Player = Players:GetPlayerFromCharacter(character)
                    if Player == gg.client then
                        print("Execute damage on user")
                    end
                end
            end
        end)

        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            proxy:Destroy()
            for i,v in pairs(hitboxExtender.Parts) do
                if v == proxy then
                    table.remove(hitboxExtender.Parts, i)
                end
            end
        end)

        table.insert(hitboxExtender.Parts, proxy)
    end

    for _, player in pairs(Players:GetPlayers()) do
        createHitbox(player)
    end

    hitboxExtender.PlayerAdded = Players.PlayerAdded:connect(function(player)
        createHitbox(player)
        player.CharacterAdded:Connect(function()
            createHitbox(player)
        end)
    end)
end

-- Creating a slider

local newSlider = gg.slider.new(gg.ui:WaitForChild("Menu").Menu.Slider, 5, 15, 1)

newSlider:Bind(function(val)
    for _,proxy in pairs(hitboxExtender.Parts) do
        hitboxExtender.Size = val
        proxy:SetSize(Vector3.new(hitboxExtender.Size, hitboxExtender.Size, hitboxExtender.Size))
    end
end)

-- TODO // remake this section to be universal using Keybinds.lua

UserInputService.InputBegan:connect(function(input)
    local KeyCode = input.KeyCode
    if KeyCode == hitboxExtender.Keybind then
        if hitboxExtender.Activated == false then
            hitboxExtender:On()
        else
            hitboxExtender:Off()
        end
        hitboxExtender.Activated = not hitboxExtender.Activated
    end
end)

return hitboxExtender
