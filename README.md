# CryzenHub UI Library v1.0.5

A modern, powerful, and highly customizable UI library for Roblox Luau scripts with a sleek design, smooth animations, and extensive features.

## What's New in v1.0.5

- **ColorPicker element**: Create custom color pickers with RGB input support
- **KeyBind element**: Add key bindings to your scripts
- **Notification system**: Display informative notifications to users
- **Section containers**: Organize your UI elements into collapsible sections
- **Theme presets**: Choose from multiple built-in themes (Default, Dark, Light, Discord)
- **Improved animations**: Smoother transitions and effects
- **Performance optimizations**: Better handling of UI updates
- **Bug fixes**: Various stability improvements

## Features

- Sleek and modern UI design
- Window with draggable functionality
- Multi-tab system with optional icons
- Sections for better organization
- Various UI elements (buttons, toggles, sliders, dropdowns, text inputs, color pickers, key binds)
- Notification system with different types (Success, Warning, Error, Info)
- Theme customization and built-in theme presets
- Smooth animations and transitions
- Intuitive and easy to use API

## Getting Started

### Installation

```lua
local CryzenHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/YourUsername/CryzenHub/main/Source.lua'))()
```

### Basic Usage

```lua
-- Create a window with a custom theme
local window = CryzenHub:CreateWindow({
    Title = "CryzenHub Example",
    Size = UDim2.new(0, 550, 0, 400),
    Theme = "Discord", -- Use a theme preset (Default, Dark, Light, Discord)
    DefaultTab = "Main" -- Tab to be selected by default
})

-- Create tabs
local mainTab = window:CreateTab("Main", "rbxassetid://7733765398") -- Optional icon
local settingsTab = window:CreateTab("Settings", "rbxassetid://7733774602")

-- Create a section in the main tab
local generalSection = mainTab:CreateSection("General Features")

-- Add elements to the section
generalSection:CreateLabel({Text = "Welcome to CryzenHub UI Library v1.0.5!"})

generalSection:CreateButton({
    Text = "Click Me",
    Callback = function()
        window:Notify({
            Title = "Button Clicked",
            Content = "You clicked the button!",
            Duration = 3,
            Type = "Success"
        })
    end
})

-- Create a toggle with a callback
generalSection:CreateToggle({
    Text = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

## Documentation

### Window

#### Creating a Window

```lua
local window = CryzenHub:CreateWindow({
    Title = "My Window",  -- Window title
    Size = UDim2.new(0, 550, 0, 400),  -- Window size
    Theme = "Dark",  -- Theme preset (Default, Dark, Light, Discord) or custom theme table
    DefaultTab = "Main"  -- Default selected tab
})
```

#### Notifications

```lua
window:Notify({
    Title = "Notification Title",  -- Title of the notification
    Content = "This is a notification message",  -- Content text
    Duration = 5,  -- Duration in seconds (default: 5)
    Type = "Info"  -- Type: "Success", "Warning", "Error", "Info"
})
```

#### Change Theme

```lua
-- Use a preset theme
window:ChangeTheme("Light")

