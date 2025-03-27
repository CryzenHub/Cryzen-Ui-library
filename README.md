
# Ultra Lord UI Library V2

A modern, feature-rich UI library for Roblox with smooth animations and customizable themes.

## Features

- Clean and modern design
- Multiple built-in themes
- Smooth animations and effects
- Customizable fonts
- Notification system
- Tab-based interface
- Responsive draggable windows

## Themes

- UltraLordV2
- UltraSpaceV2
- UltraDarkV2
- UltraLegend

## Quick Start

```lua
local UltraLordLib = loadstring(game:HttpGet("path_to_library"))()

-- Create a window
local Window = UltraLordLib:MakeWindow({
    Name = "My Window",
    Theme = "UltraLordV2", -- UltraLordV2, UltraSpaceV2, UltraDarkV2, UltraLegend
    Font = "FredokaOne" -- FredokaOne, GothamBold, SourceSansBold
})

-- Create a tab
local Tab = Window:CreateTab("Main", "rbxassetid://4384401360")

-- Create a button
local Button = Tab:CreateButton("Click Me", function()
    print("Button clicked!")
end)

-- Create a toggle
local Toggle = Tab:CreateToggle("Toggle Me", false, function(Value)
    print("Toggle state:", Value)
end)

-- Create a slider
local Slider = Tab:CreateSlider("Adjust Value", 0, 100, 50, function(Value)
    print("Slider value:", Value)
end)

-- Create a notification
UltraLordLib:MakeNotification({
    Name = "Hello!",
    Content = "Welcome to Ultra Lord UI Library V2",
    Image = "rbxassetid://4384401360",
    Time = 5
})
```

## Elements

### Window
```lua
local Window = UltraLordLib:MakeWindow({
    Name = string,
    Theme = string,
    Font = string
})
```

### Tab
```lua
local Tab = Window:CreateTab(name, iconId)
```

### Button
```lua
local Button = Tab:CreateButton(name, callback)
```

### Toggle
```lua
local Toggle = Tab:CreateToggle(name, defaultState, callback)
```

### Slider
```lua
local Slider = Tab:CreateSlider(name, min, max, default, callback)
```

### Notification
```lua
UltraLordLib:MakeNotification({
    Name = string,
    Content = string,
    Image = string,
    Time = number
})
```

## License
MIT License
