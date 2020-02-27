--[[
    Login/hide.lua
    Handles the login hiding feature of the UI.
    @author NodeSupport
]]

local Ui = gg.ui
local loading = Ui:WaitForChild("Loading")
local RunService = game:GetService("RunService")

wait()
loading.LockIcon:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.2, true)
spawn(function()
    for i = loading.Input.TextTransparency, 1 + .1, .1 do
        wait()
        loading.Input.TextTransparency = i
    end
    loading.TokenInputBox:TweenSize(UDim2.new(0, 0, .107, 0), "In", "Linear", 0.2, true)
end)
for i = loading.Header.TextTransparency, 1 + 0.05, .05 do
    RunService.RenderStepped:Wait()
    loading.Header.TextTransparency = i
end

loading:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.6, true)
wait(.6)

Ui.Overlay.Visible = true
Ui.Overlay.Goat.Size = UDim2.new(0, 0, 0, 0)
Ui.Overlay.Goat:TweenSize(UDim2.new(0.211, 0, 0.211, 0), "Out", "Back", 0.3, true)
