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

local players = game:GetService("Players")

function kopis.getKopis()
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
end

function kopis.getEvent()
    local tool = kopis.getKopis()
    if not tool then
        return
    end
    local event = tool:FindFirstChild("swordEvent", true)
    if not event then
        event = tool:FindFirstChild("SwordEvent")
    end
    return event
end

function kopis.damage(humanoid, part, cooldown)
    if not part.Parent:IsA("Tool") then
        return
    end
    local tool = kopis.getKopis()
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

local mt = getrawmetatable(game)
setreadonly(mt, false)

local old = mt.__namecall

getrawmetatable(game).__namecall = function(self, ...) [nonamecall]
    local arguments = {...}
    if typeof(self) == "Instance" and self.Name and self.Name == "swordEvent" or self.Name == "SwordEvent" then
        local humanoid
        if arguments[1] and arguments[1].IsA and arguments[1]:IsA("Humanoid") then
            humanoid = arguments[1]
        elseif arguments[2] and arguments[2].IsA and arguments[2]:IsA("Humanoid") then
            humanoid = arguments[2]
        end
        if humanoid then
            if players:GetPlayerFromCharacter(humanoid.Parent).Team == gg.client.Team and kopis.teamKill == true then
            	return false
            end
        end
    end

    return old(self, ...)
end

return kopis