-- Or use a custom theme
window:ChangeTheme({
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 120, 215),
    LightAccent = Color3.fromRGB(0, 140, 235),
    DarkAccent = Color3.fromRGB(0, 100, 195),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200),
    SecondaryBackground = Color3.fromRGB(40, 40, 40),
    ElementBackground = Color3.fromRGB(50, 50, 50),
    ElementBorder = Color3.fromRGB(60, 60, 60),
    InactiveElement = Color3.fromRGB(80, 80, 80),
    Notification = {
        Success = Color3.fromRGB(0, 180, 0),
        Warning = Color3.fromRGB(255, 150, 0),
        Error = Color3.fromRGB(220, 0, 0),
        Info = Color3.fromRGB(0, 120, 215)
    }
})
```

#### Creating a Tab

```lua
local tab = window:CreateTab("Tab Name", "rbxassetid://7733765398")  -- Optional icon
```

#### Creating a Section

```lua
local section = tab:CreateSection("Section Name")
```

### UI Elements

#### Button

```lua
local button = section:CreateButton({
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

#### Toggle

```lua
local toggle = section:CreateToggle({
    Text = "Toggle Me",
    Default = false,  -- Initial state (optional)
    Callback = function(value)
        print("Toggle state:", value)
    end
})

-- API methods
toggle:Set(true)  -- Set toggle state
local state = toggle:Get()  -- Get current state
```

#### Slider

```lua
local slider = section:CreateSlider({
    Text = "Slider Example",
    Min = 0,  -- Minimum value
    Max = 100,  -- Maximum value
    Default = 50,  -- Default value (optional)
    Precise = false,  -- Whether to use decimal values (optional)
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- API methods
slider:Set(75)  -- Set slider value
local value = slider:Get()  -- Get current value
```

#### Dropdown

```lua
local dropdown = section:CreateDropdown({
    Text = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",  -- Default selected option (optional)
    Callback = function(option)
        print("Selected option:", option)
    end
})

-- API methods
dropdown:Set("Option 2")  -- Set selected option
local selected = dropdown:Get()  -- Get current selection
dropdown:Refresh({"New Option 1", "New Option 2"}, "New Option 1")  -- Update options and default
```

#### Text Input

```lua
local input = section:CreateInput({
    Text = "Input Example",
    Placeholder = "Type here...",
    Default = "",  -- Default text (optional)
    Callback = function(text)
        print("Input text:", text)
    end
})

-- API methods
input:Set("New text")  -- Set input text
local text = input:Get()  -- Get current text
```

#### Color Picker

```lua
local colorPicker = section:CreateColorPicker({
    Text = "Select Color",
    Default = Color3.fromRGB(255, 0, 0),  -- Default color (optional)
    Callback = function(color)
        print("Selected color:", color)
    end
})

-- API methods
colorPicker:Set(Color3.fromRGB(0, 255, 0))  -- Set color
local color = colorPicker:Get()  -- Get current color
```

#### Key Bind

```lua
local keyBind = section:CreateKeyBind({
    Text = "Toggle Key",
    Default = Enum.KeyCode.F,  -- Default key (optional)
    Callback = function(key)
        print("Key pressed:", key.Name)
    end
})

-- API methods
keyBind:Set(Enum.KeyCode.G)  -- Set key
local key = keyBind:Get()  -- Get current key
```

#### Label

```lua
local label = section:CreateLabel({
    Text = "This is a label"
})

-- API methods
label:Set("Updated label text")  -- Update the text
local text = label:Get()  -- Get current text
```

#### Divider

```lua
section:CreateDivider()  -- Creates a horizontal line divider
```

## Comprehensive Example

```lua
local CryzenHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/YourUsername/CryzenHub/main/Source.lua'))()

local window = CryzenHub:CreateWindow({
    Title = "CryzenHub Example v1.0.5",
    Size = UDim2.new(0, 550, 0, 400),
    Theme = "Discord",
    DefaultTab = "Main"
})

-- Main tab with sections
local mainTab = window:CreateTab("Main", "rbxassetid://7733765398")
local generalSection = mainTab:CreateSection("General")
local visualsSection = mainTab:CreateSection("Visuals")

-- Settings tab
local settingsTab = window:CreateTab("Settings", "rbxassetid://7733774602")
local configSection = settingsTab:CreateSection("Configuration")
local themeSection = settingsTab:CreateSection("Theme")

-- General section elements
generalSection:CreateLabel({Text = "Main Features"})

generalSection:CreateButton({
    Text = "Print Hello",
    Callback = function()
        print("Hello, world!")
        window:Notify({
            Title = "Success",
            Content = "Hello was printed to the console!",
            Type = "Success"
        })
    end
})

local autoFarm = generalSection:CreateToggle({
    Text = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

generalSection:CreateSlider({
    Text = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

generalSection:CreateDivider()

-- Visuals section elements
visualsSection:CreateDropdown({
    Text = "ESP Type",
    Options = {"Boxes", "Names", "Health", "Distance", "All"},
    Default = "Boxes",
    Callback = function(option)
        print("ESP Type set to:", option)
    end
})

visualsSection:CreateColorPicker({
    Text = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("ESP Color set to:", color)
    end
})

-- Configuration section elements
configSection:CreateInput({
    Text = "Custom Name",
    Placeholder = "Enter your name",
    Callback = function(text)
        print("Name set to:", text)
    end
})

configSection:CreateKeyBind({
    Text = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Callback = function(key)
        print("UI toggle key set to:", key.Name)
    end
})

-- Theme section elements
local themes = {"Default", "Dark", "Light", "Discord"}
themeSection:CreateDropdown({
    Text = "UI Theme",
    Options = themes,
    Default = "Discord",
    Callback = function(theme)
        window:ChangeTheme(theme)
        window:Notify({
            Title = "Theme Changed",
            Content = "The UI theme has been changed to " .. theme,
            Type = "Info",
            Duration = 3
        })
    end
})
```

## License

This library is free to use for any purpose. Credit is appreciated but not required.

## Credits

Created by CryzenHub Team - v1.0.5
```

This update adds several significant improvements to the CryzenHub UI Library:

1. **ColorPicker element** - A full-featured color picker with RGB input support
2. **KeyBind element** - Allows users to set and use keyboard shortcuts
3. **Notification system** - Displays informative notifications with different types (Success, Warning, Error, Info)
4. **Section containers** - Better organization of UI elements into collapsible sections
5. **Theme presets** - Built-in themes (Default, Dark, Light, Discord) and improved theme customization
6. **Improved animations** - Smoother transitions and effects throughout the UI
7. **Bug fixes and performance improvements** - Enhanced stability and responsiveness
