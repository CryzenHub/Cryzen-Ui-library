

# Ultra Lord UI Library

A modern, animated UI library for Roblox with smooth transitions and customizable themes.

## Quick Start (Loadstring)

```lua
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/source"))()

-- Create a window
local window = UltraLordLib:CreateWindow({
    Title = "My Window",
    Theme = {
        Primary = Color3.fromRGB(36, 36, 36),
        Secondary = Color3.fromRGB(46, 46, 46),
        Accent = Color3.fromRGB(240, 240, 240)
    }
})
```

## Features

- Smooth animations and transitions
- Customizable themes and fonts
- Multiple UI components:
  - Buttons
  - Toggles
  - Labels
  - Paragraphs
  - Sliders
  - Notifications
- Draggable windows
- Menu toggle functionality

## Example Usage

```lua
-- Create a tab
local tab = window:AddTab("General")

-- Add a button
tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

-- Add a toggle
tab:AddToggle({
    Name = "Toggle Me",
    Default = false,
    Callback = function(value)
        print("Toggle value:", value)
    end
})

-- Add a slider
tab:AddSlider({
    Name = "Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- Show notification
UltraLordLib:Notify({
    Title = "Success",
    Message = "Operation completed!",
    Duration = 3
})
```

## UI Elements

### Button
```lua
tab:AddButton({
    Name = "Button Name",  -- Text displayed on the button
    Callback = function()  -- Function called when clicked
        -- Your code here
    end
})
```

### Toggle
```lua
tab:AddToggle({
    Name = "Toggle Name",    -- Text displayed next to toggle
    Default = false,         -- Initial state (true/false)
    Callback = function(value)  -- Function called with new state
        -- value is true/false
    end
})
```

### Label
```lua
tab:AddLabel({
    Text = "Label Text"  -- Static text to display
})
```

### Paragraph
```lua
tab:AddParagraph({
    Text = "Multi-line text content that automatically wraps"
})
```

### Slider
```lua
tab:AddSlider({
    Name = "Slider Name",  -- Text displayed above slider
    Min = 0,              -- Minimum value
    Max = 100,            -- Maximum value
    Default = 50,         -- Starting value
    Callback = function(value)  -- Function called with new value
        -- value is number between Min and Max
    end
})
```

### Notification
```lua
UltraLordLib:Notify({
    Title = "Title",      -- Notification title
    Message = "Message",  -- Notification content
    Duration = 3         -- How long to show (seconds)
})
```

## Full Source Code

```lua
-- Ultra Lord UI Library Source Code
local UltraLordLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    Theme = {
        Primary = Color3.fromRGB(36, 36, 36),
        Secondary = Color3.fromRGB(46, 46, 46),
        Accent = Color3.fromRGB(240, 240, 240),
        Success = Color3.fromRGB(56, 207, 137),
        Error = Color3.fromRGB(229, 57, 53),
        Highlight = Color3.fromRGB(61, 133, 224)
    },
    Fonts = {
        Title = Enum.Font.GothamBold,
        Text = Enum.Font.Gotham,
        Button = Enum.Font.GothamMedium
    },
    Animation = {
        Short = 0.15,
        Normal = 0.3,
        Long = 0.5
    },
    MenuToggle = {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0.5, -20),
        Image = "rbxassetid://11432851457",
        Transparency = 0.1,
        HoverTransparency = 0
    }
}

return UltraLordLib
```

## Themes

The library supports custom themes with the following properties:
- Primary: Main background color
- Secondary: Secondary UI elements color
- Accent: Text and highlight color
- Success: Used for positive states
- Error: Used for negative states
- Highlight: Used for hover effects

## License

MIT License - Feel free to use and modify this library in your projects.
