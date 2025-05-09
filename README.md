# CryzenHub UI Library v1.1.0 (Beta)

A premium, feature-rich UI library for Roblox Luau scripts with a completely redesigned interface, key system, and numerous enhancements.

## What's New in v1.1.0 (Beta)

- **Complete UI redesign**: Modern flat design with improved visual aesthetics
- **Key system**: Secure your script with a customizable key verification system
- **Tabbed windows**: Better organization for complex UIs
- **Search functionality**: Easily find tabs and elements
- **Rich text support**: Format your text with colors, bold, italics, etc.
- **Tooltips**: Add helpful information to any UI element
- **Enhanced animations**: Smooth transitions and visual effects
- **Mobile support**: Responsive design for all devices
- **Loading screen**: Professional splash screen with animations
- **Improved performance**: Optimized rendering and resource usage

## Key System Features

- Multiple key verification methods
- Automatic key saving between sessions
- Configurable attempt limits
- Option to fetch keys from external websites
- Custom error messages and instructions

## Getting Started

### Installation

```lua
local CryzenHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/CryzenHub/Cryzen-Ui-library/refs/heads/main/source'))()
```

### Basic Usage with Key System

```lua
-- Configure the key system (optional, default settings shown)
CryzenHub.KeySystem = true -- Enable/disable key system
CryzenHub.KeySettings = {
    Title = "CryzenHub Key System",
    Subtitle = "Key verification required",
    Note = "Get your key from discord.gg/cryzen",
    SaveKey = true, -- The key saves in a file
    GrabKeyFromSite = false, -- Get key from a site
    Key = {"CRYZEN-DEMO", "BETA-TESTER"}, -- List of working keys
    FileName = "CryzenHubKey", -- File name for saved key
    KeyUrl = "https://pastebin.com/raw/YOURCODE", -- URL for key if GrabKeyFromSite is true
    MaxAttempts = 5 -- Max incorrect key attempts before closing
}

-- Create a window
local window = CryzenHub:CreateWindow({
    Title = "CryzenHub Example",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Aqua", -- Use a theme preset (Default, Light, Discord, Aqua)
    DefaultTab = "Main" -- Tab to be selected by default
})

-- Create tabs with optional icons
local mainTab = window:CreateTab("Main", "rbxassetid://7072718444")
local settingsTab = window:CreateTab("Settings", "rbxassetid://7072725299")

-- Create a section in the main tab
local generalSection = mainTab:CreateSection("General Features")

-- Add elements to the section with tooltips
generalSection:CreateButton({
    Text = "Click Me",
    Tooltip = "This is a helpful tooltip",
    Callback = function()
        window:Notify({
            Title = "Button Clicked",
            Content = "You clicked the button!",
            Duration = 3,
            Type = "Success"
        })
    end
})
```

## Documentation

### Key System Configuration

```lua
-- Enable or disable the key system
CryzenHub.KeySystem = true

-- Configure key system settings
CryzenHub.KeySettings = {
    Title = "Script Key System",  -- Title shown on the key system window
    Subtitle = "Key Required",    -- Subtitle shown below the title
    Note = "Get your key from our Discord",  -- Note shown to guide users
    SaveKey = true,               -- Whether to save the key between sessions
    GrabKeyFromSite = false,      -- Whether to fetch the key from a website
    Key = {"KEY1", "KEY2"},       -- Single key or table of valid keys
    FileName = "MyScriptKey",     -- Filename for saved key
    KeyUrl = "https://example.com/key.txt",  -- URL to fetch key from
    MaxAttempts = 5               -- Maximum incorrect attempts allowed
}
```

### Window

#### Creating a Window

```lua
local window = CryzenHub:CreateWindow({
    Title = "My Window",  -- Window title
    Size = UDim2.new(0, 600, 0, 400),  -- Window size
    Theme = "Aqua",  -- Theme preset (Default, Light, Discord, Aqua) or custom theme table
    DefaultTab = "Main",  -- Default selected tab
    SaveConfig = true     -- Whether to save configuration between sessions
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
window:ChangeTheme("Aqua")

-- Or use a custom theme (example shows partial structure)
window:ChangeTheme({
    Primary = Color3.fromRGB(32, 32, 32),
    Secondary = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 120, 215),
    Text = Color3.fromRGB(240, 240, 240),
    -- See full theme structure in source code
})
```

#### Creating a Tab

```lua
local tab = window:CreateTab("Tab Name", "rbxassetid://7072718444")  -- Icon is optional
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
    Tooltip = "Optional tooltip text",  -- Optional tooltip
    Callback = function()
        print("Button clicked!")
    end
})

-- API methods
button:SetText("New Button Text")
```

#### Toggle

```lua
local toggle = section:CreateToggle({
    Text = "Toggle Me",
    Tooltip = "Optional tooltip text",  -- Optional tooltip
    Default = false,  -- Initial state (optional)
    Callback = function(value)
        print("Toggle state:", value)
    end
})

-- API methods
toggle:Set(true)  -- Set toggle state
local state = toggle:Get()  -- Get current state
toggle:SetText("New Toggle Text")
```

#### Slider

