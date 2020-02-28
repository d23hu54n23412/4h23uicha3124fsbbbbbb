--[[
    slider.lua
    Creates a new slider based off the given UI element
    @author NodeSupport
--]]

local slider = {}

function slider:Bind(func)
    table.insert(self.functions, func)
end

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
        self.Ui.SliderBar.Size = UDim2.new(percent, 0, 0.1, 0)
		if #self.functions > 0 then
			local val = 0 + ((self.maximum - 0) * percent)
            for _, func in pairs(self.functions) do
                if self.Ui:FindFirstChild("Count") then
                    self.Ui.Count.Position = self.Ui.Circle.Position + UDim2.new(0, 0, 0.583, 0)
                    if round then
                        local mult = 10 ^ (self.round or 0)
                        val = math.floor(val * mult + 0.5) / mult
                    end
                    self.Ui.Count.Text = tostring(val)
                end
                func(val)
            end
		end
	end)
end

function slider.new(ui, maximum, round)
    if not ui or not maximum then
        return warn("Invalid specified UI/Maximum in slider")
    end
    local circle = ui:FindFirstChild("Circle")
    local newSlider = setmetatable({
        Ui = ui,
        maximum = maximum,
        functions = {}
        round = round,
    }, {
        __index = function(self, index)
            if slider[index] then
                return function(self, ...)
                    slider[index](self, ...)
                end
            end
        end
    })

    circle.InputBegan:connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            newSlider:Track()
        end
    end)

    circle.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if newSlider.TrackConnection then
				newSlider.TrackConnection:disconnect()
				newSlider.TrackConnection = nil
			end
		end
    end)
    
    return newSlider
end

return slider