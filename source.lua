--[[
 ██████╗██████╗ ██╗   ██╗███████╗███████╗███╗   ██╗    ██╗  ██╗██╗   ██╗██████╗ 
██╔════╝██╔══██╗╚██╗ ██╔╝╚══███╔╝██╔════╝████╗  ██║    ██║  ██║██║   ██║██╔══██╗
██║     ██████╔╝ ╚████╔╝   ███╔╝ █████╗  ██╔██╗ ██║    ███████║██║   ██║██████╔╝
██║     ██╔══██╗  ╚██╔╝   ███╔╝  ██╔══╝  ██║╚██╗██║    ██╔══██║██║   ██║██╔══██╗
╚██████╗██║  ██║   ██║   ███████╗███████╗██║ ╚████║    ██║  ██║╚██████╔╝██████╔╝
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                                                                               
    CryzenHub V2 - Based on Orion UI Library
    Upgraded with new design, bug fixes, and enhanced features
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

-- Create CryzenHub library base
local CryzenLib = {
    Elements = {},
    ThemeObjects = {},
    Connections = {},
    Flags = {},
    Themes = {
        Default = {
            Main = Color3.fromRGB(25, 25, 30),
            Second = Color3.fromRGB(32, 32, 38),
            Stroke = Color3.fromRGB(60, 60, 70),
            Divider = Color3.fromRGB(60, 60, 70),
            Text = Color3.fromRGB(240, 240, 245),
            TextDark = Color3.fromRGB(150, 150, 160),
            Accent = Color3.fromRGB(98, 108, 241)
        },
        Dark = {
            Main = Color3.fromRGB(18, 18, 22),
            Second = Color3.fromRGB(24, 24, 28),
            Stroke = Color3.fromRGB(50, 50, 55),
            Divider = Color3.fromRGB(50, 50, 55),
            Text = Color3.fromRGB(240, 240, 245),
            TextDark = Color3.fromRGB(140, 140, 145),
            Accent = Color3.fromRGB(90, 100, 240)
        },
        Light = {
            Main = Color3.fromRGB(240, 240, 245),
            Second = Color3.fromRGB(230, 230, 235),
            Stroke = Color3.fromRGB(180, 180, 185),
            Divider = Color3.fromRGB(180, 180, 185),
            Text = Color3.fromRGB(40, 40, 45),
            TextDark = Color3.fromRGB(100, 100, 110),
            Accent = Color3.fromRGB(90, 100, 240)
        }
    },
    SelectedTheme = "Default",
    Folder = nil,
    SaveCfg = false,
    ConfigFolder = "CryzenHub"
}

-- Load Feather Icons for UI elements
local Icons = {}

local Success, Response = pcall(function()
    Icons = HttpService:JSONDecode(game:HttpGetAsync("https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json")).icons
end)

if not Success then
    warn("\nCryzenHub - Failed to load Feather Icons. Error code: " .. Response .. "\n")
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
if syn then
    syn.protect_gui(Cryzen)
    Cryzen.Parent = game.CoreGui
else
    Cryzen.Parent = gethui() or game.CoreGui
end

-- Remove duplicate UIs
if gethui then
    for _, Interface in ipairs(gethui():GetChildren()) do
        if Interface.Name == Cryzen.Name and Interface ~= Cryzen then
            Interface:Destroy()
        end
    end
else
    for _, Interface in ipairs(game.CoreGui:GetChildren()) do
        if Interface.Name == Cryzen.Name and Interface ~= Cryzen then
            Interface:Destroy()
        end
    end
end

-- Core functions
function CryzenLib:IsRunning()
    if gethui then
        return Cryzen.Parent == gethui()
    else
        return Cryzen.Parent == game:GetService("CoreGui")
    end
end

local function AddConnection(Signal, Function)
    if (not CryzenLib:IsRunning()) then
        return
    end
    local SignalConnect = Signal:Connect(Function)
    table.insert(CryzenLib.Connections, SignalConnect)
    return SignalConnect
end

task.spawn(function()
    while (CryzenLib:IsRunning()) do
        wait()
    end

    for _, Connection in next, CryzenLib.Connections do
        Connection:Disconnect()
    end
end)

-- Utility functions
local function AddDraggingFunctionality(DragPoint, Main)
    pcall(function()
        local Dragging, DragInput, MousePos, FramePos = false
        
        AddConnection(DragPoint.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
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
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                DragInput = Input
            end
        end)
        
        AddConnection(UserInputService.InputChanged, function(Input)
            if Input == DragInput and Dragging then
                local Delta = Input.Position - MousePos
                TweenService:Create(Main, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
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
    local NewElement = CryzenLib.Elements[ElementName](...)
    return NewElement
end

local function SetProps(Element, Props)
    table.foreach(Props, function(Property, Value)
        Element[Property] = Value
    end)
    return Element
end

local function SetChildren(Element, Children)
    table.foreach(Children, function(_, Child)
        Child.Parent = Element
    end)
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
    if Theme == "Default" or not CryzenLib.Themes[Theme] then
        return CryzenLib.Themes["Default"]
    else
        return CryzenLib.Themes[Theme]
    end
end

local function AddThemeObject(Object, Type)
    if not CryzenLib.ThemeObjects[Type] then
        CryzenLib.ThemeObjects[Type] = {}
    end
    table.insert(CryzenLib.ThemeObjects[Type], Object)
    Object.BackgroundColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme][Type]
    return Object
end

local function SetTheme(Theme)
    if not CryzenLib.Themes[Theme] and Theme ~= "Default" then
        warn("CryzenHub | Theme '" .. Theme .. "' doesn't exist!")
        return
    end
    
    CryzenLib.SelectedTheme = Theme
    
    for Type, Objects in next, CryzenLib.ThemeObjects do
        for _, Object in next, Objects do
            if Object.BackgroundColor3 ~= nil then
                TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[Theme][Type]}):Play()
            end
            if Object.TextColor3 ~= nil then
                TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = CryzenLib.Themes[Theme][Type]}):Play()
            end
        end
    end
