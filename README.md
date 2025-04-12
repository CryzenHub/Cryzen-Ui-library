**Complete Full start**

```
local UltraLordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ultra-Lord-Hub/Ultra-Lord-Ui-library/refs/heads/main/source.lua"))()

-- Create window
local Window = UltraLordLib:MakeWindow({
    Name = "Ultra Lord Example",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Dark"
})

-- Create notification
UltraLordLib:CreateNotification("Welcome", "Thanks for using the script!", 5)

-- Create tabs
local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "rbxassetid://7072706318"
})

local WorldTab = Window:CreateTab({
    Name = "World"
})

local SettingsTab = Window:CreateTab({
    Name = "Settings"
})

-- Player Tab Elements
PlayerTab:CreateSection("Character Modifications")

-- Speed settings
local speedEnabled = false
PlayerTab:CreateToggle({
    Text = "Speed Boost",
    Default = false,
    Callback = function(Value)
        speedEnabled = Value
        if speedEnabled then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

-- Jump power settings
local jumpPower = 50
local JumpSlider = PlayerTab:CreateSlider({
    Text = "Jump Power",
    Min = 50,
    Max = 250,
    Default = 50,
    Precision = 0,
    Callback = function(Value)
        jumpPower = Value
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

-- Teleport function
PlayerTab:CreateSection("Teleportation")

local teleportLocations = {
    ["Spawn"] = Vector3.new(0, 10, 0),
    ["Shop"] = Vector3.new(100, 10, 100),
    ["Arena"] = Vector3.new(-100, 10, -100)
}

PlayerTab:CreateDropdown({
    Text = "Teleport Location",
    Options = {"Spawn", "Shop", "Arena"},
    Default = "Spawn",
    Callback = function(Option)
        local location = teleportLocations[Option]
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(location)
    end
})

-- World Tab Elements
WorldTab:CreateSection("Time Controls")

WorldTab:CreateButton({
    Text = "Set Day",
    Callback = function()
        game.Lighting.TimeOfDay = "12:00:00"
    end
})

WorldTab:CreateButton({
    Text = "Set Night",
    Callback = function()
        game.Lighting.TimeOfDay = "00:00:00"
    end
})

WorldTab:CreateSlider({
    Text = "Time of Day",
    Min = 0,
    Max = 24,
    Default = 12,
    Precision = 1,
    Callback = function(Value)
        local hours = math.floor(Value)
        local minutes = math.floor((Value - hours) * 60)
        game.Lighting.TimeOfDay = string.format("%02d:%02d:00", hours, minutes)
    end
})
```
