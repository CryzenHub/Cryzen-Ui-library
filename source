--[[
 ██████╗██████╗ ██╗   ██╗███████╗███████╗███╗   ██╗    ██╗  ██╗██╗   ██╗██████╗ 
██╔════╝██╔══██╗╚██╗ ██╔╝╚══███╔╝██╔════╝████╗  ██║    ██║  ██║██║   ██║██╔══██╗
██║     ██████╔╝ ╚████╔╝   ███╔╝ █████╗  ██╔██╗ ██║    ███████║██║   ██║██████╔╝
██║     ██╔══██╗  ╚██╔╝   ███╔╝  ██╔══╝  ██║╚██╗██║    ██╔══██║██║   ██║██╔══██╗
╚██████╗██║  ██║   ██║   ███████╗███████╗██║ ╚████║    ██║  ██║╚██████╔╝██████╔╝
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                                                                               
    CryzenHub V2.3 - Fluent Design Edition
    - Fixed attempt to call nil value errors
    - Redesigned UI with Fluent Design principles
    - Enhanced mobile support
    - Improved performance and stability
    - Better error handling and debugging
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

-- Create CryzenHub library base
local CryzenLib = {
    Elements = {},
    ThemeObjects = {},
    Connections = {},
    Flags = {},
    Themes = {
        Fluent = {
            Main = Color3.fromRGB(32, 32, 38),
            Second = Color3.fromRGB(38, 38, 46),
            Stroke = Color3.fromRGB(60, 60, 72),
            Divider = Color3.fromRGB(60, 60, 72),
            Text = Color3.fromRGB(240, 240, 245),
            TextDark = Color3.fromRGB(180, 180, 190),
            Accent = Color3.fromRGB(98, 108, 241)
        },
        Dark = {
            Main = Color3.fromRGB(25, 25, 30),
            Second = Color3.fromRGB(32, 32, 38),
            Stroke = Color3.fromRGB(50, 50, 60),
            Divider = Color3.fromRGB(50, 50, 60),
            Text = Color3.fromRGB(240, 240, 245),
            TextDark = Color3.fromRGB(160, 160, 170),
            Accent = Color3.fromRGB(90, 100, 240)
        },
        Light = {
            Main = Color3.fromRGB(240, 240, 245),
            Second = Color3.fromRGB(230, 230, 235),
            Stroke = Color3.fromRGB(200, 200, 210),
            Divider = Color3.fromRGB(200, 200, 210),
            Text = Color3.fromRGB(40, 40, 45),
            TextDark = Color3.fromRGB(100, 100, 110),
            Accent = Color3.fromRGB(90, 100, 240)
        },
        Midnight = {
            Main = Color3.fromRGB(20, 20, 35),
            Second = Color3.fromRGB(28, 28, 45),
            Stroke = Color3.fromRGB(50, 50, 80),
            Divider = Color3.fromRGB(50, 50, 80),
            Text = Color3.fromRGB(240, 240, 255),
            TextDark = Color3.fromRGB(130, 130, 180),
            Accent = Color3.fromRGB(100, 120, 255)
        },
        Aqua = {
            Main = Color3.fromRGB(20, 35, 40),
            Second = Color3.fromRGB(25, 45, 50),
            Stroke = Color3.fromRGB(40, 80, 90),
            Divider = Color3.fromRGB(40, 80, 90),
            Text = Color3.fromRGB(240, 250, 255),
            TextDark = Color3.fromRGB(130, 180, 190),
            Accent = Color3.fromRGB(60, 180, 200)
        }
    },
    SelectedTheme = "Fluent",
    Folder = "CryzenHub",
    SaveCfg = false,
    ConfigFolder = "CryzenHub",
    Version = "2.3.0",
    KeySystem = false,
    KeySettings = {
        Title = "CryzenHub Key System",
        Subtitle = "Key Verification",
        Note = "Enter your key to access the script",
        Key = "",
        KeyLink = "",
        SaveKey = false,
        GrabKeyFromSite = false,
        FileName = "CryzenKey",
        MaxAttempts = 5,
        RejectMessage = "Invalid key, please try again.",
        Callback = function() end
    },
    IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
    Debug = false
}

-- Debug logging function
local function debugLog(...)
    if CryzenLib.Debug then
        print("[CryzenHub Debug]", ...)
    end
end

-- Error handling wrapper
local function safeCall(func, ...)
    if type(func) ~= "function" then
        debugLog("Attempted to call a non-function:", func)
        return
    end
    
    local success, result = pcall(func, ...)
    if not success then
        warn("[CryzenHub Error]", result)
    end
    return success, result
end

-- Load Fluent Icons
local Icons = {}

local Success, Response = pcall(function()
    local Data = game:HttpGet("https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json")
    if Data then
        return HttpService:JSONDecode(Data).icons
    else
        return {}
    end
end)

if not Success then
    warn("[CryzenHub] Failed to load icons. Using fallback icons.")
    Icons = {}
else
    Icons = Response
end

local function GetIcon(IconName)
    if Icons[IconName] ~= nil then
        return Icons[IconName]
    else
        return nil
    end
end

-- Create main UI
local Cryzen = Instance.new("ScreenGui")
Cryzen.Name = "CryzenHub"
Cryzen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Cryzen.ResetOnSpawn = false

-- Protection and initialization
if syn then
    syn.protect_gui(Cryzen)
    Cryzen.Parent = CoreGui
elseif gethui then
    Cryzen.Parent = gethui()
else
    Cryzen.Parent = CoreGui
end

-- Remove duplicate UIs
local function RemoveDuplicates()
    local parent = Cryzen.Parent
    for _, Interface in ipairs(parent:GetChildren()) do
        if Interface.Name == Cryzen.Name and Interface ~= Cryzen then
            Interface:Destroy()
        end
    end
end

pcall(RemoveDuplicates)

-- Core functions
function CryzenLib:IsRunning()
    return Cryzen and Cryzen.Parent ~= nil
end

local function AddConnection(Signal, Function)
    if (not CryzenLib:IsRunning()) then
        return
    end
    local SignalConnect = Signal:Connect(Function)
    table.insert(CryzenLib.Connections, SignalConnect)
    return SignalConnect
end

-- Clean up connections when the UI is destroyed
task.spawn(function()
    while (CryzenLib:IsRunning()) do
        wait(1)
    end

    for _, Connection in next, CryzenLib.Connections do
        if typeof(Connection) == "RBXScriptConnection" and Connection.Connected then
            Connection:Disconnect()
        end
    end
end)

-- Utility functions
local function AddDraggingFunctionality(DragPoint, Main)
    pcall(function()
        local Dragging, DragInput, MousePos, FramePos = false
        
        AddConnection(DragPoint.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                MousePos = Input.Position
                FramePos = Main.Position

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        
        AddConnection(DragPoint.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                DragInput = Input
            end
        end)
        
        AddConnection(UserInputService.InputChanged, function(Input)
            if Input == DragInput and Dragging then
                local Delta = Input.Position - MousePos
                TweenService:Create(Main, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
            end
        end)
    end)
end

local function Create(Name, Properties, Children)
    local Object = Instance.new(Name)
    for i, v in next, Properties or {} do
        Object[i] = v
    end
    for i, v in next, Children or {} do
        v.Parent = Object
    end
    return Object
end

local function CreateElement(ElementName, ElementFunction)
    CryzenLib.Elements[ElementName] = function(...)
        return ElementFunction(...)
    end
end

local function MakeElement(ElementName, ...)
    if CryzenLib.Elements[ElementName] then
        return CryzenLib.Elements[ElementName](...)
    else
        warn("[CryzenHub] Element not found:", ElementName)
        return Create("Frame", {BackgroundTransparency = 1})
    end
end

local function SetProps(Element, Props)
    for Property, Value in next, Props or {} do
        Element[Property] = Value
    end
    return Element
end

local function SetChildren(Element, Children)
    for _, Child in next, Children or {} do
        Child.Parent = Element
    end
    return Element
end

local function Round(Number, Factor)
    local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
    if Result < 0 then
        Result = Result + Factor
    end
    return Result
end

local function GetTextBounds(Text, TextSize, Font)
    return TextService:GetTextSize(Text, TextSize, Font, Vector2.new(math.huge, math.huge))
end

local function GetTheme(Theme)
    if Theme == "Fluent" or not CryzenLib.Themes[Theme] then
        return CryzenLib.Themes["Fluent"]
    else
        return CryzenLib.Themes[Theme]
    end
end

local function AddThemeObject(Object, Type)
    if not CryzenLib.ThemeObjects[Type] then
        CryzenLib.ThemeObjects[Type] = {}
    end
    table.insert(CryzenLib.ThemeObjects[Type], Object)
    if Object:IsA("GuiObject") and Object.BackgroundColor3 ~= nil then
        Object.BackgroundColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme][Type]
    end
    if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
        Object.TextColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme][Type]
    end
    return Object
end

local function SetTheme(Theme)
    if not CryzenLib.Themes[Theme] and Theme ~= "Fluent" then
        warn("[CryzenHub] Theme '" .. Theme .. "' doesn't exist!")
        return
    end
    
    CryzenLib.SelectedTheme = Theme
    
    for Type, Objects in next, CryzenLib.ThemeObjects do
        for _, Object in next, Objects do
            if Object:IsA("GuiObject") and Object.BackgroundColor3 ~= nil then
                TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[Theme][Type]}):Play()
            end
            if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
                TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = CryzenLib.Themes[Theme][Type]}):Play()
            end
            if Object:IsA("ImageLabel") or Object:IsA("ImageButton") and Type == "Accent" then
                TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageColor3 = CryzenLib.Themes[Theme][Type]}):Play()
            end
        end
    end
