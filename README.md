
# Ultra Lord UI Library V2

A modern, feature-rich UI library for Roblox with smooth animations, dynamic themes, and an intuitive API.

## Features

- 🎨 Multiple built-in themes (UltraLordV2, UltraSpaceV2, UltraDarkV2, UltraLegend)
- ✨ Smooth animations and transitions
- 🎯 Customizable fonts
- 📢 Modern notification system
- 📑 Tab-based interface
- 🔄 Draggable windows
- 🛡️ UICorner standardization
- 📱 Touch support

## Quick Start

```lua
local UltraLordLib = loadstring(game:HttpGet("path_to_library"))()

-- Create a window
local Window = UltraLordLib:MakeWindow({
    Name = "My Window",
    Theme = "UltraLordV2",
    Font = "FredokaOne"
})

-- Create a tab
local Tab = Window:CreateTab("Main", "rbxassetid://4384401360")

-- Add elements
local Button = Tab:CreateButton("Click Me", function()
    print("Button clicked!")
end)

local Toggle = Tab:CreateToggle("Toggle Me", false, function(Value)
    print("Toggle state:", Value)
end)

local Slider = Tab:CreateSlider("Adjust Value", 0, 100, 50, function(Value)
    print("Slider value:", Value)
end)
```

## API Reference

### Window Configuration
```lua
UltraLordLib:MakeWindow({
    Name = string,    -- Window title
    Theme = string,   -- Theme name
    Font = string     -- Font family
})
```

### Notifications
```lua
UltraLordLib:MakeNotification({
    Name = string,    -- Notification title
    Content = string, -- Message content
    Image = string,   -- Icon ID
    Time = number     -- Duration in seconds
})
```

### Available Themes
- UltraLordV2 (Default)
- UltraSpaceV2
- UltraDarkV2
- UltraLegend

### Available Fonts
- FredokaOne (Default)
- GothamBold
- SourceSansBold

## UI Elements

### Button
```lua
Tab:CreateButton(name, callback)
```

### Toggle
```lua
Tab:CreateToggle(name, defaultState, callback)
```

### Slider
```lua
Tab:CreateSlider(name, min, max, default, callback)
```

## Key Features

- **Smart Animations**: Smooth transitions and effects
- **Theme Support**: Multiple built-in themes
- **Responsive Design**: Adapts to different screen sizes
- **Touch Support**: Works on mobile devices
- **Modern UI**: Clean and intuitive interface

## License
MIT License
