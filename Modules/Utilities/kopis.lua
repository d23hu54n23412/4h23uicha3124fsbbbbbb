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

local swingSpeeds = {
    swingSpeeds = nil,
    kopis = nil,

    default = {
        1.5;
        1;
        1.25;
        1.25;
        1;
    },

    cooldown = .55
}

local players = game:GetService("Players")

function kopis.setDamageCooldown(cooldown)
    swingSpeeds.cooldown = cooldown
end

function kopis.getDefaultSwingSpeeds()
    return swingSpeeds.default
end

function kopis.getKopis(searchPlayer)
    local client = gg.client
    if searchPlayer == true then
        local tip = client:FindFirstChild("Tip", true)
        if not tip or not tip.Parent:IsA("Tool") then
            return
        end
        local tool = tip.Parent
        return tool
    else
        local character = client.Character
        if not character then
            return
        end
        local tip = character:FindFirstChild("Tip", true)
        if not tip or not tip.Parent:IsA("Tool") then
            return
        end
        local tool = tip.Parent
        return tool
    end
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

function kopis.getSwingSpeed()
    local kopis = kopis.getKopis() or kopis.getKopis(true)
    if not kopis then
        return
    end
    if kopis == swingSpeeds.kopis then
        return swingSpeeds.swingSpeeds
    end
    for _,v in pairs(getgc()) do
        if type(v) == "function" then
            for x,y in pairs(debug.getupvalues(v)) do
                if type(y) == "table" and rawget(y,1) == 1.5 and rawget(y,2) == 1 and rawget(y, 3) == 1.25 and rawget(y,4) == 1.25 and rawget(y, 5)== 1 then
                    swingSpeeds.kopis, swingSpeeds.swingSpeeds = kopis, y
                    return y
                end
            end
        end
    end
end

function kopis.getSlashDelay()
    for _,v in pairs(getgc()) do
        if type(v) == "function" then
            for _,y in pairs(debug.getupvalues(v)) do
                if type(y) == "table" then 
                    if rawget(y, "slash") then 
                        return y
                    end
                end
            end
        end
    end
end

function kopis.damage(humanoid, part)
    if not part.Parent:IsA("Tool") then
        return
    end
    local tool = kopis.getKopis()
    local tip = tool:FindFirstChild("Tip", true)
    if part == tip then
        local event = tool:FindFirstChild("swordEvent", true)
        if event and tick() - lastHit >= swingSpeeds.cooldown then
            event:FireServer("dmg", humanoid)
            lastHit = tick()
        elseif tool:FindFirstChild("SwordEvent") and tick() - lastHit >= swingSpeeds.cooldown then -- Lake Tech
            event = tool:FindFirstChild("SwordEvent")
            event:FireServer(humanoid)
            lastHit = tick()
        end
    end
end


local lastCrit = tick()

-- Calamari Support <3 Devv

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

if getreg().Calamari__namecall then -- is using calamar
    -- Add calamari TK support here (eventually)
else
    getrawmetatable(game).__namecall = function(self, ...) [nonamecall]
        local arguments = {...}
        if typeof(self) == "Instance" and self.Name and self.Name == "swordEvent" or self.Name == "SwordEvent" then
            local humanoid
            if arguments[1] and arguments[1].IsA and arguments[1]:IsA("Humanoid") then
                humanoid = arguments[1]
            elseif arguments[2] and arguments[2].IsA and arguments[2]:IsA("Humanoid") then
                humanoid = arguments[2]
            end
            if humanoid and players:GetPlayerFromCharacter(humanoid.Parent) then
                if players:GetPlayerFromCharacter(humanoid.Parent).Team == gg.client.Team and kopis.teamKill == true then
                    return false
                end

                if gg.getCriticalHitData().Activated then
                    local chanceNum = math.random(0, 100)
                    if chanceNum <= gg.getCriticalHitData().Chance and tick() - lastCrit >= gg.getCriticalHitData().Delay + .1 then
                        spawn(function()
                            wait(gg.getCriticalHitData().Delay)
                            lastCrit = tick()
                            kopis.damage(humanoid, kopis.getKopis():WaitForChild("Tip"))
                        end)
                    end
                end
            end
        end

        return old(self, ...)
    end
end

return kopis