```lua
local slider = section:CreateSlider({
    Text = "Slider Example",
    Tooltip = "Optional tooltip text",  -- Optional tooltip
    Min = 0,  -- Minimum value
    Max = 100,  -- Maximum value
    Default = 50,  -- Default value (optional)
    Suffix = "%",  -- Optional suffix for the displayed value
    Precise = false,  -- Whether to use decimal values (optional)
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- API methods
slider:Set(75)  -- Set slider value
local value = slider:Get()  -- Get current value
slider:SetText("New Slider Text")
```

#### Dropdown

```lua
local dropdown = section:CreateDropdown({
    Text = "Select Option",
    Tooltip = "Optional tooltip text",  -- Optional tooltip
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
dropdown:SetText("New Dropdown Text")
```

## Comprehensive Example

```lua
local CryzenHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/CryzenHub/Cryzen-Ui-library/refs/heads/main/source'))()

-- Configure key system
CryzenHub.KeySystem = true
CryzenHub.KeySettings = {
    Title = "CryzenHub Authentication",
    Subtitle = "Key Required",
    Note = "Get your key from our Discord server: discord.gg/cryzen",
    Key = {"CRYZEN-DEMO", "BETA-TESTER"}
}

-- Create window after key verification
local window = CryzenHub:CreateWindow({
    Title = "CryzenHub v1.1.0 Beta",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Aqua",
    DefaultTab = "Main"
})

-- Main tab with sections
local mainTab = window:CreateTab("Main", "rbxassetid://7072718444")
local generalSection = mainTab:CreateSection("General")
local playerSection = mainTab:CreateSection("Player")

-- Settings tab
local settingsTab = window:CreateTab("Settings", "rbxassetid://7072725299")
local configSection = settingsTab:CreateSection("Configuration")
local themeSection = settingsTab:CreateSection("Theme")

-- General section elements
generalSection:CreateButton({
    Text = "Welcome Message",
    Tooltip = "Displays a welcome notification",
    Callback = function()
        window:Notify({
            Title = "Welcome",
            Content = "Thanks for using CryzenHub v1.1.0 Beta!",
            Type = "Success"
        })
    end
})

local autoFarm = generalSection:CreateToggle({
    Text = "Auto Farm",
    Tooltip = "Automatically farms resources",
    Default = false,
    Callback = function(state)
        window:Notify({
            Title = state and "Enabled" or "Disabled",
            Content = "Auto farming has been " .. (state and "enabled" or "disabled"),
            Type = state and "Success" or "Info",
            Duration = 2
        })
    end
})

-- Player section elements
playerSection:CreateSlider({
    Text = "Walk Speed",
    Tooltip = "Adjusts your character's walking speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Suffix = " studs/s",
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

playerSection:CreateSlider({
    Text = "Jump Power",
    Tooltip = "Adjusts your character's jumping power",
    Min = 50,
    Max = 200,
    Default = 50,
    Suffix = " studs",
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

playerSection:CreateDropdown({
    Text = "Teleport To",
    Tooltip = "Teleport to selected location",
    Options = {"Spawn", "Shop", "Boss Area", "Secret Room"},
    Default = "Spawn",
    Callback = function(option)
        window:Notify({
            Title = "Teleporting",
            Content = "Teleporting to " .. option,
            Type = "Info",
            Duration = 2
        })
    end
})

-- Configuration section elements
local keybindOption = configSection:CreateDropdown({
    Text = "Toggle UI Key",
    Options = {"RightShift", "LeftAlt", "RightControl"},
    Default = "RightShift",
    Callback = function(option)
        -- Set UI toggle key
    end
})

-- Theme section elements
local themes = {"Default", "Light", "Discord", "Aqua"}
themeSection:CreateDropdown({
    Text = "UI Theme",
    Options = themes,
    Default = "Aqua",
    Callback = function(theme)
        window:ChangeTheme(theme)
        window:Notify({
            Title = "Theme Changed",
            Content = "The UI theme has been changed to " .. theme,
            Type = "Info",
            Duration = 2
        })
    end
})

-- Show welcome notification
window:Notify({
    Title = "CryzenHub v1.1.0 Beta",
    Content = "Welcome to the beta version! Please report any bugs you find.",
    Duration = 5,
    Type = "Info"
})
```

## License

This library is free to use for any purpose. Credit is appreciated but not required.

## Credits

Created by CryzenHub Team - v1.1.0 Beta
```

This update introduces a major redesign of the CryzenHub UI Library with a modern, flat design aesthetic and several significant new features:

1. **Key System**: A complete key verification system with multiple verification methods, key saving, and attempt limits
2. **Improved Design**: A completely redesigned UI with smooth animations and visual effects
3. **Loading Screen**: Professional splash screen with animations during initialization
4. **Tooltip System**: Informative tooltips for all UI elements
5. **Mobile Support**: Responsive design that works on all devices
6. **Search Functionality**: Ability to search for tabs and elements
7. **Optimized Performance**: Better resource usage and rendering

The code includes detailed comments and is structured for easy maintenance and expansion. The README provides comprehensive documentation on how to use all the new features, along with examples and API reference.