end

-- Create standard UI elements
local WhitelistedMouse = {
    Enum.UserInputType.MouseButton1,
    Enum.UserInputType.MouseButton2,
    Enum.UserInputType.MouseButton3,
    Enum.UserInputType.Touch
}

local BlacklistedKeys = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.Slash,
    Enum.KeyCode.Tab,
    Enum.KeyCode.Escape
}

local function CheckKey(Table, Key)
    for _, v in next, Table do
        if v == Key then
            return true
        end
    end
    return false
end

-- Define basic UI elements
CreateElement("Corner", function(Radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, Radius or 5)
    })
end)

CreateElement("Stroke", function(Color, Thickness)
    return Create("UIStroke", {
        Color = Color or Color3.fromRGB(255, 255, 255),
        Thickness = Thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
end)

CreateElement("List", function(Padding, HorizontalAlignment)
    return Create("UIListLayout", {
        Padding = UDim.new(0, Padding or 0),
        HorizontalAlignment = HorizontalAlignment or Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
end)

CreateElement("Padding", function(PaddingData)
    return Create("UIPadding", {
        PaddingBottom = PaddingData.Bottom or UDim.new(0, 0),
        PaddingLeft = PaddingData.Left or UDim.new(0, 0),
        PaddingRight = PaddingData.Right or UDim.new(0, 0),
        PaddingTop = PaddingData.Top or UDim.new(0, 0)
    })
end)

CreateElement("TFrame", function()
    return Create("Frame", {
        BackgroundTransparency = 1
    })
end)

CreateElement("Frame", function(Color, Transparency)
    return Create("Frame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = Transparency or 0,
        BorderSizePixel = 0
    })
end)

CreateElement("RoundFrame", function(Color, Transparency, Radius)
    return Create("Frame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = Transparency or 0,
        BorderSizePixel = 0
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, Radius or 5)
        })
    })
end)

CreateElement("Button", function()
    return Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
end)

CreateElement("ScrollFrame", function(Color, Transparency, Radius)
    return Create("ScrollingFrame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = Transparency or 0,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120),
        ScrollBarImageTransparency = 0.2,
        VerticalScrollBarInset = Enum.ScrollBarInset.Always,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, Radius or 5)
        })
    })
end)

CreateElement("Image", function(ImageId)
    return Create("ImageLabel", {
        Image = ImageId or "",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit
    })
end)

CreateElement("ImageButton", function(ImageId)
    return Create("ImageButton", {
        Image = ImageId or "",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit
    })
end)

CreateElement("Label", function(Text, TextSize, Transparency)
    return Create("TextLabel", {
        Text = Text or "",
        TextSize = TextSize or 14,
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextTransparency = Transparency or 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        RichText = true,
        ClipsDescendants = true
    })
end)

CreateElement("Gradient", function(Colors, Transparency, Rotation)
    return Create("UIGradient", {
        Color = Colors or ColorSequence.new(Color3.fromRGB(255, 255, 255)),
        Transparency = Transparency or NumberSequence.new(0),
        Rotation = Rotation or 0
    })
end)

CreateElement("SmoothButton", function(Color)
    local Button = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    
    -- Create ripple effect for button
    local RippleContainer = Create("Frame", {
        Name = "RippleContainer",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = Button
    })
    
    AddConnection(Button.InputBegan, function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
            local RippleCircle = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Parent = RippleContainer
            })
            
            Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = RippleCircle
            })
            
            local ButtonAbsoluteSize = Button.AbsoluteSize
            local ButtonAbsolutePosition = Button.AbsolutePosition
            
            local MaxSize = math.max(ButtonAbsoluteSize.X, ButtonAbsoluteSize.Y) * 2
            
            -- Calculate position based on input type
            local Position
            if Input.UserInputType == Enum.UserInputType.Touch then
                Position = UDim2.new(0, Input.Position.X - ButtonAbsolutePosition.X, 0, Input.Position.Y - ButtonAbsolutePosition.Y)
            else
                Position = UDim2.new(0, Input.Position.X - ButtonAbsolutePosition.X, 0, Input.Position.Y - ButtonAbsolutePosition.Y)
            end
            
            RippleCircle.Position = Position
            RippleCircle.Size = UDim2.new(0, 0, 0, 0)
            
            TweenService:Create(RippleCircle, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, MaxSize, 0, MaxSize),
                BackgroundTransparency = 1
            }):Play()
            
            game.Debris:AddItem(RippleCircle, 0.5)
        end
    end)
    
    return Button
end)

-- Configuration management
local function SaveCfg(GameId)
    if not CryzenLib.SaveCfg then return end
    
    debugLog("Saving configuration for game", GameId)
    
    local success = pcall(function()
        if not isfolder(CryzenLib.Folder) then
            makefolder(CryzenLib.Folder)
        end
        
        if not isfolder(CryzenLib.Folder.."/"..GameId) then
            makefolder(CryzenLib.Folder.."/"..GameId)
        end
        
        if not isfolder(CryzenLib.Folder.."/"..GameId.."/configs") then
            makefolder(CryzenLib.Folder.."/"..GameId.."/configs")
        end
        
        local Config = {
            Flags = {},
            Theme = CryzenLib.SelectedTheme,
            Version = CryzenLib.Version
        }
        
        for i,v in next, CryzenLib.Flags do
            if v.Save then
                if v.Type == "Colorpicker" then
                    Config.Flags[i] = {
                        Type = "Colorpicker",
                        Value = {v.Value.R, v.Value.G, v.Value.B}
                    }
                elseif v.Type == "Bind" then
                    Config.Flags[i] = {
                        Type = "Bind",
                        Value = v.Value
                    }
                elseif v.Type == "Dropdown" then
                    Config.Flags[i] = {
                        Type = "Dropdown",
                        Value = v.Value
                    }
                else
                    Config.Flags[i] = {
                        Type = "Other",
                        Value = v.Value
                    }
                end
            end
        end
        
        local encoded = HttpService:JSONEncode(Config)
        writefile(CryzenLib.Folder.."/"..GameId.."/configs".."/"..CryzenLib.ConfigFolder..".cfg", encoded)
    end)
    
    if not success then
        warn("[CryzenHub] Failed to save config.")
    end
end

