--[[
    Initalize.lua
    Handles the backbones to our environmental API
    @author NodeSupport
--]]

local environment = {
    modules = {}
}

if getgenv().gg then
    return warn("Battlegrounds Zero Environment is already loaded")
end

getgenv().gg = environment


-- Bypassing Adonis Anti-Cheat (Error Detection)

local function checkErrorConnections()
    local Connections = getconnections(game:GetService("ScriptContext").Error)

    if #Connections > 0 then
        for ConnectionKey, Connection in pairs(Connections) do
			Connection:Disable()
		end
	else
		return false
	end
	
	return true
end

spawn(function()
    local errorConnections = checkErrorConnections()
    while RunService.RenderStepped:Wait() do
        if errorConnections then
            errorConnections = checkErrorConnections()
        end
    end
end)

function environment.load(path)
    if not path then
        return warn("Invalid Pathway for loading module")
    end
    if type(path) == "string" then
        print("Loading "..path)
        local succ, error = pcall(function()
            game:HttpGetAsync("https://raw.githubusercontent.com/ToggledReach/BGZ501ca/master/".. path ..".lua")
        end)
        if succ then
            return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ToggledReach/BGZ501ca/master/".. path ..".lua"))()
        else
            warn("Error whilst loading '"..path.. "' : "..tostring(error))
            return
        end
    elseif type(path) == "number" then
        return game:GetObjects("rbxassetid://" .. path)[1]
    end
end

gg.ui = environment.load(4735247703)
gg.modules.login = environment.load("Modules/login")
