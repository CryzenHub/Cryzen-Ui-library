-- Ultra Lord UI Library v3.2
local UltraLordLibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Themes
local Themes = {
    Default = {
        BackgroundColor = Color3.fromRGB(30, 30, 35),
        SidebarColor = Color3.fromRGB(25, 25, 30),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(200, 200, 200),
        UIStrokeColor = Color3.fromRGB(60, 60, 70),
        AccentColor = Color3.fromRGB(114, 137, 218),
        ButtonColor = Color3.fromRGB(50, 50, 60),
        ButtonHoverColor = Color3.fromRGB(60, 60, 70),
        ToggleOnColor = Color3.fromRGB(114, 137, 218),
        ToggleOffColor = Color3.fromRGB(80, 80, 90),
        SliderColor = Color3.fromRGB(114, 137, 218),
        SliderBackgroundColor = Color3.fromRGB(50, 50, 60),
        DropdownColor = Color3.fromRGB(40, 40, 50),
        TextboxColor = Color3.fromRGB(45, 45, 55),
        KeySystemColor = Color3.fromRGB(35, 35, 40),
        KeySystemAccentColor = Color3.fromRGB(114, 137, 218),
        NotificationColor = Color3.fromRGB(30, 30, 35),
        MenuToggleIconColor = Color3.fromRGB(255, 255, 255)
    },
    Dark = {
        BackgroundColor = Color3.fromRGB(20, 20, 25),
        SidebarColor = Color3.fromRGB(15, 15, 20),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(180, 180, 180),
        UIStrokeColor = Color3.fromRGB(50, 50, 60),
        AccentColor = Color3.fromRGB(90, 120, 200),
        ButtonColor = Color3.fromRGB(40, 40, 50),
        ButtonHoverColor = Color3.fromRGB(50, 50, 60),
        ToggleOnColor = Color3.fromRGB(90, 120, 200),
        ToggleOffColor = Color3.fromRGB(70, 70, 80),
        SliderColor = Color3.fromRGB(90, 120, 200),
        SliderBackgroundColor = Color3.fromRGB(40, 40, 50),
        DropdownColor = Color3.fromRGB(30, 30, 40),
        TextboxColor = Color3.fromRGB(35, 35, 45),
        KeySystemColor = Color3.fromRGB(25, 25, 30),
        KeySystemAccentColor = Color3.fromRGB(90, 120, 200),
        NotificationColor = Color3.fromRGB(20, 20, 25),
        MenuToggleIconColor = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        BackgroundColor = Color3.fromRGB(240, 240, 245),
        SidebarColor = Color3.fromRGB(230, 230, 235),
        PrimaryTextColor = Color3.fromRGB(40, 40, 45),
        SecondaryTextColor = Color3.fromRGB(80, 80, 85),
        UIStrokeColor = Color3.fromRGB(200, 200, 210),
        AccentColor = Color3.fromRGB(90, 120, 200),
        ButtonColor = Color3.fromRGB(220, 220, 230),
        ButtonHoverColor = Color3.fromRGB(210, 210, 220),
        ToggleOnColor = Color3.fromRGB(90, 120, 200),
        ToggleOffColor = Color3.fromRGB(180, 180, 190),
        SliderColor = Color3.fromRGB(90, 120, 200),
        SliderBackgroundColor = Color3.fromRGB(220, 220, 230),
        DropdownColor = Color3.fromRGB(230, 230, 240),
        TextboxColor = Color3.fromRGB(225, 225, 235),
        KeySystemColor = Color3.fromRGB(235, 235, 240),
        KeySystemAccentColor = Color3.fromRGB(90, 120, 200),
        NotificationColor = Color3.fromRGB(240, 240, 245),
        MenuToggleIconColor = Color3.fromRGB(40, 40, 45)
    },
    Rainbow = {
        BackgroundColor = Color3.fromRGB(30, 30, 35),
        SidebarColor = Color3.fromRGB(25, 25, 30),
        PrimaryTextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(200, 200, 200),
        UIStrokeColor = Color3.fromRGB(60, 60, 70),
        AccentColor = Color3.fromRGB(114, 137, 218), -- This will be rainbow
        ButtonColor = Color3.fromRGB(50, 50, 60),
        ButtonHoverColor = Color3.fromRGB(60, 60, 70),
        ToggleOnColor = Color3.fromRGB(114, 137, 218), -- This will be rainbow
        ToggleOffColor = Color3.fromRGB(80, 80, 90),
        SliderColor = Color3.fromRGB(114, 137, 218), -- This will be rainbow
        SliderBackgroundColor = Color3.fromRGB(50, 50, 60),
        DropdownColor = Color3.fromRGB(40, 40, 50),
        TextboxColor = Color3.fromRGB(45, 45, 55),
        KeySystemColor = Color3.fromRGB(35, 35, 40),
        KeySystemAccentColor = Color3.fromRGB(114, 137, 218), -- This will be rainbow
        NotificationColor = Color3.fromRGB(30, 30, 35),
        MenuToggleIconColor = Color3.fromRGB(255, 255, 255),
        IsRainbowTheme = true
    }
}

-- Current theme
local CurrentTheme = Themes.Default
local RainbowConnection = nil

-- Rainbow color function
local function getRainbowColor(offset)
    offset = offset or 0
    local time = tick() * 0.5 + offset
    return Color3.fromHSV(time % 1, 0.8, 1)
end

-- Function to apply rainbow effects
local function setupRainbowTheme(elements)
    if RainbowConnection then
        RainbowConnection:Disconnect()
        RainbowConnection = nil
    end
    
    if CurrentTheme.IsRainbowTheme then
        RainbowConnection = RunService.Heartbeat:Connect(function()
            if elements and #elements > 0 then
                local rainbowColor = getRainbowColor()
                for _, element in ipairs(elements) do
                    if element.Type == "Accent" and element.Instance then
                        element.Instance.BackgroundColor3 = rainbowColor
                    elseif element.Type == "Text" and element.Instance then
                        element.Instance.TextColor3 = rainbowColor
                    elseif element.Type == "Stroke" and element.Instance then
                        element.Instance.Color = rainbowColor
                    end
                end
            end
        end)
    end
