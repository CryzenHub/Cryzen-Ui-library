# CryzenHub UI Library v1.0.0 Alpha

A modern, easy-to-use UI library for Roblox Luau scripts with a clean design and smooth animations.

## Features

- Sleek and modern UI design
- Window with draggable functionality
- Multi-tab system
- Various UI elements (buttons, toggles, sliders, dropdowns, text inputs)
- Smooth animations and transitions
- Easy to understand API

## Getting Started

### Installation

```lua
local CryzenHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/YourUsername/CryzenHub/main/Source.lua'))()
```

### Basic Usage

```lua
-- Create a window
local window = CryzenHub:CreateWindow({
    Title = "CryzenHub Example",
    Size = UDim2.new(0, 500, 0, 350),
    Theme = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 120, 215),
        Text = Color3.fromRGB(255, 255, 255),
        SecondaryBackground = Color3.fromRGB(40, 40, 40),
        ElementBackground = Color3.fromRGB(50, 50, 50)
    }
})

-- Create tabs
local mainTab = window:CreateTab("Main")
local settingsTab = window:CreateTab("Settings")

-- Add elements to tabs
mainTab:CreateLabel({Text = "Welcome to CryzenHub UI Library!"})
mainTab:CreateButton({
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

## Documentation

### Window

#### Creating a Window

```lua
local window = CryzenHub:CreateWindow({
    Title = "My Window",  -- Window title
    Size = UDim2.new(0, 500, 0, 350),  -- Window size
    Theme = {  -- Custom theme (optional)
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 120, 215),
        Text = Color3.fromRGB(255, 255, 255),
        SecondaryBackground = Color3.fromRGB(40, 40, 40),
        ElementBackground = Color3.fromRGB(50, 50, 50)
    }
})
```

#### Creating a Tab

```lua
local tab = window:CreateTab("Tab Name")
```

### UI Elements

#### Button

```lua
local button = tab:CreateButton({
    Text = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

#### Toggle

```lua
local toggle = tab:CreateToggle({
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
local slider = tab:CreateSlider({
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
local dropdown = tab:CreateDropdown({
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
local input = tab:CreateInput({
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

#### Label

```lua
local label = tab:CreateLabel({
    Text = "This is a label"
})

-- API methods
label:Set("Updated label text")  -- Update the text
local text = label:Get()  -- Get current text
```

#### Divider

```lua
tab:CreateDivider()  -- Creates a horizontal line divider
```

## Example Script

```lua
local CryzenHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/YourUsername/CryzenHub/main/Source.lua'))()

local window = CryzenHub:CreateWindow({
    Title = "CryzenHub Example",
    Size = UDim2.new(0, 500, 0, 350)
})

local mainTab = window:CreateTab("Main")
local settingsTab = window:CreateTab("Settings")

mainTab:CreateLabel({Text = "Main Features"})
mainTab:CreateButton({
    Text = "Print Hello",
    Callback = function()
        print("Hello, world!")
    end
})

mainTab:CreateToggle({
    Text = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

mainTab:CreateSlider({
    Text = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

settingsTab:CreateLabel({Text = "Settings"})
settingsTab:CreateDropdown({
    Text = "Quality",
    Options = {"Low", "Medium", "High", "Ultra"},
    Default = "Medium",
    Callback = function(option)
        print("Quality set to:", option)
    end
})

settingsTab:CreateInput({
    Text = "Custom Name",
    Placeholder = "Enter your name",
    Callback = function(text)
        print("Name set to:", text)
    end
})
```

## License

This library is free to use for any purpose. Credit is appreciated but not required.

## Credits

Created by CryzenHub Team
```

This implementation provides a comprehensive UI library with a clean, modern design. The library includes all the common UI elements (buttons, toggles, sliders, dropdowns, text inputs) with a consistent look and feel, along with a detailed README explaining how to use it.

The code is well-structured, commented, and includes features like:
- Draggable window
- Tab system
- Smooth animations
- Customizable theme
- API methods for each UI element
- Responsive layout
