--[[
    damage.lua
    Commits damage on the specified object if possible
    @author NodeSupport
--]]

local lastHit = tick()

local kopis = {
    authorizedHit = true,
    teamKill = true,
}

local __namecall = getrawmetatable(game).__namecall
setreadonly(getrawmetatable(game), false)

function kopis.damage(humanoid, part, cooldown)
    if not part.Parent:IsA("Tool") then
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
            lastHit = tick()
        elseif tool:FindFirstChild("SwordEvent") then -- Lake Tech
            event = tool:FindFirstChild("SwordEvent")
            event:FireServer(humanoid)
            lastHit = tick()
        end
    end
end

--[[getrawmetatable(game).__namecall = function(...)
    if type(({...})[1]) == "userdata" then
        if ({...})[1].Name and kopis.getEvent() and ({...})[1].Name == "RemoteEvent" then 
            if ({...})[2] == "1" or "2" or "3" or "4" or "5" then
                print("caught event")
                return false
            end
        end
    end
    return __namecall(...)
end]]

return kopis