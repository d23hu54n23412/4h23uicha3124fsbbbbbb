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
        local char = gg.client.Character
        if not char then
            return
        end
        local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
        local distance = (part1.Position - humanoidRootPart.Position).Magnitude
        print((part1.Position - humanoidRootPart.Position).Magnitude)
        print(distance)
        if distance < 75 then
            local _, proxyOnScreen = camera:WorldToScreenPoint(part1.Position)
            local _, playerOnScreen = camera:WorldToScreenPoint(part2.Position)
            if onScreen or playerOnScreen then
                part1.CFrame = part2.CFrame
            end
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

function proxyPart:Link(Part)
    if not self.Part then
        return
    end
    self.Part.Parent = game:GetService("Workspace")

    self.Part.Transparency, self.Part.CanCollide = 1, false

    links[self.Part] = Part
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
