## How to Use CryzenHub UI Library V2.3 (Fluent Design Edition)

### Basic Setup

```lua
-- Load the library
local CryzenLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/CryzenHub/main/source.lua"))()

-- Create a window
local Window = CryzenLib:MakeWindow({
    Name = "CryzenHub - Game Name", -- Title of your script hub
    Theme = "Fluent", -- Choose theme: Fluent, Dark, Light, Midnight, Aqua
    IntroEnabled = true, -- Enable intro animation
    IntroText = "CryzenHub",
    IntroIcon = "rbxassetid://10618644218",
    Icon = "rbxassetid://10618644218", -- Hub icon (optional)
    SaveConfig = true, -- Enable configuration saving
    ConfigFolder = "CryzenHubConfig" -- Folder to save configs
})

-- Create a tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://7733964368", -- Tab icon (optional)
    PremiumOnly = false -- Set to true to make this tab premium only
})

-- Create a section in the tab
local MainSection = MainTab:AddSection({
    Name = "Main Features"
})

-- Add elements to the section
MainSection:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

-- Add a toggle
local Toggle = MainSection:AddToggle({
    Name = "Toggle Feature",
    Default = false, -- Default state
    Save = true, -- Save toggle state
    Flag = "toggleFeature", -- Unique identifier for saving
    Callback = function(Value)
        print("Toggle is now:", Value)
    end
})

-- Add a slider
local Slider = MainSection:AddSlider({
    Name = "Walkspeed",
    Min = 16, -- Minimum value
    Max = 500, -- Maximum value
    Default = 16, -- Default value
    Increment = 1, -- Step size
    ValueName = "speed", -- Unit name
    Save = true,
    Flag = "walkspeedSlider",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Add a dropdown
local Dropdown = MainSection:AddDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "",
    Save = true,
    Flag = "dropdownOption",
    Callback = function(Option)
        print("Selected:", Option)
    end
})

-- Add theme and settings tabs
local ThemeTab = Window:AddThemeTab() -- Creates a theme customization tab
local SettingsTab = Window:AddSettingsTab() -- Creates a settings tab with UI toggle
```

### Adding a Home Page

```lua
-- Add a custom home page
Window:AddHome({
    Welcome = {
        Title = "Welcome to CryzenHub",
        Content = "Thank you for using our script!"
    },
    Buttons = {
        {
            Title = "Join Discord",
            Icon = "rbxassetid://7733658504",
            Callback = function()
                setclipboard("https://discord.gg/yourserver")
                CryzenLib:MakeNotification({
                    Title = "Discord Link Copied",
                    Content = "Discord invite link copied to clipboard!",
                    Time = 5,
                    Type = "Success"
                })
            end
        },
        {
            Title = "Check Updates",
            Icon = "rbxassetid://7733715400",
            Callback = function()
                CryzenLib:MakeNotification({
                    Title = "Checking Updates",
                    Content = "You are using the latest version!",
                    Time = 5,
                    Type = "Info"
                })
            end
        }
    },
    ShowCredits = true -- Show credits section
})
```

### Using the Key System

```lua
-- Set up key system (do this before creating window)
CryzenLib:SetKey({
    Title = "CryzenHub Key System",
    Subtitle = "Key Verification",
    Note = "Get the key from our Discord server",
    Key = "YourSecretKey123", -- Your secret key
    SaveKey = true, -- Save key for future use
    KeyLink = "https://discord.gg/yourserver", -- Discord invite or key website
    GrabKeyFromSite = false, -- Set to true to fetch key from KeyLink
    MaxAttempts = 5,
    RejectMessage = "Invalid key! Please try again.",
    Callback = function() 
        print("Key verified successfully!")
    end
})

-- Then create your window
local Window = CryzenLib:MakeWindow({
    Name = "CryzenHub"
    -- other options...
})
```

### Creating Notifications

```lua
-- Create a notification
CryzenLib:MakeNotification({
    Title = "Notification Title",
    Content = "This is a notification message",
    Time = 5, -- Duration in seconds
    Type = "Info" -- Info, Success, Error, Warning
})

-- Example success notification
CryzenLib:MakeNotification({
    Title = "Success!",
    Content = "Operation completed successfully",
    Time = 3,
    Type = "Success"
})

-- Example error notification
CryzenLib:MakeNotification({
    Title = "Error",
    Content = "Something went wrong!",
    Time = 3,
    Type = "Error"
})

-- Example warning notification
CryzenLib:MakeNotification({
    Title = "Warning",
    Content = "This action might be risky",
    Time = 3,
    Type = "Warning"
})
```

### Manipulating UI Elements After Creation

```lua
-- Update toggle value
Toggle:Set(true)

-- Update slider value
Slider:Set(100)

-- Update dropdown options
Dropdown:Refresh({"New Option 1", "New Option 2"}, true) -- true to clear previous options
Dropdown:Set("New Option 1") -- Set selected option

-- Access saved values
local toggleValue = CryzenLib.Flags["toggleFeature"].Value
local sliderValue = CryzenLib.Flags["walkspeedSlider"].Value
local dropdownValue = CryzenLib.Flags["dropdownOption"].Value
```

### Creating Advanced UI Elements

```lua
-- Create a keybind
local Bind = MainSection:AddBind({
    Name = "Speed Boost",
    Default = Enum.KeyCode.LeftShift,
    Hold = true, -- Hold mode (true) or toggle mode (false)
    Save = true,
    Flag = "speedBoostKey",
    Callback = function(Value)
        if Value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

-- Create a textbox
MainSection:AddTextbox({
    Name = "Player Name",
    Default = "",
    TextDisappear = false, -- Whether text disappears after losing focus
    Callback = function(Value)
        print("Entered text:", Value)
    end
})

-- Create a color picker
local ColorPicker = MainSection:AddColorpicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Save = true,
    Flag = "espColor",
    Callback = function(Value)
        print("Selected color:", Value)
    end
})

-- Create a label
local Label = MainSection:AddLabel("This is a label")
-- Update label text
Label:Set("Updated label text")
-- Change label color
Label:SetColor(Color3.fromRGB(0, 255, 0))

-- Create a paragraph
local Paragraph = MainSection:AddParagraph("Title", "This is a longer text that explains something in detail.")
-- Update paragraph
Paragraph:SetTitle("New Title")
Paragraph:SetContent("Updated content text")
```

### Mobile Support

The library automatically detects mobile devices and provides a mobile-friendly interface with a toggle button to show/hide the UI.

### Troubleshooting Common Issues

1. **If you get "attempt to call nil value" error:**
   - Make sure you're using the correct function names
   - Check that you're creating elements in the right order (Window → Tab → Section → Element)
   - Verify your key system is properly set up if you're using it

2. **If UI elements don't appear:**
   - Check for errors in the output
   - Ensure you're not trying to create elements before the library is fully loaded

3. **If the UI looks incorrect:**
   - Try using a different theme
   - Make sure your game allows custom UIs

4. **If configuration saving doesn't work:**
   - Ensure you've set `SaveConfig = true` in your window configuration
   - Check that you've added the `Save = true` and `Flag = "uniqueName"` parameters to elements

This updated version of CryzenHub UI Library features a sleek Fluent Design-inspired interface with improved animations, better mobile support, and fixed error handling to prevent the "attempt to call nil value" error.
