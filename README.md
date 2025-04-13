# How to Use the Ultra Lord UI Library

## 1. Loading the Library

First, you need to load the library using `game:HttpGet` and `loadstring`:

```lua
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/source.lua"))()
-- UltraLordLib now holds the library's functions
```

# 2. Create The Main Window
```lua
local Window = UltraLordLib:MakeWindow({
    Name = "My Awesome UI",       -- Title of the window [cite: 46]
    Size = UDim2.new(0, 500, 0, 350), -- Size of the window [cite: 46]
    Theme = "Dark"                 -- Optional theme ("Default", "Dark", "Light", "Rainbow") [cite: 47]
    -- Icon = "rbxassetid://..."   -- Optional window icon [cite: 46, 50, 51]
    -- KeySystem = true             -- Optional: Enable the key system [cite: 46, 47]
    -- KeySettings = { ... }      -- Optional: Settings for the key system [cite: 47]
})

-- If KeySystem is enabled and validation fails, Window will be false[cite: 47].
if not Window then return end -- Stop script if key system fails
```
or

# 3. optional key system
```lua
local Window = UltraLordLib:MakeWindow({
    Name = "Protected UI",
    Size = UDim2.new(0, 500, 0, 350),
    Theme = "Dark",
    KeySystem = true, -- Enable key system [cite: 46]
    KeySettings = {   -- Configure the key system [cite: 47]
        Title = "Enter Key", -- [cite: 25]
        Subtitle = "Enter your access key below.", -- [cite: 25]
        -- KeyList = {"key1", "secret_key"}, -- Option 1: List of valid keys [cite: 25]
        CustomKeyFunction = function(inputKey) -- Option 2: Custom validation function [cite: 25, 37]
            -- Example: Check if the key matches a specific pattern or web request
            return string.sub(inputKey, 1, 4) == "PRO-"
        end,
        SaveKey = true, -- Optional: Try to save/load the key locally [cite: 25, 26, 38]
        OnCorrect = function() -- Runs after correct key [cite: 25, 41]
            print("Key accepted!")
        end,
        OnIncorrect = function(inputKey) -- Runs after incorrect key [cite: 25, 44]
            print("Incorrect key entered:", inputKey)
        end
    }
})

if not Window then
    print("Key validation failed or user closed.")
    return
end
-- Continue with UI setup...
```

# 4. Adding Tab
```lua
local MainTab = Window:CreateTab({
    Name = "Main",                -- Text on the tab button [cite: 57]
    Icon = "rbxassetid://7072706318" -- Optional icon for the tab [cite: 57, 59]
})

local SettingsTab = Window:CreateTab({ Name = "Settings" }) -- Another tab [cite: 57]

-- The first tab created is automatically selected[cite: 190].
```

# 5. Adding button
```lua
MainTab:CreateButton({
    Text = "Click Me!",        -- Button text [cite: 73]
    -- Icon = "rbxassetid://..." -- Optional button icon [cite: 73, 76, 77]
    Callback = function()      -- Function to run when clicked [cite: 73, 79]
        print("Button clicked!")
    end
})
```

# 6. Adding Toggle
```lua
local myToggle = MainTab:CreateToggle({
    Text = "Enable Feature", -- Label text [cite: 86]
    Default = false,         -- Initial state (true=on, false=off) [cite: 86, 92]
    -- Enabled = true,      -- Optional: Set if interactable initially [cite: 86]
    Callback = function(isEnabled) -- Function runs on state change [cite: 86, 96]
        print("Feature enabled:", isEnabled)
    end
})

-- You can control the toggle programmatically:
-- myToggle:SetValue(true)  -- Turns the toggle on [cite: 99]
-- local currentState = myToggle:GetValue() [cite: 100]
-- myToggle:SetEnabled(false) -- Disables the toggle [cite: 100, 101]
```

# 7. Adding Silder
```lua
local mySlider = MainTab:CreateSlider({
    Text = "Speed",          -- Label text [cite: 102]
    Min = 10,                -- Minimum value [cite: 103]
    Max = 100,               -- Maximum value [cite: 103]
    Default = 16,            -- Initial value [cite: 103, 112]
    Precision = 0,           -- Decimal places (0 for integer) [cite: 103, 113]
    Callback = function(value) -- Function runs when value changes [cite: 103, 116]
        print("Speed set to:", value)
    end
})

-- You can control the slider programmatically:
-- mySlider:SetValue(50) -- Sets the slider's value [cite: 123]
-- local currentValue = mySlider:GetValue() [cite: 123]
```

# 8. Adding Label

```lua
local myLabel = MainTab:CreateLabel({ Text = "This is informational text." }) -- [cite: 124]

-- You can change the label's text:
-- myLabel:SetText("Updated information.") [cite: 128]
```
# 9. Adding Textbox

```lua
local myTextbox = MainTab:CreateTextbox({
    Text = "Enter Name:",            -- Label text [cite: 129, 133]
    PlaceholderText = "Type here...", -- Text shown when empty [cite: 129, 136]
    Default = "",                   -- Initial text [cite: 130, 136]
    -- ClearOnFocus = true,         -- Optional: Clear text on focus [cite: 130, 136]
    Callback = function(text, enterPressed) -- Function runs when focus is lost [cite: 130, 138]
        print("Textbox value:", text, "Enter pressed:", enterPressed)
    end
})

-- You can control the textbox programmatically:
-- myTextbox:SetValue("New Text") [cite: 138]
-- local currentValue = myTextbox:GetValue() [cite: 139]
```

# 10. Adding DropDown

```lua
local optionsList = {"Option A", "Option B", "Option C"}
local myDropdown = MainTab:CreateDropdown({
    Text = "Select Option:",  -- Label text [cite: 140]
    Options = optionsList,    -- Table of string options [cite: 141, 169]
    Default = optionsList[1], -- Initial selection [cite: 141, 146]
    Callback = function(selectedOption) -- Function runs on selection change [cite: 141, 161]
        print("Selected:", selectedOption)
    end
})

-- You can control the dropdown programmatically:
-- myDropdown:SetValue("Option B") -- Selects "Option B" if it exists [cite: 181, 182]
-- local currentValue = myDropdown:GetValue() [cite: 183]
-- myDropdown:Refresh({"New Option 1", "New Option 2"}, false) -- Updates options [cite: 183, 184, 185]
```
# 11. Adding Notification

```lua
UltraLordLib:CreateNotification({
    Title = "Action Complete",     -- Notification title [cite: 19]
    Description = "The task finished successfully.", -- Body text [cite: 20]
    Duration = 3,                  -- Display time in seconds [cite: 20]
    -- Icon = "rbxassetid://..."   -- Optional icon [cite: 20, 21]
})

-- Or using the window object:
-- Window:Notify({ Title = "Warning", Description = "Something needs attention." }) [cite: 193]
```