end

-- Create standard UI elements
local WhitelistedMouse = {
    Enum.UserInputType.MouseButton1,
    Enum.UserInputType.MouseButton2,
    Enum.UserInputType.MouseButton3
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

CreateElement("Corner", function(Radius)
    local Corner = Create("UICorner", {
        CornerRadius = UDim.new(0, Radius)
    })
    return Corner
end)

CreateElement("Stroke", function(Color, Thickness)
    local Stroke = Create("UIStroke", {
        Color = Color or Color3.fromRGB(255, 255, 255),
        Thickness = Thickness or 1
    })
    return Stroke
end)

CreateElement("List", function(Padding, HorizontalAlignment)
    local List = Create("UIListLayout", {
        Padding = UDim.new(0, Padding),
        HorizontalAlignment = HorizontalAlignment or Enum.HorizontalAlignment.Left
    })
    return List
end)

CreateElement("Padding", function(PaddingData)
    local Padding = Create("UIPadding", {
        PaddingBottom = PaddingData.Bottom or UDim.new(0, 0),
        PaddingLeft = PaddingData.Left or UDim.new(0, 0),
        PaddingRight = PaddingData.Right or UDim.new(0, 0),
        PaddingTop = PaddingData.Top or UDim.new(0, 0)
    })
    return Padding
end)

CreateElement("TFrame", function()
    local Frame = Create("Frame", {
        BackgroundTransparency = 1
    })
    return Frame
end)

CreateElement("Frame", function(Color, Transparency)
    local Frame = Create("Frame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = Transparency or 0,
        BorderSizePixel = 0
    })
    return Frame
end)

CreateElement("RoundFrame", function(Color, Transparency, Radius)
    local Frame = Create("Frame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = Transparency or 0,
        BorderSizePixel = 0
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, Radius or 5)
        })
    })
    return Frame
end)

CreateElement("Button", function()
    local Button = Create("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    return Button
end)

CreateElement("ScrollFrame", function(Color, Transparency, Radius)
    local ScrollFrame = Create("ScrollingFrame", {
        BackgroundColor3 = Color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = Transparency or 0,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        VerticalScrollBarInset = Enum.ScrollBarInset.Always
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, Radius or 5)
        })
    })
    return ScrollFrame
end)

