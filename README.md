# UltraLord UI Library V2

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
- 🎮 Menu toggle functionality
- 🖱️ Configurable drag controls

## Quick Start

```lua
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/Source"))()

-- Create a window
local Window = UltraLordLib:MakeWindow({
    Name = "My Window",
    Theme = "UltraLordV2",
    Font = "FredokaOne",
    SaveConfig = true,
    ConfigFolder = "UltraLordConfig"
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

UltraLordLib:MakeNotification({
    Name = "Hello!",
    Content = "This is a basic notification",
    Image = "rbxassetid://4384403532",
    Time = 5
})
```

## Window Configuration Options

```lua
UltraLordLib:MakeWindow({
    Name = string,              -- Window title
    Theme = string,             -- Theme name
    Font = string,              -- Font family
    ConfigFolder = string,      -- Config save location
    SaveConfig = boolean,       -- Enable config saving
    HidePremium = boolean,      -- Hide premium features
    IntroEnabled = boolean,     -- Show intro animation
    IntroText = string,         -- Intro text
    IntroIcon = string,         -- Intro icon
    Icon = string,              -- Window icon
    CloseCallback = function()  -- On close callback
})
```

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

### Notification
```lua
UltraLordLib:MakeNotification({
    Name = string,     -- Title
    Content = string,  -- Message
    Image = string,    -- Icon ID
    Time = number      -- Duration (seconds)
})
```

### Menu Toggle
The library includes a built-in menu toggle feature:
- Hide/Show UI with toggle button
- Automatic notification on hide
- Maintains drag functionality state

## Themes & Styling

### Available Themes
- UltraLord (Default)

### Available Fonts
- FredokaOne (Default)
- GothamBold
- SourceSansBold

## Advanced Features

### Configuration Saving
Enable automatic configuration saving:
```lua
local Window = UltraLordLib:MakeWindow({
    SaveConfig = true,
    ConfigFolder = "MyConfigs"
})
```

### Custom Theme Colors
```lua
UltraLordLib.Themes.Custom = {
    Main = Color3.fromRGB(25, 25, 25),
    Second = Color3.fromRGB(32, 32, 32),
    Stroke = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150)
}
```

## Key Features

- **Smart Animations**: Smooth transitions and effects
- **Theme Support**: Multiple built-in themes
- **Responsive Design**: Adapts to different screen sizes
- **Touch Support**: Works on mobile devices
- **Modern UI**: Clean and intuitive interface
- **Auto-Save**: Configuration persistence
- **Customizable**: Extensive styling options

## License
MIT License - Feel free to use and modify while maintaining attribution.
