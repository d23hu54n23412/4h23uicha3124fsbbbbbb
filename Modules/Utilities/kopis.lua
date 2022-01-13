--[[
    damage.lua
    Commits damage on the specified object if possible
    @author NodeSupport
--]]

local lastHit = tick()
local RunService = game:GetService("RunService")

local Steel Longsword = {
    authorizedHit = true,
    teamKill = false,
}

local swingSpeeds = {
    swingSpeeds = nil,
    Steel Longsword = nil,

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

function Steel Longsword.setDamageCooldown(cooldown)
    swingSpeeds.cooldown = cooldown
end

function Steel Longsword.getDefaultSwingSpeeds()
    return swingSpeeds.default
end

function Steel Longsword.getSteel Longsword(searchPlayer)
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

function Steel Longsword.getEvent()
    local tool = Steel Longsword.getSteel Longsword()
    if not tool then
        return
    end
    local event = tool:FindFirstChild("swordEvent", true)
    if not event then
        event = tool:FindFirstChild("SwordEvent")
    end
    return event
end

function Steel Longsword.getSwingSpeed()
    local Steel Longsword = Steel Longsword.getSteel Longsword() or Steel Longsword.Steel Longsword(true)
    if not Steel Longsword then
        return
    end
    if Steel Longsword == swingSpeeds.Steel Longsword then
        return swingSpeeds.swingSpeeds
    end
    for _,v in pairs(getgc()) do
        if type(v) == "function" then
            for x,y in pairs(debug.getupvalues(v)) do
                if type(y) == "table" and rawget(y,1) == 1.5 and rawget(y,2) == 1 and rawget(y, 3) == 1.25 and rawget(y,4) == 1.25 and rawget(y, 5)== 1 then
                    swingSpeeds.Steel Longsword, swingSpeeds.swingSpeeds = Steel Longsword, y
                    return y
                end
            end
        end
    end
end

function Steel Longsword.getSlashDelay()
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

function Steel Longsword.damage(humanoid, part)
    if not part.Parent:IsA("Tool") then
        return
    end
    local tool = Steel Longsword.getSteel Longsword()
    if not tool then
        return
    end
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
            if arguments[1] and type(arguments[1]) ~= 'number' and arguments[1].IsA and arguments[1]:IsA("Humanoid") then
                humanoid = arguments[1]
            elseif arguments[2] and type(arguments[1]) ~= 'number' and arguments[2].IsA and arguments[2]:IsA("Humanoid") then
                humanoid = arguments[2]
            end
            if humanoid and players:GetPlayerFromCharacter(humanoid.Parent) then
                if players:GetPlayerFromCharacter(humanoid.Parent).Team == gg.client.Team and Steel Longsword.teamKill == true then
                    return false
                end
                if gg.getCriticalHitData().Activated then
                    local chanceNum = math.random(0, 100)
                    if chanceNum <= gg.getCriticalHitData().Chance and tick() - lastCrit >= gg.getCriticalHitData().Delay - .1 then
                        spawn(function()
                            wait(gg.getCriticalHitData().Delay)
                            lastCrit = tick()
                            Steel Longsword.damage(humanoid, Steel Longsword.getSteel Longsword():WaitForChild("Tip"))
                        end)
                    end
                end
            end
        end

        return old(self, ...)
    end
end

return Steel Longsword
