# UltraLord Library V5

A modern, sleek UI library for Roblox with enhanced animations and styling.

## Features

- Modern and clean design
- Smooth animations and transitions
- Enhanced shadow effects
- Improved corner radius system
- Modern notification system
- Fully customizable theme
- Draggable windows
- Built-in key system authentication
- Secure input handling
- Anti-tampering measures
- Buttons with hover effects
- Animated toggles
- Dynamic sliders
- Text inputs
- Labels and paragraphs
- Custom notifications
- Tab system


## 📦 Installation

```lua
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/source"))()
```

## 🚀 Quick Start

```lua
-- Initialize with key authentication
local window = UltraLordLib:CreateWindow({
    Title = "Ultra Lord V5",
    Key = "YourSecureKey123", -- Minimum 8 chars with numbers and uppercase
    Theme = {
        Primary = Color3.fromRGB(24, 24, 28),
        Secondary = Color3.fromRGB(32, 32, 36),
        Accent = Color3.fromRGB(240, 240, 245),
        Success = Color3.fromRGB(56, 207, 137),
        Error = Color3.fromRGB(229, 57, 53),
        Highlight = Color3.fromRGB(61, 133, 224),
        Stroke = Color3.fromRGB(45, 45, 50)
    }
})
```

## 💡 Components Guide

### Tabs
```lua
local tab = window:AddTab("General")
```

### Buttons
```lua
tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

### Toggles
```lua
tab:AddToggle({
    Name = "Feature Toggle",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```

### Sliders
```lua
tab:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Speed:", value)
    end
})
```

### Input Fields
```lua
tab:AddInput({
    Placeholder = "Enter text...",
    Default = "",
    ClearOnFocus = true,
    Callback = function(text)
        print("Input:", text)
    end
})
```

### Labels
```lua
tab:AddLabel({
    Text = "Information Label"
})
```

### Paragraphs
```lua
tab:AddParagraph({
    Text = "This is a detailed paragraph that can contain longer text content with automatic wrapping."
})
```

### Notifications
```lua
UltraLordLib:Notify({
    Title = "Success",
    Message = "Operation completed!",
    Duration = 3
})
```

## 🎨 Theme Customization

The theme can be customized by passing a table to the `CreateWindow` function.  Here's an example of a custom theme:

```lua
local window = UltraLordLib:CreateWindow({
    Theme = {
        Primary = Color3.fromRGB(24, 24, 28),    -- Main background
        Secondary = Color3.fromRGB(32, 32, 36),  -- Secondary elements
        Accent = Color3.fromRGB(240, 240, 245),  -- Text and highlights
        Success = Color3.fromRGB(56, 207, 137),  -- Success states
        Error = Color3.fromRGB(229, 57, 53),     -- Error states
        Highlight = Color3.fromRGB(61, 133, 224), -- Hover effects
        Stroke = Color3.fromRGB(45, 45, 50),     -- UI borders
        InputBackground = Color3.fromRGB(30, 30, 30) -- Input fields
    }
})
```

## 🎯 UI Corner Customization

```lua
-- Available corner sizes
Corner = {
    Small = UDim.new(0, 4),
    Medium = UDim.new(0, 6),
    Large = UDim.new(0, 8)
}
```

## ✨ Animation Settings

```lua
-- Animation duration presets
Animation = {
    Short = 0.15,  -- Quick feedback
    Normal = 0.3,  -- Standard transitions
    Long = 0.5     -- Emphasis effects
}
```

## 🛡️ Key System Example

```lua
local window = UltraLordLib:CreateWindow({
    Title = "Secured Window",
    Key = "SecureKey123", -- Must have 8+ chars, numbers, and uppercase
    Theme = {
        Primary = Color3.fromRGB(36, 36, 36),
        Secondary = Color3.fromRGB(46, 46, 46)
    }
})
```

## 📱 Complete Example

```lua
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/source"))()

local window = UltraLordLib:CreateWindow({
    Title = "Ultra Lord V5",
    Key = "SecureKey123",
    Theme = {
        Primary = Color3.fromRGB(36, 36, 36),
        Secondary = Color3.fromRGB(46, 46, 46)
    }
})

local mainTab = window:AddTab("Main")
local settingsTab = window:AddTab("Settings")

-- Main Tab
mainTab:AddButton({
    Name = "Start",
    Callback = function()
        UltraLordLib:Notify({
            Title = "Started",
            Message = "Process initiated!",
            Duration = 2
        })
    end
})

mainTab:AddInput({
    Placeholder = "Enter name...",
    ClearOnFocus = true,
    Callback = function(text)
        print("Name:", text)
    end
})

-- Settings Tab
settingsTab:AddToggle({
    Name = "Auto Save",
    Default = true,
    Callback = function(value)
        print("Auto Save:", value)
    end
})

settingsTab:AddSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        print("Volume:", value)
    end
})
```

## 🔄 Updates in V5

- Enhanced UI corners and strokes
- Improved animations and transitions
- New input component
- Draggable menu toggle
- Inertia-based dragging
- Enhanced theme customization
- Improved key system UI
- Better performance and stability

## ⚠️ Best Practices

1. **Security**
   - Use strong keys (8+ characters)
   - Include numbers and uppercase letters
   - Don't share keys publicly

2. **Performance**
   - Group related elements in tabs
   - Use appropriate animation durations
   - Clean up connections when needed

3. **UI/UX**
   - Maintain consistent styling
   - Provide user feedback
   - Use clear, descriptive labels

## 🔧 Support

For updates and support, check back regularly. Report any issues or feature requests through the appropriate channels.
