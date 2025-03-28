
# Ultra Lord UI Library V3

A modern, feature-rich UI library for Roblox with smooth animations and customizable themes.

## Installation

```lua
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/source"))()
```

## Quick Start

```lua
-- Create a window
local Window = UltraLordLib:CreateWindow({
    Title = "My App",
    Theme = {
        Primary = Color3.fromRGB(36, 36, 36),
        Secondary = Color3.fromRGB(46, 46, 46),
        Accent = Color3.fromRGB(240, 240, 240)
    }
})

-- Create a tab
local Tab = Window:AddTab("Main")
```

## Components

### Button
```lua
Tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

### Toggle
```lua
Tab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})
```

### Slider
```lua
Tab:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Speed:", Value)
    end
})
```

### Label
```lua
Tab:AddLabel({
    Text = "Section Title"
})
```

### Paragraph
```lua
Tab:AddParagraph({
    Text = "This is a longer text that will automatically adjust its height based on content."
})
```

### Notification
```lua
UltraLordLib:Notify({
    Title = "Success",
    Message = "Operation completed",
    Duration = 3
})
```

## Theming

Customize the appearance with these theme options:

```lua
{
    Primary = Color3.fromRGB(36, 36, 36),    -- Main background
    Secondary = Color3.fromRGB(46, 46, 46),   -- Component background
    Accent = Color3.fromRGB(240, 240, 240),   -- Text and highlights
    Success = Color3.fromRGB(56, 207, 137),   -- Success states
    Error = Color3.fromRGB(229, 57, 53)       -- Error states
}
```

## Font Customization

```lua
{
    Title = Enum.Font.GothamBold,      -- Window titles
    Text = Enum.Font.Gotham,           -- General text
    Button = Enum.Font.GothamMedium    -- Button text
}
```

## License
MIT License - Free to use and modify

## Support
For issues or feature requests, please create an issue in the repository.
