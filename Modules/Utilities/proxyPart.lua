--[[
    ProxyPart.lua
    Creates a proxy part to bypass anti-cheats/changed values

    @author NodeSupport
--]]


local proxyPart = {}
local RunService = game:GetService("RunService")
local links = {}
local camera = workspace.CurrentCamera

RunService.RenderStepped:Connect(function()
    for part1, part2 in pairs(links) do
        if not part1 or not part2 then
            return
        end
        local _, proxyOnScreen = camera:WorldToScreenPoint(part1.Position)
        local _, playerOnScreen = camera:WorldToScreenPoint(part2.Position)
        if onScreen or playerOnScreen then
            part1.CFrame = part2.CFrame
        end
    end
end)

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
    if links[self.Part] then
        links[self.Part] = nil
    end
    if self.TouchedConnection then
        self.TouchedConnection:Disconnect()
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

function proxyPart:Link(Part, Weld)
    if not self.Part then
        return
    end

    self.Part.Parent = game:GetService("Workspace")
    self.Part.Transparency, self.Part.CanCollide = 1, false

    if Weld then
        self.Part.CFrame = Part.CFrame
        local Weld = Instance.new("Weld")
        Weld.C0 = Part.CFrame:Inverse() * self.Part.CFrame
        Weld.Part0 = Part
        Weld.Part1 = self.Part
        Weld.Parent = self.Part
    else
        self.Part.Anchored = true
        links[self.Part] = Part
    end
end

function proxyPart.new()
    return setmetatable({
        Part = Instance.new("Part"),
        TouchedBindings = {},
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
