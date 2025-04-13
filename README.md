# How to Use the Ultra Lord UI Library

## 1. Loading the Library

First, you need to load the library using `game:HttpGet` and `loadstring`:

```lua
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/source.lua"))()
-- UltraLordLib now holds the library's functions
```

# 2. Create The Main Window
```lua
local Window = UltraLordLibrary:MakeWindow({
    Name = "Ultra Lord Example",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Default", -- Options: Default, Dark, Light, Rainbow
    Icon = "rbxassetid://10618644218", -- Optional icon
    ToggleKeybind = Enum.KeyCode.LeftControl -- Key to toggle UI visibility
})
```
or

# 3. key system
```lua
local Window = UltraLordLibrary:MakeWindow({
    Name = "Protected Script",
    KeySystem = true,
    KeySettings = {
        Title = "Authentication",
        Subtitle = "Enter your license key",
        KeyList = {"key1", "key2", "key3"},
        SaveKey = true,
        FilePath = "MyScriptKeys.json",
        OnCorrect = function()
            print("Correct key entered!")
        end,
        OnIncorrect = function(key)
            print("Incorrect key:", key)
        end
    }
})
```

# 4. Adding Tab
```lua
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10723424505" -- Optional tab icon
})

local SettingsTab = Window:CreateTab({
    Name = "Settings"
})
```

# 5. Adding button
```lua
MainTab:CreateButton({
    Text = "Click Me",
    Icon = "rbxassetid://10723424505", -- Optional
    Callback = function()
        print("Button clicked!")
    end
})
```

# 6. Adding Toggle
```lua
local MyToggle = MainTab:CreateToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(Value)
        print("Toggle set to:", Value)
    end
})

-- You can change the value later:
MyToggle:SetValue(true)

-- Get the current value:
local currentValue = MyToggle:GetValue()

-- Enable/disable the toggle:
MyToggle:SetEnabled(false) -- Disables interaction
```

# 7. Adding Silder
```lua
local MySlider = MainTab:CreateSlider({
    Text = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Precision = 1, -- Decimal places
    Callback = function(Value)
        print("Slider value:", Value)
    end
})

-- Set the value programmatically:
MySlider:SetValue(75)

-- Get the current value:
local sliderValue = MySlider:GetValue()
```

# 8. Adding Label

```lua
local MyLabel = MainTab:CreateLabel({
    Text = "This is a label"
})

-- Update the text later:
MyLabel:SetText("Updated text")
```
# 9. Adding Textbox

```lua
local MyTextbox = MainTab:CreateTextbox({
    Text = "Username",
    PlaceholderText = "Enter username...",
    Default = "",
    ClearOnFocus = true,
    Callback = function(Text, EnterPressed)
        print("Input:", Text, "Enter Pressed:", EnterPressed)
    end
})

-- Set the value programmatically:
MyTextbox:SetValue("New value")

-- Get the current value:
local textValue = MyTextbox:GetValue()
```

# 10. Adding DropDown

```lua
local options = {"Option 1", "Option 2", "Option 3"}

local MyDropdown = MainTab:CreateDropdown({
    Text = "Select Option",
    Options = options,
    Default = options[1],
    Callback = function(Option)
        print("Selected:", Option)
    end
})

-- Set the selected option:
MyDropdown:SetValue("Option 2")

-- Get the current option:
local currentOption = MyDropdown:GetValue()

-- Update the options:
MyDropdown:Refresh({"New 1", "New 2", "New 3"}, true) -- Keep selection if possible
```
# 11. Adding Notification

```lua
Window:Notify({
    Title = "Success",
    Description = "Operation completed successfully!",
    Duration = 5, -- Seconds
    Icon = "rbxassetid://10723424505" -- Optional
})
```

# 12. Toggle UI

```lua
-- Toggle programmatically
Window:ToggleUI()
```

# 13. ColorPicker

```lua
local MyColorPicker = MainTab:CreateColorPicker({
    Text = "Select Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
        print("Selected color:", Color)
    end
})

-- Set the color programmatically:
MyColorPicker:SetColor(Color3.fromRGB(0, 255, 0))

-- Get the current color:
local currentColor = MyColorPicker:GetColor()
```

# 14. KeyBind

```lua
local MyKeybind = MainTab:CreateKeybind({
    Text = "Toggle Action",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Keybind pressed!")
    end
})

-- Set the key programmatically:
MyKeybind:SetKey(Enum.KeyCode.G)

-- Get the current key:
local currentKey = MyKeybind:GetKey()
```

# 15. Example Full complete

```lua
local UltraLordLibrary = loadstring(game:HttpGet("YOUR_RAW_SCRIPT_URL"))()

local Window = UltraLordLibrary:MakeWindow({
    Name = "Ultra Lord Example",
    Theme = "Default"
})

local MainTab = Window:CreateTab({
    Name = "Main"
})

MainTab:CreateSection("Features")

MainTab:CreateButton({
    Text = "Click Me",
    Callback = function()
        Window:Notify({
            Title = "Button Clicked",
            Description = "You clicked the button!",
            Duration = 3
        })
    end
})

local toggle = MainTab:CreateToggle({
    Text = "Toggle Feature",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

local slider = MainTab:CreateSlider({
    Text = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Speed:", Value)
    end
})

local dropdown = MainTab:CreateDropdown({
    Text = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(Option)
        print("Selected:", Option)
    end
})

local colorPicker = MainTab:CreateColorPicker({
    Text = "Select Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
        print("Color:", Color)
    end
})

local keybind = MainTab:CreateKeybind({
    Text = "Action Keybind",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Keybind pressed!")
    end
})

local SettingsTab = Window:CreateTab({
    Name = "Settings"
})

SettingsTab:CreateSection("UI Settings")

SettingsTab:CreateButton({
    Text = "Destroy UI",
    Callback = function()
        Window.GUI:Destroy()
    end
})
```

## Create Your own theme

```lua
UltraLordLibrary:CreateTheme("MyTheme", {
    BackgroundColor = Color3.fromRGB(30, 30, 35),
    SidebarColor = Color3.fromRGB(25, 25, 30),
    PrimaryTextColor = Color3.fromRGB(255, 255, 255),
    SecondaryTextColor = Color3.fromRGB(200, 200, 200),
    UIStrokeColor = Color3.fromRGB(60, 60, 70),
    AccentColor = Color3.fromRGB(114, 137, 218),
    ButtonColor = Color3.fromRGB(50, 50, 60),
    ButtonHoverColor = Color3.fromRGB(60, 60, 70),
    ToggleOnColor = Color3.fromRGB(114, 137, 218),
    ToggleOffColor = Color3.fromRGB(80, 80, 90),
    SliderColor = Color3.fromRGB(114, 137, 218),
    SliderBackgroundColor = Color3.fromRGB(50, 50, 60),
    DropdownColor = Color3.fromRGB(40, 40, 50),
    TextboxColor = Color3.fromRGB(45, 45, 55),
    KeySystemColor = Color3.fromRGB(35, 35, 40),
    KeySystemAccentColor = Color3.fromRGB(114, 137, 218),
    NotificationColor = Color3.fromRGB(30, 30, 35),
    MenuToggleIconColor = Color3.fromRGB(255, 255, 255),
    ColorPickerBackgroundColor = Color3.fromRGB(35, 35, 40)
})
```
