local accuracy = {
    Activated = false,
    Keybind = Enum.KeyCode.L,
}

local UserInputService = game:GetService("UserInputService")
local InputConnection

local cooldown = tick()
local Gyro
local Current = 0

function accuracy:On()
    InputConnection = UserInputService.InputBegan:connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local kopis = gg.kopis.getKopis()
            if not kopis then
                return
            end

            Current = Current + 1

            local client = gg.client

            local clientCharacter = client.Character
            if not clientCharacter then
                return
            end

            local clientRoot = clientCharacter:FindFirstChild("HumanoidRootPar")
            if not clientRoot then
                return
            end

            if not Gyro then
                Gyro = Instance.new("BodyGyro")
                Gyro.Parent = clientRoot
                Gyro.D = 0
                Gyro.P = 60000
            end

            local target, dis = nil, math.huge
            for _,player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local distance = (humanoidRootPart.Position - clientRoot.Position).Magnitude
                    if distance < dis then
                        target, dis = player, distance
                    end
                end
            end

            if not target then
                return
            end

            local targetCFrame = target.Character:FindFirstChild("HumanoidRootPart").CFrame
            local inverse = targetCFrame:Inverse()

            Gyro.MaxTorque = Vector3.new(0, math.huge, 0)
            Gyro.CFrame = CFrame.Angles(0, math.rad(180), 0) * inverse
            
            spawn(function()
                local savedCurrent = Current
                wait(.3)
                if Current == savedCurrent then
                    Gyro.MaxTorque = Vector3.new(0, 0, 0)
                end
            end)
        end
    end)
end

function accuracy:Off()
    if InputConnection then
        InputConnection:Disconnect()
        InputConnection = nil
    end
    if Gyro then
        Gyro:Destroy()
    end
end

-- Creating a keybind handler

local newKeybind = gg.keybinds.newButton(gg.ui.Menu.Settings.accuracy.Keybind, "Team Kill")

newKeybind:Bind(function(key)
    accuracy.Keybind = key
end)

-- Binding an input connection

local label

UserInputService.InputBegan:connect(function(input)
    local TextBoxFocused = UserInputService:GetFocusedTextBox()
    if TextBoxFocused then return end
    local KeyCode = input.KeyCode
    if KeyCode == accuracy.Keybind then
        if accuracy.Activated == false then
            accuracy:On()

            if label then
                label:Destroy()
                label = nil
            end

            label = gg.ui.Templates.TextLabel:Clone()
            label.Text = "Accuracy"
            label.Parent = gg.ui.Overlay:WaitForChild("Active")
            label.Visible = true
        else
            accuracy:Off()

            if label then
                label:Destroy()
                label = nil
            end
        end
        accuracy.Activated = not accuracy.Activated
    end
end)

return accuracy