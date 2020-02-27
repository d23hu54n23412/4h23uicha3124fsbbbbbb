--[[
    login.lua
    Prompts the login UI and confirms that the user is valid
    @author NodeSupport
--]]

local ui = gg.ui
if not ui then
    return warn("Failure whilst loading Battleground Zero UI")
end

gg.load("Modules/Animations/Login/show.lua")

print("Displaying Login")