end

-- Utility functions
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 5)
    corner.Parent = parent
    return corner
end

local function createUIStroke(parent, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or CurrentTheme.UIStrokeColor
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    return tween
end

-- Improved draggable function that works on all devices
local function makeDraggable(dragUI, dragFrame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragUI.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            mousePos = input.Position
            framePos = dragFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragUI.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            dragFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create notification function (Enhanced with icon support)
function UltraLordLibrary:CreateNotification(notifConfig)
    local notifConfig = notifConfig or {}
    local title = notifConfig.Title or "Notification"
    local description = notifConfig.Description or ""
    local duration = notifConfig.Duration or 5
    local icon = notifConfig.Icon
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UltraLordNotification"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.Size = UDim2.new(0, 280, 0, 80)
    NotificationFrame.Position = UDim2.new(1, 10, 0.8, 0)
    NotificationFrame.BackgroundColor3 = CurrentTheme.NotificationColor
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = ScreenGui
    createUICorner(NotificationFrame, 8)
    createUIStroke(NotificationFrame, 1)
    
    -- Icon (if provided)
    local iconSize = 0
    if icon then
        local IconImage = Instance.new("ImageLabel")
        IconImage.Name = "NotificationIcon"
        IconImage.Size = UDim2.new(0, 20, 0, 20)
        IconImage.Position = UDim2.new(0, 10, 0, 7)
        IconImage.BackgroundTransparency = 1
        IconImage.Image = icon
        IconImage.Parent = NotificationFrame
        iconSize = 30 -- Width of icon + padding
    end
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -(20 + iconSize), 0, 25)
    TitleLabel.Position = UDim2.new(0, 10 + iconSize, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = CurrentTheme.PrimaryTextColor
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Text = title
    TitleLabel.Parent = NotificationFrame
    
    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Name = "Description"
    DescriptionLabel.Size = UDim2.new(1, -20, 0, 40)
    DescriptionLabel.Position = UDim2.new(0, 10, 0, 30)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.TextColor3 = CurrentTheme.SecondaryTextColor
    DescriptionLabel.TextSize = 14
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.Text = description
    DescriptionLabel.Parent = NotificationFrame
    
    -- Animation
    NotificationFrame.Position = UDim2.new(1, 300, 0.8, 0)
    local showTween = createTween(NotificationFrame, {Position = UDim2.new(1, -290, 0.8, 0)}, 0.5, Enum.EasingStyle.Back)
    showTween:Play()
    
    task.delay(duration, function()
        local hideTween = createTween(NotificationFrame, {Position = UDim2.new(1, 300, 0.8, 0)}, 0.5)
        hideTween:Play()
        hideTween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
end

-- Key system function
function UltraLordLibrary:CreateKeySystem(keySystemConfig)
    local keySystemConfig = keySystemConfig or {}
    local title = keySystemConfig.Title or "Key System"
    local subtitle = keySystemConfig.Subtitle or "Enter your key to access the script"
    local keyList = keySystemConfig.KeyList or {}
    local customKeyFunction = keySystemConfig.CustomKeyFunction
    local saveKey = keySystemConfig.SaveKey or false
    local onCorrectCallback = keySystemConfig.OnCorrect or function() end
    local onIncorrectCallback = keySystemConfig.OnIncorrect or function() end
    
    -- Check for saved key
    local savedKey = ""
    if saveKey then
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("UltraLordKey.json"))
        end)
        
        if success and result.Key then
            savedKey = result.Key
            
            -- Validate saved key
            if customKeyFunction then
                if customKeyFunction(savedKey) then
                    onCorrectCallback()
                    return true
                end
            elseif table.find(keyList, savedKey) then
                onCorrectCallback()
                return true
            end
        end
    end
    
    -- Create key system UI
    local KeySystemGui = Instance.new("ScreenGui")
    KeySystemGui.Name = "UltraLordKeySystem"
    KeySystemGui.Parent = CoreGui
    KeySystemGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local BackgroundFrame = Instance.new("Frame")
    BackgroundFrame.Name = "Background"
    BackgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    BackgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundFrame.BackgroundTransparency = 0.5
    BackgroundFrame.Parent = KeySystemGui
    
    local KeySystemFrame = Instance.new("Frame")
    KeySystemFrame.Name = "KeySystem"
    KeySystemFrame.Size = UDim2.new(0, 350, 0, 200)
    KeySystemFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    KeySystemFrame.BackgroundColor3 = CurrentTheme.KeySystemColor
    KeySystemFrame.Parent = KeySystemGui
    createUICorner(KeySystemFrame, 8)
    createUIStroke(KeySystemFrame, 1, CurrentTheme.UIStrokeColor)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -20, 0, 30)
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = CurrentTheme.PrimaryTextColor
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.Text = title
    TitleLabel.Parent = KeySystemFrame
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Size = UDim2.new(1, -20, 0, 20)
    SubtitleLabel.Position = UDim2.new(0, 10, 0, 40)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.TextColor3 = CurrentTheme.SecondaryTextColor
    SubtitleLabel.TextSize = 14
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    SubtitleLabel.Text = subtitle
    SubtitleLabel.Parent = KeySystemFrame
    
    local KeyBoxContainer = Instance.new("Frame")
    KeyBoxContainer.Name = "KeyBoxContainer"
    KeyBoxContainer.Size = UDim2.new(1, -40, 0, 35)
    KeyBoxContainer.Position = UDim2.new(0, 20, 0, 80)
    KeyBoxContainer.BackgroundColor3 = CurrentTheme.TextboxColor
    KeyBoxContainer.Parent = KeySystemFrame
    createUICorner(KeyBoxContainer, 6)
    createUIStroke(KeyBoxContainer, 1, CurrentTheme.UIStrokeColor)
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Name = "KeyBox"
    KeyBox.Size = UDim2.new(1, -16, 1, 0)
    KeyBox.Position = UDim2.new(0, 8, 0, 0)
    KeyBox.BackgroundTransparency = 1
    KeyBox.TextColor3 = CurrentTheme.PrimaryTextColor
    KeyBox.PlaceholderColor3 = CurrentTheme.SecondaryTextColor
    KeyBox.TextSize = 14
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyBox.PlaceholderText = "Enter key here..."
    KeyBox.Text = savedKey
    KeyBox.ClearTextOnFocus = savedKey == ""
    KeyBox.Parent = KeyBoxContainer
    
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Size = UDim2.new(0, 150, 0, 35)
    SubmitButton.Position = UDim2.new(0.5, -75, 0, 135)
    SubmitButton.BackgroundColor3 = CurrentTheme.KeySystemAccentColor
    SubmitButton.TextColor3 = CurrentTheme.PrimaryTextColor
    SubmitButton.TextSize = 14
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Text = "Submit"
    SubmitButton.Parent = KeySystemFrame
    createUICorner(SubmitButton, 6)
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Size = UDim2.new(1, -40, 0, 20)
    StatusLabel.Position = UDim2.new(0, 20, 0, 175)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = CurrentTheme.SecondaryTextColor
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Text = ""
    StatusLabel.Parent = KeySystemFrame
    
    -- Rainbow effects for accent elements if theme is Rainbow
    if CurrentTheme.IsRainbowTheme then
        local rainbowElements = {
            {Type = "Accent", Instance = SubmitButton}
        }
        setupRainbowTheme(rainbowElements)
    end
    
    -- Button hover effect
    SubmitButton.MouseEnter:Connect(function()
        if not CurrentTheme.IsRainbowTheme then
            createTween(SubmitButton, {BackgroundColor3 = CurrentTheme.ButtonHoverColor}):Play()
        end
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        if not CurrentTheme.IsRainbowTheme then
            createTween(SubmitButton, {BackgroundColor3 = CurrentTheme.KeySystemAccentColor}):Play()
        end
    end)
    
    -- Validate key function
    local function validateKey()
        local inputKey = KeyBox.Text
        local isCorrect = false
        
        -- Check key
        if customKeyFunction then
            isCorrect = customKeyFunction(inputKey)
        else
            isCorrect = table.find(keyList, inputKey) ~= nil
        end
        
        if isCorrect then
            -- Save key if needed
            if saveKey then
                pcall(function()
                    writefile("UltraLordKey.json", game:GetService("HttpService"):JSONEncode({Key = inputKey}))
                end)
            end
            
            -- Successful animation
            StatusLabel.Text = "Key Verified! Loading..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            createTween(SubmitButton, {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
            task.wait(1)
            
            -- Close key system
            local closeTween = createTween(KeySystemFrame, {Position = UDim2.new(0.5, -175, 1.5, -100)}, 0.5)
            closeTween:Play()
            
            closeTween.Completed:Connect(function()
                KeySystemGui:Destroy()
                onCorrectCallback()
            end)
            
            return true
        else
            -- Failed animation
            StatusLabel.Text = "Invalid Key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            
            createTween(SubmitButton, {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}, 0.2):Play()
            task.wait(0.2)
            createTween(SubmitButton, {BackgroundColor3 = CurrentTheme.KeySystemAccentColor}, 0.2):Play()
            
            -- Shake effect
            local originalPos = KeySystemFrame.Position
            local shake = 10
            for i = 1, 5 do
                KeySystemFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + (i % 2 == 0 and shake or -shake), originalPos.Y.Scale, originalPos.Y.Offset)
                task.wait(0.03)
            end
            KeySystemFrame.Position = originalPos
            
            onIncorrectCallback(inputKey)
            return false
        end
    end
    
    -- Submit button click
    SubmitButton.MouseButton1Click:Connect(validateKey)
    
    -- Submit on Enter key
    KeyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
    
    -- Return control functions
    return {
        Destroy = function()
            KeySystemGui:Destroy()
        end
    }