local function LoadCfg(GameId)
    if not CryzenLib.SaveCfg then return end
    
    debugLog("Loading configuration for game", GameId)
    
    local success = pcall(function()
        if not isfile(CryzenLib.Folder.."/"..GameId.."/configs".."/"..CryzenLib.ConfigFolder..".cfg") then
            return
        end
        
        local fileContent = readfile(CryzenLib.Folder.."/"..GameId.."/configs".."/"..CryzenLib.ConfigFolder..".cfg")
        local Config = HttpService:JSONDecode(fileContent)
        
        -- Set theme if it exists in config
        if Config.Theme and CryzenLib.Themes[Config.Theme] then
            SetTheme(Config.Theme)
        end
        
        -- Set flag values
        for i,v in next, Config.Flags do
            if CryzenLib.Flags[i] then
                if v.Type == "Colorpicker" then
                    CryzenLib.Flags[i]:Set(Color3.fromRGB(v.Value[1], v.Value[2], v.Value[3]))
                else
                    CryzenLib.Flags[i]:Set(v.Value)
                end
            end
        end
    end)
    
    if not success then
        warn("[CryzenHub] Failed to load config.")
    end
end

-- Key System
function CryzenLib:SetKey(KeySettings)
    KeySettings = KeySettings or {}
    
    -- Merge with default settings
    for k, v in pairs(KeySettings) do
        self.KeySettings[k] = v
    end
    
    self.KeySystem = true
    return self
end

function CryzenLib:VerifyKey(Key)
    if Key == self.KeySettings.Key then
        return true
    elseif self.KeySettings.GrabKeyFromSite and self.KeySettings.KeyLink ~= "" then
        local success, keyFromSite = pcall(function()
            return game:HttpGet(self.KeySettings.KeyLink)
        end)
        
        if success and keyFromSite and Key == keyFromSite then
            return true
        end
    end
    
    return false
end

function CryzenLib:SaveKeyToFile(Key)
    if not self.KeySettings.SaveKey then return end
    
    pcall(function()
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
        
        writefile(self.Folder.."/"..self.KeySettings.FileName..".txt", Key)
    end)
end

function CryzenLib:LoadKeyFromFile()
    if not self.KeySettings.SaveKey then return nil end
    
    local key = nil
    pcall(function()
        if not isfolder(self.Folder) then
            return nil
        end
        
        if not isfile(self.Folder.."/"..self.KeySettings.FileName..".txt") then
            return nil
        end
        
        key = readfile(self.Folder.."/"..self.KeySettings.FileName..".txt")
    end)
    
    return key
end

function CryzenLib:CreateKeySystem()
    if not self.KeySystem then return true end
    
    debugLog("Creating key system")
    
    -- Check if key is already saved
    local SavedKey = self:LoadKeyFromFile()
    if SavedKey and self:VerifyKey(SavedKey) then
        self.KeySettings.Callback(SavedKey)
        return true
    end
    
    -- Create key system UI
    local KeyUI = Create("ScreenGui", {
        Name = "CryzenKeySystem",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    if syn then
        syn.protect_gui(KeyUI)
        KeyUI.Parent = game.CoreGui
    else
        KeyUI.Parent = gethui() or game.CoreGui
    end
    
    local MainFrame = Create("Frame", {
        BackgroundColor3 = self.Themes[self.SelectedTheme].Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 400, 0, 260),
        Parent = KeyUI
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }),
        Create("UIStroke", {
            Color = self.Themes[self.SelectedTheme].Stroke,
            Thickness = 1
        })
    })
    
    -- Add shadow
    local Shadow = Create("ImageLabel", {
        Image = "rbxassetid://6015897843", -- New shadow image
        Size = UDim2.new(1, 47, 1, 47),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ZIndex = 0,
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local Title = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 0, 15),
        Font = Enum.Font.GothamBold,
        Text = self.KeySettings.Title,
        TextColor3 = self.Themes[self.SelectedTheme].Text,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MainFrame
    })
    
    local Subtitle = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0, 20, 0, 45),
        Font = Enum.Font.Gotham,
        Text = self.KeySettings.Subtitle,
        TextColor3 = self.Themes[self.SelectedTheme].TextDark,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MainFrame
    })
    
    local Note = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 75),
        Font = Enum.Font.Gotham,
        Text = self.KeySettings.Note,
        TextColor3 = self.Themes[self.SelectedTheme].TextDark,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = MainFrame
    })
    
    local KeyBoxContainer = Create("Frame", {
        BackgroundColor3 = self.Themes[self.SelectedTheme].Second,
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 125),
        Parent = MainFrame
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }),
        Create("UIStroke", {
            Color = self.Themes[self.SelectedTheme].Stroke,
            Thickness = 1
        })
    })
    
    local KeyBox = Create("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = "Enter Key...",
        TextColor3 = self.Themes[self.SelectedTheme].Text,
        PlaceholderColor3 = self.Themes[self.SelectedTheme].TextDark,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = KeyBoxContainer,
        ClearTextOnFocus = false
    })
    
    local GetKeyButton = Create("Frame", {
        BackgroundColor3 = self.Themes[self.SelectedTheme].Second,
        Size = UDim2.new(0, 120, 0, 35),
        Position = UDim2.new(0, 20, 0, 180),
        Parent = MainFrame
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }),
        Create("UIStroke", {
            Color = self.Themes[self.SelectedTheme].Stroke,
            Thickness = 1
        }),
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "Get Key",
            TextColor3 = self.Themes[self.SelectedTheme].Text,
            TextSize = 14,
            Parent = nil
        })
    })
    
    -- Only create the label if KeyLink is provided
    if self.KeySettings.KeyLink ~= "" then
        GetKeyButton.TextLabel.Parent = GetKeyButton
    end
    
    local SubmitButton = Create("Frame", {
        BackgroundColor3 = self.Themes[self.SelectedTheme].Accent,
        Size = UDim2.new(0, 120, 0, 35),
        Position = UDim2.new(1, -140, 0, 180),
        Parent = MainFrame
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }),
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "Submit",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Parent = nil
        })
    })
    
    SubmitButton.TextLabel.Parent = SubmitButton
    
    local StatusLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0, 20, 0, 225),
        Font = Enum.Font.Gotham,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 75, 75),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = MainFrame
    })
    
    -- Get key button functionality
    local GetKeyBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = GetKeyButton
    })
    
    GetKeyBtn.MouseButton1Click:Connect(function()
        if self.KeySettings.KeyLink ~= "" then
            pcall(function() setclipboard(self.KeySettings.KeyLink) end)
            StatusLabel.Text = "Key link copied to clipboard!"
            StatusLabel.TextColor3 = Color3.fromRGB(75, 255, 75)
            wait(2)
            StatusLabel.Text = ""
        end
    end)
    
    -- Submit button functionality
    local SubmitBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = SubmitButton
    })
    
    local Attempts = 0
    local KeyVerified = false
    
    SubmitBtn.MouseButton1Click:Connect(function()
        local Key = KeyBox.Text
        
        if Key == "" then
            StatusLabel.Text = "Please enter a key!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
            return
        end
        
        Attempts = Attempts + 1
        
        if self:VerifyKey(Key) then
            StatusLabel.Text = "Key verified successfully!"
            StatusLabel.TextColor3 = Color3.fromRGB(75, 255, 75)
            KeyVerified = true
            
            -- Save key if option enabled
            if self.KeySettings.SaveKey then
                self:SaveKeyToFile(Key)
            end
            
            -- Callback and close
            wait(1)
            KeyUI:Destroy()
            self.KeySettings.Callback(Key)
        else
            if Attempts >= self.KeySettings.MaxAttempts then
                StatusLabel.Text = "Too many attempts. Closing in 3s..."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
                wait(3)
                KeyUI:Destroy()
            else
                StatusLabel.Text = self.KeySettings.RejectMessage .. " (" .. Attempts .. "/" .. self.KeySettings.MaxAttempts .. ")"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
            end
        end
    end)
    
    -- Add dragging functionality
    AddDraggingFunctionality(MainFrame, MainFrame)
    
    -- Center the frame
    MainFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
    
    -- Wait for key verification or UI closure
    local KeySystemClosed = false
    
    local connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not KeyUI.Parent then
            KeySystemClosed = true
            connection:Disconnect()
        end
    end)
    
    -- Simulate waiting for verification
    repeat wait() until KeyVerified or KeySystemClosed
    
    return KeyVerified
end

