--[[
    login.lua
    Prompts the login UI and confirms that the user is valid
    @author NodeSupport
--]]

local ui = gg.ui
if not ui then
    return warn("Failure whilst loading Battleground Zero UI")
end

gg.load("Modules/Animations/Login/show")

local loading = gg.ui:WaitForChild("Loading")

loading.Input.FocusLost:connect(function()
    local response = loading.Input.Text
    if response == "test" then
        gg.keybinds = gg.load("Modules/keybinds")
        gg.client = game:GetService("Players").LocalPlayer
        gg.load("Modules/menu")
        gg.load("Modules/Animations/Login/hide")
    end
end)