end

-- Make window function (Enhanced with icon support)
function UltraLordLibrary:MakeWindow(config)
    local config = config or {}
    local windowName = config.Name or "Ultra Lord UI"
    local windowSize = config.Size or UDim2.new(0, 600, 0, 400)
    local theme = config.Theme or "Default"
    local icon = config.Icon
    local keySystem = config.KeySystem or false
    local keySettings = config.KeySettings or {}
    
    -- Set theme
    if Themes[theme] then
        CurrentTheme = Themes[theme]
    end
    
    -- Handle key system first if enabled
    if keySystem then
        local keySystemResult = UltraLordLibrary:CreateKeySystem(keySettings)
        if not keySystemResult then
            return false
        end
    end
    
    -- Create main GUI
    local UltraLordGUI = Instance.new("ScreenGui")
    UltraLordGUI.Name = "UltraLordGUI"
    UltraLordGUI.Parent = CoreGui
    UltraLordGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UltraLordGUI.ResetOnSpawn = false
    
    -- Create main window frame
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = windowSize
    MainWindow.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    MainWindow.BackgroundColor3 = CurrentTheme.BackgroundColor
    MainWindow.BorderSizePixel = 0
    MainWindow.Parent = UltraLordGUI
    createUICorner(MainWindow, 8)
    createUIStroke(MainWindow, 1)
    
    -- Create title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = CurrentTheme.SidebarColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainWindow
    createUICorner(TitleBar, 8)
    
    -- Fix title bar corners
    local FixTitleBarCorners = Instance.new("Frame")
    FixTitleBarCorners.Name = "FixTitleBarCorners"
    FixTitleBarCorners.Size = UDim2.new(1, 0, 0, 10)
    FixTitleBarCorners.Position = UDim2.new(0, 0, 1, -10)
    FixTitleBarCorners.BackgroundColor3 = CurrentTheme.SidebarColor
    FixTitleBarCorners.BorderSizePixel = 0
    FixTitleBarCorners.Parent = TitleBar
    
    -- Icon (if provided)
    local iconSize = 0
    if icon then
        local WindowIcon = Instance.new("ImageLabel")
        WindowIcon.Name = "WindowIcon"
        WindowIcon.Size = UDim2.new(0, 20, 0, 20)
        WindowIcon.Position = UDim2.new(0, 10, 0, 5)
        WindowIcon.BackgroundTransparency = 1
        WindowIcon.Image = icon
        WindowIcon.Parent = TitleBar
        iconSize = 30 -- Width of icon + padding
    end
    
    -- Title text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -80 - iconSize, 1, 0)
    TitleText.Position = UDim2.new(0, 10 + iconSize, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.TextColor3 = CurrentTheme.PrimaryTextColor
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Text = windowName
    TitleText.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -27, 0, 3)
    CloseButton.BackgroundTransparency = 1
    CloseButton.TextColor3 = CurrentTheme.PrimaryTextColor
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.Parent = TitleBar
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 120, 1, -30)
    Sidebar.Position = UDim2.new(0, 0, 0, 30)
    Sidebar.BackgroundColor3 = CurrentTheme.SidebarColor
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainWindow
    
    -- Fix sidebar corners
    local FixSidebarCorners = Instance.new("Frame")
    FixSidebarCorners.Name = "FixSidebarCorners"
    FixSidebarCorners.Size = UDim2.new(0, 10, 1, 0)
    FixSidebarCorners.Position = UDim2.new(1, -10, 0, 0)
    FixSidebarCorners.BackgroundColor3 = CurrentTheme.SidebarColor
    FixSidebarCorners.BorderSizePixel = 0
    FixSidebarCorners.Parent = Sidebar
    
    -- Tab container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -10, 1, -10)
    TabContainer.Position = UDim2.new(0, 5, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = CurrentTheme.AccentColor
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.Parent = Sidebar
    
    -- Tab content container
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -130, 1, -40)
    TabContent.Position = UDim2.new(0, 125, 0, 35)
    TabContent.BackgroundTransparency = 1
    TabContent.Parent = MainWindow
    
    -- Rainbow elements collection
    local rainbowElements = {}
    
    -- Make window draggable (improved for all devices)
    makeDraggable(TitleBar, MainWindow)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        UltraLordGUI:Destroy()
        if RainbowConnection then
            RainbowConnection:Disconnect()
        end
    end)
    
    -- Window methods and properties
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.GUI = UltraLordGUI
    
    -- Function to create tabs
    function Window:CreateTab(tabConfig)
        local tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon
        
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Button"
        TabButton.Size = UDim2.new(1, -10, 0, 32)
        TabButton.Position = UDim2.new(0, 5, 0, #self.Tabs * 37 + 5)
        TabButton.BackgroundColor3 = CurrentTheme.ButtonColor
        TabButton.TextColor3 = CurrentTheme.PrimaryTextColor
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.Parent = TabContainer
        createUICorner(TabButton, 6)
        createUIStroke(TabButton, 1, CurrentTheme.UIStrokeColor)
        
        -- Tab icon (if provided)
        if tabIcon then
            local Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(0, 5, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.Image = tabIcon
            Icon.Parent = TabButton
            
            -- Adjust text position for icon
            TabButton.TextXAlignment = Enum.TextXAlignment.Center
        end
        
        -- Tab content frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName .. "Frame"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = CurrentTheme.AccentColor
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.Visible = false
        TabFrame.Parent = TabContent
        
        -- Elements container
        local ElementsContainer = Instance.new("Frame")
        ElementsContainer.Name = "ElementsContainer"
        ElementsContainer.Size = UDim2.new(1, -10, 0, 0)
        ElementsContainer.Position = UDim2.new(0, 5, 0, 5)
        ElementsContainer.BackgroundTransparency = 1
        ElementsContainer.AutomaticSize = Enum.AutomaticSize.Y
        ElementsContainer.Parent = TabFrame
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)
        UIListLayout.Parent = ElementsContainer
        
        -- Tab button click handler
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tab frames
            for _, tab in pairs(self.Tabs) do
                tab.Frame.Visible = false
                if not CurrentTheme.IsRainbowTheme then
                    createTween(tab.Button, {BackgroundColor3 = CurrentTheme.ButtonColor}):Play()
                end
            end
            
            -- Show selected tab
            TabFrame.Visible = true
            if not CurrentTheme.IsRainbowTheme then
                createTween(TabButton, {BackgroundColor3 = CurrentTheme.AccentColor}):Play()
            end
            self.CurrentTab = tabName
        end)
        
        -- Tab button hover effects
        TabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= tabName and not CurrentTheme.IsRainbowTheme then
                createTween(TabButton, {BackgroundColor3 = CurrentTheme.ButtonHoverColor}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= tabName and not CurrentTheme.IsRainbowTheme then
                createTween(TabButton, {BackgroundColor3 = CurrentTheme.ButtonColor}):Play()
            end
        end)
        
        -- Add to rainbow elements if theme is Rainbow
        if CurrentTheme.IsRainbowTheme then
            table.insert(rainbowElements, {Type = "Accent", Instance = TabButton})
        end
        
        -- Tab object and methods
        local Tab = {}
        Tab.Name = tabName
        Tab.Button = TabButton
        Tab.Frame = TabFrame
        Tab.Container = ElementsContainer
        Tab.ElementCount = 0
        
        -- Function to create a section
        function Tab:CreateSection(sectionName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = sectionName .. "Section"
            SectionLabel.Size = UDim2.new(1, 0, 0, 30)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.TextColor3 = CurrentTheme.AccentColor
            SectionLabel.TextSize = 16
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Text = sectionName
            SectionLabel.LayoutOrder = self.ElementCount
            SectionLabel.Parent = self.Container
            
            -- Add to rainbow elements if theme is Rainbow
            if CurrentTheme.IsRainbowTheme then
                table.insert(rainbowElements, {Type = "Text", Instance = SectionLabel})
            end
            
            self.ElementCount = self.ElementCount + 1
            return SectionLabel
        end
        
        -- Function to create a button
        function Tab:CreateButton(buttonConfig)
            local buttonConfig = buttonConfig or {}
            local buttonText = buttonConfig.Text or "Button"
            local buttonCallback = buttonConfig.Callback or function() end
            local buttonIcon = buttonConfig.Icon
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = buttonText .. "ButtonFrame"
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            ButtonFrame.BackgroundTransparency = 1
            ButtonFrame.LayoutOrder = self.ElementCount
            ButtonFrame.Parent = self.Container
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundColor3 = CurrentTheme.ButtonColor
            Button.TextColor3 = CurrentTheme.PrimaryTextColor
            Button.TextSize = 14
            Button.Font = Enum.Font.Gotham
            Button.Text = buttonText
            Button.Parent = ButtonFrame
            createUICorner(Button, 6)
            createUIStroke(Button, 1, CurrentTheme.UIStrokeColor)
            
            -- Button icon (if provided)
            if buttonIcon then
                local Icon = Instance.new("ImageLabel")
                Icon.Name = "Icon"
                Icon.Size = UDim2.new(0, 20, 0, 20)
                Icon.Position = UDim2.new(0, 8, 0.5, -10)
                Icon.BackgroundTransparency = 1
                Icon.Image = buttonIcon
                Icon.Parent = Button
                
                -- Adjust text position for icon
                Button.TextXAlignment = Enum.TextXAlignment.Center
            end
            
            -- Button click animation and callback
            Button.MouseButton1Click:Connect(function()
                -- Animation
                if not CurrentTheme.IsRainbowTheme then
                    createTween(Button, {BackgroundColor3 = CurrentTheme.AccentColor}, 0.1):Play()
                    task.wait(0.1)
                    createTween(Button, {BackgroundColor3 = CurrentTheme.ButtonColor}, 0.1):Play()
                else
                    -- For rainbow theme, use white flash
                    local originalText = Button.TextColor3
                    createTween(Button, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1):Play()
                    task.wait(0.1)
                    createTween(Button, {TextColor3 = originalText}, 0.1):Play()
                end
                
                -- Callback
                buttonCallback()
            end)
            
            -- Button hover effects
            Button.MouseEnter:Connect(function()
                if not CurrentTheme.IsRainbowTheme then
                    createTween(Button, {BackgroundColor3 = CurrentTheme.ButtonHoverColor}):Play()
                end
            end)
            
            Button.MouseLeave:Connect(function()
                if not CurrentTheme.IsRainbowTheme then
                    createTween(Button, {BackgroundColor3 = CurrentTheme.ButtonColor}):Play()
                end
            end)
            
            -- Add to rainbow elements if theme is Rainbow
            if CurrentTheme.IsRainbowTheme then
                table.insert(rainbowElements, {Type = "Accent", Instance = Button})
            end
            
            self.ElementCount = self.ElementCount + 1
            return Button
        end
        
        -- Function to create a toggle (improved to not require click-hold)
        function Tab:CreateToggle(toggleConfig)
            local toggleConfig = toggleConfig or {}
            local toggleText = toggleConfig.Text or "Toggle"
            local defaultValue = toggleConfig.Default or false
            local toggleCallback = toggleConfig.Callback or function() end
            local toggleEnabled = toggleConfig.Enabled ~= nil and toggleConfig.Enabled or true
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = toggleText .. "ToggleFrame"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.LayoutOrder = self.ElementCount
            ToggleFrame.Parent = self.Container
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Size = UDim2.new(1, -55, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.TextColor3 = CurrentTheme.PrimaryTextColor
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Text = toggleText
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleButton.BackgroundColor3 = defaultValue and CurrentTheme.ToggleOnColor or CurrentTheme.ToggleOffColor
            ToggleButton.Parent = ToggleFrame
            createUICorner(ToggleButton, 10)
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = UDim2.new(defaultValue and 0.6 or 0.1, 0, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Parent = ToggleButton
            createUICorner(ToggleCircle, 10)
            
            -- Toggle state
            local toggled = defaultValue
            
            -- Function to update toggle visuals
            local function updateToggle()
                local targetPosition = toggled and UDim2.new(0.6, 0, 0.5, -8) or UDim2.new(0.1, 0, 0.5, -8)
                local targetColor
                
                if not CurrentTheme.IsRainbowTheme then
                    targetColor = toggled and CurrentTheme.ToggleOnColor or CurrentTheme.ToggleOffColor
                    createTween(ToggleButton, {BackgroundColor3 = targetColor}):Play()
                end
                
                createTween(ToggleCircle, {Position = targetPosition}):Play()
            end
            
            -- Toggle click handler (improved to work with single click)
            local function toggleClicked()
                if not toggleEnabled then return end
                
                toggled = not toggled
                updateToggle()
                toggleCallback(toggled)
            end
            
            -- Make the entire frame clickable
            local ToggleClickArea = Instance.new("TextButton")
            ToggleClickArea.Name = "ToggleClickArea"
            ToggleClickArea.Size = UDim2.new(1, 0, 1, 0)
            ToggleClickArea.BackgroundTransparency = 1
            ToggleClickArea.Text = ""
            ToggleClickArea.ZIndex = 0
            ToggleClickArea.Parent = ToggleFrame
            
            ToggleClickArea.MouseButton1Click:Connect(toggleClicked)
            
            -- Add to rainbow elements if theme is Rainbow
            if CurrentTheme.IsRainbowTheme then
                table.insert(rainbowElements, {Type = "Accent", Instance = ToggleButton})
            end
            
            -- Toggle object and methods
            local Toggle = {}
            Toggle.Value = toggled
            
            function Toggle:SetValue(value)
                toggled = value
                updateToggle()
                toggleCallback(toggled)
            end
            
            function Toggle:GetValue()
                return toggled
            end
            
            function Toggle:SetEnabled(enabled)
                toggleEnabled = enabled
                ToggleLabel.TextTransparency = enabled and 0 or 0.5
                ToggleButton.BackgroundTransparency = enabled and 0 or 0.5
                ToggleCircle.BackgroundTransparency = enabled and 0 or 0.5
            end
            
            self.ElementCount = self.ElementCount + 1
            return Toggle
        end
        
        -- Function to create a slider (improved for all devices)
        function Tab:CreateSlider(sliderConfig)
            local sliderConfig = sliderConfig or {}
            local sliderText = sliderConfig.Text or "Slider"
            local minValue = sliderConfig.Min or 0
            local maxValue = sliderConfig.Max or 100
            local defaultValue = math.clamp(sliderConfig.Default or minValue, minValue, maxValue)
            local sliderPrecision = sliderConfig.Precision or 1
            local sliderCallback = sliderConfig.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = sliderText .. "SliderFrame"
            SliderFrame.Size = UDim2.new(1, 0, 0, 55)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.LayoutOrder = self.ElementCount
            SliderFrame.Parent = self.Container
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.Position = UDim2.new(0, 0, 0, 0)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.TextColor3 = CurrentTheme.PrimaryTextColor
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Text = sliderText
            SliderLabel.Parent = SliderFrame
            
            local SliderValueLabel = Instance.new("TextLabel")
            SliderValueLabel.Name = "SliderValueLabel"
            SliderValueLabel.Size = UDim2.new(0, 50, 0, 20)
            SliderValueLabel.Position = UDim2.new(1, -50, 0, 0)
            SliderValueLabel.BackgroundTransparency = 1
            SliderValueLabel.TextColor3 = CurrentTheme.AccentColor
            SliderValueLabel.TextSize = 14
            SliderValueLabel.Font = Enum.Font.GothamBold
            SliderValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            SliderValueLabel.Text = tostring(defaultValue)
            SliderValueLabel.Parent = SliderFrame
            
            local SliderBackground = Instance.new("Frame")
            SliderBackground.Name = "SliderBackground"
            SliderBackground.Size = UDim2.new(1, 0, 0, 10)
            SliderBackground.Position = UDim2.new(0, 0, 0, 30)
            SliderBackground.BackgroundColor3 = CurrentTheme.SliderBackgroundColor
            SliderBackground.Parent = SliderFrame
            createUICorner(SliderBackground, 5)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
            SliderFill.BackgroundColor3 = CurrentTheme.SliderColor
            SliderFill.Parent = SliderBackground
            createUICorner(SliderFill, 5)
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBackground
            
            -- Add to rainbow elements if theme is Rainbow
            if CurrentTheme.IsRainbowTheme then
                table.insert(rainbowElements, {Type = "Accent", Instance = SliderFill})
                table.insert(rainbowElements, {Type = "Text", Instance = SliderValueLabel})
            end
            
            -- Current value
            local value = defaultValue
            
            -- Function to format value based on precision
            local function formatValue(val)
                if sliderPrecision == 0 then
                    return math.floor(val)
                else
                    local fmt = "%." .. sliderPrecision .. "f"
                    return string.format(fmt, val)
                end
            end
            
            -- Function to update slider
            local function updateSlider(newValue)
                value = math.clamp(newValue, minValue, maxValue)
                SliderValueLabel.Text = formatValue(value)
                
                local fillRatio = (value - minValue) / (maxValue - minValue)
                createTween(SliderFill, {Size = UDim2.new(fillRatio, 0, 1, 0)}, 0.1):Play()
                
                sliderCallback(value)
            end
            
            -- Improved slider functionality for all devices
            local isDragging = false
            
            -- Calculate value based on position
            local function calculateValue(inputPosition)
                local sliderPosition = SliderBackground.AbsolutePosition
                local sliderSize = SliderBackground.AbsoluteSize
                
                local relativeX = math.clamp((inputPosition.X - sliderPosition.X) / sliderSize.X, 0, 1)
                return minValue + (maxValue - minValue) * relativeX
            end
            
            -- Handle input begin
            SliderButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    updateSlider(calculateValue(input.Position))
                end
            end)
            
            -- Handle input ended
            UserInputService.InputEnded:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
                    isDragging = false
                end
            end)
            
            -- Handle input changed for dragging
            UserInputService.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
                    updateSlider(calculateValue(input.Position))
                end
            end)
            
            -- Slider object and methods
            local Slider = {}
            Slider.Value = value
            
            function Slider:SetValue(newValue)
                updateSlider(newValue)
            end
            
            function Slider:GetValue()
                return value
            end
            
            self.ElementCount = self.ElementCount + 1
            return Slider
        end
        
        -- Function to create a text label
        function Tab:CreateLabel(labelConfig)
            local labelConfig = labelConfig or {}
            local labelText = labelConfig.Text or "Label"
            
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "LabelFrame"
            LabelFrame.Size = UDim2.new(1, 0, 0, 25)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.LayoutOrder = self.ElementCount
            LabelFrame.Parent = self.Container
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = CurrentTheme.SecondaryTextColor
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Text = labelText
            Label.Parent = LabelFrame
            
            -- Label object and methods
            local LabelObject = {}
            
            function LabelObject:SetText(newText)
                Label.Text = newText
            end
            
            self.ElementCount = self.ElementCount + 1
            return LabelObject
        end
        
        -- Function to create a textbox
        function Tab:CreateTextbox(textboxConfig)
            local textboxConfig = textboxConfig or {}
            local textboxText = textboxConfig.Text or "Textbox"
            local placeholderText = textboxConfig.PlaceholderText or "Enter text..."
            local defaultValue = textboxConfig.Default or ""
            local clearOnFocus = textboxConfig.ClearOnFocus
            if clearOnFocus == nil then clearOnFocus = true end
            local textboxCallback = textboxConfig.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = textboxText .. "TextboxFrame"
            TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.LayoutOrder = self.ElementCount
            TextboxFrame.Parent = self.Container
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Name = "TextboxLabel"
            TextboxLabel.Size = UDim2.new(1, 0, 0, 20)
            TextboxLabel.Position = UDim2.new(0, 0, 0, 0)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.TextColor3 = CurrentTheme.PrimaryTextColor
            TextboxLabel.TextSize = 14
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Text = textboxText
            TextboxLabel.Parent = TextboxFrame
            
            local TextboxContainer = Instance.new("Frame")
            TextboxContainer.Name = "TextboxContainer"
            TextboxContainer.Size = UDim2.new(1, 0, 0, 30)
            TextboxContainer.Position = UDim2.new(0, 0, 0, 25)
            TextboxContainer.BackgroundColor3 = CurrentTheme.TextboxColor
            TextboxContainer.Parent = TextboxFrame
            createUICorner(TextboxContainer, 6)
            createUIStroke(TextboxContainer, 1, CurrentTheme.UIStrokeColor)
            
            local Textbox = Instance.new("TextBox")
            Textbox.Name = "Textbox"
            Textbox.Size = UDim2.new(1, -16, 1, 0)
            Textbox.Position = UDim2.new(0, 8, 0, 0)
            Textbox.BackgroundTransparency = 1
            Textbox.TextColor3 = CurrentTheme.PrimaryTextColor
            Textbox.PlaceholderColor3 = CurrentTheme.SecondaryTextColor
            Textbox.TextSize = 14
            Textbox.Font = Enum.Font.Gotham
            Textbox.TextXAlignment = Enum.TextXAlignment.Left
            Textbox.PlaceholderText = placeholderText
            Textbox.Text = defaultValue
            Textbox.ClearTextOnFocus = clearOnFocus
            Textbox.Parent = TextboxContainer
            
            -- Focused and unfocused animations
            Textbox.Focused:Connect(function()
                createTween(TextboxContainer, {BackgroundColor3 = CurrentTheme.ButtonHoverColor}):Play()
            end)
            
            Textbox.FocusLost:Connect(function(enterPressed)
                createTween(TextboxContainer, {BackgroundColor3 = CurrentTheme.TextboxColor}):Play()
                textboxCallback(Textbox.Text, enterPressed)
            end)
            
            -- Textbox object and methods
            local TextboxObject = {}
            
            function TextboxObject:SetValue(newValue)
                Textbox.Text = newValue
            end
            
            function TextboxObject:GetValue()
                return Textbox.Text
            end
            
            self.ElementCount = self.ElementCount + 1
            return TextboxObject
        end
        
        -- Function to create a dropdown (FIXED)
        function Tab:CreateDropdown(dropdownConfig)
            local dropdownConfig = dropdownConfig or {}
            local dropdownText = dropdownConfig.Text or "Dropdown"
            local options = dropdownConfig.Options or {}
            local defaultOption = dropdownConfig.Default or (options[1] or "")
            local dropdownCallback = dropdownConfig.Callback or function() end
            
            -- Main dropdown frame
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = dropdownText .. "DropdownFrame"
            DropdownFrame.Size = UDim2.new(1, 0, 0, 55)  -- Initial size without dropdown expanded
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.LayoutOrder = self.ElementCount
            DropdownFrame.Parent = self.Container
            
            -- Dropdown label
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "DropdownLabel"
            DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
            DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.TextColor3 = CurrentTheme.PrimaryTextColor
            DropdownLabel.TextSize = 14
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Text = dropdownText
            DropdownLabel.Parent = DropdownFrame
            
            -- Selection display button
            local SelectionButton = Instance.new("TextButton")
            SelectionButton.Name = "SelectionButton"
            SelectionButton.Size = UDim2.new(1, 0, 0, 30)
            SelectionButton.Position = UDim2.new(0, 0, 0, 25)
            SelectionButton.BackgroundColor3 = CurrentTheme.DropdownColor
            SelectionButton.TextColor3 = CurrentTheme.PrimaryTextColor
            SelectionButton.TextSize = 14
            SelectionButton.Font = Enum.Font.Gotham
            SelectionButton.TextXAlignment = Enum.TextXAlignment.Left
            SelectionButton.Text = "  " .. defaultOption
            SelectionButton.ClipsDescendants = true
            SelectionButton.Parent = DropdownFrame
            createUICorner(SelectionButton, 6)
            createUIStroke(SelectionButton, 1, CurrentTheme.UIStrokeColor)
            
            -- Arrow indicator
            local Arrow = Instance.new("TextLabel")
            Arrow.Name = "Arrow"
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -25, 0.5, -10)
            Arrow.BackgroundTransparency = 1
            Arrow.TextColor3 = CurrentTheme.SecondaryTextColor
            Arrow.TextSize = 14
            Arrow.Font = Enum.Font.GothamBold
            Arrow.Text = "▼"
            Arrow.Parent = SelectionButton
            
            -- Dropdown list container (this will be outside the button)
            local DropdownListOuterFrame = Instance.new("Frame")
            DropdownListOuterFrame.Name = "DropdownListOuterFrame"
            DropdownListOuterFrame.Size = UDim2.new(1, 0, 0, 0)  -- Start with 0 height
            DropdownListOuterFrame.Position = UDim2.new(0, 0, 0, 55)  -- Position it below the selection button
            DropdownListOuterFrame.BackgroundTransparency = 1
            DropdownListOuterFrame.ClipsDescendants = true
            DropdownListOuterFrame.Visible = false
            DropdownListOuterFrame.ZIndex = 10  -- Ensure it's above other elements
            DropdownListOuterFrame.Parent = DropdownFrame
            
            -- The actual dropdown list
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Size = UDim2.new(1, 0, 1, 0)
            DropdownList.BackgroundColor3 = CurrentTheme.DropdownColor
            DropdownList.ZIndex = 10
            DropdownList.Parent = DropdownListOuterFrame
            createUICorner(DropdownList, 6)
            createUIStroke(DropdownList, 1, CurrentTheme.UIStrokeColor)
            
            -- Scrolling frame for options
            local OptionsContainer = Instance.new("ScrollingFrame")
            OptionsContainer.Name = "OptionsContainer"
            OptionsContainer.Size = UDim2.new(1, -10, 1, -10)
            OptionsContainer.Position = UDim2.new(0, 5, 0, 5)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.BorderSizePixel = 0
            OptionsContainer.ScrollBarThickness = 3
            OptionsContainer.ScrollBarImageColor3 = CurrentTheme.AccentColor
            OptionsContainer.ZIndex = 11
            OptionsContainer.Parent = DropdownList
            
            -- List layout for options
            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 5)
            UIListLayout.Parent = OptionsContainer
            
            -- State tracking
            local isOpen = false
            local selectedOption = defaultOption
            
            -- Function to create an option button
            local function createOptionButton(option, index)
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = "Option_" .. option
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.BackgroundColor3 = CurrentTheme.ButtonColor
                OptionButton.TextColor3 = CurrentTheme.PrimaryTextColor
                OptionButton.TextSize = 14
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                OptionButton.Text = "  " .. option
                OptionButton.LayoutOrder = index
                OptionButton.ZIndex = 12
                OptionButton.Parent = OptionsContainer
                createUICorner(OptionButton, 6)
                
                -- Option button hover effects
                OptionButton.MouseEnter:Connect(function()
                    createTween(OptionButton, {BackgroundColor3 = CurrentTheme.ButtonHoverColor}):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    createTween(OptionButton, {BackgroundColor3 = CurrentTheme.ButtonColor}):Play()
                end)
                
                -- Option selection
                OptionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    SelectionButton.Text = "  " .. option
                    toggleDropdown()
                    dropdownCallback(option)
                end)
                
                return OptionButton
            end
            
            -- Function to toggle dropdown visibility
            function toggleDropdown()
                isOpen = not isOpen
                
                if isOpen then
                    -- Calculate total height needed for the list (limit to 150px max)
                    local optionHeight = 25 + 5  -- Button height + padding
                    local listHeight = math.min(#options * optionHeight, 150)
                    
                    -- Show dropdown
                    DropdownListOuterFrame.Visible = true
                    Arrow.Text = "▲"  -- Up arrow
                    
                    -- Animate dropdown opening
                    createTween(DropdownListOuterFrame, {Size = UDim2.new(1, 0, 0, listHeight)}):Play()
                    
                    -- Update canvas size
                    OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, #options * optionHeight)
                else
                    -- Change arrow
                    Arrow.Text = "▼"  -- Down arrow
                    
                    -- Animate dropdown closing
                    local closeTween = createTween(DropdownListOuterFrame, {Size = UDim2.new(1, 0, 0, 0)})
                    closeTween:Play()
                    
                    -- Hide after animation completes
                    closeTween.Completed:Connect(function()
                        if not isOpen then
                            DropdownListOuterFrame.Visible = false
                        end
                    end)
                end
            end
            
            -- Populate options
            for i, option in ipairs(options) do
                createOptionButton(option, i)
            end
            
            -- Toggle dropdown on button click
            SelectionButton.MouseButton1Click:Connect(toggleDropdown)
            
            -- Close dropdown when clicking elsewhere
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if isOpen and (not DropdownFrame:IsDescendantOf(game) or not DropdownFrame.Parent) then 
                        return 
                    end
                    
                    if isOpen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dropdownPos = DropdownFrame.AbsolutePosition
                        local dropdownSize = DropdownFrame.AbsoluteSize
                        local dropdownListSize = DropdownListOuterFrame.AbsoluteSize
                        
                        -- Check if click is outside dropdown area
                        local isInDropdownButton = 
                            mousePos.X >= dropdownPos.X and
                            mousePos.X <= dropdownPos.X + dropdownSize.X and
                            mousePos.Y >= dropdownPos.Y and
                            mousePos.Y <= dropdownPos.Y + 55
                            
                        local isInDropdownList = 
                            mousePos.X >= dropdownPos.X and
                            mousePos.X <= dropdownPos.X + dropdownSize.X and
                            mousePos.Y >= dropdownPos.Y + 55 and
                            mousePos.Y <= dropdownPos.Y + 55 + dropdownListSize.Y
                        
                        if not (isInDropdownButton or isInDropdownList) then
                            toggleDropdown()
                        end
                    end
                end
            end)
            
            -- Button hover effects
            SelectionButton.MouseEnter:Connect(function()
                if not isOpen then
                    createTween(SelectionButton, {BackgroundColor3 = CurrentTheme.ButtonHoverColor}):Play()
                end
            end)
            
            SelectionButton.MouseLeave:Connect(function()
                if not isOpen then
                    createTween(SelectionButton, {BackgroundColor3 = CurrentTheme.DropdownColor}):Play()
                end
            end)
            
            -- Dropdown object and methods
            local Dropdown = {}
            
            function Dropdown:SetValue(option)
                if table.find(options, option) then
                    selectedOption = option
                    SelectionButton.Text = "  " .. option
                    dropdownCallback(option)
                end
            end
            
            function Dropdown:GetValue()
                return selectedOption
            end
            
            function Dropdown:Refresh(newOptions, keepSelection)
                options = newOptions or {}
                
                -- Clear existing options
                for _, child in pairs(OptionsContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Add new options
                for i, option in ipairs(options) do
                    createOptionButton(option, i)
                end
                
                -- Reset selection if needed
                if not keepSelection or not table.find(options, selectedOption) then
                    selectedOption = options[1] or ""
                    SelectionButton.Text = "  " .. selectedOption
                end
                
                -- Update canvas size
                local optionHeight = 25 + 5  -- Button height + padding
                OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, #options * optionHeight)
                
                -- Close dropdown
                if isOpen then
                    toggleDropdown()
                end
            end
            
            self.ElementCount = self.ElementCount + 1
            return Dropdown
        end
        
        -- Add tab to window tabs table
        table.insert(self.Tabs, Tab)
        
        -- If this is the first tab, select it
        if #self.Tabs == 1 then
            TabFrame.Visible = true
            if not CurrentTheme.IsRainbowTheme then
                createTween(TabButton, {BackgroundColor3 = CurrentTheme.AccentColor}):Play()
            end
            self.CurrentTab = tabName
        end
        
        return Tab
    end
    
    -- Function to change theme
    function Window:SetTheme(themeName)
        if Themes[themeName] then
            CurrentTheme = Themes[themeName]
            
            -- Stop existing rainbow connection if exists
            if RainbowConnection then
                RainbowConnection:Disconnect()
                RainbowConnection = nil
            end
            
            -- If new theme is rainbow, set up rainbow effects
            if CurrentTheme.IsRainbowTheme then
                setupRainbowTheme(rainbowElements)
            end
            
            -- Would need to implement full UI update here
        end
    end
    
    -- Function to create notification from window
    function Window:Notify(notifConfig)
        UltraLordLibrary:CreateNotification(notifConfig)
    end
    
    -- Set up rainbow theme if needed
    if CurrentTheme.IsRainbowTheme then
        setupRainbowTheme(rainbowElements)
    end
    
    return Window
end

-- Function to change the global theme
function UltraLordLibrary:SetTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
    end
end

-- Function to create a custom theme
function UltraLordLibrary:CreateTheme(themeName, themeColors)
    Themes[themeName] = themeColors
end

return UltraLordLibrary
