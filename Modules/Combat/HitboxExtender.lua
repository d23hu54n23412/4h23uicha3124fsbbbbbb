--[[
    HitboxExtender.lua
--]]

local HitboxExtender = {
    Activated = false,
    Keybind = Enum.KeyCode.X,
    Parts = {},
    Size = 5,
}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

function HitboxExtender:Off()

end

function HitboxExtender:On()
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local proxy = gg.proxyPart.new()
        proxy:Link(humanoidRootPart)
        proxy:SetSize(Vector3.new(self.Size, self.Size, self.Size))
        proxy:CreateOutline()
    end
end

UserInputService.InputBegan:connect(function(input)
    local KeyCode = input.KeyCode
    if KeyCode == HitboxExtender.Keybind then
        if HitboxExtender.Activated == false then
            HitboxExtender:On()
        else
            HitboxExtender:Off()
        end
        HitboxExtender.Activated = not HitboxExtender.Activated
    end
end)

return HitBoxExtender