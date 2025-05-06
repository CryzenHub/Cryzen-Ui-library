--[[
 ██████╗██████╗ ██╗   ██╗███████╗███████╗███╗   ██╗    ██╗  ██╗██╗   ██╗██████╗
██╔════╝██╔══██╗╚██╗ ██╔╝╚══███╔╝██╔════╝████╗  ██║    ██║  ██║██║   ██║██╔══██╗
██║     ██████╔╝ ╚████╔╝   ███╔╝ █████╗  ██╔██╗ ██║    ███████║██║   ██║██████╔╝
██║     ██╔══██╗  ╚██╔╝   ███╔╝  ██╔══╝  ██║╚██╗██║    ██╔══██║██║   ██║██╔══██╗
╚██████╗██║  ██║   ██║   ███████╗███████╗██║ ╚████║    ██║  ██║╚██████╔╝██████╔╝
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝

    CryzenHub v2.4 - Premium UI Library
    Developed by Cryzen Team
]]

local CryzenLib = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Viewport = workspace.CurrentCamera.ViewportSize

-- Library Configuration
CryzenLib.Elements = {}
CryzenLib.Flags = {}
CryzenLib.Connections = {}
CryzenLib.Theme = {
    BackgroundColor = Color3.fromRGB(25, 25, 30),
    SectionColor = Color3.fromRGB(30, 30, 35),
    ElementColor = Color3.fromRGB(35, 35, 40),
    TextColor = Color3.fromRGB(235, 235, 235),
    AccentColor = Color3.fromRGB(90, 100, 240),
    PlaceholderColor = Color3.fromRGB(150, 150, 160),
    NotificationColors = {
        Success = Color3.fromRGB(85, 215, 110),
        Error = Color3.fromRGB(215, 85, 85),
        Info = Color3.fromRGB(85, 155, 215),
        Warning = Color3.fromRGB(215, 175, 85)
    }
}
CryzenLib.Version = "2.4.0"
CryzenLib.IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
CryzenLib.KeySystem = false
CryzenLib.KeyData = {
    Key = "",
    SaveKey = false
}
CryzenLib.SaveConfig = false
CryzenLib.ConfigFolder = "CryzenHub"

-- Utility Functions
local function Create(Type, Properties, Children)
    local Object = Instance.new(Type)

    for Name, Value in pairs(Properties or {}) do
        Object[Name] = Value
    end

    for _, Child in ipairs(Children or {}) do
        Child.Parent = Object
    end

    return Object
end

local function AddConnection(Signal, Callback)
    local Connection = Signal:Connect(Callback)
    table.insert(CryzenLib.Connections, Connection)
    return Connection
end

local function Round(Number, Factor)
    return math.floor(Number/Factor + 0.5) * Factor
end

local function MakeDraggable(DragPoint, Object)
    local Dragging, DragInput, MousePos, FramePos = false

    AddConnection(DragPoint.InputBegan, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            MousePos = Input.Position
            FramePos = Object.Position

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
            TweenService:Create(Object, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
            }):Play()
        end
    end)
end

-- Main GUI Setup
local CryzenGUI = Create("ScreenGui", {
    Name = "CryzenHub",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

-- Protect GUI from being destroyed
if syn and syn.protect_gui then
    syn.protect_gui(CryzenGUI)
    CryzenGUI.Parent = CoreGui
elseif gethui then
    CryzenGUI.Parent = gethui()
else
    CryzenGUI.Parent = CoreGui
end

-- Remove duplicate GUIs
for _, GUI in ipairs(CryzenGUI.Parent:GetChildren()) do
    if GUI.Name == "CryzenHub" and GUI ~= CryzenGUI then
        GUI:Destroy()
    end
end

-- Configuration Management
function CryzenLib:SaveConfiguration(GameID)
    if not self.SaveConfig then return end

    local ConfigData = {
        Flags = {},
        Theme = self.Theme,
        Version = self.Version
    }

    -- Save flags
    for FlagName, FlagData in pairs(self.Flags) do
        ConfigData.Flags[FlagName] = {
            Type = FlagData.Type,
            Value = FlagData.Value
        }
    end

    -- Create folders if needed
    if not isfolder(self.ConfigFolder) then
        makefolder(self.ConfigFolder)
    end

    if not isfolder(self.ConfigFolder .. "/" .. GameID) then
        makefolder(self.ConfigFolder .. "/" .. GameID)
    end

    -- Save the configuration
    local Success, Result = pcall(function()
        return HttpService:JSONEncode(ConfigData)
    end)

    if Success then
        writefile(self.ConfigFolder .. "/" .. GameID .. "/config.json", Result)
        return true
    else
        warn("CryzenHub | Failed to save configuration: " .. tostring(Result))
        return false
    end
end

function CryzenLib:LoadConfiguration(GameID)
    if not self.SaveConfig then return false end

    local FilePath = self.ConfigFolder .. "/" .. GameID .. "/config.json"

    -- Check if configuration exists
    if not isfolder(self.ConfigFolder) or not isfolder(self.ConfigFolder .. "/" .. GameID) or not isfile(FilePath) then
        return false
    end

    -- Load configuration
    local Success, ConfigData = pcall(function()
        local FileContent = readfile(FilePath)
        return HttpService:JSONDecode(FileContent)
    end)

    if not Success then
        warn("CryzenHub | Failed to load configuration: " .. tostring(ConfigData))
        return false
    end

    -- Apply loaded flags
    for FlagName, FlagData in pairs(ConfigData.Flags) do
        if self.Flags[FlagName] then
            self.Flags[FlagName]:Set(FlagData.Value)
        end
    end

    return true
end

-- Key System
function CryzenLib:SetKey(KeyData)
    self.KeySystem = true
    self.KeyData = KeyData or {
        Key = "",
        SaveKey = false
    }
    return self
end

function CryzenLib:VerifyKey(Key)
    return Key == self.KeyData.Key
end

function CryzenLib:SaveKeyToFile(Key)
    if not self.KeyData.SaveKey then return end

    if not isfolder(self.ConfigFolder) then
        makefolder(self.ConfigFolder)
    end

    writefile(self.ConfigFolder .. "/key.txt", Key)
end

function CryzenLib:LoadKeyFromFile()
    if not self.KeyData.SaveKey then return nil end

    if not isfolder(self.ConfigFolder) or not isfile(self.ConfigFolder .. "/key.txt") then
        return nil
    end

    return readfile(self.ConfigFolder .. "/key.txt")
end

function CryzenLib:CreateKeySystem()
    if not self.KeySystem then return true end

    -- Check for saved key
    local SavedKey = self:LoadKeyFromFile()
    if SavedKey and self:VerifyKey(SavedKey) then
        return true
    end

    -- Create key UI
    local KeyUI = Create("Frame", {
        Name = "KeySystem",
        Size = UDim2.new(0, 350, 0, 200),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.BackgroundColor,
        Parent = CryzenGUI
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }),
        Create("TextLabel", {
            Name = "Title",
            Text = "CryzenHub Key System",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            TextColor3 = self.Theme.TextColor,
            TextSize = 18,
            Font = Enum.Font.GothamBold
        }),
        Create("TextLabel", {
            Name = "Subtitle",
            Text = "Please enter your key to continue",
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1,
            TextColor3 = self.Theme.PlaceholderColor,
            TextSize = 14,
            Font = Enum.Font.Gotham
        }),
        Create("Frame", {
            Name = "KeyBoxFrame",
            Size = UDim2.new(0.9, 0, 0, 36),
            Position = UDim2.new(0.5, 0, 0, 80),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = self.Theme.ElementColor
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 6)
            }),
            Create("TextBox", {
                Name = "KeyBox",
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = "Enter Key...",
                TextColor3 = self.Theme.TextColor,
                PlaceholderColor3 = self.Theme.PlaceholderColor,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus = false
            })
        }),
        Create("TextButton", {
            Name = "SubmitButton",
            Size = UDim2.new(0.9, 0, 0, 36),
            Position = UDim2.new(0.5, 0, 0, 130),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = self.Theme.AccentColor,
            Text = "Submit",
            TextColor3 = self.Theme.TextColor,
            TextSize = 14,
            Font = Enum.Font.GothamBold
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 6)
            })
        }),
        Create("TextLabel", {
            Name = "Status",
            Text = "",
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 170),
            BackgroundTransparency = 1,
            TextColor3 = self.Theme.NotificationColors.Error,
            TextSize = 14,
            Font = Enum.Font.Gotham
        })
    })

    MakeDraggable(KeyUI, KeyUI)

    -- Key verification logic
    local KeyBox = KeyUI.KeyBoxFrame.KeyBox
    local SubmitButton = KeyUI.SubmitButton
    local StatusLabel = KeyUI.Status

    local KeyVerified = false
    local Attempts = 0
    local MaxAttempts = 5

    SubmitButton.MouseButton1Click:Connect(function()
        local EnteredKey = KeyBox.Text

        if EnteredKey == "" then
            StatusLabel.Text = "Please enter a key"
            return
        end

        Attempts = Attempts + 1

        if self:VerifyKey(EnteredKey) then
            StatusLabel.Text = "Key verified successfully!"
            StatusLabel.TextColor3 = self.Theme.NotificationColors.Success

            if self.KeyData.SaveKey then
                self:SaveKeyToFile(EnteredKey)
            end

            KeyVerified = true
            TweenService:Create(KeyUI, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                Position = UDim2.new(0.5, 0, 1.5, 0),
                BackgroundTransparency = 1
            }):Play()

            wait(0.5)
            KeyUI:Destroy()
        else
            if Attempts >= MaxAttempts then
                StatusLabel.Text = "Too many attempts. Please try again later."
                wait(3)
                KeyUI:Destroy()
            else
                StatusLabel.Text = "Invalid key. Please try again. (" .. Attempts .. "/" .. MaxAttempts .. ")"
            end
        end
    end)

    -- Wait for key verification
    while KeyUI.Parent and not KeyVerified do
        wait(0.1)
    end

    return KeyVerified