-- Main UI components
function CryzenLib:MakeWindow(WindowConfig)
    -- Verify key system first if enabled
    if self.KeySystem then
        local KeyVerified = self:CreateKeySystem()
        if not KeyVerified then
            -- Return a dummy window if key verification failed
            return {
                MakeTab = function() return {
                    AddSection = function() return {} end
                } end,
                AddSettingsTab = function() return {} end,
                AddThemeTab = function() return {} end,
                AddHome = function() end,
                SetTheme = function() end
            }
        end
    end
    
    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "CryzenHub"
    WindowConfig.ConfigFolder = WindowConfig.ConfigFolder or WindowConfig.Name
    WindowConfig.SaveConfig = WindowConfig.SaveConfig or false
    WindowConfig.HidePremium = WindowConfig.HidePremium or false
    WindowConfig.IntroEnabled = WindowConfig.IntroEnabled or false
    WindowConfig.IntroText = WindowConfig.IntroText or WindowConfig.Name
    WindowConfig.IntroIcon = WindowConfig.IntroIcon or "rbxassetid://7733658504"
    WindowConfig.CloseCallback = WindowConfig.CloseCallback or function() end
    WindowConfig.ShowIcon = WindowConfig.ShowIcon ~= false
    WindowConfig.Icon = WindowConfig.Icon or "rbxassetid://7733750749"
    WindowConfig.Theme = WindowConfig.Theme or "Fluent"
    WindowConfig.LoadingTitle = WindowConfig.LoadingTitle or "CryzenHub"
    WindowConfig.LoadingSubtitle = WindowConfig.LoadingSubtitle or "by Cryzen Team"
    WindowConfig.UseNewLoadingScreen = WindowConfig.UseNewLoadingScreen or false
    
    self.SelectedTheme = WindowConfig.Theme
    self.SaveCfg = WindowConfig.SaveConfig
    self.ConfigFolder = WindowConfig.ConfigFolder

    -- Create Loading Screen if enabled
    if WindowConfig.UseNewLoadingScreen then
        local LoadingScreen = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = self.Themes[self.SelectedTheme].Main,
            BorderSizePixel = 0,
            ZIndex = 1000,
            Parent = Cryzen
        })
        
        local LoadingContainer = Create("Frame", {
            Size = UDim2.new(0, 240, 0, 180),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            ZIndex = 1001,
            Parent = LoadingScreen
        })
        
        local Logo = Create("ImageLabel", {
            Size = UDim2.new(0, 80, 0, 80),
            Position = UDim2.new(0.5, 0, 0, 10),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Image = WindowConfig.IntroIcon,
            ImageColor3 = self.Themes[self.SelectedTheme].Accent,
            ZIndex = 1002,
            Parent = LoadingContainer
        })
        
        local Title = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 100),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = WindowConfig.LoadingTitle,
            TextColor3 = self.Themes[self.SelectedTheme].Text,
            TextSize = 22,
            ZIndex = 1002,
            Parent = LoadingContainer
        })
        
        local Subtitle = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 130),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = WindowConfig.LoadingSubtitle,
            TextColor3 = self.Themes[self.SelectedTheme].TextDark,
            TextSize = 14,
            ZIndex = 1002,
            Parent = LoadingContainer
        })
        
        -- Loading animation
        local LoadingBar = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 4),
            Position = UDim2.new(0, 0, 0, 160),
            BackgroundColor3 = self.Themes[self.SelectedTheme].Second,
            BorderSizePixel = 0,
            ZIndex = 1002,
            Parent = LoadingContainer
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 2)
            })
        })
        
        local LoadingFill = Create("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = self.Themes[self.SelectedTheme].Accent,
            BorderSizePixel = 0,
            ZIndex = 1003,
            Parent = LoadingBar
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 2)
            })
        })
        
        -- Animate loading bar
        TweenService:Create(LoadingFill, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()
        
        wait(2)
        
        TweenService:Create(LoadingScreen, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            ImageTransparency = 1
        }):Play()
        
        TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            TextTransparency = 1
        }):Play()
        
        TweenService:Create(Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            TextTransparency = 1
        }):Play()
        
        TweenService:Create(LoadingBar, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(LoadingFill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play()
        
        wait(0.5)
        LoadingScreen:Destroy()
    end

    -- Create Intro if enabled
    if WindowConfig.IntroEnabled then
        local IntroScreen = SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Cryzen
        })

        local LogoContainer = SetProps(MakeElement("RoundFrame", self.Themes[self.SelectedTheme].Main, 0, 10), {
            Size = UDim2.new(0, 120, 0, 120),
            Position = UDim2.new(0.5, 0, 0.5, -30),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = IntroScreen
        })
        
        local Logo = SetProps(MakeElement("Image", WindowConfig.IntroIcon), {
            Size = UDim2.new(0, 80, 0, 80),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ImageColor3 = self.Themes[self.SelectedTheme].Accent,
            Parent = LogoContainer
        })

        local TextContainer = SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0.5, 60),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = IntroScreen
        })
        
        local Text = SetProps(MakeElement("Label", WindowConfig.IntroText, 24), {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Center,
            Font = Enum.Font.GothamBold,
            TextTransparency = 1,
            TextColor3 = self.Themes[self.SelectedTheme].Text,
            Parent = TextContainer
        })
        
        local Subtitle = SetProps(MakeElement("Label", "v" .. self.Version, 14), {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 1, 5),
            TextXAlignment = Enum.TextXAlignment.Center,
            Font = Enum.Font.Gotham,
            TextTransparency = 1,
            TextColor3 = self.Themes[self.SelectedTheme].TextDark,
            Parent = TextContainer
        })

        -- Animate intro
        LogoContainer.BackgroundTransparency = 1
        Logo.ImageTransparency = 1
        
        -- Fade in logo
        TweenService:Create(LogoContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TweenService:Create(Logo, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
        
        wait(0.3)
        -- Fade in text
        TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TweenService:Create(Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        
        wait(1.5)
        -- Fade out everything
        TweenService:Create(LogoContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
        TweenService:Create(Text, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
        TweenService:Create(Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
        
        wait(0.5)
        IntroScreen:Destroy()
    end

    -- Create main window
    local MainUI = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
        Size = UDim2.new(0, 560, 0, 400),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = Cryzen
    }), {
        SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 0, 38),
            Name = "TopBar",
            ZIndex = 3
        }), {
            -- Window title
            SetProps(MakeElement("Label", WindowConfig.Name, 14), {
                Size = UDim2.new(1, -38, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Title",
                ZIndex = 3
            }),
            
            -- Window controls
            SetChildren(SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 1), {
                Size = UDim2.new(0, 70, 1, 0),
                Position = UDim2.new(1, -70, 0, 0),
                ZIndex = 3,
                Name = "Controls"
            }), {
                SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0.25), {
                    Size = UDim2.new(0, 1, 1, -18),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    ZIndex = 3
                }),
                
                SetChildren(SetProps(MakeElement("TFrame"), {
                    Size = UDim2.new(0, 70, 1, 0),
                    ZIndex = 3,
                    Name = "Buttons"
                }), {
                    MakeElement("List", 0, Enum.HorizontalAlignment.Right),
                    MakeElement("Padding", {
                        Right = UDim.new(0, 5)
                    }),
                    
                    SetChildren(SetProps(MakeElement("Button"), {
                        Size = UDim2.new(0, 28, 0, 28),
                        Name = "Minimize",
                        ZIndex = 3
                    }), {
                        SetProps(MakeElement("Image", "rbxassetid://7733919718"), {
                            Size = UDim2.new(0, 16, 0, 16),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            ZIndex = 3,
                            ImageColor3 = Color3.fromRGB(220, 220, 220)
                        })
                    }),
                    
                    SetChildren(SetProps(MakeElement("Button"), {
                        Size = UDim2.new(0, 28, 0, 28),
                        Name = "Close",
                        ZIndex = 3
                    }), {
                        SetProps(MakeElement("Image", "rbxassetid://7733914923"), {
                            Size = UDim2.new(0, 16, 0, 16),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            ZIndex = 3,
                            ImageColor3 = Color3.fromRGB(220, 220, 220)
                        })
                    })
                })
            }),
            
            AddThemeObject(MakeElement("Stroke", Color3.fromRGB(255, 255, 255), 1), "Stroke")
        }),
        
        -- Tab container
        SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(0, 120, 1, -38),
            Position = UDim2.new(0, 0, 0, 38),
            Name = "TabHolder",
            ZIndex = 2
        }), {
            SetProps(AddThemeObject(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0), {
                Size = UDim2.new(1, 0, 1, 0),
                Name = "LeftFrame",
                ZIndex = 2
            }), "Second"),
            
            AddThemeObject(SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0.25), {
                Size = UDim2.new(0, 1, 1, -10),
                Position = UDim2.new(1, 0, 0, 5),
                Name = "Divider",
                ZIndex = 2
            }), "Divider"),
            
            SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 1, 0), {
                Size = UDim2.new(1, 0, 1, 0),
                Name = "TabScroller",
                ClipsDescendants = true,
                ZIndex = 2
            }), {
                MakeElement("List", 0),
                MakeElement("Padding", {
                    Top = UDim.new(0, 8),
                    Bottom = UDim.new(0, 8)
                })
            })
        }),
        
        -- Content container
        SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, -120, 1, -38),
            Position = UDim2.new(0, 120, 0, 38),
            Name = "Content"
        }), {
            SetChildren(SetProps(MakeElement("TFrame"), {
                Size = UDim2.new(1, 0, 1, 0),
                Name = "HomeTab"
            }), {
                SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 1, 5), {
                    Size = UDim2.new(1, -10, 1, -10),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Name = "HomeContainer"
                }), {
                    MakeElement("List", 8),
                    MakeElement("Padding", {
                        Left = UDim.new(0, 6),
                        Right = UDim.new(0, 6),
                        Top = UDim.new(0, 6),
                        Bottom = UDim.new(0, 6)
                    })
                })
            })
        }),
        
        -- Window shadow (updated shadow style)
        SetProps(MakeElement("Image", "rbxassetid://6015897843"), {
            Size = UDim2.new(1, 47, 1, 47),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.6,
            ZIndex = 0
        })
    }), "Main")
    
    MainUI.Visible = true
    
    -- Add minimize/close functionality
    MainUI.TopBar.Controls.Buttons.Minimize.MouseButton1Click:Connect(function()
        MainUI.Visible = false
    end)
    
    local MinimizeKey = Enum.KeyCode.RightControl
    AddConnection(UserInputService.InputBegan, function(Input)
        if Input.KeyCode == MinimizeKey then
            MainUI.Visible = not MainUI.Visible
        end
    end)
    
    MainUI.TopBar.Controls.Buttons.Close.MouseButton1Click:Connect(function()
        -- Fade out animation
        TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
            Size = UDim2.new(0, 480, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.5, function()
            Cryzen:Destroy()
            WindowConfig.CloseCallback()
        end)
    end)
    
    -- Add window icon if enabled
    if WindowConfig.ShowIcon then
        local IconButton = SetProps(MakeElement("Button"), {
            Size = UDim2.new(0, 34, 0, 34),
            Position = UDim2.new(0, 2, 0, 2),
            ZIndex = 3
        })
        
        local Icon = SetProps(MakeElement("Image", WindowConfig.Icon), {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 3,
            ImageColor3 = self.Themes[self.SelectedTheme].Accent
        })
        
        Icon.Parent = IconButton
        IconButton.Parent = MainUI.TopBar
        MainUI.TopBar.Title.Position = UDim2.new(0, 36, 0, 0)
        MainUI.TopBar.Title.Size = UDim2.new(1, -70, 1, 0)
    end
    
    -- Add mobile menu toggle if on mobile
    if self.IsMobile then
        local MenuToggleBtn = SetChildren(SetProps(MakeElement("RoundFrame", self.Themes[self.SelectedTheme].Main, 0, 5), {
            Size = UDim2.new(0, 40, 0, 40),
            Position = UDim2.new(0, 20, 0, 20),
            AnchorPoint = Vector2.new(0, 0),
            Parent = Cryzen,
            ZIndex = 10
        }), {
            SetProps(MakeElement("Image", "rbxassetid://7733717447"), {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ImageColor3 = self.Themes[self.SelectedTheme].Accent,
                ZIndex = 11
            }),
            AddThemeObject(MakeElement("Stroke", Color3.fromRGB(255, 255, 255), 1), "Stroke")
        })
        
        local MenuButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 12,
            Parent = MenuToggleBtn
        })
        
        AddConnection(MenuButton.MouseButton1Click, function()
            MainUI.Visible = not MainUI.Visible
        end)
        
        -- Add dragging for mobile menu button
        AddDraggingFunctionality(MenuToggleBtn, MenuToggleBtn)
    end
    
    AddDraggingFunctionality(MainUI.TopBar, MainUI)
    
    local TabCount = 0
    local TabHolder = MainUI.TabHolder.TabScroller
    local HomeTab = MainUI.Content.HomeTab
    local HomeContainer = HomeTab.HomeContainer
    
    local WindowFunctions = {}
    
    function WindowFunctions:SetTheme(Theme)
        SetTheme(Theme)
    end
    
    function WindowFunctions:MakeTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""
        TabConfig.PremiumOnly = TabConfig.PremiumOnly or false
        
        TabCount = TabCount + 1
        
        -- Create tab button with modern design
        local TabButton = AddThemeObject(SetChildren(SetProps(MakeElement("Button"), {
            Size = UDim2.new(1, -14, 0, 30),
            Position = UDim2.new(0, 7, 0, 0),
            Name = TabConfig.Name.."TabButton"
        }), {
            AddThemeObject(SetProps(MakeElement("Label", TabConfig.Name, 14), {
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 30, 0, 0),
                Font = Enum.Font.GothamSemibold,
                TextTransparency = 0.4,
                Name = "Title"
            }), "Text"),
            
            SetProps(MakeElement("Image", TabConfig.Icon), {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 5, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                ImageTransparency = 0.4,
                ImageColor3 = self.Themes[self.SelectedTheme].Text,
                Name = "Icon"
            }),
            
            -- Add indicator for selected tab
            SetProps(MakeElement("Frame", self.Themes[self.SelectedTheme].Accent, 1), {
                Size = UDim2.new(0, 0, 0, 2),
                Position = UDim2.new(0, 0, 1, -2),
                Name = "Indicator",
                BorderSizePixel = 0
            })
        }), "Second")
        
        TabButton.Parent = TabHolder
        
        -- Create tab content container
        local Container = SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 1, 5), {
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Name = TabConfig.Name.."Container",
            Visible = false
        }), {
            MakeElement("List", 8),
            MakeElement("Padding", {
                Left = UDim.new(0, 6),
                Right = UDim.new(0, 6),
                Top = UDim2.new(0, 6),
                Bottom = UDim2.new(0, 6)
            })
        })
        
        Container.Parent = MainUI.Content
        
        local TabFunctions = {}
        
        function TabFunctions:Show()
            for _, Tab in next, MainUI.Content:GetChildren() do
                if Tab:IsA("ScrollingFrame") and Tab.Visible then
                    -- Fade out current tab
                    for _, Child in pairs(Tab:GetChildren()) do
                        if Child:IsA("Frame") then
                            TweenService:Create(Child, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
                            for _, SubChild in pairs(Child:GetDescendants()) do
                                if SubChild:IsA("TextLabel") then
                                    TweenService:Create(SubChild, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
                                elseif SubChild:IsA("ImageLabel") or SubChild:IsA("ImageButton") then
                                    TweenService:Create(SubChild, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
                                elseif SubChild:IsA("Frame") and not SubChild:IsA("ScrollingFrame") then
                                    TweenService:Create(SubChild, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
                                end
                            end
                        end
                    end
                    wait(0.2)
                    Tab.Visible = false
                end
            end
            
            -- Update tab buttons
            for _, Button in next, TabHolder:GetChildren() do
                if Button:IsA("TextButton") then
                    TweenService:Create(Button, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(Button.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {TextTransparency = 0.4}):Play()
                    TweenService:Create(Button.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {ImageTransparency = 0.4}):Play()
                    TweenService:Create(Button.Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 2)}):Play()
                end
            end
            
            -- Highlight selected tab with modern indicator
            TweenService:Create(TabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabButton.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
            TweenService:Create(TabButton.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {ImageTransparency = 0}):Play()
            TweenService:Create(TabButton.Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 2)}):Play()
            
            HomeTab.Visible = false
            Container.Visible = true
            
            -- Fade in elements of the new tab
            for _, Child in pairs(Container:GetChildren()) do
                if Child:IsA("Frame") then
                    Child.BackgroundTransparency = 1
                    TweenService:Create(Child, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
                    for _, SubChild in pairs(Child:GetDescendants()) do
                        if SubChild:IsA("TextLabel") then
                            SubChild.TextTransparency = 1
                            TweenService:Create(SubChild, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
                        elseif SubChild:IsA("ImageLabel") or SubChild:IsA("ImageButton") then
                            SubChild.ImageTransparency = 1
                            TweenService:Create(SubChild, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {ImageTransparency = 0}):Play()
                        elseif SubChild:IsA("Frame") and not SubChild:IsA("ScrollingFrame") then
                            SubChild.BackgroundTransparency = 1
                            TweenService:Create(SubChild, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
                        end
                    end
                end
            end
        end
        
        function TabFunctions:Hide()
            Container.Visible = false
        end
        
        TabButton.MouseButton1Click:Connect(function()
            TabFunctions:Show()
        end)
        
        -- Add elements to tab
        function TabFunctions:AddSection(SectionConfig)
            SectionConfig = SectionConfig or {}
            SectionConfig.Name = SectionConfig.Name or "Section"
            
            local SectionFrame = SetChildren(SetProps(MakeElement("TFrame"), {
                Size = UDim2.new(1, 0, 0, 26),
                Parent = Container
            }), {
                AddThemeObject(SetProps(MakeElement("Label", SectionConfig.Name, 14), {
                    Size = UDim2.new(1, -12, 0, 16),
                    Position = UDim2.new(0, 0, 0, 3),
                    Font = Enum.Font.GothamSemibold
                }), "TextDark"),
                
                SetChildren(SetProps(MakeElement("TFrame"), {
                    AnchorPoint = Vector2.new(0, 0),
                    Size = UDim2.new(1, 0, 1, -24),
                    Position = UDim2.new(0, 0, 0, 23),
                    Name = "Holder"
                }), {
                    MakeElement("List", 6)
                }),
            })
            
            AddConnection(SectionFrame.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y + 31)
                SectionFrame.Holder.Size = UDim2.new(1, 0, 0, SectionFrame.Holder.UIListLayout.AbsoluteContentSize.Y)
            end)
            
            local SectionElements = {}
            
            -- Add elements to section
            function SectionElements:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Name = ButtonConfig.Name or "Button"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end
                ButtonConfig.Icon = ButtonConfig.Icon or nil
                
                local Button = {}
                
                local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionFrame.Holder
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name, 15), {
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        Name = "Title"
                    }), "Text"),
                    
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    SetProps(MakeElement("SmoothButton"), {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = "Button"
                    })
                }), "Second")
                
                -- Add icon if specified
                if ButtonConfig.Icon then
                    local Icon = SetProps(MakeElement("Image", ButtonConfig.Icon), {
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        ImageColor3 = self.Themes[self.SelectedTheme].Accent,
                        Name = "Icon"
                    })
                    Icon.Parent = ButtonFrame
                    ButtonFrame.Title.Position = UDim2.new(0, 40, 0, 0)
                    ButtonFrame.Title.Size = UDim2.new(1, -40, 1, 0)
                end
                
                AddConnection(ButtonFrame.Button.MouseEnter, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 5, self.Themes[self.SelectedTheme].Second.G * 255 + 5, self.Themes[self.SelectedTheme].Second.B * 255 + 5)}):Play()
                end)
                
                AddConnection(ButtonFrame.Button.MouseLeave, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = self.Themes[self.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(ButtonFrame.Button.MouseButton1Up, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 5, self.Themes[self.SelectedTheme].Second.G * 255 + 5, self.Themes[self.SelectedTheme].Second.B * 255 + 5)}):Play()
                    ButtonConfig.Callback()
                end)
                
                AddConnection(ButtonFrame.Button.MouseButton1Down, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 8, self.Themes[self.SelectedTheme].Second.G * 255 + 8, self.Themes[self.SelectedTheme].Second.B * 255 + 8)}):Play()
                end)
                
                function Button:Set(NewTitle)
                    ButtonFrame.Title.Text = NewTitle
                end
                
                function Button:Destroy()
                    ButtonFrame:Destroy()
                end
                
                return Button
            end
            
            function SectionElements:AddToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Name = ToggleConfig.Name or "Toggle"
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                ToggleConfig.Flag = ToggleConfig.Flag or nil
                ToggleConfig.Save = ToggleConfig.Save or false
                
                local Toggle = {Value = ToggleConfig.Default, Save = ToggleConfig.Save, Type = "Toggle"}
                
                -- Modern toggle design
                local ToggleBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
                    Size = UDim2.new(0, 38, 0, 18),
                    Position = UDim2.new(1, -54, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5)
                }), {
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = "ToggleButton"
                    }),
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    AddThemeObject(SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0), {
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = Toggle.Value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 1, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Name = "Indicator"
                    }), "Accent")
                }), "Main")
                
                local ToggleFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionFrame.Holder
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", ToggleConfig.Name, 15), {
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        Name = "Title"
                    }), "Text"),
                    
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = "ToggleButton"
                    }),
                    
                    ToggleBox
                }), "Second")
                
                local ToggleCorner = Instance.new("UICorner", ToggleBox.Indicator)
                ToggleCorner.CornerRadius = UDim.new(1, 0)
                
                function Toggle:Set(Value)
                    Toggle.Value = Value
                    TweenService:Create(ToggleBox.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Position = Toggle.Value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 1, 0.5, 0)
                    }):Play()
                    ToggleConfig.Callback(Toggle.Value)
                end
                
                AddConnection(ToggleFrame.ToggleButton.MouseEnter, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 5, self.Themes[self.SelectedTheme].Second.G * 255 + 5, self.Themes[self.SelectedTheme].Second.B * 255 + 5)}):Play()
                end)
                
                AddConnection(ToggleFrame.ToggleButton.MouseLeave, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = self.Themes[self.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(ToggleFrame.ToggleButton.MouseButton1Up, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 5, self.Themes[self.SelectedTheme].Second.G * 255 + 5, self.Themes[self.SelectedTheme].Second.B * 255 + 5)}):Play()
                    Toggle:Set(not Toggle.Value)
                    SaveCfg(game.GameId)
                end)
                
                AddConnection(ToggleBox.ToggleButton.MouseButton1Up, function()
                    Toggle:Set(not Toggle.Value)
                    SaveCfg(game.GameId)
                end)
                
                AddConnection(ToggleFrame.ToggleButton.MouseButton1Down, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 8, self.Themes[self.SelectedTheme].Second.G * 255 + 8, self.Themes[self.SelectedTheme].Second.B * 255 + 8)}):Play()
                end)
                
                Toggle:Set(Toggle.Value)
                if ToggleConfig.Flag then
                    self.Flags[ToggleConfig.Flag] = Toggle
                end
                
                function Toggle:Destroy()
                    ToggleFrame:Destroy()
                    if ToggleConfig.Flag then
                        self.Flags[ToggleConfig.Flag] = nil
                    end
                end
                
                return Toggle
            end
            
            function SectionElements:AddSlider(SliderConfig)
                SliderConfig = SliderConfig or {}
                SliderConfig.Name = SliderConfig.Name or "Slider"
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Increment = SliderConfig.Increment or 1
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Callback = SliderConfig.Callback or function() end
                SliderConfig.ValueName = SliderConfig.ValueName or ""
                SliderConfig.Color = SliderConfig.Color or self.Themes[self.SelectedTheme].Accent
                SliderConfig.Flag = SliderConfig.Flag or nil
                SliderConfig.Save = SliderConfig.Save or false
                
                local Slider = {Value = SliderConfig.Default, Save = SliderConfig.Save, Type = "Slider", Min = SliderConfig.Min, Max = SliderConfig.Max}
                local Dragging = false
                
                -- Modern slider design
                local SliderDrag = SetChildren(SetProps(MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundTransparency = 0.2,
                    ClipsDescendants = true
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", "Value", 13), {
                        Size = UDim2.new(1, -12, 0, 14),
                        Position = UDim2.new(0, 12, 0, 6),
                        Font = Enum.Font.GothamBold,
                        Name = "Value",
                        TextTransparency = 0
                    }), "Text")
                })
                
                local SliderBar = SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, -24, 0, 26),
                    Position = UDim2.new(0, 12, 0, 30),
                    BackgroundTransparency = 0.9
                }), {
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = "SliderButton"
                    }),
                    SliderDrag
                })
                
                local SliderFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 65),
                    Parent = SectionFrame.Holder
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", SliderConfig.Name, 15), {
                        Size = UDim2.new(1, -12, 0, 14),
                        Position = UDim2.new(0, 12, 0, 10),
                        Font = Enum.Font.GothamBold,
                        Name = "Title"
                    }), "Text"),
                    
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    SliderBar
                }), "Second")
                
                function Slider:Set(Value)
                    if Value < SliderConfig.Min then
                        Value = SliderConfig.Min
                    elseif Value > SliderConfig.Max then
                        Value = SliderConfig.Max
                    end
                    
                    Slider.Value = Round(Value, SliderConfig.Increment)
                    SliderDrag.Value.Text = Slider.Value .. SliderConfig.ValueName
                    
                    local Percent = (Slider.Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                    TweenService:Create(SliderDrag, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(Percent, 0, 1, 0)}):Play()
                    
                    SliderConfig.Callback(Slider.Value)
                    SaveCfg(game.GameId)
                end
                
                local function UpdateSlider(Input)
                    local InputPositionX
                    if Input.UserInputType == Enum.UserInputType.Touch then
                        InputPositionX = Input.Position.X
                    else
                        InputPositionX = UserInputService:GetMouseLocation().X
                    end
                    
                    local BtnPos = SliderBar.SliderButton.AbsolutePosition.X
                    local Percent = math.clamp((InputPositionX - BtnPos) / SliderBar.SliderButton.AbsoluteSize.X, 0, 1)
                    local Value = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * Percent)
                    Slider:Set(Value)
                end
                
                AddConnection(SliderBar.SliderButton.InputBegan, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateSlider(Input)
                    end
                end)
                
                AddConnection(UserInputService.InputEnded, function(Input)
                    if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
                        Dragging = false
                    end
                end)
                
                AddConnection(UserInputService.InputChanged, function(Input)
                    if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Dragging then
                        UpdateSlider(Input)
                    end
                end)
                
                AddConnection(SliderFrame.MouseEnter, function()
                    TweenService:Create(SliderFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 5, self.Themes[self.SelectedTheme].Second.G * 255 + 5, self.Themes[self.SelectedTheme].Second.B * 255 + 5)}):Play()
                end)
                
                AddConnection(SliderFrame.MouseLeave, function()
                    TweenService:Create(SliderFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = self.Themes[self.SelectedTheme].Second}):Play()
                end)
                
                Slider:Set(Slider.Value)
                if SliderConfig.Flag then
                    self.Flags[SliderConfig.Flag] = Slider
                end
                
                function Slider:Destroy()
                    SliderFrame:Destroy()
                    if SliderConfig.Flag then
                        self.Flags[SliderConfig.Flag] = nil
                    end
                end
                
                return Slider
            end
            
            -- Additional UI elements would go here...
            
            return SectionElements
        end
        
        if TabConfig.PremiumOnly then
            for i, v in next, SectionElements do
                SectionElements[i] = function() end
            end
            
            SetChildren(SetProps(MakeElement("TFrame"), {
                Size = UDim2.new(1, 0, 1, 0),
                Parent = Container
            }), {
                AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://3610239960"), {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0, 15, 0, 15),
                    ImageTransparency = 0.4
                }), "Text"),
                AddThemeObject(SetProps(MakeElement("Label", "Premium Feature", 14), {
                    Size = UDim2.new(1, -38, 0, 14),
                    Position = UDim2.new(0, 38, 0, 18),
                    TextTransparency = 0.4
                }), "Text"),
                AddThemeObject(SetProps(MakeElement("Image", "rbxassetid://4483345875"), {
                    Size = UDim2.new(0, 56, 0, 56),
                    Position = UDim2.new(0, 84, 0, 110),
                }), "Text"),
                AddThemeObject(SetProps(MakeElement("Label", "Premium Features", 14), {
                    Size = UDim2.new(1, -150, 0, 14),
                    Position = UDim2.new(0, 150, 0, 112),
                    Font = Enum.Font.GothamBold
                }), "Text"),
                AddThemeObject(SetProps(MakeElement("Label", "This feature is only available to premium users. Purchase premium in the Discord server.", 12), {
                    Size = UDim2.new(1, -200, 0, 14),
                    Position = UDim2.new(0, 150, 0, 138),
                    TextWrapped = true,
                    TextTransparency = 0.4
                }), "Text")
            })
        end
        
        return TabFunctions
    end
    
    -- Home tab (default)
    function WindowFunctions:AddHome(HomeConfig)
        HomeConfig = HomeConfig or {}
        HomeConfig.Welcome = HomeConfig.Welcome or {
            Title = "Welcome to CryzenHub",
            Content = "Thanks for using CryzenHub UI Library v" .. self.Version
        }
        
        AddThemeObject(SetProps(MakeElement("Label", HomeConfig.Welcome.Title, 20), {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 5),
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = HomeContainer
        }), "Text")
        
        AddThemeObject(SetProps(MakeElement("Label", HomeConfig.Welcome.Content, 14), {
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 35),
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextTransparency = 0.3,
            Parent = HomeContainer
        }), "TextDark")
        
        if HomeConfig.Buttons then
            for _, Button in pairs(HomeConfig.Buttons) do
                local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = HomeContainer
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", Button.Title or "Button", 15), {
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        Name = "Title"
                    }), "Text"),
                    
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    SetProps(MakeElement("SmoothButton"), {
                        Size = UDim2.new(1, 0, 1, 0),
                        Name = "HomeButton"
                    })
                }), "Second")
                
                -- Add icon if specified
                if Button.Icon then
                    local Icon = SetProps(MakeElement("Image", Button.Icon), {
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        ImageColor3 = self.Themes[self.SelectedTheme].Accent,
                        Name = "Icon",
                        Parent = ButtonFrame
                    })
                    ButtonFrame.Title.Position = UDim2.new(0, 40, 0, 0)
                    ButtonFrame.Title.Size = UDim2.new(1, -40, 1, 0)
                end
                
                AddConnection(ButtonFrame.HomeButton.MouseEnter, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 5, self.Themes[self.SelectedTheme].Second.G * 255 + 5, self.Themes[self.SelectedTheme].Second.B * 255 + 5)}):Play()
                end)
                
                AddConnection(ButtonFrame.HomeButton.MouseLeave, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = self.Themes[self.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(ButtonFrame.HomeButton.MouseButton1Up, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 5, self.Themes[self.SelectedTheme].Second.G * 255 + 5, self.Themes[self.SelectedTheme].Second.B * 255 + 5)}):Play()
                    Button.Callback()
                end)
                
                AddConnection(ButtonFrame.HomeButton.MouseButton1Down, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(self.Themes[self.SelectedTheme].Second.R * 255 + 8, self.Themes[self.SelectedTheme].Second.G * 255 + 8, self.Themes[self.SelectedTheme].Second.B * 255 + 8)}):Play()
                end)
            end
        end
        
        -- Add credits section
        if HomeConfig.ShowCredits ~= false then
            local CreditsFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                Size = UDim2.new(1, 0, 0, 80),
                Parent = HomeContainer
            }), {
                AddThemeObject(SetProps(MakeElement("Label", "CryzenHub UI Library", 15), {
                    Size = UDim2.new(1, -12, 0, 20),
                    Position = UDim2.new(0, 12, 0, 10),
                    Font = Enum.Font.GothamBold,
                    Name = "Title"
                }), "Text"),
                
                AddThemeObject(SetProps(MakeElement("Label", "Created with ❤️ by Cryzen Team\nVersion: " .. self.Version, 13), {
                    Size = UDim2.new(1, -12, 0, 40),
                    Position = UDim2.new(0, 12, 0, 32),
                    Font = Enum.Font.Gotham,
                    TextTransparency = 0.3,
                    Name = "Subtitle",
                    TextYAlignment = Enum.TextYAlignment.Top
                }), "TextDark"),
                
                AddThemeObject(MakeElement("Stroke"), "Stroke")
            }), "Second")
        end
    end
    
    -- Themes tab
    function WindowFunctions:AddThemeTab()
        local ThemeTab = WindowFunctions:MakeTab({
            Name = "Themes",
            Icon = "rbxassetid://6031280882"
        })
        
        local ThemeSection = ThemeTab:AddSection({
            Name = "Theme Settings"
        })
        
        local ThemeDropdown = ThemeSection:AddDropdown({
            Name = "Theme",
            Default = self.SelectedTheme,
            Options = {"Fluent", "Dark", "Light", "Midnight", "Aqua"},
            Callback = function(Value)
                WindowFunctions:SetTheme(Value)
            end,
            Flag = "UITheme",
            Save = true
        })
        
        local ColorSection = ThemeTab:AddSection({
            Name = "Custom Colors"
        })
        
        for themeName, themeColors in pairs(self.Themes) do
            local CustomSection = ThemeTab:AddSection({
                Name = themeName .. " Theme"
            })
            
            for colorName, colorValue in pairs(themeColors) do
                CustomSection:AddColorpicker({
                    Name = colorName,
                    Default = colorValue,
                    Callback = function(Value)
                        self.Themes[themeName][colorName] = Value
                        
                        if themeName == self.SelectedTheme then
                            SetTheme(self.SelectedTheme)
                        end
                    end
                })
            end
        end
        
        return ThemeTab
    end
    
    -- Settings tab
    function WindowFunctions:AddSettingsTab()
        local SettingsTab = WindowFunctions:MakeTab({
            Name = "Settings",
            Icon = "rbxassetid://6031280883"
        })
        
        local ToggleSection = SettingsTab:AddSection({
            Name = "UI Settings"
        })
        
        local UIToggle = ToggleSection:AddBind({
            Name = "Toggle UI",
            Default = Enum.KeyCode.RightControl,
            Hold = false,
            Callback = function()
                MainUI.Visible = not MainUI.Visible
            end,
            Flag = "UIKeybind",
            Save = true
        })
        
        if WindowConfig.SaveConfig then
            local SaveSection = SettingsTab:AddSection({
                Name = "Configuration"
            })
            
            SaveSection:AddButton({
                Name = "Save Config",
                Callback = function()
                    SaveCfg(game.GameId)
                    self:MakeNotification({
                        Title = "Configuration Saved",
                        Content = "Your settings have been saved for this game",
                        Time = 3,
                        Type = "Success"
                    })
                end
            })
            
            SaveSection:AddButton({
                Name = "Load Config",
                Callback = function()
                    LoadCfg(game.GameId)
                    self:MakeNotification({
                        Title = "Configuration Loaded",
                        Content = "Your settings have been loaded for this game",
                        Time = 3,
                        Type = "Success"
                    })
                end
            })
        end
        
        return SettingsTab
    end
    
    -- Load saved configuration
    if WindowConfig.SaveConfig then
        task.spawn(function()
            LoadCfg(game.GameId)
        end)
    end
    
    return WindowFunctions
