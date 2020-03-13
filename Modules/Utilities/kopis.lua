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

local __namecall = getrawmetatable(game).__namecall
setreadonly(getrawmetatable(game), false)

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

getrawmetatable(game).__namecall = function(...)
    if type(({...})[1]) == "userdata" then
        if ({...})[1].Name and kopis.getEvent() and ({...})[1].Name == kopis.getEvent().Name then
            for i,v in pairs({...}) do
                if v:IsA("Humanoid") then
                    local target = players:GetPlayerFromCharacter(v.Parent)
                    if target then
                        print("KOPIS TEAM KILL : ".. kopis.teamKill)
                        if kopis.teamKill == true then
                            local clientTeam = gg.client.Team
                            local targetTeam = target.Team
                            print("KOPIS TEAM SAME : ".. targetTeam == clientTeam)
                            if targetTeam == clientTeam then
                                print("NULLIFYING TK DAMAGE")
                                return false
                            end
                        end
                    end
                end
            end
        end
    end
    return __namecall(...)
end

return kopis