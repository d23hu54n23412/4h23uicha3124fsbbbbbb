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

function loadModules()
    gg.keybinds = gg.load("Modules/keybinds")
    gg.client = game:GetService("Players").LocalPlayer
    gg.slider = gg.load("Modules/slider")
    gg.proxyPart = gg.load("Modules/Utilities/proxyPart")
    gg.load("Modules/menu")
end

loading.Input.FocusLost:connect(function()
    local response = loading.Input.Text
    if response == "VVS2" then
        loadModules()
        gg.load("Modules/Animations/Login/hide")
    end
end)
