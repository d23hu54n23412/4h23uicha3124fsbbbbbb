--[[
    slider.lua
    Creates a new slider based off the given UI element
    @author NodeSupport
--]]

print("loading slider")

local slider = {}

function slider:Track()
    if not self.Ui then
        return
    end
    local Mouse = gg.client:GetMouse()
    self.TrackConnection = Mouse.Move:connect(function()
		local x,y = Mouse.X, Mouse.Y
		local Circle = self.Ui.Circle
		local bar_size = self.Ui.Total.AbsoluteSize
		local bar_start, bar_end = self.Ui.Total.AbsolutePosition,  self.Ui.Total.AbsolutePosition + bar_size
		local distance = bar_end.X - bar_start.X
		local difference_mouse = x - bar_start.X
		local percent = difference_mouse / (bar_size.X)
		percent = math.clamp(percent, 0, 1)
		Circle.Position = UDim2.new(percent,0,.5,0)
		self.Ui.SliderBar.Size = UDim2.new(percent, 0, 1, 0)
		--if self.Function then
			local val = 0 + ((self.Max - 0) * percent)
            --self.Function(val)
            print(val)
		--end
	end)
end

function slider.new(ui, maximum)
    if not ui or not maximum then
        return warn("Invalid specified UI/Maximum in slider")
    end
    local circle = ui:FindFirstChild("Circle")
    local newSlider = setmetatable({
        Ui = ui, 
    }, {
        __index = function(self, index)
            if slider[index] then
                return function(self, ...)
                    slider[index](self, ...)
                end
            end
        end
    })

    Circle.InputBegan:connect(function(input), 
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            newSlider:Track()
        end
    end)

    Circle.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if newSlider.TrackConnection then
				newSlider.TrackConnection:disconnect()
				newSlider.TrackConnection = nil
			end
		end
	end)
end

return slider