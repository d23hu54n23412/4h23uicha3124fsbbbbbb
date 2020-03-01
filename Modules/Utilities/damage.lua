--[[
    damage.lua
    Commits damage on the specified object if possible
    @author NodeSupport
--]]

local lastHit = tick()

return function(humanoid, part, cooldown)
    if not part:IsA("Tool") then
        return
    end
    local client = gg.client
    local character = client.Character
    if not character then
        return
    end
    local tip = character:FindFirstChild("Tip", true)
    if not tip or not tip.Parent:IsA("Tool") then
        return
    end
    local tool = tip.Parent
    if part == tip then
        local event = tool:FindFirstChild("swordEvent", true)
        if event and tick() - lastHit >= cooldown then
            event:FireServer("dmg", humanoid)
        elseif tool:FindFirstChild("SwordEvent") -- Lake Tech
            event = tool:FindFirstChild("SwordEvent")
            event:FireServer(humanoid)
        end
        lastHit = tick()
    end
end