end

-- Notification System
function CryzenLib:Notify(NotificationData)
    NotificationData = NotificationData or {}
    NotificationData.Title = NotificationData.Title or "Notification"
    NotificationData.Content = NotificationData.Content or ""
    NotificationData.Duration = NotificationData.Duration or 3
    NotificationData.Type = NotificationData.Type or "Info" -- Info, Success, Error, Warning

    -- Create notification container if it doesn't exist
    local NotificationContainer = CryzenGUI:FindFirstChild("NotificationContainer")
    if not NotificationContainer then
        NotificationContainer = Create("Frame", {
            Name = "NotificationContainer",
            Size = UDim2.new(0, 300, 1, 0),
            Position = UDim2.new(1, -310, 0, 10),
            BackgroundTransparency = 1,
            Parent = CryzenGUI
        }, {
            Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top
            })
        })
    end

    -- Get notification type color
    local TypeColor = self.Theme.NotificationColors[NotificationData.Type] or self.Theme.NotificationColors.Info

    -- Create notification
    local Notification = Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, -20, 0, 80),
        BackgroundColor3 = self.Theme.SectionColor,
        Position = UDim2.new(1, 0, 0, 0),
        Parent = NotificationContainer
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }),
        Create("Frame", {
            Name = "AccentBar",
            Size = UDim2.new(0, 5, 1, -10),
            Position = UDim2.new(0, 5, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = TypeColor
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 2)
            })
        }),
        Create("TextLabel", {
            Name = "Title",
            Text = NotificationData.Title,
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 20, 0, 10),
            BackgroundTransparency = 1,
            TextColor3 = self.Theme.TextColor,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Create("TextLabel", {
            Name = "Content",
            Text = NotificationData.Content,
            Size = UDim2.new(1, -50, 0, 40),
            Position = UDim2.new(0, 20, 0, 35),
            BackgroundTransparency = 1,
            TextColor3 = self.Theme.PlaceholderColor,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        }),
        Create("TextButton", {
            Name = "CloseButton",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -25, 0, 10),
            BackgroundTransparency = 1,
            Text = "×",
            TextColor3 = self.Theme.PlaceholderColor,
            TextSize = 20,
            Font = Enum.Font.GothamBold
        })
    })

    -- Animation
    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    -- Close button
    Notification.CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Position = UDim2.new(1, 0, 0, 0)
        }):Play()

        wait(0.5)
        Notification:Destroy()
    end)

    -- Auto close
    task.spawn(function()
        wait(NotificationData.Duration)
        if Notification and Notification.Parent then
            TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                Position = UDim2.new(1, 0, 0, 0)
            }):Play()

            wait(0.5)
            if Notification and Notification.Parent then
                Notification:Destroy()
            end
        end
    end)

    return Notification
end

