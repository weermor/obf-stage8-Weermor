(function()
                if speedEnabled and rootPart and rootPart:FindFirstChild("SpeedHackVelocity") then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        local moveDirection = humanoid.MoveDirection * speedMultiplier
                        bodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
                    end
                end
            end)
        else
            if rootPart:FindFirstChild("SpeedHackVelocity") then
                rootPart:FindFirstChild("SpeedHackVelocity"):Destroy()
            end
        end
    end
})

MovementWindow:Slider({
    Text = "Speed Multiplier",
    Minimum = 10,
    Maximum = 100,
    Default = speedMultiplier,
    Callback = function(value)
        speedMultiplier = value
    end
})

RunService.RenderStepped:Connect(function()
    if spinBotEnabled then
        local player = Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)

MovementWindow:Toggle({
    Text = "Spin Bot",
    Default = false,
    Callback = function(state)
        spinBotEnabled = state
    end
})

MovementWindow:Slider({
    Text = "Spin Speed",
    Minimum = 30,
    Maximum = 360,
    Default = spinSpeed,
    Callback = function(value)
        spinSpeed = value
    end
})

MiscWindow:Toggle({
    Text = "Fake Lag",
    Default = false,
    Flag = "FakeLagToggle",
    Callback = function(state)
        fakeLagEnabled = state
        if not fakeLagEnabled then
            noclipEnabled = false
            local player = Players.LocalPlayer
            local character = player.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Anchored = false
                end
            end
            library:Notification({
                Text = "Fake Lag: " .. (state and "Enabled" or "Disabled"),
                Duration = 3
            })
        end
    end
})


-- Fake lag mode selection
MiscWindow:Dropdown({
    Text = "Fake Lag Mode",
    List = {"Keybind", "Automatic"},
    Default = "Automatic",
    Callback = function(value)
        fakeLagMode = value
        library:Notification({
            Text = "Fake Lag Mode set to: " .. value,
            Duration = 3
        })
        -- Ensure noclip is disabled when switching modes to prevent conflicts
        noclipEnabled = false
        local character = Players.LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = false
            end
        end
    end
})

-- Keybind for fake lag (only active in Keybind mode)
MiscWindow:Keybind({
    Text = "Fake Lag Keybind",
    Default = Enum.KeyCode.X,
    Callback = function()
        if fakeLagMode == "Keybind" then
            fakeLagEnabled = not fakeLagEnabled
            noclipEnabled = fakeLagEnabled
            local player = Players.LocalPlayer
            local character = player.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Anchored = noclipEnabled
                end
            end
            library:Notification({
                Text = "Fake Lag (Keybind): " .. (fakeLagEnabled and "Enabled" or "Disabled"),
                Duration = 3
            })
        end
    end
})

-- Automatic fake lag interval slider
MiscWindow:Slider({
    Text = "Fake Lag Interval",
    Minimum = 1,
    Maximum = 10,
    Default = fakeLagInterval,
    Flag = "FakeLagInterval",
    Callback = function(value)
        fakeLagInterval = value
        library:Notification({
            Text = "Fake Lag Interval set to: " .. value .. " seconds",
            Duration = 3
        })
    end
})

-- Automatic fake lag logic
spawn(function()
    while true do
        if fakeLagMode == "Automatic" and fakeLagEnabled then
            wait(fakeLagInterval)
            noclipEnabled = not noclipEnabled
            local player = Players.LocalPlayer
            local character = player.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Anchored = noclipEnabled
                end
            end
            library:Notification({
                Text = "Fake Lag (Automatic): " .. (noclipEnabled and "Enabled" or "Disabled"),
                Duration = 1
            })
        else
            wait(0.1)
        end
    end
end)

MiscWindow:Slider({
    Text = "Noclip Speed",
    Minimum = 1,
