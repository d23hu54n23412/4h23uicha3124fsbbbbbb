--[[
    ProxyPart.lua
    Creates a proxy part to bypass anti-cheats/changed values

    @author NodeSupport
--]]


local proxyPart = {}
local RunService = game:GetService("RunService")

function proxyPart:BindTouch(func)
    if not self.Part then
        return
    end
    if #self.TouchedBindings == 0 and not self.TouchedConnection then
        self.TouchedConnection = self.Part.Touched:connect(function(part)
            for _,func in pairs(self.TouchedBindings) do
                func(part)
            end
        end)
    end
    table.insert(self.TouchedBindings, func)
end

function proxyPart:Destroy()
    if self.TouchedConnection then
        self.TouchedConnection:Disconnect()
    end
    if self.Linking then
        self.Linking:Disconnect()
    end
    if self.selectionBox then
        self.selectionBox:Destroy()
    end
    if self.Part then
        self.Part:Destroy()
    end
    self = nil
end

function proxyPart:CreateOutline()
    if not self.Part then
        return
    end

    if self.selectionBox then
        self.selectionBox:Destroy()
        self.selectionBox = nil
    end

    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Color3 = Color3.new(255, 255, 255)
    selectionBox.LineThickness = 0.025
    selectionBox.Adornee = self.Part
    selectionBox.Parent = self.Part

    self.selectionBox = selectionBox
end

function proxyPart:SetSize(Vector)
    if not self.Part or not Vector then
        return
    end
    self.Part.Size = Vector
end

function proxyPart:Link(Part)
    if not self.Part then
        return
    end
    self.Part.Parent = game:GetService("Workspace")
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

function proxyPart.new()
    return setmetatable({
        Part = Instance.new("Part"),
        Linking = nil,,
        TouchedBindings = {}
        TouchedConnection = nil
    }, {
        __index = function(self, index)
            if proxyPart[index] then
                return function(self, ...)
                    return proxyPart[index](self, ...)
                end
            end
        end
    })
end

return proxyPart