-- Main Window Creation
function CryzenLib:CreateWindow(WindowConfig)
    WindowConfig = WindowConfig or {}
    WindowConfig.Title = WindowConfig.Title or "CryzenHub"
    WindowConfig.Size = WindowConfig.Size or UDim2.new(0, 550, 0, 400)
    WindowConfig.Theme = WindowConfig.Theme or self.Theme
    WindowConfig.Centered = WindowConfig.Centered ~= false
    WindowConfig.AutoShow = WindowConfig.AutoShow ~= false

    -- Apply theme
    self.Theme = WindowConfig.Theme

    -- First check key system
    if self.KeySystem then
        local KeyVerified = self:CreateKeySystem()
        if not KeyVerified then
            return {
                AddTab = function() end,
                AddSection = function() end,
                Show = function() end,
                Hide = function() end,
                Destroy = function() end
            }
        end
    end

    -- Create main window
    local Window = Create("Frame", {
        Name = "MainWindow",
        Size = WindowConfig.Size,
        Position = WindowConfig.Centered and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 100, 0, 100),
        AnchorPoint = WindowConfig.Centered and Vector2.new(0.5, 0.5) or Vector2.new(0, 0),
        BackgroundColor3 = self.Theme.BackgroundColor,
        Visible = WindowConfig.AutoShow,
        Parent = CryzenGUI
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }),
        Create("Frame", {
            Name = "TopBar",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = self.Theme.SectionColor
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }),
            Create("TextLabel", {
                Name = "Title",
                Text = WindowConfig.Title,
                Size = UDim2.new(1, -120, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                TextColor3 = self.Theme.TextColor,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Create("TextButton", {
                Name = "CloseButton",
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -35, 0, 5),
                BackgroundTransparency = 1,
                Text = "×",
                TextColor3 = self.Theme.TextColor,
                TextSize = 24,
                Font = Enum.Font.GothamBold
            }),
            Create("TextButton", {
                Name = "MinimizeButton",
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -65, 0, 5),
                BackgroundTransparency = 1,
                Text = "-",
                TextColor3 = self.Theme.TextColor,
                TextSize = 24,
                Font = Enum.Font.GothamBold
            })
        }),
        Create("Frame", {
            Name = "TabContainer",
            Size = UDim2.new(0, 130, 1, -50),
            Position = UDim2.new(0, 10, 0, 50),
            BackgroundColor3 = self.Theme.SectionColor
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }),
            Create("ScrollingFrame", {
                Name = "TabList",
                Size = UDim2.new(1, -10, 1, -10),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = self.Theme.PlaceholderColor,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }, {
                Create("UIListLayout", {
                    Padding = UDim.new(0, 5),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            })
        }),
        Create("Frame", {
            Name = "ContentContainer",
            Size = UDim2.new(1, -160, 1, -50),
            Position = UDim2.new(0, 150, 0, 50),
            BackgroundColor3 = self.Theme.SectionColor
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 8)
            })
        })
    })

    -- Make window draggable
    MakeDraggable(Window.TopBar, Window)

    -- Window controls
    Window.TopBar.CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Window, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Position = UDim2.new(0.5, 0, 1.5, 0),
            BackgroundTransparency = 1
        }):Play()

        wait(0.5)
        CryzenGUI:Destroy()
    end)

    Window.TopBar.MinimizeButton.MouseButton1Click:Connect(function()
        Window.Visible = false
    end)

    -- Keyboard toggle (RightControl)
    AddConnection(UserInputService.InputBegan, function(Input)
        if Input.KeyCode == Enum.KeyCode.RightControl then
            Window.Visible = not Window.Visible
        end
    end)

    -- Update tab list canvas size
    local TabList = Window.TabContainer.TabList
    local TabListLayout = TabList.UIListLayout

    AddConnection(TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Window methods
    local WindowMethods = {}

    function WindowMethods:AddTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Title = TabConfig.Title or "Tab"
        TabConfig.Icon = TabConfig.Icon or nil

        -- Tab button
        local TabButton = Create("TextButton", {
            Name = TabConfig.Title .. "Button",
            Size = UDim2.new(1, -10, 0, 36),
            BackgroundColor3 = self.Theme.ElementColor,
            Text = "",
            Parent = TabList
        }, {
            Create("UICorner", {
                CornerRadius = UDim.new(0, 6)
            }),
            Create("TextLabel", {
                Name = "Title",
                Text = TabConfig.Title,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = self.Theme.TextColor,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold
            })
        })

        -- Add icon if provided
        if TabConfig.Icon then
            TabButton.Title.Size = UDim2.new(1, -30, 1, 0)
            TabButton.Title.Position = UDim2.new(0, 30, 0, 0)

            Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 10, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = TabConfig.Icon,
                ImageColor3 = self.Theme.TextColor,
                Parent = TabButton
            })
        end

        -- Tab content
        local TabContent = Create("ScrollingFrame", {
            Name = TabConfig.Title .. "Content",
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = self.Theme.PlaceholderColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = Window.ContentContainer
        }, {
            Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        })

        -- Show first tab by default
        if #TabList:GetChildren() == 2 then -- UIListLayout + first tab
            TabContent.Visible = true
            TabButton.BackgroundColor3 = self.Theme.AccentColor
        end

        -- Tab button click
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, Content in pairs(Window.ContentContainer:GetChildren()) do
                if Content:IsA("ScrollingFrame") then
                    Content.Visible = false
                end
            end

            -- Reset all tab buttons
            for _, Button in pairs(TabList:GetChildren()) do
                if Button:IsA("TextButton") then
                    Button.BackgroundColor3 = self.Theme.ElementColor
                end
            end

            -- Show selected tab
            TabContent.Visible = true
            TabButton.BackgroundColor3 = self.Theme.AccentColor
        end)

        -- Update content size when children change
        local ContentLayout = TabContent.UIListLayout

        AddConnection(ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 16)
        end)

        -- Tab methods
        local TabMethods = {}

        function TabMethods:AddSection(SectionConfig)
            SectionConfig = SectionConfig or {}
            SectionConfig.Title = SectionConfig.Title or "Section"

            -- Create section
            local Section = Create("Frame", {
                Name = SectionConfig.Title .. "Section",
                Size = UDim2.new(1, 0, 0, 36), -- Initial size, will be updated
                BackgroundColor3 = self.Theme.ElementColor,
                Parent = TabContent
            }, {
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6)
                }),
                Create("TextLabel", {
                    Name = "Title",
                    Text = SectionConfig.Title,
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = self.Theme.TextColor,
                    TextSize = 15,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Create("Frame", {
                    Name = "Content",
                    Size = UDim2.new(1, -20, 0, 0), -- Will be updated
                    Position = UDim2.new(0, 10, 0, 30),
                    BackgroundTransparency = 1
                }, {
                    Create("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                })
            })

            -- Update section size when content changes
            local ContentLayout = Section.Content.UIListLayout

            AddConnection(ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                Section.Content.Size = UDim2.new(1, -20, 0, ContentLayout.AbsoluteContentSize.Y)
                Section.Size = UDim2.new(1, 0, 0, 30 + ContentLayout.AbsoluteContentSize.Y + 10) -- +10 for padding
            end)

            -- Section methods
            local SectionMethods = {}

            -- Add Button
            function SectionMethods:AddButton(ButtonConfig)
                ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Button"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end

                local Button = Create("TextButton", {
                    Name = ButtonConfig.Title .. "Button",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    Text = "",
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = ButtonConfig.Title,
                        Size = UDim2.new(1, -16, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })
                })

                -- Button click
                Button.MouseButton1Click:Connect(ButtonConfig.Callback)

                -- Hover effects
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = self.Theme.AccentColor
                    }):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = self.Theme.BackgroundColor
                    }):Play()
                end)

                -- Button methods
                local ButtonMethods = {}

                function ButtonMethods:SetText(Text)
                    Button.Title.Text = Text
                end

                return ButtonMethods
            end

            -- Add Toggle
            function SectionMethods:AddToggle(ToggleConfig)
                ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Toggle"
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                ToggleConfig.Flag = ToggleConfig.Flag or nil

                local Toggle = Create("Frame", {
                    Name = ToggleConfig.Title .. "Toggle",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = ToggleConfig.Title,
                        Size = UDim2.new(1, -50, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("Frame", {
                        Name = "ToggleFrame",
                        Size = UDim2.new(0, 40, 0, 20),
                        Position = UDim2.new(1, -46, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = ToggleConfig.Default and self.Theme.AccentColor or self.Theme.ElementColor
                    }, {
                        Create("UICorner", {
                            CornerRadius = UDim.new(1, 0)
                        }),
                        Create("Frame", {
                            Name = "Indicator",
                            Size = UDim2.new(0, 16, 0, 16),
                            Position = UDim2.new(ToggleConfig.Default and 1 or 0, ToggleConfig.Default and -18 or 2, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundColor3 = self.Theme.TextColor
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(1, 0)
                            })
                        })
                    }),
                    Create("TextButton", {
                        Name = "ToggleButton",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = ""
                    })
                })

                local ToggleValue = ToggleConfig.Default
                local ToggleFrame = Toggle.ToggleFrame
                local Indicator = ToggleFrame.Indicator

                -- Toggle methods
                local ToggleMethods = {
                    Value = ToggleValue,
                    Type = "Toggle"
                }

                function ToggleMethods:Set(Value)
                    ToggleValue = Value
                    ToggleMethods.Value = Value

                    TweenService:Create(ToggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = ToggleValue and self.Theme.AccentColor or self.Theme.ElementColor
                    }):Play()

                    TweenService:Create(Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(ToggleValue and 1 or 0, ToggleValue and -18 or 2, 0.5, 0)
                    }):Play()

                    ToggleConfig.Callback(ToggleValue)

                    if ToggleConfig.Flag then
                        self.Flags[ToggleConfig.Flag] = ToggleMethods
                    end
                end

                -- Toggle button
                Toggle.ToggleButton.MouseButton1Click:Connect(function()
                    ToggleMethods:Set(not ToggleValue)
                end)

                -- Register flag
                if ToggleConfig.Flag then
                    self.Flags[ToggleConfig.Flag] = ToggleMethods
                end

                return ToggleMethods
            end

            -- Add Slider
            function SectionMethods:AddSlider(SliderConfig)
                SliderConfig = SliderConfig or {}
                SliderConfig.Title = SliderConfig.Title or "Slider"
                SliderConfig.Min = SliderConfig.Min or 0
                SliderConfig.Max = SliderConfig.Max or 100
                SliderConfig.Default = SliderConfig.Default or 50
                SliderConfig.Increment = SliderConfig.Increment or 1
                SliderConfig.Callback = SliderConfig.Callback or function() end
                SliderConfig.Flag = SliderConfig.Flag or nil
                SliderConfig.ValueSuffix = SliderConfig.ValueSuffix or ""

                local Slider = Create("Frame", {
                    Name = SliderConfig.Title .. "Slider",
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = SliderConfig.Title,
                        Size = UDim2.new(1, -16, 0, 20),
                        Position = UDim2.new(0, 8, 0, 5),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("TextLabel", {
                        Name = "Value",
                        Text = tostring(SliderConfig.Default) .. SliderConfig.ValueSuffix,
                        Size = UDim2.new(0, 50, 0, 20),
                        Position = UDim2.new(1, -58, 0, 5),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.PlaceholderColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold
                    }),
                    Create("Frame", {
                        Name = "SliderBar",
                        Size = UDim2.new(1, -16, 0, 6),
                        Position = UDim2.new(0, 8, 0, 32),
                        BackgroundColor3 = self.Theme.ElementColor
                    }, {
                        Create("UICorner", {
                            CornerRadius = UDim.new(1, 0)
                        }),
                        Create("Frame", {
                            Name = "Fill",
                            Size = UDim2.new((SliderConfig.Default - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min), 0, 1, 0),
                            BackgroundColor3 = self.Theme.AccentColor
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(1, 0)
                            })
                        })
                    }),
                    Create("TextButton", {
                        Name = "SliderButton",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = ""
                    })
                })

                local SliderBar = Slider.SliderBar
                local SliderFill = SliderBar.Fill
                local ValueLabel = Slider.Value

                local SliderValue = SliderConfig.Default
                local IsDragging = false

                -- Slider methods
                local SliderMethods = {
                    Value = SliderValue,
                    Type = "Slider"
                }

                function SliderMethods:Set(Value)
                    -- Constrain and round value
                    Value = math.clamp(Value, SliderConfig.Min, SliderConfig.Max)
                    Value = math.floor(Value / SliderConfig.Increment + 0.5) * SliderConfig.Increment
                    Value = tonumber(string.format("%.14g", Value))

                    SliderValue = Value
                    SliderMethods.Value = Value

                    -- Update visuals
                    local Percent = (Value - SliderConfig.Min) / (SliderConfig.Max - SliderConfig.Min)
                    SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
                    ValueLabel.Text = tostring(Value) .. SliderConfig.ValueSuffix

                    -- Callback
                    SliderConfig.Callback(Value)

                    -- Update flag
                    if SliderConfig.Flag then
                        self.Flags[SliderConfig.Flag] = SliderMethods
                    end
                end

                -- Slider interaction
                local function UpdateSlider(Input)
                    local Percent = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local Value = SliderConfig.Min + (SliderConfig.Max - SliderConfig.Min) * Percent
                    SliderMethods:Set(Value)
                end

                Slider.SliderButton.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsDragging = true
                        UpdateSlider(Input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(Input)
                    if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(Input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        IsDragging = false
                    end
                end)

                -- Register flag
                if SliderConfig.Flag then
                    self.Flags[SliderConfig.Flag] = SliderMethods
                end

                return SliderMethods
            end

            -- Add Dropdown
            function SectionMethods:AddDropdown(DropdownConfig)
                DropdownConfig = DropdownConfig or {}
                DropdownConfig.Title = DropdownConfig.Title or "Dropdown"
                DropdownConfig.Items = DropdownConfig.Items or {}
                DropdownConfig.Default = DropdownConfig.Default or ""
                DropdownConfig.Callback = DropdownConfig.Callback or function() end
                DropdownConfig.Flag = DropdownConfig.Flag or nil
                DropdownConfig.Multi = DropdownConfig.Multi or false

                local Dropdown = Create("Frame", {
                    Name = DropdownConfig.Title .. "Dropdown",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    ClipsDescendants = true,
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = DropdownConfig.Title,
                        Size = UDim2.new(1, -30, 0, 32),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("TextLabel", {
                        Name = "Arrow",
                        Text = "▼",
                        Size = UDim2.new(0, 20, 0, 32),
                        Position = UDim2.new(1, -25, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.PlaceholderColor,
                        TextSize = 12,
                        Font = Enum.Font.GothamBold
                    }),
                    Create("TextLabel", {
                        Name = "Selected",
                        Text = DropdownConfig.Default,
                        Size = UDim2.new(1, -60, 0, 32),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.PlaceholderColor,
                        TextSize = 14,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Right
                    }),
                    Create("Frame", {
                        Name = "ItemContainer",
                        Size = UDim2.new(1, -16, 0, 0), -- Will be updated
                        Position = UDim2.new(0, 8, 0, 32),
                        BackgroundTransparency = 1
                    }, {
                        Create("UIListLayout", {
                            Padding = UDim.new(0, 4),
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder
                        })
                    }),
                    Create("TextButton", {
                        Name = "DropdownButton",
                        Size = UDim2.new(1, 0, 0, 32),
                        BackgroundTransparency = 1,
                        Text = ""
                    })
                })

                local Selected = DropdownConfig.Multi and {} or DropdownConfig.Default
                local ItemContainer = Dropdown.ItemContainer
                local ItemLayout = ItemContainer.UIListLayout
                local IsOpen = false

                -- Dropdown methods
                local DropdownMethods = {
                    Value = Selected,
                    Type = "Dropdown"
                }

                local function UpdateDropdownText()
                    if DropdownConfig.Multi then
                        local Count = 0
                        for _ in pairs(Selected) do
                            Count = Count + 1
                        end

                        if Count == 0 then
                            Dropdown.Selected.Text = ""
                        elseif Count == 1 then
                            for Item, _ in pairs(Selected) do
                                Dropdown.Selected.Text = Item
                                break
                            end
                        else
                            Dropdown.Selected.Text = Count .. " items selected"
                        end
                    else
                        Dropdown.Selected.Text = Selected or ""
                    end
                end

                local function CreateDropdownItem(Item)
                    local ItemButton = Create("TextButton", {
                        Name = Item .. "Item",
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = self.Theme.ElementColor,
                        Text = "",
                        Parent = ItemContainer
                    }, {
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 4)
                        }),
                        Create("TextLabel", {
                            Name = "Title",
                            Text = Item,
                            Size = UDim2.new(1, -16, 1, 0),
                            Position = UDim2.new(0, 8, 0, 0),
                            BackgroundTransparency = 1,
                            TextColor3 = self.Theme.TextColor,
                            TextSize = 14,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left
                        })
                    })

                    -- Add checkbox for multi-select
                    if DropdownConfig.Multi then
                        local Checkbox = Create("Frame", {
                            Name = "Checkbox",
                            Size = UDim2.new(0, 16, 0, 16),
                            Position = UDim2.new(1, -24, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundColor3 = Selected[Item] and self.Theme.AccentColor or self.Theme.ElementColor,
                            Parent = ItemButton
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(0, 4)
                            }),
                            Create("UIStroke", {
                                Color = self.Theme.StrokeColor,
                                Thickness = 1
                            }),
                            Create("TextLabel", {
                                Name = "Check",
                                Text = "✓",
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                TextColor3 = self.Theme.TextColor,
                                TextSize = 12,
                                Font = Enum.Font.GothamBold,
                                Visible = Selected[Item] or false
                            })
                        })
                    end

                    -- Item click
                    ItemButton.MouseButton1Click:Connect(function()
                        if DropdownConfig.Multi then
                            Selected[Item] = not Selected[Item]

                            if Selected[Item] then
                                TweenService:Create(ItemButton.Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                                    BackgroundColor3 = self.Theme.AccentColor
                                }):Play()
                                ItemButton.Checkbox.Check.Visible = true
                            else
                                TweenService:Create(ItemButton.Checkbox, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                                    BackgroundColor3 = self.Theme.ElementColor
                                }):Play()
                                ItemButton.Checkbox.Check.Visible = false

                                if Selected[Item] == false then
                                    Selected[Item] = nil
                                end
                            end

                            UpdateDropdownText()
                            DropdownMethods.Value = Selected
                            DropdownConfig.Callback(Selected)
                        else
                            Selected = Item
                            UpdateDropdownText()
                            DropdownMethods.Value = Selected
                            DropdownConfig.Callback(Selected)

                            -- Close dropdown
                            TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                                Size = UDim2.new(1, 0, 0, 32)
                            }):Play()
                            TweenService:Create(Dropdown.Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                                Rotation = 0
                            }):Play()
                            IsOpen = false
                        end

                        if DropdownConfig.Flag then
                            self.Flags[DropdownConfig.Flag] = DropdownMethods
                        end
                    end)

                    -- Item hover effects
                    ItemButton.MouseEnter:Connect(function()
                        TweenService:Create(ItemButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            BackgroundColor3 = self.Theme.AccentColor
                        }):Play()
                    end)

                    ItemButton.MouseLeave:Connect(function()
                        TweenService:Create(ItemButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            BackgroundColor3 = self.Theme.ElementColor
                        }):Play()
                    end)
                end

                -- Create initial items
                for _, Item in ipairs(DropdownConfig.Items) do
                    CreateDropdownItem(Item)
                end

                -- Update container size
                AddConnection(ItemLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                    if IsOpen then
                        ItemContainer.Size = UDim2.new(1, -16, 0, ItemLayout.AbsoluteContentSize.Y)
                        Dropdown.Size = UDim2.new(1, 0, 0, 32 + ItemLayout.AbsoluteContentSize.Y + 8)
                    end
                end)

                -- Dropdown button
                Dropdown.DropdownButton.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen

                    if IsOpen then
                        TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, 32 + ItemLayout.AbsoluteContentSize.Y + 8)
                        }):Play()
                        TweenService:Create(Dropdown.Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Rotation = 180
                        }):Play()
                    else
                        TweenService:Create(Dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, 32)
                        }):Play()
                        TweenService:Create(Dropdown.Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Rotation = 0
                        }):Play()
                    end
                end)

                -- Initialize
                UpdateDropdownText()

                -- Set method
                function DropdownMethods:Set(Value)
                    if DropdownConfig.Multi then
                        if type(Value) ~= "table" then
                            warn("Dropdown:Set requires a table for multi-select dropdowns")
                            return
                        end

                        Selected = Value

                        for _, Item in ipairs(DropdownConfig.Items) do
                            local ItemButton = ItemContainer:FindFirstChild(Item .. "Item")
                            if ItemButton and ItemButton:FindFirstChild("Checkbox") then
                                ItemButton.Checkbox.BackgroundColor3 = Selected[Item] and self.Theme.AccentColor or self.Theme.ElementColor
                                ItemButton.Checkbox.Check.Visible = Selected[Item] or false
                            end
                        end
                    else
                        if table.find(DropdownConfig.Items, Value) then
                            Selected = Value
                        end
                    end

                    UpdateDropdownText()
                    DropdownMethods.Value = Selected
                    DropdownConfig.Callback(Selected)

                    if DropdownConfig.Flag then
                        self.Flags[DropdownConfig.Flag] = DropdownMethods
                    end
                end

                -- Add items method
                function DropdownMethods:Refresh(Items, Clear)
                    if Clear then
                        -- Clear existing items
                        for _, Child in ipairs(ItemContainer:GetChildren()) do
                            if Child:IsA("TextButton") then
                                Child:Destroy()
                            end
                        end

                        DropdownConfig.Items = Items
                    else
                        -- Add new items
                        for _, Item in ipairs(Items) do
                            if not table.find(DropdownConfig.Items, Item) then
                                table.insert(DropdownConfig.Items, Item)
                            end
                        end
                    end

                    -- Create new items
                    for _, Item in ipairs(DropdownConfig.Items) do
                        if not ItemContainer:FindFirstChild(Item .. "Item") then
                            CreateDropdownItem(Item)
                        end
                    end
                end

                -- Register flag
                if DropdownConfig.Flag then
                    self.Flags[DropdownConfig.Flag] = DropdownMethods
                end

                return DropdownMethods
            end

            -- Add TextBox
            function SectionMethods:AddTextbox(TextboxConfig)
                TextboxConfig = TextboxConfig or {}
                TextboxConfig.Title = TextboxConfig.Title or "Textbox"
                TextboxConfig.Default = TextboxConfig.Default or ""
                TextboxConfig.Placeholder = TextboxConfig.Placeholder or "Enter text..."
                TextboxConfig.Callback = TextboxConfig.Callback or function() end
                TextboxConfig.Flag = TextboxConfig.Flag or nil
                TextboxConfig.ClearOnFocus = TextboxConfig.ClearOnFocus ~= nil and TextboxConfig.ClearOnFocus or false

                local Textbox = Create("Frame", {
                    Name = TextboxConfig.Title .. "Textbox",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = TextboxConfig.Title,
                        Size = UDim2.new(0, 200, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("Frame", {
                        Name = "InputFrame",
                        Size = UDim2.new(0.5, -16, 0, 24),
                        Position = UDim2.new(1, -8, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = self.Theme.ElementColor
                    }, {
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 4)
                        }),
                        Create("TextBox", {
                            Name = "Input",
                            Size = UDim2.new(1, -16, 1, 0),
                            Position = UDim2.new(0, 8, 0, 0),
                            BackgroundTransparency = 1,
                            Text = TextboxConfig.Default,
                            PlaceholderText = TextboxConfig.Placeholder,
                            TextColor3 = self.Theme.TextColor,
                            PlaceholderColor3 = self.Theme.PlaceholderColor,
                            TextSize = 14,
                            Font = Enum.Font.Gotham,
                            ClearTextOnFocus = TextboxConfig.ClearOnFocus
                        })
                    })
                })

                local TextboxValue = TextboxConfig.Default
                local InputBox = Textbox.InputFrame.Input

                -- Textbox methods
                local TextboxMethods = {
                    Value = TextboxValue,
                    Type = "Textbox"
                }

                function TextboxMethods:Set(Value)
                    TextboxValue = Value
                    TextboxMethods.Value = Value
                    InputBox.Text = Value

                    if TextboxConfig.Flag then
                        self.Flags[TextboxConfig.Flag] = TextboxMethods
                    end
                end

                -- Focus lost callback
                InputBox.FocusLost:Connect(function(EnterPressed)
                    TextboxValue = InputBox.Text
                    TextboxMethods.Value = TextboxValue

                    TextboxConfig.Callback(TextboxValue, EnterPressed)

                    if TextboxConfig.Flag then
                        self.Flags[TextboxConfig.Flag] = TextboxMethods
                    end
                end)

                -- Register flag
                if TextboxConfig.Flag then
                    self.Flags[TextboxConfig.Flag] = TextboxMethods
                end

                return TextboxMethods
            end

            -- Add Keybind
            function SectionMethods:AddKeybind(KeybindConfig)
                KeybindConfig = KeybindConfig or {}
                KeybindConfig.Title = KeybindConfig.Title or "Keybind"
                KeybindConfig.Default = KeybindConfig.Default or Enum.KeyCode.Unknown
                KeybindConfig.Callback = KeybindConfig.Callback or function() end
                KeybindConfig.Flag = KeybindConfig.Flag or nil
                KeybindConfig.ChangedCallback = KeybindConfig.ChangedCallback or function() end

                local Keybind = Create("Frame", {
                    Name = KeybindConfig.Title .. "Keybind",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = KeybindConfig.Title,
                        Size = UDim2.new(1, -120, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("Frame", {
                        Name = "KeyDisplay",
                        Size = UDim2.new(0, 100, 0, 24),
                        Position = UDim2.new(1, -108, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = self.Theme.ElementColor
                    }, {
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 4)
                        }),
                        Create("TextLabel", {
                            Name = "KeyText",
                            Text = KeybindConfig.Default ~= Enum.KeyCode.Unknown and KeybindConfig.Default.Name or "None",
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            TextColor3 = self.Theme.TextColor,
                            TextSize = 14,
                            Font = Enum.Font.Gotham
                        })
                    }),
                    Create("TextButton", {
                        Name = "KeybindButton",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = ""
                    })
                })

                local KeyDisplay = Keybind.KeyDisplay
                local KeyText = KeyDisplay.KeyText
                local CurrentKey = KeybindConfig.Default
                local IsChangingKey = false

                -- Keybind methods
                local KeybindMethods = {
                    Value = CurrentKey,
                    Type = "Keybind"
                }

                function KeybindMethods:Set(Key)
                    CurrentKey = Key
                    KeybindMethods.Value = Key
                    KeyText.Text = Key ~= Enum.KeyCode.Unknown and Key.Name or "None"

                    if KeybindConfig.Flag then
                        self.Flags[KeybindConfig.Flag] = KeybindMethods
                    end

                    KeybindConfig.ChangedCallback(Key)
                end

                -- Keybind button
                Keybind.KeybindButton.MouseButton1Click:Connect(function()
                    if IsChangingKey then return end

                    IsChangingKey = true
                    KeyText.Text = "..."

                    local InputConnection
                    InputConnection = UserInputService.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Keyboard then
                            KeybindMethods:Set(Input.KeyCode)
                            IsChangingKey = false
                            InputConnection:Disconnect()
                        end
                    end)
                end)

                -- Global input detection
                UserInputService.InputBegan:Connect(function(Input)
                    if not IsChangingKey and Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode == CurrentKey then
                            KeybindConfig.Callback()
                        end
                    end
                end)

                -- Register flag
                if KeybindConfig.Flag then
                    self.Flags[KeybindConfig.Flag] = KeybindMethods
                end

                return KeybindMethods
            end

            -- Add Colorpicker
            function SectionMethods:AddColorpicker(ColorpickerConfig)
                ColorpickerConfig = ColorpickerConfig or {}
                ColorpickerConfig.Title = ColorpickerConfig.Title or "Colorpicker"
                ColorpickerConfig.Default = ColorpickerConfig.Default or Color3.fromRGB(255, 255, 255)
                ColorpickerConfig.Callback = ColorpickerConfig.Callback or function() end
                ColorpickerConfig.Flag = ColorpickerConfig.Flag or nil

                local Colorpicker = Create("Frame", {
                    Name = ColorpickerConfig.Title .. "Colorpicker",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    ClipsDescendants = true,
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = ColorpickerConfig.Title,
                        Size = UDim2.new(1, -120, 1, 0),
                        Position = UDim2.new(0, 8, 0, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("Frame", {
                        Name = "ColorDisplay",
                        Size = UDim2.new(0, 100, 0, 24),
                        Position = UDim2.new(1, -108, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = ColorpickerConfig.Default
                    }, {
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 4)
                        })
                    }),
                    Create("TextButton", {
                        Name = "ColorpickerButton",
                        Size = UDim2.new(1, 0, 0, 32),
                        BackgroundTransparency = 1,
                        Text = ""
                    }),
                    Create("Frame", {
                        Name = "ColorPickerContainer",
                        Size = UDim2.new(1, -16, 0, 0), -- Will be updated
                        Position = UDim2.new(0, 8, 0, 32),
                        BackgroundColor3 = self.Theme.ElementColor,
                        Visible = false
                    }, {
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 4)
                        }),
                        Create("Frame", {
                            Name = "ColorSpace",
                            Size = UDim2.new(1, -130, 0, 120),
                            Position = UDim2.new(0, 5, 0, 5),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(0, 4)
                            }),
                            Create("UIGradient", {
                                Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                                }),
                                Transparency = NumberSequence.new(0)
                            }),
                            Create("Frame", {
                                Name = "Overlay",
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            }, {
                                Create("UICorner", {
                                    CornerRadius = UDim.new(0, 4)
                                }),
                                Create("UIGradient", {
                                    Color = ColorSequence.new({
                                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                                    }),
                                    Transparency = NumberSequence.new({
                                        NumberSequenceKeypoint.new(0, 0),
                                        NumberSequenceKeypoint.new(1, 1)
                                    }),
                                    Rotation = 90
                                })
                            }),
                            Create("Frame", {
                                Name = "Cursor",
                                Size = UDim2.new(0, 10, 0, 10),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                ZIndex = 2
                            }, {
                                Create("UICorner", {
                                    CornerRadius = UDim.new(1, 0)
                                }),
                                Create("UIStroke", {
                                    Color = Color3.fromRGB(0, 0, 0),
                                    Thickness = 1
                                })
                            })
                        }),
                        Create("Frame", {
                            Name = "HueSlider",
                            Size = UDim2.new(0, 20, 0, 120),
                            Position = UDim2.new(1, -120, 0, 5),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(0, 4)
                            }),
                            Create("UIGradient", {
                                Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                                }),
                                Rotation = 90
                            }),
                            Create("Frame", {
                                Name = "Cursor",
                                Size = UDim2.new(1, 0, 0, 4),
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                ZIndex = 2
                            }, {
                                Create("UICorner", {
                                    CornerRadius = UDim.new(0, 2)
                                }),
                                Create("UIStroke", {
                                    Color = Color3.fromRGB(0, 0, 0),
                                    Thickness = 1
                                })
                            })
                        }),
                        Create("Frame", {
                            Name = "AlphaSlider",
                            Size = UDim2.new(0, 20, 0, 120),
                            Position = UDim2.new(1, -90, 0, 5),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            ClipsDescendants = true
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(0, 4)
                            }),
                            Create("Frame", {
                                Name = "Checker",
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1
                            }),
                            Create("UIGradient", {
                                Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                                }),
                                Rotation = 90
                            }),
                            Create("Frame", {
                                Name = "Cursor",
                                Size = UDim2.new(1, 0, 0, 4),
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                ZIndex = 2
                            }, {
                                Create("UICorner", {
                                    CornerRadius = UDim.new(0, 2)
                                }),
                                Create("UIStroke", {
                                    Color = Color3.fromRGB(0, 0, 0),
                                    Thickness = 1
                                })
                            })
                        }),
                        Create("Frame", {
                            Name = "Preview",
                            Size = UDim2.new(0, 60, 0, 60),
                            Position = UDim2.new(1, -60, 0, 5),
                            BackgroundColor3 = ColorpickerConfig.Default
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(0, 4)
                            })
                        }),
                        Create("TextButton", {
                            Name = "ConfirmButton",
                            Size = UDim2.new(0, 60, 0, 30),
                            Position = UDim2.new(1, -60, 0, 70),
                            BackgroundColor3 = self.Theme.AccentColor,
                            Text = "Confirm",
                            TextColor3 = self.Theme.TextColor,
                            TextSize = 14,
                            Font = Enum.Font.GothamBold
                        }, {
                            Create("UICorner", {
                                CornerRadius = UDim.new(0, 4)
                            })
                        })
                    })
                })

                local ColorDisplay = Colorpicker.ColorDisplay
                local ColorPickerContainer = Colorpicker.ColorPickerContainer
                local ColorSpace = ColorPickerContainer.ColorSpace
                local HueSlider = ColorPickerContainer.HueSlider
                local AlphaSlider = ColorPickerContainer.AlphaSlider
                local Preview = ColorPickerContainer.Preview
                local ConfirmButton = ColorPickerContainer.ConfirmButton

                local ColorH, ColorS, ColorV = 0, 0, 1
                local CurrentColor = ColorpickerConfig.Default
                local CurrentAlpha = 1
                local IsOpen = false

                -- Convert RGB to HSV
                local h, s, v = Color3.toHSV(CurrentColor)
                ColorH, ColorS, ColorV = h, s, v

                -- Update color space gradient
                local function UpdateColorSpace()
                    ColorSpace.UIGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromHSV(ColorH, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    })
                end

                -- Update preview color
                local function UpdatePreview()
                    local NewColor = Color3.fromHSV(ColorH, ColorS, ColorV)
                    Preview.BackgroundColor3 = NewColor
                    ColorDisplay.BackgroundColor3 = NewColor
                end

                -- Update cursors
                local function UpdateCursors()
                    -- Color space cursor
                    ColorSpace.Cursor.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)

                    -- Hue slider cursor
                    HueSlider.Cursor.Position = UDim2.new(0, 0, ColorH, 0)

                    -- Alpha slider cursor
                    AlphaSlider.Cursor.Position = UDim2.new(0, 0, CurrentAlpha, 0)
                end

                -- Initialize
                UpdateColorSpace()
                UpdatePreview()
                UpdateCursors()

                -- Colorpicker methods
                local ColorpickerMethods = {
                    Value = CurrentColor,
                    Type = "Colorpicker"
                }

                function ColorpickerMethods:Set(Color, Alpha)
                    if typeof(Color) == "Color3" then
                        local h, s, v = Color3.toHSV(Color)
                        ColorH, ColorS, ColorV = h, s, v
                        CurrentColor = Color

                        UpdateColorSpace()
                        UpdatePreview()
                        UpdateCursors()

                        ColorpickerMethods.Value = CurrentColor
                        ColorpickerConfig.Callback(CurrentColor, CurrentAlpha)

                        if ColorpickerConfig.Flag then
                            self.Flags[ColorpickerConfig.Flag] = ColorpickerMethods
                        end
                    end

                    if Alpha then
                        CurrentAlpha = Alpha
                        UpdateCursors()
                    end
                end

                -- Color space interaction
                local ColorSpaceButton = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = ColorSpace
                })

                local function UpdateColorFromSpace(Input)
                    local RelativeX = math.clamp((Input.Position.X - ColorSpace.AbsolutePosition.X) / ColorSpace.AbsoluteSize.X, 0, 1)
                    local RelativeY = math.clamp((Input.Position.Y - ColorSpace.AbsolutePosition.Y) / ColorSpace.AbsoluteSize.Y, 0, 1)

                    ColorS = RelativeX
                    ColorV = 1 - RelativeY

                    UpdatePreview()
                    UpdateCursors()
                end

                local SpaceDragging = false

                ColorSpaceButton.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        SpaceDragging = true
                        UpdateColorFromSpace(Input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(Input)
                    if SpaceDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateColorFromSpace(Input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        SpaceDragging = false
                    end
                end)

                -- Hue slider interaction
                local HueButton = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = HueSlider
                })

                local function UpdateHue(Input)
                    local RelativeY = math.clamp((Input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)

                    ColorH = RelativeY

                    UpdateColorSpace()
                    UpdatePreview()
                    UpdateCursors()
                end

                local HueDragging = false

                HueButton.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        HueDragging = true
                        UpdateHue(Input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(Input)
                    if HueDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateHue(Input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        HueDragging = false
                    end
                end)

                -- Alpha slider interaction
                local AlphaButton = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = AlphaSlider
                })

                local function UpdateAlpha(Input)
                    local RelativeY = math.clamp((Input.Position.Y - AlphaSlider.AbsolutePosition.Y) / AlphaSlider.AbsoluteSize.Y, 0, 1)

                    CurrentAlpha = RelativeY

                    UpdateCursors()
                end

                local AlphaDragging = false

                AlphaButton.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        AlphaDragging = true
                        UpdateAlpha(Input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(Input)
                    if AlphaDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateAlpha(Input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        AlphaDragging = false
                    end
                end)

                -- Confirm button
                ConfirmButton.MouseButton1Click:Connect(function()
                    CurrentColor = Color3.fromHSV(ColorH, ColorS, ColorV)
                    ColorpickerMethods.Value = CurrentColor

                    ColorpickerConfig.Callback(CurrentColor, CurrentAlpha)

                    if ColorpickerConfig.Flag then
                        self.Flags[ColorpickerConfig.Flag] = ColorpickerMethods
                    end

                    -- Close colorpicker
                    TweenService:Create(Colorpicker, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(1, 0, 0, 32)
                    }):Play()

                    IsOpen = false
                    wait(0.2)
                    ColorPickerContainer.Visible = false
                end)

                -- Toggle colorpicker
                Colorpicker.ColorpickerButton.MouseButton1Click:Connect(function()
                    IsOpen = not IsOpen

                    if IsOpen then
                        ColorPickerContainer.Size = UDim2.new(1, -16, 0, 130)
                        ColorPickerContainer.Visible = true

                        TweenService:Create(Colorpicker, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, 170)
                        }):Play()
                    else
                        TweenService:Create(Colorpicker, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(1, 0, 0, 32)
                        }):Play()

                        wait(0.2)
                        ColorPickerContainer.Visible = false
                    end
                end)

                -- Register flag
                if ColorpickerConfig.Flag then
                    self.Flags[ColorpickerConfig.Flag] = ColorpickerMethods
                end

                return ColorpickerMethods
            end

            -- Add Label
            function SectionMethods:AddLabel(LabelConfig)
                LabelConfig = LabelConfig or {}
                LabelConfig.Text = LabelConfig.Text or "Label"
                LabelConfig.Color = LabelConfig.Color or self.Theme.TextColor

                local Label = Create("Frame", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Parent = Section.Content
                }, {
                    Create("TextLabel", {
                        Name = "Text",
                        Text = LabelConfig.Text,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        TextColor3 = LabelConfig.Color,
                        TextSize = 14,
                        Font = Enum.Font.GothamSemibold,
                        TextWrapped = true
                    })
                })

                -- Label methods
                local LabelMethods = {}

                function LabelMethods:SetText(Text)
                    Label.Text.Text = Text
                end

                function LabelMethods:SetColor(Color)
                    Label.Text.TextColor3 = Color
                end

                return LabelMethods
            end

            -- Add Paragraph
            function SectionMethods:AddParagraph(ParagraphConfig)
                ParagraphConfig = ParagraphConfig or {}
                ParagraphConfig.Title = ParagraphConfig.Title or "Title"
                ParagraphConfig.Content = ParagraphConfig.Content or "Content"

                local Paragraph = Create("Frame", {
                    Name = "Paragraph",
                    Size = UDim2.new(1, 0, 0, 40), -- Will be updated
                    BackgroundColor3 = self.Theme.BackgroundColor,
                    Parent = Section.Content
                }, {
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4)
                    }),
                    Create("TextLabel", {
                        Name = "Title",
                        Text = ParagraphConfig.Title,
                        Size = UDim2.new(1, -16, 0, 20),
                        Position = UDim2.new(0, 8, 0, 8),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.TextColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamBold,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    Create("TextLabel", {
                        Name = "Content",
                        Text = ParagraphConfig.Content,
                        Size = UDim2.new(1, -16, 0, 0), -- Will be updated
                        Position = UDim2.new(0, 8, 0, 28),
                        BackgroundTransparency = 1,
                        TextColor3 = self.Theme.PlaceholderColor,
                        TextSize = 14,
                        Font = Enum.Font.Gotham,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    })
                })

                -- Update content size
                local Content = Paragraph.Content
                local TextSize = TextService:GetTextSize(Content.Text, 14, Enum.Font.Gotham, Vector2.new(Content.AbsoluteSize.X, math.huge))

                Content.Size = UDim2.new(1, -16, 0, TextSize.Y)
                Paragraph.Size = UDim2.new(1, 0, 0, 36 + TextSize.Y)

                -- Paragraph methods
                local ParagraphMethods = {}

                function ParagraphMethods:SetTitle(Title)
                    Paragraph.Title.Text = Title
                end

                function ParagraphMethods:SetContent(Content)
                    Paragraph.Content.Text = Content

                    -- Update size
                    local TextSize = TextService:GetTextSize(Paragraph.Content.Text, 14, Enum.Font.Gotham, Vector2.new(Paragraph.Content.AbsoluteSize.X, math.huge))

                    Paragraph.Content.Size = UDim2.new(1, -16, 0, TextSize.Y)
                    Paragraph.Size = UDim2.new(1, 0, 0, 36 + TextSize.Y)
                end

                return ParagraphMethods
            end

            return SectionMethods
        end

        -- Window show/hide methods
        function WindowMethods:Show()
            Window.Visible = true
        end

        function WindowMethods:Hide()
            Window.Visible = false
        end

        function WindowMethods:Toggle()
            Window.Visible = not Window.Visible
        end

        function WindowMethods:Destroy()
            CryzenGUI:Destroy()
        end

        -- Tab container update
        AddConnection(Window.TabContainer.TabList.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            local TabList = Window.TabContainer.TabList
            TabList.CanvasSize = UDim2.new(0, 0, 0, TabList.UIListLayout.AbsoluteContentSize.Y + 10)
        end)

        return WindowMethods
    end

    -- Clean up connections when the GUI is destroyed
    AddConnection(CryzenGUI:GetPropertyChangedSignal("Parent"), function()
        if not CryzenGUI.Parent then
            for _, Connection in pairs(CryzenLib.Connections) do
                Connection:Disconnect()
            end
            CryzenLib.Connections = {}
        end
    end)

    return self
end

return CryzenLib