CreateElement("Image", function(ImageId)
    local ImageNew = Create("ImageLabel", {
        Image = ImageId or "",
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    return ImageNew
end)

CreateElement("ImageButton", function(ImageId)
    local Image = Create("ImageButton", {
        Image = ImageId or "",
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    return Image
end)

CreateElement("Label", function(Text, TextSize, Transparency)
    local Label = Create("TextLabel", {
        Text = Text or "",
        TextSize = TextSize or 14,
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(240, 240, 240),
        TextTransparency = Transparency or 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0,
        RichText = true
    })
    return Label
end)

-- Configuration management
local ConfigFolder = "CryzenHub"

local function SaveCfg(GameId)
    if not CryzenLib.SaveCfg then return end
    
    if not isfolder(ConfigFolder) then
        makefolder(ConfigFolder)
    end
    
    if not isfolder(ConfigFolder.."/"..GameId) then
        makefolder(ConfigFolder.."/"..GameId)
    end
    
    if not isfolder(ConfigFolder.."/"..GameId.."/configs") then
        makefolder(ConfigFolder.."/"..GameId.."/configs")
    end
    
    local Config = {
        Flags = {}
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
    
    writefile(ConfigFolder.."/"..GameId.."/configs".."/"..CryzenLib.ConfigFolder..".cfg", HttpService:JSONEncode(Config))
end

local function LoadCfg(GameId)
    if not CryzenLib.SaveCfg then return end
    
    if not isfile(ConfigFolder.."/"..GameId.."/configs".."/"..CryzenLib.ConfigFolder..".cfg") then
        return
    end
    
    local Config = HttpService:JSONDecode(readfile(ConfigFolder.."/"..GameId.."/configs".."/"..CryzenLib.ConfigFolder..".cfg"))
    for i,v in next, Config.Flags do
        if v.Type == "Colorpicker" then
            CryzenLib.Flags[i]:Set(Color3.fromRGB(v.Value[1], v.Value[2], v.Value[3]))
        else
            CryzenLib.Flags[i]:Set(v.Value)
        end
    end
end

-- Main UI components
function CryzenLib:MakeWindow(WindowConfig)
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
    WindowConfig.Theme = WindowConfig.Theme or "Default"
    
    CryzenLib.SelectedTheme = WindowConfig.Theme
    CryzenLib.SaveCfg = WindowConfig.SaveConfig
    CryzenLib.ConfigFolder = WindowConfig.ConfigFolder

    -- Create Intro if enabled
    if WindowConfig.IntroEnabled then
        local IntroScreen = SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Cryzen
        })

        local Logo = SetProps(MakeElement("Image", WindowConfig.IntroIcon), {
            Size = UDim2.new(0, 100, 0, 100),
            Position = UDim2.new(0.5, 0, 0.5, -30),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        Logo.Parent = IntroScreen

        local Text = SetProps(MakeElement("Label", WindowConfig.IntroText, 24), {
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0.5, 40),
            AnchorPoint = Vector2.new(0, 0.5),
            TextXAlignment = Enum.TextXAlignment.Center,
            Font = Enum.Font.GothamBold,
            TextTransparency = 1
        })
        Text.Parent = IntroScreen

        -- Animate intro
        TweenService:Create(Logo, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, -30)}):Play()
        wait(0.3)
        TweenService:Create(Text, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        wait(1.5)
        TweenService:Create(Logo, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, -100), Size = UDim2.new(0, 80, 0, 80)}):Play()
        TweenService:Create(Text, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
        wait(0.5)
        TweenService:Create(IntroScreen, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        wait(0.7)
        IntroScreen:Destroy()
    end

    -- Create main window
    local MainUI = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10), {
        Size = UDim2.new(0, 560, 0, 400),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }), {
        SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(1, 0, 0, 38),
            Name = "TopBar",
            ZIndex = 2
        }), {
            -- Window title
            SetProps(MakeElement("Label", WindowConfig.Name, 14), {
                Size = UDim2.new(1, -38, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Font = Enum.Font.GothamBold,
                Name = "Title",
                ZIndex = 2
            }),
            
            -- Window controls
            SetChildren(SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 1), {
                Size = UDim2.new(0, 70, 1, 0),
                Position = UDim2.new(1, -70, 0, 0),
                ZIndex = 2,
                Name = "Controls"
            }), {
                SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0.25), {
                    Size = UDim2.new(0, 1, 1, -18),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    ZIndex = 2
                }),
                
                SetChildren(SetProps(MakeElement("TFrame"), {
                    Size = UDim2.new(0, 70, 1, 0),
                    ZIndex = 2,
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
            
            MakeElement("Stroke", Color3.fromRGB(255, 255, 255), 1)
        }),
        
        -- Tab container
        SetChildren(SetProps(MakeElement("TFrame"), {
            Size = UDim2.new(0, 120, 1, -38),
            Position = UDim2.new(0, 0, 0, 38),
            Name = "TabHolder"
        }), {
            SetProps(AddThemeObject(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0), {
                Size = UDim2.new(1, 0, 1, 0),
                Name = "LeftFrame"
            }), "Second"),
            
            SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0.25), {
                Size = UDim2.new(0, 1, 1, -10),
                Position = UDim2.new(1, 0, 0, 5),
                Name = "Divider"
            }),
            
            SetChildren(SetProps(MakeElement("ScrollFrame", Color3.fromRGB(255, 255, 255), 1, 0), {
                Size = UDim2.new(1, 0, 1, 0),
                Name = "TabScroller",
                ClipsDescendants = true
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
        })
    }), "Main")
    
    MainUI.Parent = Cryzen
    MainUI.Visible = true
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
        Cryzen:Destroy()
        WindowConfig.CloseCallback()
    end)
    
    -- Add window icon if enabled
    if WindowConfig.ShowIcon then
        local IconButton = SetProps(MakeElement("Button"), {
            Size = UDim2.new(0, 34, 0, 34),
            Position = UDim2.new(0, 2, 0, 2),
            ZIndex = 2
        })
        
        local Icon = SetProps(MakeElement("Image", WindowConfig.Icon), {
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 2,
            ImageColor3 = Color3.fromRGB(220, 220, 220)
        })
        
        Icon.Parent = IconButton
        IconButton.Parent = MainUI.TopBar
        MainUI.TopBar.Title.Position = UDim2.new(0, 36, 0, 0)
        MainUI.TopBar.Title.Size = UDim2.new(1, -70, 1, 0)
    end
    
    AddDraggingFunctionality(MainUI.TopBar, MainUI)
    
    local TabCount = 0
    local TabHolder = MainUI.TabHolder.TabScroller
    local HomeTab = MainUI.Content.HomeTab
    local HomeContainer = HomeTab.HomeContainer
    
    local WindowFunctions = {}
    
    function WindowFunctions:SetTheme(Theme)
        if not CryzenLib.Themes[Theme] and Theme ~= "Default" then
            warn("CryzenHub | Theme '" .. Theme .. "' doesn't exist!")
            return
        end
        
        CryzenLib.SelectedTheme = Theme
        
        for Type, Objects in next, CryzenLib.ThemeObjects do
            for _, Object in next, Objects do
                if Object.BackgroundColor3 ~= nil then
                    TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[Theme][Type]}):Play()
                end
                if Object.TextColor3 ~= nil then
                    TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextColor3 = CryzenLib.Themes[Theme][Type]}):Play()
                end
            end
        end
    end
    
    function WindowFunctions:MakeTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "Tab"
        TabConfig.Icon = TabConfig.Icon or ""
        TabConfig.PremiumOnly = TabConfig.PremiumOnly or false
        
        TabCount = TabCount + 1
        
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
                Name = "Icon"
            })
        }), "Second")
        
        TabButton.Parent = TabHolder
        
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
                Top = UDim.new(0, 6),
                Bottom = UDim.new(0, 6)
            })
        })
        
        Container.Parent = MainUI.Content
        
        local TabFunctions = {}
        
        function TabFunctions:Show()
            for _, Tab in next, MainUI.Content:GetChildren() do
                if Tab:IsA("ScrollingFrame") then
                    Tab.Visible = false
                end
            end
            
            for _, Button in next, TabHolder:GetChildren() do
                if Button:IsA("TextButton") then
                    TweenService:Create(Button, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(Button.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0.4}):Play()
                    TweenService:Create(Button.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0.4}):Play()
                end
            end
            
            TweenService:Create(TabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            TweenService:Create(TabButton.Title, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            TweenService:Create(TabButton.Icon, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
            
            HomeTab.Visible = false
            Container.Visible = true
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
                
                local Button = {}
                
                local ButtonFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionFrame.Holder
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", ButtonConfig.Name, 15), {
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold
                    }), "Text"),
                    
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0)
                    })
                }), "Second")
                
                AddConnection(ButtonFrame.Button.MouseEnter, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                end)
                
                AddConnection(ButtonFrame.Button.MouseLeave, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(ButtonFrame.Button.MouseButton1Up, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                    ButtonConfig.Callback()
                end)
                
                AddConnection(ButtonFrame.Button.MouseButton1Down, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 6)}):Play()
                end)
                
                function Button:Set(NewTitle)
                    ButtonFrame.Title.Text = NewTitle
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
                
                local ToggleBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
                    Size = UDim2.new(0, 24, 0, 24),
                    Position = UDim2.new(1, -24, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5)
                }), {
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0)
                    }),
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    AddThemeObject(SetProps(MakeElement("Frame", Color3.fromRGB(255, 255, 255), 0), {
                        Size = UDim2.new(1, -6, 1, -6),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Name = "Fill",
                        Visible = Toggle.Value
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
                        Size = UDim2.new(1, 0, 1, 0)
                    }),
                    
                    ToggleBox
                }), "Second")
                
                function Toggle:Set(Value)
                    Toggle.Value = Value
                    ToggleBox.Fill.Visible = Toggle.Value
                    ToggleConfig.Callback(Toggle.Value)
                end
                
                AddConnection(ToggleFrame.Button.MouseEnter, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                end)
                
                AddConnection(ToggleFrame.Button.MouseLeave, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(ToggleFrame.Button.MouseButton1Up, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                    Toggle:Set(not Toggle.Value)
                    SaveCfg(game.GameId)
                end)
                
                AddConnection(ToggleFrame.Button.MouseButton1Down, function()
                    TweenService:Create(ToggleFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 6)}):Play()
                end)
                
                Toggle:Set(Toggle.Value)
                if ToggleConfig.Flag then
                    CryzenLib.Flags[ToggleConfig.Flag] = Toggle
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
                SliderConfig.Color = SliderConfig.Color or Color3.fromRGB(90, 100, 240)
                SliderConfig.Flag = SliderConfig.Flag or nil
                SliderConfig.Save = SliderConfig.Save or false
                
                local Slider = {Value = SliderConfig.Default, Save = SliderConfig.Save, Type = "Slider", Min = SliderConfig.Min, Max = SliderConfig.Max}
                local Dragging = false
                
                local SliderDrag = SetChildren(SetProps(MakeElement("RoundFrame", SliderConfig.Color, 0, 5), {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundTransparency = 0.3,
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
                        Size = UDim2.new(1, 0, 1, 0)
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
                
                AddConnection(SliderBar.Button.MouseButton1Down, function()
                    Dragging = true
                    
                    AddConnection(RunService.RenderStepped, function()
                        if Dragging then
                            local MousePos = UserInputService:GetMouseLocation().X
                            local BtnPos = SliderBar.Button.AbsolutePosition.X
                            local Percent = math.clamp((MousePos - BtnPos) / SliderBar.Button.AbsoluteSize.X, 0, 1)
                            local Value = SliderConfig.Min + ((SliderConfig.Max - SliderConfig.Min) * Percent)
                            Slider:Set(Value)
                        end
                    end)
                    
                    AddConnection(UserInputService.InputEnded, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                        end
                    end)
                end)
                
                Slider:Set(Slider.Value)
                if SliderConfig.Flag then
                    CryzenLib.Flags[SliderConfig.Flag] = Slider
                end
                
                return Slider
            end
            
            function SectionElements:AddDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Name = DropdownConfig.Name or "Dropdown"
                DropdownConfig.Options = DropdownConfig.Options or {}
                DropdownConfig.Default = DropdownConfig.Default or ""
                DropdownConfig.Callback = DropdownConfig.Callback or function() end
                DropdownConfig.Flag = DropdownConfig.Flag or nil
                DropdownConfig.Save = DropdownConfig.Save or false
                
                local Dropdown = {Value = DropdownConfig.Default, Options = DropdownConfig.Options, Toggled = false, Type = "Dropdown", Save = DropdownConfig.Save}
                local MaxElements = 5
                
                if not table.find(Dropdown.Options, Dropdown.Value) then
                    Dropdown.Value = ""
                end
                
                local DropdownList = SetProps(MakeElement("List"), {
                    Parent = SectionFrame.Holder
                })
                
                local DropdownContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 38),
                    BackgroundTransparency = 0,
                    Visible = false,
                    Parent = DropdownFrame
                }), {
                    DropdownList
                }), "Second")
                
                local DropdownFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionFrame.Holder
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", DropdownConfig.Name, 15), {
                        Size = UDim2.new(1, -12, 0, 14),
                        Position = UDim2.new(0, 12, 0, 12),
                        Font = Enum.Font.GothamBold,
                        Name = "Title"
                    }), "Text"),
                    
                    AddThemeObject(SetProps(MakeElement("Label", "> " .. Dropdown.Value, 13), {
                        Position = UDim2.new(1, -40, 0, 0),
                        Size = UDim2.new(0, 30, 1, 0),
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Font = Enum.Font.GothamBold,
                        Name = "Value"
                    }), "TextDark"),
                    
                    SetProps(MakeElement("Image", "rbxassetid://7733717447"), {
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(1, -20, 0, 19),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        ImageColor3 = Color3.fromRGB(240, 240, 240),
                        Name = "Icon"
                    }),
                    
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0)
                    }),
                    
                    DropdownContainer
                }), "Second")
                
                AddConnection(DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                    DropdownContainer.Size = UDim2.new(1, 0, 0, math.min(DropdownList.AbsoluteContentSize.Y, (MaxElements * 30)))
                end)
                
                local function AddOptions(Options)
                    for _, Option in pairs(Options) do
                        local OptionBtn = AddThemeObject(SetChildren(SetProps(MakeElement("Button"), {
                            Size = UDim2.new(1, 0, 0, 30),
                            BackgroundTransparency = 1,
                            Parent = DropdownList
                        }), {
                            AddThemeObject(SetProps(MakeElement("Label", Option, 14), {
                                Size = UDim2.new(1, -12, 1, 0),
                                Position = UDim2.new(0, 12, 0, 0),
                                Font = Enum.Font.GothamSemibold
                            }), "Text")
                        }), "Divider")
                        
                        AddConnection(OptionBtn.MouseButton1Click, function()
                            Dropdown:Set(Option)
                            Dropdown.Toggled = false
                            TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.new(1, 0, 0, 38)}):Play()
                            TweenService:Create(DropdownFrame.Icon,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = 0}):Play()
                            DropdownContainer.Visible = false
                        end)
                    end
                end
                
                function Dropdown:Refresh(Options, Delete)
                    if Delete then
                        for _, v in pairs(DropdownList:GetChildren()) do
                            if v:IsA("TextButton") then
                                v:Destroy()
                            end
                        end
                    end
                    
                    Dropdown.Options = Options
                    AddOptions(Options)
                end
                
                function Dropdown:Set(Value)
                    if Value ~= "" then
                        if not table.find(Dropdown.Options, Value) then
                            Dropdown.Value = Dropdown.Options[1]
                            DropdownFrame.Value.Text = "> " .. Dropdown.Value
                        else
                            Dropdown.Value = Value
                            DropdownFrame.Value.Text = "> " .. Dropdown.Value
                        end
                        DropdownConfig.Callback(Dropdown.Value)
                        SaveCfg(game.GameId)
                    end
                end
                
                AddConnection(DropdownFrame.Button.MouseButton1Click, function()
                    Dropdown.Toggled = not Dropdown.Toggled
                    
                    if Dropdown.Toggled then
                        for _, DropdownOther in pairs(SectionFrame.Holder:GetChildren()) do
                            if DropdownOther:IsA("Frame") and DropdownOther ~= DropdownFrame and DropdownOther:FindFirstChild("Container") and DropdownOther.Container.Visible then
                                DropdownOther.Container.Visible = false
                                TweenService:Create(DropdownOther,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.new(1, 0, 0, 38)}):Play()
                                TweenService:Create(DropdownOther.Icon,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = 0}):Play()
                            end
                        end
                        
                        TweenService:Create(DropdownFrame.Icon,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = 180}):Play()
                        DropdownContainer.Visible = true
                        
                        if #Dropdown.Options > MaxElements then
                            TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.new(1, 0, 0, 38 + (MaxElements * 30))}):Play()
                        else
                            TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.new(1, 0, 0, DropdownList.AbsoluteContentSize.Y + 38)}):Play()
                        end
                    else
                        TweenService:Create(DropdownFrame.Icon,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = 0}):Play()
                        DropdownContainer.Visible = false
                        TweenService:Create(DropdownFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = UDim2.new(1, 0, 0, 38)}):Play()
                    end
                end)
                
                Dropdown:Refresh(Dropdown.Options, false)
                Dropdown:Set(Dropdown.Value)
                if DropdownConfig.Flag then                
                    CryzenLib.Flags[DropdownConfig.Flag] = Dropdown
                end
                
                return Dropdown
            end
            
            function SectionElements:AddBind(BindConfig)
                BindConfig.Name = BindConfig.Name or "Bind"
                BindConfig.Default = BindConfig.Default or Enum.KeyCode.Unknown
                BindConfig.Hold = BindConfig.Hold or false
                BindConfig.Callback = BindConfig.Callback or function() end
                BindConfig.Flag = BindConfig.Flag or nil
                BindConfig.Save = BindConfig.Save or false
                
                local Bind = {Value = BindConfig.Default, Binding = false, Type = "Bind", Save = BindConfig.Save}
                local Holding = false
                
                local BindBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
                    Size = UDim2.new(0, 24, 0, 24),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5)
                }), {
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 14), {
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.GothamBold,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Name = "Value"
                    }), "Text")
                }), "Main")
                
                local Click = SetProps(MakeElement("Button"), {
                    Size = UDim2.new(1, 0, 1, 0)
                })
                
                local BindFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionFrame.Holder
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", BindConfig.Name, 15), {
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    BindBox,
                    Click
                }), "Second")
                
                AddConnection(BindBox.Value:GetPropertyChangedSignal("Text"), function()
                    TweenService:Create(BindBox, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, BindBox.Value.TextBounds.X + 16, 0, 24)}):Play()
                end)
                
                AddConnection(Click.InputEnded, function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if Bind.Binding then return end
                        Bind.Binding = true
                        BindBox.Value.Text = ""
                    end
                end)
                
                AddConnection(UserInputService.InputBegan, function(Input)
                    if UserInputService:GetFocusedTextBox() then return end
                    if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
                        if BindConfig.Hold then
                            Holding = true
                            BindConfig.Callback(Holding)
                        else
                            BindConfig.Callback()
                        end
                    elseif Bind.Binding then
                        local Key
                        pcall(function()
                            if not CheckKey(BlacklistedKeys, Input.KeyCode) then
                                Key = Input.KeyCode
                            end
                        end)
                        pcall(function()
                            if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then
                                Key = Input.UserInputType
                            end
                        end)
                        Key = Key or Bind.Value
                        Bind:Set(Key)
                        SaveCfg(game.GameId)
                    end
                end)
                
                AddConnection(UserInputService.InputEnded, function(Input)
                    if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
                        if BindConfig.Hold and Holding then
                            Holding = false
                            BindConfig.Callback(Holding)
                        end
                    end
                end)
                
                AddConnection(Click.MouseEnter, function()
                    TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                end)
                
                AddConnection(Click.MouseLeave, function()
                    TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(Click.MouseButton1Up, function()
                    TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                end)
                
                AddConnection(Click.MouseButton1Down, function()
                    TweenService:Create(BindFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 6)}):Play()
                end)
                
                function Bind:Set(Key)
                    Bind.Binding = false
                    Bind.Value = Key or Bind.Value
                    Bind.Value = Bind.Value.Name or Bind.Value
                    BindBox.Value.Text = Bind.Value
                end
                
                Bind:Set(BindConfig.Default)
                if BindConfig.Flag then                
                    CryzenLib.Flags[BindConfig.Flag] = Bind
                end
                
                return Bind
            end
            
            function SectionElements:AddTextbox(TextboxConfig)
                TextboxConfig = TextboxConfig or {}
                TextboxConfig.Name = TextboxConfig.Name or "Textbox"
                TextboxConfig.Default = TextboxConfig.Default or ""
                TextboxConfig.TextDisappear = TextboxConfig.TextDisappear or false
                TextboxConfig.Callback = TextboxConfig.Callback or function() end
                
                local TextboxActual = AddThemeObject(Create("TextBox", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    PlaceholderColor3 = Color3.fromRGB(210,210,210),
                    PlaceholderText = "Input",
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextSize = 14,
                    ClearTextOnFocus = false
                }), "Text")
                
                local TextContainer = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
                    Size = UDim2.new(0, 24, 0, 24),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5)
                }), {
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    TextboxActual
                }), "Main")
                
                local Click = SetProps(MakeElement("Button"), {
                    Size = UDim2.new(1, 0, 1, 0)
                })
                
                local TextboxFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionFrame.Holder
                }), {
                    AddThemeObject(SetProps(MakeElement("Label", TextboxConfig.Name, 15), {
                        Size = UDim2.new(1, -12, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        Font = Enum.Font.GothamBold,
                        Name = "Content"
                    }), "Text"),
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    TextContainer,
                    Click
                }), "Second")
                
                AddConnection(TextboxActual:GetPropertyChangedSignal("Text"), function()
                    TweenService:Create(TextContainer, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, TextboxActual.TextBounds.X + 16, 0, 24)}):Play()
                end)
                
                AddConnection(TextboxActual.FocusLost, function()
                    TextboxConfig.Callback(TextboxActual.Text)
                    if TextboxConfig.TextDisappear then
                        TextboxActual.Text = ""
                    end    
                end)
                
                TextboxActual.Text = TextboxConfig.Default
                
                AddConnection(Click.MouseEnter, function()
                    TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                end)
                
                AddConnection(Click.MouseLeave, function()
                    TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(Click.MouseButton1Up, function()
                    TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                    TextboxActual:CaptureFocus()
                end)
                
                AddConnection(Click.MouseButton1Down, function()
                    TweenService:Create(TextboxFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 6)}):Play()
                end)
            end
            
            function SectionElements:AddColorpicker(ColorpickerConfig)
                ColorpickerConfig = ColorpickerConfig or {}
                ColorpickerConfig.Name = ColorpickerConfig.Name or "Colorpicker"
                ColorpickerConfig.Default = ColorpickerConfig.Default or Color3.fromRGB(255,255,255)
                ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end
                ColorpickerConfig.Flag = ColorpickerConfig.Flag or nil
                ColorpickerConfig.Save = ColorpickerConfig.Save or false
                
                local ColorH, ColorS, ColorV = 1, 1, 1
                local Colorpicker = {Value = ColorpickerConfig.Default, Toggled = false, Type = "Colorpicker", Save = ColorpickerConfig.Save}
                
                local ColorSelection = Create("ImageLabel", {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(select(3, Color3.toHSV(Colorpicker.Value))),
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "http://www.roblox.com/asset/?id=4805639000"
                })
                
                local HueSelection = Create("ImageLabel", {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(Colorpicker.Value))),
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = "http://www.roblox.com/asset/?id=4805639000"
                })
                
                local Color = Create("ImageLabel", {
                    Size = UDim2.new(1, -25, 1, 0),
                    Visible = false,
                    Image = "rbxassetid://4155801252"
                }, {
                    Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                    ColorSelection
                })
                
                local Hue = Create("Frame", {
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    Visible = false
                }, {
                    Create("UIGradient", {Rotation = 270, Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))},}),
                    Create("UICorner", {CornerRadius = UDim.new(0, 5)}),
                    HueSelection
                })
                
                local ColorpickerContainer = Create("Frame", {
                    Position = UDim2.new(0, 0, 0, 32),
                    Size = UDim2.new(1, 0, 1, -32),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true
                }, {
                    Hue,
                    Color,
                    Create("UIPadding", {
                        PaddingLeft = UDim.new(0, 35),
                        PaddingRight = UDim.new(0, 35),
                        PaddingBottom = UDim.new(0, 10),
                        PaddingTop = UDim.new(0, 17)
                    })
                })
                
                local Click = SetProps(MakeElement("Button"), {
                    Size = UDim2.new(1, 0, 1, 0)
                })
                
                local ColorpickerBox = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4), {
                    Size = UDim2.new(0, 24, 0, 24),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5)
                }), {
                    AddThemeObject(MakeElement("Stroke"), "Stroke")
                }), "Main")
                
                local ColorpickerFrame = AddThemeObject(SetChildren(SetProps(MakeElement("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5), {
                    Size = UDim2.new(1, 0, 0, 38),
                    Parent = SectionFrame.Holder
                }), {
                    SetProps(SetChildren(MakeElement("TFrame"), {
                        AddThemeObject(SetProps(MakeElement("Label", ColorpickerConfig.Name, 15), {
                            Size = UDim2.new(1, -12, 1, 0),
                            Position = UDim2.new(0, 12, 0, 0),
                            Font = Enum.Font.GothamBold,
                            Name = "Content"
                        }), "Text"),
                        ColorpickerBox,
                        Click,
                        AddThemeObject(SetProps(MakeElement("Frame"), {
                            Size = UDim2.new(1, 0, 0, 1),
                            Position = UDim2.new(0, 0, 1, -1),
                            Name = "Line",
                            Visible = false
                        }), "Stroke"),
                    }), {
                        Size = UDim2.new(1, 0, 0, 38),
                        ClipsDescendants = true,
                        Name = "F"
                    }),
                    ColorpickerContainer,
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                }), "Second")
                
                AddConnection(Click.MouseButton1Click, function()
                    Colorpicker.Toggled = not Colorpicker.Toggled
                    TweenService:Create(ColorpickerFrame,TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Colorpicker.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)}):Play()
                    Color.Visible = Colorpicker.Toggled
                    Hue.Visible = Colorpicker.Toggled
                    ColorpickerFrame.F.Line.Visible = Colorpicker.Toggled
                end)
                
                local function UpdateColorPicker()
                    ColorpickerBox.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
                    Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
                    Colorpicker:Set(ColorpickerBox.BackgroundColor3)
                    ColorpickerConfig.Callback(ColorpickerBox.BackgroundColor3)
                    SaveCfg(game.GameId)
                end
                
                ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
                ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
                
                AddConnection(Color.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if ColorInput then
                            ColorInput:Disconnect()
                        end
                        ColorInput = AddConnection(RunService.RenderStepped, function()
                            local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                            local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
                            ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                            ColorS = ColorX
                            ColorV = 1 - ColorY
                            UpdateColorPicker()
                        end)
                    end
                end)
                
                AddConnection(Color.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if ColorInput then
                            ColorInput:Disconnect()
                        end
                    end
                end)
                
                AddConnection(Hue.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if HueInput then
                            HueInput:Disconnect()
                        end;
                
                        HueInput = AddConnection(RunService.RenderStepped, function()
                            local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
                
                            HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
                            ColorH = 1 - HueY
                
                            UpdateColorPicker()
                        end)
                    end
                end)
                
                AddConnection(Hue.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if HueInput then
                            HueInput:Disconnect()
                        end
                    end
                end)
                
                function Colorpicker:Set(Value)
                    Colorpicker.Value = Value
                    ColorpickerBox.BackgroundColor3 = Colorpicker.Value
                    ColorpickerConfig.Callback(Colorpicker.Value)
                end
                
                Colorpicker:Set(Colorpicker.Value)
                if ColorpickerConfig.Flag then                
                    CryzenLib.Flags[ColorpickerConfig.Flag] = Colorpicker
                end
                
                return Colorpicker
            end
            
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
            Content = "Thanks for using CryzenHub UI Library"
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
                        Font = Enum.Font.GothamBold
                    }), "Text"),
                    
                    AddThemeObject(MakeElement("Stroke"), "Stroke"),
                    
                    SetProps(MakeElement("Button"), {
                        Size = UDim2.new(1, 0, 1, 0)
                    })
                }), "Second")
                
                AddConnection(ButtonFrame.Button.MouseEnter, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                end)
                
                AddConnection(ButtonFrame.Button.MouseLeave, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = CryzenLib.Themes[CryzenLib.SelectedTheme].Second}):Play()
                end)
                
                AddConnection(ButtonFrame.Button.MouseButton1Up, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 3, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 3)}):Play()
                    Button.Callback()
                end)
                
                AddConnection(ButtonFrame.Button.MouseButton1Down, function()
                    TweenService:Create(ButtonFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(CryzenLib.Themes[CryzenLib.SelectedTheme].Second.R * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.G * 255 + 6, CryzenLib.Themes[CryzenLib.SelectedTheme].Second.B * 255 + 6)}):Play()
                end)
            end
        end
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
    NotificationConfig.Title = NotificationConfig.Title or "Notification"
    NotificationConfig.Content = NotificationConfig.Content or "Content"
    NotificationConfig.Time = NotificationConfig.Time or 3
    NotificationConfig.Image = NotificationConfig.Image or "rbxassetid://7733658504"
    
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
        
        local NotifImage = Create("ImageLabel", {
            Image = NotificationConfig.Image,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 20),
            Size = UDim2.new(0, 25, 0, 25),
            ImageColor3 = Color3.fromRGB(240, 240, 240)
        })
        
        local NotifTitle = Create("TextLabel", {
            Text = NotificationConfig.Title,
            TextColor3 = Color3.fromRGB(240, 240, 240),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1, -45, 0, 20),
            Position = UDim2.new(0, 45, 0, 20),
        })
        
        local NotifContent = Create("TextLabel", {
            Text = NotificationConfig.Content,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, -45, 0, 20),
            Position = UDim2.new(0, 45, 0, 40),
        })
        
        local Notification = Create("Frame", {
            Size = UDim2.new(0, 300, 0, 80),
            BackgroundColor3 = Color3.fromRGB(25, 25, 30),
            BorderSizePixel = 0,
            Parent = NotificationParent
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 5)
            }),
            Create("UIStroke", {
                Thickness = 1,
                Color = Color3.fromRGB(50, 50, 55)
            }),
            NotifImage,
            NotifTitle,
            NotifContent
        })
        
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        
        task.wait(NotificationConfig.Time - 0.88)
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 10, 0, 0)}):Play()
        task.wait(0.88)
        Notification:Destroy()
    end)
end

-- Destroy UI
function CryzenLib:Destroy()
    Cryzen:Destroy()
end

return CryzenLib
