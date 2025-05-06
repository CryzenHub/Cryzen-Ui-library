## How to Use CryzenHub UI Library

1. Basic Setup

-- Load the library
`lualocal CryzenLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/CryzenHub.lua"))()`

-- Create a window
`lualocal Window = CryzenLib:CreateWindow({
    Title = "CryzenHub - Game Name",
    Size = UDim2.new(0, 550, 0, 400), -- Optional, default is 550x400
    Theme = CryzenLib.Theme -- Optional, uses default theme if not specified
})`

-- Create a tab
`lualocal MainTab = Window:AddTab({
    Title = "Main",
    Icon = "rbxassetid://7734053495" -- Optional
})`

-- Create a section
`lualocal MainSection = MainTab:AddSection({
    Title = "Features"
})`

2. Adding UI Elements

Button
MainSection:AddButton({
    Title = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

Toggle
local Toggle = MainSection:AddToggle({
    Title = "Toggle Feature",
    Default = false, -- Optional, default is false
    Callback = function(Value)
        print("Toggle is now:", Value)
    end,
    Flag = "myToggle" -- Optional, for saving/loading configs
})

-- You can change the toggle state programmatically
Toggle:Set(true)

Slider
local Slider = MainSection:AddSlider({
    Title = "Walkspeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1, -- Optional, default is 1
    ValueSuffix = " studs/s", -- Optional, adds a suffix to the displayed value
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
    Flag = "walkspeedSlider" -- Optional
})

-- You can change the slider value programmatically
Slider:Set(100)

Dropdown
local Dropdown = MainSection:AddDropdown({
    Title = "Select Option",
    Items = {"Option 1", "Option 2", "Option 3"},
    Default = "", -- Optional
    Multi = false, -- Optional, enables multi-selection
    Callback = function(Selected)
        print("Selected:", Selected)
    end,
    Flag = "myDropdown" -- Optional
})

-- Update dropdown options
Dropdown:Refresh({"New Option 1", "New Option 2"}, true) -- true to clear old options

-- Set selection programmatically
Dropdown:Set("New Option 1")

-- For multi-select dropdowns
local MultiDropdown = MainSection:AddDropdown({
    Title = "Multi-Select",
    Items = {"Option 1", "Option 2", "Option 3"},
    Multi = true,
    Callback = function(Selected)
        for Item, _ in pairs(Selected) do
            print("Selected:", Item)
        end
    end
})

-- Set multiple selections
MultiDropdown:Set({["Option 1"] = true, ["Option 3"] = true})

Textbox
local Textbox = MainSection:AddTextbox({
    Title = "Enter Text",
    Default = "", -- Optional
    Placeholder = "Type here...", -- Optional
    ClearOnFocus = false, -- Optional
    Callback = function(Text, EnterPressed)
        print("Text entered:", Text)
        print("Enter pressed:", EnterPressed)
    end,
    Flag = "myTextbox" -- Optional
})

-- Set text programmatically
Textbox:Set("New text")

Keybind
local Keybind = MainSection:AddKeybind({
    Title = "Keybind",
    Default = Enum.KeyCode.E, -- Optional
    Callback = function()
        print("Keybind pressed!")
    end,
    ChangedCallback = function(NewKey)
        print("Keybind changed to:", NewKey.Name)
    end,
    Flag = "myKeybind" -- Optional
})

-- Change keybind programmatically
Keybind:Set(Enum.KeyCode.F)

Colorpicker
local Colorpicker = MainSection:AddColorpicker({
    Title = "Select Color",
    Default = Color3.fromRGB(255, 0, 0), -- Optional
    Callback = function(Color, Alpha)
        print("Color selected:", Color, "Alpha:", Alpha)
    end,
    Flag = "myColor" -- Optional
})

-- Set color programmatically
Colorpicker:Set(Color3.fromRGB(0, 255, 0), 0.5) -- Color and optional alpha

Label
local Label = MainSection:AddLabel({
    Text = "This is a label",
    Color = Color3.fromRGB(255, 255, 255) -- Optional
})

-- Update label text
Label:SetText("Updated label")

-- Change label color
Label:SetColor(Color3.fromRGB(255, 0, 0))

Paragraph
local Paragraph = MainSection:AddParagraph({
    Title = "Information",
    Content = "This is a longer text that provides detailed information about something important."
})

-- Update paragraph
Paragraph:SetTitle("New Title")
Paragraph:SetContent("Updated content with new information.")

3. Creating Multiple Tabs

local CombatTab = Window:AddTab({
    Title = "Combat",
    Icon = "rbxassetid://7733774602"
})

local SettingsTab = Window:AddTab({
    Title = "Settings",
    Icon = "rbxassetid://7734053495"
})

-- Add sections to each tab
local CombatSection = CombatTab:AddSection({
    Title = "Combat Options"
})

local SettingsSection = SettingsTab:AddSection({
    Title = "General Settings"
})

4. Using Notifications

CryzenLib:Notify({
    Title = "Success",
    Content = "Operation completed successfully!",
    Duration = 5, -- Seconds
    Type = "Success" -- Info, Success, Error, Warning
})

-- Different notification types
CryzenLib:Notify({
    Title = "Error",
    Content = "Something went wrong!",
    Type = "Error"
})

CryzenLib:Notify({
    Title = "Warning",
    Content = "This action may cause issues!",
    Type = "Warning"
})

CryzenLib:Notify({
    Title = "Information",
    Content = "This is some useful information.",
    Type = "Info"
})

5. Using Key System

-- Set up key system before creating the window
CryzenLib:SetKey({
    Key = "SecretKey123",
    SaveKey = true -- Optional, saves the key for future use
})

-- Then create your window
local Window = CryzenLib:CreateWindow({
    Title = "CryzenHub - Game Name"
})

6. Using Configuration Saving

-- Enable configuration saving
CryzenLib.SaveConfig = true
CryzenLib.ConfigFolder = "MyCryzenConfig" -- Optional, default is "CryzenHub"

-- Create window with flags for saving
local Window = CryzenLib:CreateWindow({
    Title = "CryzenHub - Game Name"
})

-- Use flags when creating elements to save their values
local Toggle = MainSection:AddToggle({
    Title = "Save This Setting",
    Default = false,
    Flag = "savedToggle"
})

-- Save configuration manually
CryzenLib:SaveConfiguration(game.GameId)

-- Load configuration manually (automatically attempted on startup)
CryzenLib:LoadConfiguration(game.GameId)

7. Controlling Window Visibility

-- Show/hide window
Window:Show()
Window:Hide()
Window:Toggle()

-- Default toggle key is RightControl
-- You can also destroy the window completely
Window:Destroy()

Additional Tips

Mobile Support: The library automatically detects if the user is on mobile and adapts accordingly.

Error Handling: Use pcall when loading the library to handle potential errors:
      local Success, CryzenLib = pcall(function()
       return loadstring(game:HttpGet("https://raw.githubusercontent.com/username/CryzenHub.lua"))()
   end)

   if not Success then
       warn("Failed to load CryzenHub: " .. CryzenLib)
       return
   end

Flags: Use flags to track and save element values. You can access them via CryzenLib.Flags[FlagName].

UI Organization: Group related features into sections and tabs for better organization.

Theme Customization: Modify CryzenLib.Theme before creating your window to customize colors.

This comprehensive guide should help you use all features of the CryzenHub UI Library effectively.
