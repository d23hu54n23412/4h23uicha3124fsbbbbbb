--[[
    login.lua
    Prompts the login UI and confirms that the user is valid
    @author NodeSupport
--]]

local ui = gg.ui
if not ui then
    return warn("Failure whilst loading Battleground Zero UI")
end

local loading = ui:WaitForChild("Loading")
loading.Visible = true

local SETTINGS = {
    BEGINNING_DELAY = 0,
    LOADING_DELAY = 2.5,
}

ui.Parent = game:GetService("CoreGui")
Loading.Size = UDim2.new(0, 0, 0, 0)

wait(SETTINGS.BEGINNING_DELAY)

Loading:TweenSize(UDim2.new(0, 263, 0, 263), "Out", "Back", 2, true)

wait(SETTINGS.LOADING_DELAY)

Loading.Goat:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true)

Loading:TweenSize(UDim2.new(0, 321, 0, 373), "In", "Linear", 0.4, true)

for i = Loading.Circle.SliceScale, 0.4, -.1 do
	wait()
	Loading.Circle.SliceScale = i
end

Loading.Header.Visible = true
Loading.Header.TextTransparency = 1

spawn(function()
	for i = Loading.Header.TextTransparency, 0, -.1 do
		wait()
		Loading.Header.TextTransparency = i
	end
end)

Loading.TokenInputBox.Size = UDim2.new(0, 0, 0.107, 0)
Loading.TokenInputBox.Visible = true

Loading.TokenInputBox:TweenSize(UDim2.new(.821, 0, .107, 0), "In", "Linear", 0.2, true)

wait(.2)

Loading.LockIcon.Size = UDim2.new(0, 0, 0, 0)
Loading.LockIcon.Visible = true

wait()
Loading.LockIcon:TweenSize(UDim2.new(.077, 0, .062, 0), "Out", "Back", 0.2, true)

Loading.Input.Visible = true
Loading.Input.TextTransparency = 1

spawn(function()
	for i = Loading.Input.TextTransparency, 0, -.1 do
		wait()
		Loading.Input.TextTransparency = i
	end
end)
