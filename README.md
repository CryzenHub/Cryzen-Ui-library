# Ultra Lord UI Library V2

A modern, feature-rich UI Library for Roblox with smooth animations, notifications, and clean design.

## Features

- 🎨 Modern and clean design
- ✨ Smooth animations and transitions
- 🔔 Customizable notifications with timer
- 🎯 Draggable window interface
- 🔄 UI visibility toggle
- 📱 Responsive design
- 🎭 Theme customization
- 🔤 Font configuration

## Quick Start

1. Load the library:
```lua
local UltraLordLib = loadstring(game:HttpGet("source.lua"))()
```

2. Create a window with custom theme:
```lua
local Window = UltraLordLib:MakeWindow({
    WindowName = "My Application",
    Theme = {
        PrimaryColor = Color3.fromRGB(36, 36, 36),
        SecondaryColor = Color3.fromRGB(46, 46, 46),
        AccentColor = Color3.fromRGB(240, 240, 240),
        ToggleOnColor = Color3.fromRGB(56, 207, 137),
        ToggleOffColor = Color3.fromRGB(229, 57, 53)
    },
    Font = Enum.Font.FredokaOne
})
```

## UI Elements

### Tabs
Create organized sections in your UI:
```lua
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")
```

### Buttons
Add clickable buttons with callbacks:
```lua
MainTab:CreateButton("Save Settings", function()
    print("Settings saved!")
    Window:Notify("Success", "Settings saved successfully!", 3)
end)
```

### Toggles
Create toggle switches with state management:
```lua
MainTab:CreateToggle("Auto Save", false, function(state)
    print("Auto save is now:", state)
end)
```

### Sliders
Add value sliders with custom ranges:
```lua
MainTab:CreateSlider("Volume", 0, 100, 50, function(value)
    print("Volume set to:", value)
end)
```

### Notifications
Display timed notifications with progress bar:
```lua
Window:Notify("Title", "Message", duration) -- duration in seconds
```

## Theme Configuration

Customize the appearance with these theme options:
```lua
{
    Font = Enum.Font.FredokaOne,
    SecondaryFont = Enum.Font.FredokaOne,
    PrimaryColor = Color3.fromRGB(36, 36, 36),
    SecondaryColor = Color3.fromRGB(46, 46, 46),
    AccentColor = Color3.fromRGB(240, 240, 240),
    ToggleOnColor = Color3.fromRGB(56, 207, 137),
    ToggleOffColor = Color3.fromRGB(229, 57, 53)
}
```

## Complete Example

```lua
local UltraLordLib = loadstring(game:HttpGet("source.lua"))()

-- Create window
local Window = UltraLordLib:MakeWindow({
    WindowName = "My Application",
    Theme = {
        PrimaryColor = Color3.fromRGB(36, 36, 36),
        SecondaryColor = Color3.fromRGB(46, 46, 46),
        AccentColor = Color3.fromRGB(240, 240, 240),
        ToggleOnColor = Color3.fromRGB(56, 207, 137),
        ToggleOffColor = Color3.fromRGB(229, 57, 53)
    },
    Font = Enum.Font.FredokaOne
})

-- Create tabs
local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- Add elements to Main tab
MainTab:CreateButton("Save", function()
    Window:Notify("Success", "Data saved!", 3)
end)

MainTab:CreateToggle("Auto Save", false, function(state)
    print("Auto save:", state)
end)

MainTab:CreateSlider("Volume", 0, 100, 50, function(value)
    print("Volume set to:", value)
end)

-- Add elements to Settings tab
SettingsTab:CreateButton("Reset", function()
    Window:Notify("Info", "Settings reset to default", 3)
end)
```

## License

MIT License - Free to use and modify for your projects.
