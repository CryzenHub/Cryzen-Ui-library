CryzenHub UI Library v2.3 - Usage Guide

Getting Started

First, load the library:

local CryzenLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/CryzenHub/Cryzen-Ui-library/refs/heads/main/source.lua"))()

Creating a Window

local Window = CryzenLib:MakeWindow({
    Name = "CryzenHub Example",
    IntroText = "CryzenHub v2.3",
    IntroIcon = "rbxassetid://10618644218",
    Icon = "rbxassetid://10618644218",
    IntroEnabled = true,
    CloseCallback = function()
        print("Window closed")
    end,
    Theme = "Default", -- Default, Dark, Light, Midnight, Oceanic
    SaveConfig = true,
    ConfigFolder = "CryzenHubConfig",
    UseNewLoadingScreen = true,
    LoadingTitle = "CryzenHub",
    LoadingSubtitle = "Loading awesome features..."
})

Setting Up Key System (Optional)

CryzenLib.KeySystem = true
CryzenLib.KeySettings = {
    Title = "CryzenHub Key System",
    Subtitle = "Key Verification",
    Note = "Get your key from our Discord server",
    Key = "EXAMPLE-KEY-12345",
    SaveKey = true,
    GrabKeyFromSite = false,
    KeyLink = "https://discord.gg/yourserver",
    FileName = "CryzenKey",
    MaxAttempts = 5,
    RejectMessage = "Invalid key, please try again."
}

Creating Tabs and Sections

-- Create a tab
local MainTab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://7733960981",
    PremiumOnly = false
})

-- Add a section to the tab
local Section = MainTab:AddSection({
    Name = "Basic Controls"
})

Adding Elements

Button

local MyButton = Section:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end,
    Icon = "rbxassetid://7733964370" -- Optional icon
})

-- You can update the button text later
MyButton:Set("New Button Text")

Toggle

local MyToggle = Section:AddToggle({
    Name = "Toggle Feature",
    Default = false,
    Save = true,
    Flag = "myToggleFeature",
    Callback = function(Value)
        print("Toggle is now:", Value)
    end
})

-- You can set the value programmatically
MyToggle:Set(true)

Slider

local MySlider = Section:AddSlider({
    Name = "Walkspeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    ValueName = "studs/s",
    Save = true,
    Flag = "walkspeedValue",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- Set the slider value
MySlider:Set(100)

Dropdown

local MyDropdown = Section:AddDropdown({
    Name = "Select Option",
    Default = "Option 1",
    Options = {"Option 1", "Option 2", "Option 3"},
    Save = true,
    Flag = "selectedOption",
    Callback = function(Value)
        print("Selected:", Value)
    end
})

-- Update dropdown options
MyDropdown:Refresh({"New Option 1", "New Option 2", "New Option 3"}, true) -- true to clear old options

-- Set a specific value
MyDropdown:Set("New Option 2")

Colorpicker

local MyColorpicker = Section:AddColorpicker({
    Name = "UI Color",
    Default = Color3.fromRGB(255, 0, 0),
    Save = true,
    Flag = "uiColor",
    Callback = function(Value)
        print("Color selected:", Value)
    end
})

-- Set a specific color
MyColorpicker:Set(Color3.fromRGB(0, 255, 0))

Textbox

local MyTextbox = Section:AddTextbox({
    Name = "Enter Text",
    Default = "Default text",
    TextDisappear = false,
    Callback = function(Value)
        print("Text entered:", Value)
    end
})

Keybind

local MyKeybind = Section:AddBind({
    Name = "Keybind",
    Default = Enum.KeyCode.E,
    Hold = false,
    Save = true,
    Flag = "actionKey",
    Callback = function()
        print("Keybind pressed!")
    end
})

-- Set a specific key
MyKeybind:Set(Enum.KeyCode.F)

Label

local MyLabel = Section:AddLabel({
    Text = "This is a label"
})

-- Update label text
MyLabel:Set("Updated label text")

-- Change label color
MyLabel:SetColor(Color3.fromRGB(255, 0, 0))

Paragraph

local MyParagraph = Section:AddParagraph({
    Title = "Important Information",
    Content = "This is a longer text that provides detailed information about a feature or functionality. It will automatically wrap to fit the available space."
})

-- Update paragraph content
MyParagraph:SetTitle("New Title")
MyParagraph:SetContent("New content text goes here...")

Adding Home Tab Content

Window:AddHome({
    Welcome = {
        Title = "Welcome to CryzenHub",
        Content = "Thanks for using our UI library!"
    },
    Buttons = {
        {
            Title = "Join Discord",
            Icon = "rbxassetid://7733964370",
            Callback = function()
                setclipboard("https://discord.gg/yourserver")
                CryzenLib:MakeNotification({
                    Title = "Discord Link Copied",
                    Content = "Discord invite link copied to clipboard!",
                    Time = 3,
                    Type = "Info"
                })
            end
        },
        {
            Title = "Copy Script",
            Callback = function()
                setclipboard("loadstring(game:HttpGet('https://raw.githubusercontent.com/Cryzen-Hub/CryzenHub/main/loader.lua'))()")
            end
        }
    },
    ShowCredits = true -- Show credits section
})

Adding Theme and Settings Tabs

-- Add built-in theme customization tab
local ThemeTab = Window:AddThemeTab()

-- Add built-in settings tab
local SettingsTab = Window:AddSettingsTab()

Creating Notifications

CryzenLib:MakeNotification({
    Title = "Script Loaded",
    Content = "CryzenHub has been successfully loaded!",
    Time = 5,
    Type = "Success" -- Info, Success, Error, Warning
})

Other Useful Functions

-- Change theme
Window:SetTheme("Dark")

-- Destroy the UI
CryzenLib:Destroy()

Key Features in v2.3

Enhanced Mobile Support: Better touch controls and responsive design for mobile devices
Improved Performance: Optimized animations and rendering
New Loading Screen: Optional animated loading screen with progress bar
Advanced Key System: Multiple verification methods and persistent key storage
Enhanced Notifications: Better looking notifications with progress bars and icons
Improved Theme Customization: More theme options and custom color support
Better Config Saving: More reliable configuration saving and loading
UI Animations: Smoother transitions and animations throughout the UI
Premium Features: Support for premium-only features
Improved Element Design: Cleaner, more modern look for all UI elements

Tips for Best Usage

Use Flags for Important Values: Flags allow you to access values from anywhere in your script
Enable Config Saving: This will remember user settings between sessions
Use Icons: Icons make your UI more intuitive and visually appealing
Organize with Tabs and Sections: Keep your UI organized by grouping related features
Add Home Tab Content: Provide a welcome screen with useful information and quick access buttons
Use Appropriate Notification Types: Different notification types (Success, Error, etc.) help users understand the context
Test on Both PC and Mobile: Ensure your UI works well on all platforms
Add Key Verification: If you want to restrict access to your script