end

-- Notifications
function CryzenLib:MakeNotification(NotificationConfig)
    NotificationConfig = NotificationConfig or {}
    NotificationConfig.Title = NotificationConfig.Title or "Notification"
    NotificationConfig.Content = NotificationConfig.Content or "Content"
    NotificationConfig.Time = NotificationConfig.Time or 3
    NotificationConfig.Type = NotificationConfig.Type or "Info" -- Info, Success, Error, Warning
    
    local IconMap = {
        Info = "rbxassetid://7733658504",
        Success = "rbxassetid://7733715400",
        Error = "rbxassetid://7733799682",
        Warning = "rbxassetid://7733878302"
    }
    
    local ColorMap = {
        Info = Color3.fromRGB(90, 100, 240),
        Success = Color3.fromRGB(90, 200, 120),
        Error = Color3.fromRGB(240, 90, 90),
        Warning = Color3.fromRGB(240, 190, 90)
    }
    
    NotificationConfig.Image = IconMap[NotificationConfig.Type] or IconMap.Info
    local AccentColor = ColorMap[NotificationConfig.Type] or ColorMap.Info
    
    task.spawn(function()
        local NotificationParent = Cryzen:FindFirstChild("Notifications")
        
        if not NotificationParent then
            NotificationParent = Create("Frame", {
                Name = "Notifications",
                Position = UDim2.new(1, -25, 0, 25),
                Size = UDim2.new(0, 300, 1, -25),
                BackgroundTransparency = 1,
                Active = true,
                Parent = Cryzen
            }, {
                Create("UIListLayout", {
                    Padding = UDim.new(0, 10),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Top
                })
            })
        end
        
        -- Create notification with improved design
        local NotificationFrame = Create("Frame", {
            Size = UDim2.new(0, 300, 0, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = NotificationParent
        })
        
        local NotifBase = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundColor3 = self.Themes[self.SelectedTheme].Main,
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0, 0),
            Parent = NotificationFrame
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }),
            Create("UIStroke", {
                Thickness = 1,
                Color = self.Themes[self.SelectedTheme].Stroke
            })
        })
        
        local NotifIcon = Create("ImageLabel", {
            Image = NotificationConfig.Image,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 20),
            Size = UDim2.new(0, 25, 0, 25),
            ImageColor3 = AccentColor,
            Parent = NotifBase
        })
        
        local NotifTitle = Create("TextLabel", {
            Text = NotificationConfig.Title,
            TextColor3 = self.Themes[self.SelectedTheme].Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1, -45, 0, 20),
            Position = UDim2.new(0, 45, 0, 20),
            Parent = NotifBase
        })
        
        local NotifContent = Create("TextLabel", {
            Text = NotificationConfig.Content,
            TextColor3 = self.Themes[self.SelectedTheme].TextDark,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, -45, 0, 20),
            Position = UDim2.new(0, 45, 0, 40),
            Parent = NotifBase
        })
        
        -- Add accent bar
        local AccentBar = Create("Frame", {
            Size = UDim2.new(0, 3, 1, -10),
            Position = UDim2.new(0, 6, 0, 5),
            BackgroundColor3 = AccentColor,
            BorderSizePixel = 0,
            Parent = NotifBase
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 3)
            })
        })
        
        -- Add close button
        local CloseButton = Create("ImageButton", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -10, 0, 10),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://7733717447",
            ImageColor3 = self.Themes[self.SelectedTheme].TextDark,
            Rotation = 45,
            Parent = NotifBase
        })
        
        -- Add progress bar
        local ProgressBar = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = AccentColor,
            BorderSizePixel = 0,
            Parent = NotifBase
        })
        
        -- Animate notification
        NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
        TweenService:Create(NotifBase, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        -- Progress bar animation
        TweenService:Create(ProgressBar, TweenInfo.new(NotificationConfig.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 2)}):Play()
        
        CloseButton.MouseButton1Click:Connect(function()
            TweenService:Create(NotifBase, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.3)
            NotificationFrame:Destroy()
        end)
        
        task.delay(NotificationConfig.Time - 0.5, function()
            if NotifBase and NotifBase.Parent then
                TweenService:Create(NotifBase, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
                wait(0.5)
                NotificationFrame:Destroy()
            end
        end)
    end)
end

-- Destroy UI
function CryzenLib:Destroy()
    -- Fade out animation
    local MainUI = Cryzen:FindFirstChild("CryzenHub")
    if MainUI then
        TweenService:Create(MainUI, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
            Size = UDim2.new(0, 480, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.5, function()
            Cryzen:Destroy()
        end)
    else
        Cryzen:Destroy()
    end
end

return CryzenLib
