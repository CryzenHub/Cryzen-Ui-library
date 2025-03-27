-- Creating a Window
local Window = UltraLordLib:MakeWindow({
    Name = "My Window",
    Theme = "UltraLordV2", -- Themes: UltraLordV2, UltraSpaceV2, UltraDarkV2, UltraLegend
    Font = "FredokaOne" -- Fonts: FredokaOne, GothamBold, SourceSansBold
})

-- Creating a Tab
local Tab = Window:CreateTab("Main", "rbxassetid://4384401360") -- Name, Icon ID

-- Creating a Button
local Button = Tab:CreateButton("Click Me", function()
    print("Button clicked!")
end)

-- Creating a Toggle
local Toggle = Tab:CreateToggle("Toggle Me", false, function(Value)
    print("Toggle state:", Value)
end)

-- Creating a Slider
local Slider = Tab:CreateSlider("Adjust Value", 0, 100, 50, function(Value)
    print("Slider value:", Value)
end)

-- Creating a Notification
UltraLordLib:MakeNotification({
    Name = "Hello!",
    Content = "This is a notification",
    Image = "rbxassetid://4384401360",
    Time = 5
})

-- Toggle UI Visibility
-- Press RightControl to toggle the UI
-- Or click the menu toggle button in top-right corner

-- Theme Colors:
-- Main: Background color
-- Second: Secondary elements color
-- Stroke: Border color
-- Divider: Separator color
-- Text: Primary text color
-- TextDark: Secondary text color
