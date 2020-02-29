--[[
    ProxyPart.lua
    Creates a proxy part to bypass anti-cheats/changed values

    @author NodeSupport
--]]


local ProxyPart = {}
local RunService = game:GetService("RunService")

function ProxyPart:CreateOutline()
    if not self.Part then
        return
    end

    if self.selectionBox then
        self.selectionBox:Destroy()
        self.selectionBox = nil
    end

    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Color3 = Color3.new(255, 255, 255)
    selectionBox.LineTickness = 0.025
    selectionBox.Adornee = self.Part

    self.selectionBox = selectionBox
end

function ProxyPart:SetSize(Vector)
    if not self.Part or not Vector then
        return
    end
    self.Part.Size = Vector
end

function ProxyPart:Link(Part)
    if not self.Part then
        return
    end
    if self.Linking then
        self.Linking:Disconnect()
    end
    self.Part.Transparency, self.Part.CanCollide = 1, false
    self.Linking = RunService.RenderStepped:connect(function()
        if not self.Part or not Part then
            self.Linking:Disconnect()
            return
        end
        self.Part.CFrame = Part.CFrame
    end)
end

function ProxyPart.new()
    return setmetatable({
        Part = Instance.new("Part"),
        Linking = nil,
    }, {
        __index = function(self, index)
            if ProxyPart[index] then
                return function(self, ...)
                    return ProxyPart[index](self, ...)
                end
            end
        end
    })
end

return ProxyPart