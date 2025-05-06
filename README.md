## How to Use CryzenHub UI Library

1. Basic Setup

-- Load the library
lua```local CryzenLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/username/CryzenHub.lua"))()```

-- Create a window
lua ```local Window = CryzenLib:CreateWindow({
    Title = "CryzenHub - Game Name",
    Size = UDim2.new(0, 550, 0, 400), -- Optional, default is 550x400
    Theme = CryzenLib.Theme -- Optional, uses default theme if not specified
})```

-- Create a tab
lua```local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "rbxassetid://7734053495" -- Optional
})```

-- Create a section
lua```lualocal MainSection = MainTab:AddSection({
    Title = "Features"
})```

2. Adding UI Elements

Button
lua```MainSection:AddButton({
    Title = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})```

Toggle
lua```local Toggle = MainSection:AddToggle({
    Title = "Toggle Feature",
    Default = false, -- Optional, default is false
    Callback = function(Value)
        print("Toggle is now:", Value)
    end,
    Flag = "myToggle" -- Optional, for saving/loading configs
})```

-- You can change the toggle state programmatically
lua```Toggle:Set(true)```

Slider
lua```local Slider = MainSection:AddSlider({
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
})```

-- You can change the slider value programmatically
lua```Slider:Set(100)```

Dropdown
lua```local Dropdown = MainSection:AddDropdown({
    Title = "Select Option",
    Items = {"Option 1", "Option 2", "Option 3"},
    Default = "", -- Optional
    Multi = false, -- Optional, enables multi-selection
    Callback = function(Selected)
        print("Selected:", Selected)
    end,
    Flag = "myDropdown" -- Optional
})```

-- Update dropdown options
lua```Dropdown:Refresh({"New Option 1", "New Option 2"}, true) -- true to clear old options```

-- Set selection programmatically
lua```Dropdown:Set("New Option 1")```

-- For multi-select dropdowns
lua```local MultiDropdown = MainSection:AddDropdown({
    Title = "Multi-Select",
    Items = {"Option 1", "Option 2", "Option 3"},
    Multi = true,
    Callback = function(Selected)
        for Item, _ in pairs(Selected) do
            print("Selected:", Item)
        end
    end
})```

-- Set multiple selections
lua```MultiDropdown:Set({["Option 1"] = true, ["Option 3"] = true})```

Textbox
lua```local Textbox = MainSection:AddTextbox({
    Title = "Enter Text",
    Default = "", -- Optional
    Placeholder = "Type here...", -- Optional
    ClearOnFocus = false, -- Optional
    Callback = function(Text, EnterPressed)
        print("Text entered:", Text)
        print("Enter pressed:", EnterPressed)
    end,
    Flag = "myTextbox" -- Optional
})```

-- Set text programmatically
lua```Textbox:Set("New text")```

Keybind
lua```local Keybind = MainSection:AddKeybind({
    Title = "Keybind",
    Default = Enum.KeyCode.E, -- Optional
    Callback = function()
        print("Keybind pressed!")
    end,
    ChangedCallback = function(NewKey)
        print("Keybind changed to:", NewKey.Name)
    end,
    Flag = "myKeybind" -- Optional
})```

-- Change keybind programmatically
lua```Keybind:Set(Enum.KeyCode.F)```

Colorpicker
lua```local Colorpicker = MainSection:AddColorpicker({
    Title = "Select Color",
    Default = Color3.fromRGB(255, 0, 0), -- Optional
    Callback = function(Color, Alpha)
        print("Color selected:", Color, "Alpha:", Alpha)
    end,
    Flag = "myColor" -- Optional
})```

-- Set color programmatically
lua```Colorpicker:Set(Color3.fromRGB(0, 255, 0), 0.5) -- Color and optional alpha```

Label
lua```local Label = MainSection:AddLabel({
    Text = "This is a label",
    Color = Color3.fromRGB(255, 255, 255) -- Optional
})```

-- Update label text
lua```Label:SetText("Updated label")```

-- Change label color
lua```Label:SetColor(Color3.fromRGB(255, 0, 0))```

Paragraph
lua```local Paragraph = MainSection:AddParagraph({
    Title = "Information",
    Content = "This is a longer text that provides detailed information about something important."
})```

-- Update paragraph
lua```Paragraph:SetTitle("New Title")
Paragraph:SetContent("Updated content with new information.")```

3. Creating Multiple Tabs

lua```local CombatTab = Window:AddTab({
    Title = "Combat",
    Icon = "rbxassetid://7733774602"
})```

lua```local SettingsTab = Window:AddTab({
    Title = "Settings",
    Icon = "rbxassetid://7734053495"
})```

-- Add sections to each tab
lua```local CombatSection = CombatTab:AddSection({
    Title = "Combat Options"
})```

lua```local SettingsSection = SettingsTab:AddSection({
    Title = "General Settings"
})```

4. Using Notifications

lua```CryzenLib:Notify({
    Title = "Success",
    Content = "Operation completed successfully!",
    Duration = 5, -- Seconds
    Type = "Success" -- Info, Success, Error, Warning
})```

-- Different notification types
lua```CryzenLib:Notify({
    Title = "Error",
    Content = "Something went wrong!",
    Type = "Error"
})```

lua```CryzenLib:Notify({
    Title = "Warning",
    Content = "This action may cause issues!",
    Type = "Warning"
})```

lua```CryzenLib:Notify({
    Title = "Information",
    Content = "This is some useful information.",
    Type = "Info"
})```

5. Using Key System

lua```-- Set up key system before creating the window
CryzenLib:SetKey({
    Key = "SecretKey123",
    SaveKey = true -- Optional, saves the key for future use
})```

lua```-- Then create your window
local Window = CryzenLib:CreateWindow({
    Title = "CryzenHub - Game Name"
})```

6. Using Configuration Saving

lua```-- Enable configuration saving
CryzenLib.SaveConfig = true
CryzenLib.ConfigFolder = "MyCryzenConfig" -- Optional, default is "CryzenHub"```

lua```-- Create window with flags for saving
local Window = CryzenLib:CreateWindow({
    Title = "CryzenHub - Game Name"
})```

lua```-- Use flags when creating elements to save their values
local Toggle = MainSection:AddToggle({
    Title = "Save This Setting",
    Default = false,
    Flag = "savedToggle"
})```

lua```-- Save configuration manually
CryzenLib:SaveConfiguration(game.GameId)```

lua```-- Load configuration manually (automatically attempted on startup)
CryzenLib:LoadConfiguration(game.GameId)```

7. Controlling Window Visibility

lua`-- Show/hide window
Window:Show()
Window:Hide()
Window:Toggle()`

lua`-- Default toggle key is RightControl
-- You can also destroy the window completely
Window:Destroy()`
