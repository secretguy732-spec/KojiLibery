--[[
    ██╗  ██╗ ██████╗      ██╗██╗    ██╗   ██╗███████╗██████╗ ██╗   ██╗
    ██║ ██╔╝██╔═══██╗     ██║██║    ██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝
    █████╔╝ ██║   ██║     ██║██║    ██║   ██║█████╗  ██████╔╝ ╚████╔╝ 
    ██╔═██╗ ██║   ██║██   ██║██║    ╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝  
    ██║  ██╗╚██████╔╝╚█████╔╝██║     ╚████╔╝ ███████╗██║  ██║   ██║   
    ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚═╝      ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   

    Koji Livery — A Premium Roblox UI Library
    Version: 1.0.0
    Author: Koji Project
    License: MIT (see LICENSE)
    Docs: https://koji.menu/docs

    A clean, modern, highly customizable UI library for Roblox exploits.
    Inspired by the spirit of open-source Roblox UI tooling.
]]

-- ═══════════════════════════════════════════════════════════════
--  KOJI LIVERY v1.0.0
-- ═══════════════════════════════════════════════════════════════

local Koji = {}
Koji.__index = Koji
Koji.Version = "1.0.0"
Koji.ActiveWindows = {}
Koji.Flags = {}
Koji.Connections = {}
Koji.ConfigFolder = "KojiLivery"

-- ──────────────────────────────────────────────────────────────
--  SERVICES
-- ──────────────────────────────────────────────────────────────
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui        = game:GetService("CoreGui")
local Players        = game:GetService("Players")
local HttpService    = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ──────────────────────────────────────────────────────────────
--  INTERNAL UTILITIES
-- ──────────────────────────────────────────────────────────────
local function Tween(obj, props, dur, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir   = dir   or Enum.EasingDirection.Out
    local ti = TweenInfo.new(dur or 0.25, style, dir)
    local t  = TweenService:Create(obj, ti, props)
    t:Play()
    return t
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function RoundNumber(n, dec)
    local m = 10 ^ (dec or 0)
    return math.floor(n * m + 0.5) / m
end

local function TableFind(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return i end
    end
    return nil
end

local function SafeDestroy(obj)
    if obj and obj.Parent then
        pcall(function() obj:Destroy() end)
    end
end

-- ──────────────────────────────────────────────────────────────
--  THEME SYSTEM
-- ──────────────────────────────────────────────────────────────
Koji.Themes = {
    Midnight = {
        Background      = Color3.fromRGB(10,  10,  18),
        SecondBg        = Color3.fromRGB(16,  16,  28),
        ThirdBg         = Color3.fromRGB(22,  22,  38),
        Accent          = Color3.fromRGB(100, 160, 255),
        AccentDark      = Color3.fromRGB(60,  100, 200),
        Text            = Color3.fromRGB(240, 240, 255),
        SubText         = Color3.fromRGB(140, 140, 180),
        PlaceholderText = Color3.fromRGB(90,  90,  130),
        Border          = Color3.fromRGB(35,  35,  60),
        Toggle          = Color3.fromRGB(30,  200, 120),
        ToggleOff       = Color3.fromRGB(60,  60,  90),
        Slider          = Color3.fromRGB(100, 160, 255),
        Danger          = Color3.fromRGB(255, 80,  80),
        Warning         = Color3.fromRGB(255, 180, 60),
        Success         = Color3.fromRGB(60,  210, 120),
        TopBar          = Color3.fromRGB(14,  14,  24),
        Shadow          = Color3.fromRGB(0,   0,   0),
        Notification    = Color3.fromRGB(100, 160, 255),
    },
    Sakura = {
        Background      = Color3.fromRGB(18,  10,  18),
        SecondBg        = Color3.fromRGB(28,  14,  28),
        ThirdBg         = Color3.fromRGB(38,  20,  38),
        Accent          = Color3.fromRGB(255, 120, 200),
        AccentDark      = Color3.fromRGB(200, 70,  160),
        Text            = Color3.fromRGB(255, 240, 255),
        SubText         = Color3.fromRGB(200, 160, 200),
        PlaceholderText = Color3.fromRGB(130, 90,  130),
        Border          = Color3.fromRGB(60,  30,  60),
        Toggle          = Color3.fromRGB(255, 120, 200),
        ToggleOff       = Color3.fromRGB(80,  40,  80),
        Slider          = Color3.fromRGB(255, 120, 200),
        Danger          = Color3.fromRGB(255, 80,  80),
        Warning         = Color3.fromRGB(255, 200, 60),
        Success         = Color3.fromRGB(120, 220, 150),
        TopBar          = Color3.fromRGB(22,  12,  22),
        Shadow          = Color3.fromRGB(0,   0,   0),
        Notification    = Color3.fromRGB(255, 120, 200),
    },
    Ember = {
        Background      = Color3.fromRGB(18,  10,  8),
        SecondBg        = Color3.fromRGB(28,  16,  10),
        ThirdBg         = Color3.fromRGB(38,  22,  14),
        Accent          = Color3.fromRGB(255, 140, 60),
        AccentDark      = Color3.fromRGB(200, 90,  30),
        Text            = Color3.fromRGB(255, 240, 220),
        SubText         = Color3.fromRGB(200, 170, 140),
        PlaceholderText = Color3.fromRGB(130, 100, 80),
        Border          = Color3.fromRGB(60,  36,  20),
        Toggle          = Color3.fromRGB(255, 140, 60),
        ToggleOff       = Color3.fromRGB(80,  46,  24),
        Slider          = Color3.fromRGB(255, 140, 60),
        Danger          = Color3.fromRGB(255, 80,  80),
        Warning         = Color3.fromRGB(255, 200, 60),
        Success         = Color3.fromRGB(120, 220, 150),
        TopBar          = Color3.fromRGB(22,  12,  8),
        Shadow          = Color3.fromRGB(0,   0,   0),
        Notification    = Color3.fromRGB(255, 140, 60),
    },
    Arctic = {
        Background      = Color3.fromRGB(8,   18,  26),
        SecondBg        = Color3.fromRGB(12,  26,  38),
        ThirdBg         = Color3.fromRGB(18,  34,  50),
        Accent          = Color3.fromRGB(80,  220, 255),
        AccentDark      = Color3.fromRGB(40,  160, 210),
        Text            = Color3.fromRGB(220, 248, 255),
        SubText         = Color3.fromRGB(140, 190, 220),
        PlaceholderText = Color3.fromRGB(80,  130, 170),
        Border          = Color3.fromRGB(24,  50,  76),
        Toggle          = Color3.fromRGB(80,  220, 255),
        ToggleOff       = Color3.fromRGB(30,  70,  100),
        Slider          = Color3.fromRGB(80,  220, 255),
        Danger          = Color3.fromRGB(255, 80,  80),
        Warning         = Color3.fromRGB(255, 190, 60),
        Success         = Color3.fromRGB(80,  220, 160),
        TopBar          = Color3.fromRGB(10,  22,  32),
        Shadow          = Color3.fromRGB(0,   0,   0),
        Notification    = Color3.fromRGB(80,  220, 255),
    },
    Neon = {
        Background      = Color3.fromRGB(6,   6,   6),
        SecondBg        = Color3.fromRGB(12,  12,  12),
        ThirdBg         = Color3.fromRGB(20,  20,  20),
        Accent          = Color3.fromRGB(0,   255, 128),
        AccentDark      = Color3.fromRGB(0,   180, 90),
        Text            = Color3.fromRGB(240, 255, 240),
        SubText         = Color3.fromRGB(160, 200, 160),
        PlaceholderText = Color3.fromRGB(90,  130, 90),
        Border          = Color3.fromRGB(30,  50,  30),
        Toggle          = Color3.fromRGB(0,   255, 128),
        ToggleOff       = Color3.fromRGB(40,  60,  40),
        Slider          = Color3.fromRGB(0,   255, 128),
        Danger          = Color3.fromRGB(255, 60,  60),
        Warning         = Color3.fromRGB(255, 200, 0),
        Success         = Color3.fromRGB(0,   255, 128),
        TopBar          = Color3.fromRGB(8,   8,   8),
        Shadow          = Color3.fromRGB(0,   0,   0),
        Notification    = Color3.fromRGB(0,   255, 128),
    },
}

local CurrentTheme = Koji.Themes.Midnight

-- ──────────────────────────────────────────────────────────────
--  FONT CONSTANTS
-- ──────────────────────────────────────────────────────────────
local Fonts = {
    Title   = Enum.Font.GothamBold,
    Bold    = Enum.Font.GothamBold,
    Semi    = Enum.Font.GothamSemibold,
    Regular = Enum.Font.Gotham,
    Mono    = Enum.Font.RobotoMono,
}

-- ──────────────────────────────────────────────────────────────
--  CONFIG / PERSISTENCE
-- ──────────────────────────────────────────────────────────────
local function EnsureFolder(name)
    if not isfolder then return end
    if not isfolder(name) then
        makefolder(name)
    end
end

local function SaveConfig(fileName, data)
    if not writefile then return end
    EnsureFolder(Koji.ConfigFolder)
    local path = Koji.ConfigFolder .. "/" .. fileName .. ".json"
    local ok, err = pcall(function()
        writefile(path, HttpService:JSONEncode(data))
    end)
    if not ok then warn("[Koji] Failed to save config: " .. tostring(err)) end
end

local function LoadConfig(fileName)
    if not readfile then return {} end
    EnsureFolder(Koji.ConfigFolder)
    local path = Koji.ConfigFolder .. "/" .. fileName .. ".json"
    if isfile and isfile(path) then
        local ok, result = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if ok then return result end
    end
    return {}
end

-- ──────────────────────────────────────────────────────────────
--  NOTIFICATION SYSTEM
-- ──────────────────────────────────────────────────────────────
local NotifHolder = nil

local function EnsureNotifHolder()
    if NotifHolder and NotifHolder.Parent then return end
    local screenGui = Create("ScreenGui", {
        Name = "KojiNotifications",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then
        screenGui.Parent = LocalPlayer.PlayerGui
    end
    NotifHolder = Create("Frame", {
        Name = "Holder",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 0, 20),
        Size = UDim2.new(0, 300, 1, -40),
        AnchorPoint = Vector2.new(1, 0),
        Parent = screenGui,
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8),
        Parent = NotifHolder,
    })
end

function Koji:Notify(options)
    EnsureNotifHolder()

    local title    = options.Title    or "Koji Livery"
    local content  = options.Content  or ""
    local duration = options.Duration or 5
    local notifType = options.Type    or "Info" -- Info | Success | Warning | Error
    local icon     = options.Icon     or nil

    local typeColor = {
        Info    = CurrentTheme.Notification,
        Success = CurrentTheme.Success,
        Warning = CurrentTheme.Warning,
        Error   = CurrentTheme.Danger,
    }
    local accentColor = typeColor[notifType] or CurrentTheme.Notification

    -- Outer card
    local card = Create("Frame", {
        Name = "KojiNotif",
        BackgroundColor3 = CurrentTheme.SecondBg,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 0,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = card })
    Create("UIStroke", {
        Color = CurrentTheme.Border,
        Thickness = 1,
        Transparency = 0.4,
        Parent = card,
    })

    -- Left accent bar
    Create("Frame", {
        Name = "Accent",
        BackgroundColor3 = accentColor,
        Size = UDim2.new(0, 3, 1, 0),
        Parent = card,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = card:FindFirstChild("Accent") })

    -- Content area
    local inner = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -14, 1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    Create("UIPadding", {
        PaddingTop    = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingRight  = UDim.new(0, 10),
        Parent = inner,
    })

    Create("TextLabel", {
        Text = title,
        Font = Fonts.Bold,
        TextSize = 14,
        TextColor3 = CurrentTheme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = inner,
    })
    Create("TextLabel", {
        Text = content,
        Font = Fonts.Regular,
        TextSize = 12,
        TextColor3 = CurrentTheme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(0, 0, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = inner,
    })

    -- Progress bar
    local progress = Create("Frame", {
        BackgroundColor3 = accentColor,
        BackgroundTransparency = 0.3,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = card,
    })

    -- Animate in
    card.Position = UDim2.new(1, 20, 0, 0)
    Tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.4, Enum.EasingStyle.Back)

    -- Progress shrink
    task.delay(0.4, function()
        Tween(progress, { Size = UDim2.new(0, 0, 0, 2) }, duration - 0.4, Enum.EasingStyle.Linear)
    end)

    -- Auto dismiss
    task.delay(duration, function()
        Tween(card, { Position = UDim2.new(1, 20, 0, 0) }, 0.3)
        task.delay(0.35, function()
            SafeDestroy(card)
        end)
    end)

    return card
end

-- ──────────────────────────────────────────────────────────────
--  WINDOW
-- ──────────────────────────────────────────────────────────────
function Koji:CreateWindow(options)
    options = options or {}
    local windowName    = options.Name          or "Koji Window"
    local windowIcon    = options.Icon          or nil
    local loadingTitle  = options.LoadingTitle  or "Koji Livery"
    local loadingSub    = options.LoadingSubtitle or "Loading..."
    local themeName     = options.Theme         or "Midnight"
    local configSaving  = options.ConfigSaving  or { Enabled = false, FileName = "Config" }
    local keySystem     = options.KeySystem     or false
    local keySettings   = options.KeySettings   or {}
    local hideOnClose   = options.HideOnClose   or false

    -- Apply theme
    if Koji.Themes[themeName] then
        CurrentTheme = Koji.Themes[themeName]
    end

    local configData = {}
    if configSaving.Enabled then
        configData = LoadConfig(configSaving.FileName or "KojiConfig")
    end

    -- ── ROOT GUI ──
    local screenGui = Create("ScreenGui", {
        Name = "KojiLivery_" .. windowName,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() screenGui.Parent = CoreGui end)
    if not screenGui.Parent then
        screenGui.Parent = LocalPlayer.PlayerGui
    end

    -- ── LOADING SCREEN ──
    local loadFrame = Create("Frame", {
        Name = "LoadScreen",
        BackgroundColor3 = CurrentTheme.Background,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 100,
        Parent = screenGui,
    })
    Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.Background),
            ColorSequenceKeypoint.new(1, CurrentTheme.SecondBg),
        }),
        Rotation = 135,
        Parent = loadFrame,
    })

    local loadTitle = Create("TextLabel", {
        Text = loadingTitle,
        Font = Fonts.Bold,
        TextSize = 28,
        TextColor3 = CurrentTheme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 0, 40),
        Position = UDim2.new(0.1, 0, 0.4, -50),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = loadFrame,
    })
    local loadSub = Create("TextLabel", {
        Text = loadingSub,
        Font = Fonts.Semi,
        TextSize = 14,
        TextColor3 = CurrentTheme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 0, 24),
        Position = UDim2.new(0.1, 0, 0.4, 0),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = loadFrame,
    })

    -- Loading bar
    local barBg = Create("Frame", {
        BackgroundColor3 = CurrentTheme.ThirdBg,
        Position = UDim2.new(0.25, 0, 0.4, 40),
        Size = UDim2.new(0.5, 0, 0, 4),
        Parent = loadFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barBg })
    local barFill = Create("Frame", {
        BackgroundColor3 = CurrentTheme.Accent,
        Size = UDim2.new(0, 0, 1, 0),
        Parent = barBg,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barFill })

    -- Animated dots
    local dots = Create("TextLabel", {
        Text = "◆ ◇ ◇",
        Font = Fonts.Regular,
        TextSize = 12,
        TextColor3 = CurrentTheme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, 0, 0, 20),
        Position = UDim2.new(0.1, 0, 0.4, 55),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = loadFrame,
    })

    -- Animate loading bar + dots
    local dotFrames = {"◆ ◇ ◇", "◇ ◆ ◇", "◇ ◇ ◆", "◆ ◆ ◇", "◇ ◆ ◆", "◆ ◆ ◆"}
    local dotIdx = 1
    local dotConn
    dotConn = RunService.Heartbeat:Connect(function()
        dotIdx = (dotIdx % #dotFrames) + 1
        dots.Text = dotFrames[dotIdx]
    end)
    table.insert(Koji.Connections, dotConn)

    Tween(barFill, { Size = UDim2.new(1, 0, 1, 0) }, 1.8, Enum.EasingStyle.Quart)

    -- ── MAIN WINDOW ──
    local mainFrame = Create("Frame", {
        Name = "KojiWindow",
        BackgroundColor3 = CurrentTheme.Background,
        Size = UDim2.new(0, 580, 0, 420),
        Position = UDim2.new(0.5, -290, 0.5, -210),
        ClipsDescendants = false,
        Visible = false,
        Parent = screenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = mainFrame })
    Create("UIStroke", {
        Color = CurrentTheme.Border,
        Thickness = 1,
        Transparency = 0,
        Parent = mainFrame,
    })

    -- Drop shadow
    local shadow = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        ZIndex = -1,
        Parent = mainFrame,
    })

    -- ── TOP BAR ──
    local topBar = Create("Frame", {
        Name = "TopBar",
        BackgroundColor3 = CurrentTheme.TopBar,
        Size = UDim2.new(1, 0, 0, 44),
        Parent = mainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = topBar })

    -- Bottom crop for topbar corners
    Create("Frame", {
        BackgroundColor3 = CurrentTheme.TopBar,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0.5, 0),
        Parent = topBar,
    })

    -- Icon + Title
    local titleRow = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Parent = topBar,
    })
    if windowIcon then
        local iconLabel = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = type(windowIcon) == "number" and ("rbxassetid://" .. windowIcon) or windowIcon,
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(0, 0, 0.5, -11),
            Parent = titleRow,
        })
    end
    local titleLabel = Create("TextLabel", {
        Text = windowName,
        Font = Fonts.Bold,
        TextSize = 15,
        TextColor3 = CurrentTheme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, windowIcon and -30 or 0, 1, 0),
        Position = UDim2.new(0, windowIcon and 30 or 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleRow,
    })

    -- Control buttons (close, minimize, hide)
    local controls = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -100, 0, 0),
        Size = UDim2.new(0, 96, 1, 0),
        Parent = topBar,
    })

    local function MakeCtrlBtn(color, xPos, tooltip, callback)
        local btn = Create("TextButton", {
            Text = "",
            BackgroundColor3 = color,
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, xPos, 0.5, -7),
            AutoButtonColor = false,
            Parent = controls,
        })
        Create("UICorner", { CornerRadius = UDim.new(1,0), Parent = btn })
        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function()
            Tween(btn, { BackgroundTransparency = 0.3 }, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, { BackgroundTransparency = 0 }, 0.15)
        end)
        return btn
    end

    local isMinimized = false
    local originalSize = UDim2.new(0, 580, 0, 420)
    local minimizedSize = UDim2.new(0, 580, 0, 44)
    local isVisible = true

    MakeCtrlBtn(Color3.fromRGB(255, 90, 90),  4, "Close", function()
        if hideOnClose then
            isVisible = false
            Tween(mainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.delay(0.35, function() mainFrame.Visible = false end)
        else
            Tween(mainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            task.delay(0.35, function() SafeDestroy(screenGui) end)
        end
    end)
    MakeCtrlBtn(Color3.fromRGB(255, 190, 50), 22, "Minimize", function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(mainFrame, { Size = minimizedSize }, 0.3, Enum.EasingStyle.Quart)
        else
            Tween(mainFrame, { Size = originalSize }, 0.35, Enum.EasingStyle.Back)
        end
    end)
    MakeCtrlBtn(Color3.fromRGB(80, 200, 120), 40, "Hide", function()
        isVisible = not isVisible
        if not isVisible then
            Tween(mainFrame, { BackgroundTransparency = 1 }, 0.2)
            task.delay(0.2, function() mainFrame.Visible = false end)
        end
    end)

    -- Toggle key (RightShift to show/hide)
    local keyConn
    keyConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            isVisible = not isVisible
            mainFrame.Visible = isVisible
            if isVisible then
                mainFrame.BackgroundTransparency = 0
                Tween(mainFrame, { BackgroundTransparency = 0 }, 0.2)
            end
        end
    end)
    table.insert(Koji.Connections, keyConn)

    -- ── DRAG ──
    local dragging, dragStart, startPos = false, nil, nil
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    local dragConn
    dragConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    table.insert(Koji.Connections, dragConn)

    -- ── SIDEBAR (tabs) ──
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = CurrentTheme.SecondBg,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.new(0, 150, 1, -44),
        Parent = mainFrame,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = sidebar })
    -- bottom-right crop
    Create("Frame", {
        BackgroundColor3 = CurrentTheme.SecondBg,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Parent = sidebar,
    })
    -- top-right crop
    Create("Frame", {
        BackgroundColor3 = CurrentTheme.SecondBg,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, 0, 0, 10),
        Parent = sidebar,
    })

    local tabList = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -10),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = sidebar,
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = tabList,
    })
    Create("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = tabList,
    })

    -- ── CONTENT AREA ──
    local contentArea = Create("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 154, 0, 48),
        Size = UDim2.new(1, -158, 1, -52),
        Parent = mainFrame,
    })

    -- ── KEY SYSTEM (if enabled) ──
    if keySystem then
        -- key dialog overlay
        local keyOverlay = Create("Frame", {
            BackgroundColor3 = CurrentTheme.Background,
            BackgroundTransparency = 0.1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 50,
            Parent = mainFrame,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = keyOverlay })

        local keyCard = Create("Frame", {
            BackgroundColor3 = CurrentTheme.SecondBg,
            Size = UDim2.new(0, 320, 0, 200),
            Position = UDim2.new(0.5, -160, 0.5, -100),
            ZIndex = 51,
            Parent = keyOverlay,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = keyCard })
        Create("UIStroke", { Color = CurrentTheme.Accent, Thickness = 1, Parent = keyCard })

        Create("TextLabel", {
            Text = keySettings.Title or "Key System",
            Font = Fonts.Bold,
            TextSize = 18,
            TextColor3 = CurrentTheme.Text,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 52,
            Parent = keyCard,
        })
        Create("TextLabel", {
            Text = keySettings.Note or "Enter your key below.",
            Font = Fonts.Regular,
            TextSize = 12,
            TextColor3 = CurrentTheme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 20),
            Position = UDim2.new(0.05, 0, 0, 50),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 52,
            Parent = keyCard,
        })

        local keyInput = Create("TextBox", {
            PlaceholderText = "Enter key here...",
            Font = Fonts.Mono,
            TextSize = 13,
            TextColor3 = CurrentTheme.Text,
            PlaceholderColor3 = CurrentTheme.PlaceholderText,
            BackgroundColor3 = CurrentTheme.ThirdBg,
            Size = UDim2.new(0.85, 0, 0, 36),
            Position = UDim2.new(0.075, 0, 0, 82),
            ZIndex = 52,
            ClearTextOnFocus = false,
            Parent = keyCard,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = keyInput })

        local keyBtn = Create("TextButton", {
            Text = "Unlock",
            Font = Fonts.Bold,
            TextSize = 13,
            TextColor3 = CurrentTheme.Text,
            BackgroundColor3 = CurrentTheme.Accent,
            Size = UDim2.new(0.85, 0, 0, 34),
            Position = UDim2.new(0.075, 0, 0, 128),
            ZIndex = 52,
            Parent = keyCard,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = keyBtn })

        local statusLabel = Create("TextLabel", {
            Text = "",
            Font = Fonts.Regular,
            TextSize = 11,
            TextColor3 = CurrentTheme.Danger,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.9, 0, 0, 18),
            Position = UDim2.new(0.05, 0, 0, 168),
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 52,
            Parent = keyCard,
        })

        keyBtn.MouseButton1Click:Connect(function()
            local entered = keyInput.Text
            local keys = keySettings.Keys or {}
            local valid = false
            for _, k in ipairs(keys) do
                if entered == k then valid = true break end
            end
            if valid then
                Tween(keyOverlay, { BackgroundTransparency = 1 }, 0.3)
                task.delay(0.3, function() SafeDestroy(keyOverlay) end)
            else
                statusLabel.Text = "✗ Invalid key. Please try again."
                Tween(keyCard, { Position = UDim2.new(0.5, -168, 0.5, -100) }, 0.05)
                task.delay(0.05, function()
                    Tween(keyCard, { Position = UDim2.new(0.5, -160, 0.5, -100) }, 0.05)
                end)
            end
        end)
    end

    -- ── WINDOW OBJECT ──
    local Window = {}
    Window._gui         = screenGui
    Window._main        = mainFrame
    Window._sidebar     = sidebar
    Window._tabList     = tabList
    Window._content     = contentArea
    Window._tabs        = {}
    Window._activeTab   = nil
    Window._configData  = configData
    Window._configSave  = configSaving
    Window._theme       = CurrentTheme

    -- ── FINISH LOADING ──
    task.delay(2.2, function()
        dotConn:Disconnect()
        Tween(loadFrame, { BackgroundTransparency = 1 }, 0.5)
        task.delay(0.5, function()
            SafeDestroy(loadFrame)
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            Tween(mainFrame, { Size = originalSize, Position = UDim2.new(0.5, -290, 0.5, -210) }, 0.5, Enum.EasingStyle.Back)
        end)
    end)

    -- ════════════════════════════════════════
    --  CreateTab
    -- ════════════════════════════════════════
    function Window:CreateTab(name, iconId)
        local tab = {}
        tab._name = name
        tab._icon = iconId
        tab._elements = {}

        -- Sidebar button
        local tabBtn = Create("TextButton", {
            Name = "Tab_" .. name,
            Text = "",
            BackgroundColor3 = CurrentTheme.ThirdBg,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 36),
            AutoButtonColor = false,
            Parent = tabList,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = tabBtn })

        local tabIcon = nil
        if iconId then
            tabIcon = Create("ImageLabel", {
                BackgroundTransparency = 1,
                Image = type(iconId) == "number" and ("rbxassetid://" .. iconId) or iconId,
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 8, 0.5, -9),
                Parent = tabBtn,
            })
        end
        local tabLabel = Create("TextLabel", {
            Text = name,
            Font = Fonts.Semi,
            TextSize = 13,
            TextColor3 = CurrentTheme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, iconId and -34 or -16, 1, 0),
            Position = UDim2.new(0, iconId and 30 or 10, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn,
        })

        -- Accent bar (left)
        local accentBar = Create("Frame", {
            BackgroundColor3 = CurrentTheme.Accent,
            Size = UDim2.new(0, 3, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0),
            BackgroundTransparency = 1,
            Parent = tabBtn,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = accentBar })

        -- Content page
        local page = Create("ScrollingFrame", {
            Name = "Page_" .. name,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = CurrentTheme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = contentArea,
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 6),
            Parent = page,
        })
        Create("UIPadding", {
            PaddingTop   = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 8),
            Parent = page,
        })

        tab._btn  = tabBtn
        tab._page = page
        tab._accentBar = accentBar
        tab._label = tabLabel

        local function SelectTab()
            -- Deselect all
            for _, t in ipairs(Window._tabs) do
                Tween(t._btn, { BackgroundTransparency = 1 }, 0.2)
                Tween(t._label, { TextColor3 = CurrentTheme.SubText }, 0.2)
                Tween(t._accentBar, { BackgroundTransparency = 1 }, 0.2)
                t._page.Visible = false
            end
            -- Select this
            Tween(tabBtn, { BackgroundTransparency = 0 }, 0.2)
            Tween(tabLabel, { TextColor3 = CurrentTheme.Text }, 0.2)
            Tween(accentBar, { BackgroundTransparency = 0 }, 0.2)
            page.Visible = true
            Window._activeTab = tab
        end

        tabBtn.MouseButton1Click:Connect(SelectTab)

        table.insert(Window._tabs, tab)

        -- Auto-select first tab
        if #Window._tabs == 1 then
            task.defer(SelectTab)
        end

        -- ════════════════════════════════════════
        --  CreateSection
        -- ════════════════════════════════════════
        function tab:CreateSection(sectionName)
            local section = Create("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = page,
            })
            local line = Create("Frame", {
                BackgroundColor3 = CurrentTheme.Border,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 0, 1),
                Parent = section,
            })
            local sLabel = Create("TextLabel", {
                Text = "  " .. sectionName .. "  ",
                Font = Fonts.Bold,
                TextSize = 11,
                TextColor3 = CurrentTheme.Accent,
                BackgroundColor3 = CurrentTheme.Background,
                Size = UDim2.new(0, 0, 0, 20),
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.new(0, 10, 0.5, -10),
                Parent = section,
            })
            return section
        end

        -- ════════════════════════════════════════
        --  CreateButton
        -- ════════════════════════════════════════
        function tab:CreateButton(options)
            options = options or {}
            local name     = options.Name     or "Button"
            local desc     = options.Description or ""
            local callback = options.Callback or function() end

            local elem = Create("TextButton", {
                Text = "",
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, 0, 0, desc ~= "" and 52 or 38),
                AutoButtonColor = false,
                Parent = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = elem })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = elem })

            Create("TextLabel", {
                Text = name,
                Font = Fonts.Semi,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 12, 0, desc ~= "" and 8 or 9),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = elem,
            })
            if desc ~= "" then
                Create("TextLabel", {
                    Text = desc,
                    Font = Fonts.Regular,
                    TextSize = 11,
                    TextColor3 = CurrentTheme.SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 0, 16),
                    Position = UDim2.new(0, 12, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = elem,
                })
            end

            -- Right arrow icon
            local arrow = Create("TextLabel", {
                Text = "›",
                Font = Fonts.Bold,
                TextSize = 20,
                TextColor3 = CurrentTheme.Accent,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 24, 1, 0),
                Position = UDim2.new(1, -30, 0, 0),
                Parent = elem,
            })

            elem.MouseEnter:Connect(function()
                Tween(elem, { BackgroundColor3 = CurrentTheme.ThirdBg }, 0.15)
                Tween(arrow, { TextColor3 = CurrentTheme.Text }, 0.15)
            end)
            elem.MouseLeave:Connect(function()
                Tween(elem, { BackgroundColor3 = CurrentTheme.SecondBg }, 0.15)
                Tween(arrow, { TextColor3 = CurrentTheme.Accent }, 0.15)
            end)
            elem.MouseButton1Down:Connect(function()
                Tween(elem, { BackgroundColor3 = CurrentTheme.Accent }, 0.1)
            end)
            elem.MouseButton1Up:Connect(function()
                Tween(elem, { BackgroundColor3 = CurrentTheme.ThirdBg }, 0.1)
                task.spawn(callback)
            end)

            return elem
        end

        -- ════════════════════════════════════════
        --  CreateToggle
        -- ════════════════════════════════════════
        function tab:CreateToggle(options)
            options = options or {}
            local name     = options.Name     or "Toggle"
            local desc     = options.Description or ""
            local default  = options.Default  or false
            local flagName = options.Flag     or name
            local callback = options.Callback or function() end

            local state = default
            if configSaving.Enabled and configData[flagName] ~= nil then
                state = configData[flagName]
            end
            Koji.Flags[flagName] = state

            local elem = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, 0, 0, desc ~= "" and 52 or 38),
                Parent = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = elem })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = elem })

            Create("TextLabel", {
                Text = name,
                Font = Fonts.Semi,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 12, 0, desc ~= "" and 8 or 9),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = elem,
            })
            if desc ~= "" then
                Create("TextLabel", {
                    Text = desc,
                    Font = Fonts.Regular,
                    TextSize = 11,
                    TextColor3 = CurrentTheme.SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -70, 0, 16),
                    Position = UDim2.new(0, 12, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = elem,
                })
            end

            -- Toggle track
            local track = Create("Frame", {
                BackgroundColor3 = state and CurrentTheme.Toggle or CurrentTheme.ToggleOff,
                Size = UDim2.new(0, 42, 0, 22),
                Position = UDim2.new(1, -54, 0.5, -11),
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

            local thumb = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 16, 0, 16),
                Position = state and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                Parent = track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })

            local hitbox = Create("TextButton", {
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Parent = elem,
            })

            local function SetState(newState, callback_)
                state = newState
                Koji.Flags[flagName] = state
                Tween(track, { BackgroundColor3 = state and CurrentTheme.Toggle or CurrentTheme.ToggleOff }, 0.2)
                Tween(thumb, { Position = state and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8) }, 0.2, Enum.EasingStyle.Back)
                if callback_ ~= false then
                    task.spawn(callback, state)
                end
                if configSaving.Enabled then
                    configData[flagName] = state
                    SaveConfig(configSaving.FileName or "KojiConfig", configData)
                end
            end

            hitbox.MouseButton1Click:Connect(function()
                SetState(not state)
            end)

            local toggleObj = { SetValue = SetState, GetValue = function() return state end }
            task.spawn(callback, state)
            return toggleObj
        end

        -- ════════════════════════════════════════
        --  CreateSlider
        -- ════════════════════════════════════════
        function tab:CreateSlider(options)
            options = options or {}
            local name     = options.Name     or "Slider"
            local desc     = options.Description or ""
            local min      = options.Min      or 0
            local max      = options.Max      or 100
            local default  = options.Default  or min
            local inc      = options.Increment or 1
            local suffix   = options.Suffix   or ""
            local flagName = options.Flag     or name
            local callback = options.Callback or function() end

            local value = default
            if configSaving.Enabled and configData[flagName] ~= nil then
                value = configData[flagName]
            end
            Koji.Flags[flagName] = value

            local elem = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, 0, 0, desc ~= "" and 62 or 52),
                Parent = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = elem })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = elem })

            local valLabel = Create("TextLabel", {
                Text = tostring(value) .. suffix,
                Font = Fonts.Semi,
                TextSize = 12,
                TextColor3 = CurrentTheme.Accent,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -68, 0, desc ~= "" and 8 or 8),
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = elem,
            })
            Create("TextLabel", {
                Text = name,
                Font = Fonts.Semi,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -80, 0, 20),
                Position = UDim2.new(0, 12, 0, desc ~= "" and 8 or 8),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = elem,
            })
            if desc ~= "" then
                Create("TextLabel", {
                    Text = desc,
                    Font = Fonts.Regular,
                    TextSize = 11,
                    TextColor3 = CurrentTheme.SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 14),
                    Position = UDim2.new(0, 12, 0, 28),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = elem,
                })
            end

            local yOffset = desc ~= "" and 46 or 34
            local trackBg = Create("Frame", {
                BackgroundColor3 = CurrentTheme.ThirdBg,
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.new(0, 12, 0, yOffset),
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackBg })

            local trackFill = Create("Frame", {
                BackgroundColor3 = CurrentTheme.Slider,
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                Parent = trackBg,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackFill })

            local handle = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
                Parent = trackBg,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = handle })

            local sliding = false
            trackBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = trackBg.AbsolutePosition
                    local sz  = trackBg.AbsoluteSize
                    local rel = math.clamp((Mouse.X - pos.X) / sz.X, 0, 1)
                    local raw = min + (max - min) * rel
                    local stepped = RoundNumber(math.round((raw - min) / inc) * inc + min, 2)
                    stepped = math.clamp(stepped, min, max)
                    value = stepped
                    Koji.Flags[flagName] = value
                    valLabel.Text = tostring(value) .. suffix
                    trackFill.Size = UDim2.new(rel, 0, 1, 0)
                    handle.Position = UDim2.new(rel, -7, 0.5, -7)
                    task.spawn(callback, value)
                    if configSaving.Enabled then
                        configData[flagName] = value
                        SaveConfig(configSaving.FileName or "KojiConfig", configData)
                    end
                end
            end)

            local sliderObj = {
                SetValue = function(_, v)
                    v = math.clamp(v, min, max)
                    value = v
                    Koji.Flags[flagName] = v
                    local rel = (v - min) / (max - min)
                    valLabel.Text = tostring(v) .. suffix
                    Tween(trackFill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.15)
                    Tween(handle, { Position = UDim2.new(rel, -7, 0.5, -7) }, 0.15)
                    task.spawn(callback, v)
                end,
                GetValue = function() return value end,
            }
            task.spawn(callback, value)
            return sliderObj
        end

        -- ════════════════════════════════════════
        --  CreateDropdown
        -- ════════════════════════════════════════
        function tab:CreateDropdown(options)
            options = options or {}
            local name     = options.Name     or "Dropdown"
            local desc     = options.Description or ""
            local items    = options.Items    or {}
            local default  = options.Default  or nil
            local flagName = options.Flag     or name
            local multi    = options.Multi    or false
            local callback = options.Callback or function() end

            local selected = multi and {} or default
            if configSaving.Enabled and configData[flagName] ~= nil then
                selected = configData[flagName]
            end
            Koji.Flags[flagName] = selected

            local isOpen = false

            local elem = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, 0, 0, desc ~= "" and 62 or 46),
                ClipsDescendants = false,
                Parent = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = elem })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = elem })

            Create("TextLabel", {
                Text = name,
                Font = Fonts.Semi,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -24, 0, 20),
                Position = UDim2.new(0, 12, 0, desc ~= "" and 6 or 4),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = elem,
            })
            if desc ~= "" then
                Create("TextLabel", {
                    Text = desc,
                    Font = Fonts.Regular,
                    TextSize = 11,
                    TextColor3 = CurrentTheme.SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 14),
                    Position = UDim2.new(0, 12, 0, 26),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = elem,
                })
            end

            local yOff = desc ~= "" and 42 or 26
            local valueBtn = Create("TextButton", {
                Text = "",
                BackgroundColor3 = CurrentTheme.ThirdBg,
                Size = UDim2.new(1, -24, 0, 26),
                Position = UDim2.new(0, 12, 0, yOff),
                AutoButtonColor = false,
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = valueBtn })

            local displayLabel = Create("TextLabel", {
                Text = multi and "Select..." or (default or "Select..."),
                Font = Fonts.Regular,
                TextSize = 12,
                TextColor3 = default and CurrentTheme.Text or CurrentTheme.PlaceholderText,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -28, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = valueBtn,
            })
            local chevron = Create("TextLabel", {
                Text = "▾",
                Font = Fonts.Bold,
                TextSize = 12,
                TextColor3 = CurrentTheme.SubText,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -22, 0, 0),
                Parent = valueBtn,
            })

            -- Dropdown panel
            local panel = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, -24, 0, 0),
                Position = UDim2.new(0, 12, 1, 4),
                ClipsDescendants = true,
                ZIndex = 10,
                Visible = false,
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = panel })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = panel })

            local panelList = Create("ScrollingFrame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = CurrentTheme.Accent,
                ZIndex = 11,
                Parent = panel,
            })
            Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = panelList })
            Create("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
                Parent = panelList,
            })

            local function UpdateDisplay()
                if multi then
                    if #selected == 0 then
                        displayLabel.Text = "Select..."
                        displayLabel.TextColor3 = CurrentTheme.PlaceholderText
                    else
                        displayLabel.Text = table.concat(selected, ", ")
                        displayLabel.TextColor3 = CurrentTheme.Text
                    end
                else
                    if selected then
                        displayLabel.Text = tostring(selected)
                        displayLabel.TextColor3 = CurrentTheme.Text
                    else
                        displayLabel.Text = "Select..."
                        displayLabel.TextColor3 = CurrentTheme.PlaceholderText
                    end
                end
            end

            local function RefreshItems()
                for _, c in ipairs(panelList:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, item in ipairs(items) do
                    local isSelected = multi and (TableFind(selected, item) ~= nil) or (selected == item)
                    local itemBtn = Create("TextButton", {
                        Text = "",
                        BackgroundColor3 = isSelected and CurrentTheme.ThirdBg or Color3.fromRGB(0,0,0),
                        BackgroundTransparency = isSelected and 0 or 1,
                        Size = UDim2.new(1, 0, 0, 28),
                        AutoButtonColor = false,
                        ZIndex = 12,
                        Parent = panelList,
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = itemBtn })
                    local checkMark = Create("TextLabel", {
                        Text = isSelected and "✓" or "",
                        Font = Fonts.Bold,
                        TextSize = 12,
                        TextColor3 = CurrentTheme.Accent,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 20, 1, 0),
                        ZIndex = 13,
                        Parent = itemBtn,
                    })
                    Create("TextLabel", {
                        Text = tostring(item),
                        Font = Fonts.Regular,
                        TextSize = 12,
                        TextColor3 = isSelected and CurrentTheme.Text or CurrentTheme.SubText,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -24, 1, 0),
                        Position = UDim2.new(0, 22, 0, 0),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 13,
                        Parent = itemBtn,
                    })

                    itemBtn.MouseButton1Click:Connect(function()
                        if multi then
                            local idx = TableFind(selected, item)
                            if idx then
                                table.remove(selected, idx)
                            else
                                table.insert(selected, item)
                            end
                        else
                            selected = item
                            isOpen = false
                            panel.Visible = false
                            Tween(chevron, { Rotation = 0 }, 0.2)
                        end
                        Koji.Flags[flagName] = selected
                        UpdateDisplay()
                        RefreshItems()
                        task.spawn(callback, selected)
                        if configSaving.Enabled then
                            configData[flagName] = selected
                            SaveConfig(configSaving.FileName or "KojiConfig", configData)
                        end
                    end)
                    itemBtn.MouseEnter:Connect(function()
                        Tween(itemBtn, { BackgroundTransparency = 0, BackgroundColor3 = CurrentTheme.ThirdBg }, 0.1)
                    end)
                    itemBtn.MouseLeave:Connect(function()
                        local isSel = multi and (TableFind(selected, item) ~= nil) or (selected == item)
                        Tween(itemBtn, { BackgroundTransparency = isSel and 0 or 1 }, 0.1)
                    end)
                end
            end

            RefreshItems()
            UpdateDisplay()

            valueBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    local itemCount = math.min(#items, 5)
                    local panelH = itemCount * 30 + 12
                    panel.Visible = true
                    Tween(panel, { Size = UDim2.new(1, -24, 0, panelH) }, 0.2, Enum.EasingStyle.Quart)
                    Tween(chevron, { Rotation = 180 }, 0.2)
                else
                    Tween(panel, { Size = UDim2.new(1, -24, 0, 0) }, 0.15)
                    task.delay(0.15, function() panel.Visible = false end)
                    Tween(chevron, { Rotation = 0 }, 0.2)
                end
            end)

            local ddObj = {
                SetValue = function(_, v)
                    selected = v
                    Koji.Flags[flagName] = v
                    UpdateDisplay()
                    RefreshItems()
                    task.spawn(callback, v)
                end,
                GetValue = function() return selected end,
                Refresh = function(_, newItems)
                    items = newItems
                    RefreshItems()
                end,
            }
            return ddObj
        end

        -- ════════════════════════════════════════
        --  CreateInput (TextBox)
        -- ════════════════════════════════════════
        function tab:CreateInput(options)
            options = options or {}
            local name        = options.Name        or "Input"
            local desc        = options.Description or ""
            local placeholder = options.Placeholder or "Type here..."
            local default     = options.Default     or ""
            local numeric     = options.Numeric     or false
            local flagName    = options.Flag        or name
            local callback    = options.Callback    or function() end

            local value = default
            Koji.Flags[flagName] = value

            local elem = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, 0, 0, desc ~= "" and 62 or 46),
                Parent = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = elem })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = elem })

            Create("TextLabel", {
                Text = name,
                Font = Fonts.Semi,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -24, 0, 20),
                Position = UDim2.new(0, 12, 0, desc ~= "" and 6 or 4),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = elem,
            })
            if desc ~= "" then
                Create("TextLabel", {
                    Text = desc,
                    Font = Fonts.Regular,
                    TextSize = 11,
                    TextColor3 = CurrentTheme.SubText,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -24, 0, 14),
                    Position = UDim2.new(0, 12, 0, 26),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = elem,
                })
            end

            local yOff = desc ~= "" and 42 or 26
            local inputBox = Create("TextBox", {
                Text = default,
                PlaceholderText = placeholder,
                Font = Fonts.Regular,
                TextSize = 12,
                TextColor3 = CurrentTheme.Text,
                PlaceholderColor3 = CurrentTheme.PlaceholderText,
                BackgroundColor3 = CurrentTheme.ThirdBg,
                Size = UDim2.new(1, -24, 0, 26),
                Position = UDim2.new(0, 12, 0, yOff),
                ClearTextOnFocus = false,
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = inputBox })
            Create("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = inputBox })

            inputBox.Focused:Connect(function()
                Tween(inputBox, { BackgroundColor3 = CurrentTheme.SecondBg }, 0.15)
            end)
            inputBox.FocusLost:Connect(function(enter)
                Tween(inputBox, { BackgroundColor3 = CurrentTheme.ThirdBg }, 0.15)
                if numeric then
                    local num = tonumber(inputBox.Text)
                    if num then
                        value = num
                    else
                        inputBox.Text = tostring(value)
                        return
                    end
                else
                    value = inputBox.Text
                end
                Koji.Flags[flagName] = value
                task.spawn(callback, value, enter)
            end)

            local inputObj = {
                SetValue = function(_, v)
                    value = v
                    inputBox.Text = tostring(v)
                    Koji.Flags[flagName] = v
                end,
                GetValue = function() return value end,
            }
            return inputObj
        end

        -- ════════════════════════════════════════
        --  CreateColorPicker
        -- ════════════════════════════════════════
        function tab:CreateColorPicker(options)
            options = options or {}
            local name     = options.Name     or "Color"
            local default  = options.Default  or Color3.fromRGB(255, 255, 255)
            local flagName = options.Flag     or name
            local callback = options.Callback or function() end

            local value = default
            Koji.Flags[flagName] = value
            local isOpen = false
            local h, s, v2 = Color3.toHSV(value)

            local elem = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, 0, 0, 38),
                ClipsDescendants = false,
                Parent = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = elem })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = elem })

            Create("TextLabel", {
                Text = name,
                Font = Fonts.Semi,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = elem,
            })

            local preview = Create("TextButton", {
                Text = "",
                BackgroundColor3 = value,
                Size = UDim2.new(0, 36, 0, 22),
                Position = UDim2.new(1, -46, 0.5, -11),
                AutoButtonColor = false,
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = preview })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = preview })

            -- Simplified color panel (hue strip + SV square concept)
            local panel = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, -24, 0, 0),
                Position = UDim2.new(0, 12, 1, 6),
                ZIndex = 20,
                Visible = false,
                ClipsDescendants = true,
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = panel })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = panel })

            -- Hue bar
            local hueBar = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255,0,0),
                Size = UDim2.new(1, -16, 0, 18),
                Position = UDim2.new(0, 8, 0, 10),
                ZIndex = 21,
                Parent = panel,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = hueBar })
            Create("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 0,   0)),
                    ColorSequenceKeypoint.new(0.166,Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,   255, 0)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,   255, 255)),
                    ColorSequenceKeypoint.new(0.666,Color3.fromRGB(0,   0,   255)),
                    ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255, 0,   255)),
                    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 0,   0)),
                }),
                Parent = hueBar,
            })

            local hueThumb = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Size = UDim2.new(0, 6, 1, 4),
                Position = UDim2.new(h, -3, 0, -2),
                ZIndex = 22,
                Parent = hueBar,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = hueThumb })

            -- SV box
            local svBox = Create("Frame", {
                Size = UDim2.new(1, -16, 0, 80),
                Position = UDim2.new(0, 8, 0, 36),
                ZIndex = 21,
                Parent = panel,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = svBox })

            local svBase = Create("Frame", {
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 21,
                Parent = svBox,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = svBase })
            Create("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255)), Transparency = NumberSequence.new(0, 1), Parent = svBase })

            local svDark = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(0,0,0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 22,
                Parent = svBox,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = svDark })
            Create("UIGradient", {
                Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Rotation = 270,
                Parent = svDark,
            })

            local svCursor = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Size = UDim2.new(0, 10, 0, 10),
                Position = UDim2.new(s, -5, 1-v2, -5),
                ZIndex = 23,
                Parent = svBox,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = svCursor })

            -- Hex input
            local hexInput = Create("TextBox", {
                Text = string.format("#%02X%02X%02X", math.floor(value.R*255), math.floor(value.G*255), math.floor(value.B*255)),
                Font = Fonts.Mono,
                TextSize = 11,
                TextColor3 = CurrentTheme.Text,
                PlaceholderColor3 = CurrentTheme.PlaceholderText,
                BackgroundColor3 = CurrentTheme.ThirdBg,
                Size = UDim2.new(1, -16, 0, 24),
                Position = UDim2.new(0, 8, 0, 124),
                ZIndex = 21,
                ClearTextOnFocus = false,
                Parent = panel,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = hexInput })
            Create("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = hexInput })

            local function UpdateColor()
                value = Color3.fromHSV(h, s, v2)
                preview.BackgroundColor3 = value
                svBase.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                hexInput.Text = string.format("#%02X%02X%02X", math.floor(value.R*255), math.floor(value.G*255), math.floor(value.B*255))
                Koji.Flags[flagName] = value
                task.spawn(callback, value)
            end

            -- Hue drag
            local draggingHue = false
            hueBar.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end end)
            UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = false end end)
            UserInputService.InputChanged:Connect(function(inp)
                if draggingHue and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((Mouse.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    h = rel
                    hueThumb.Position = UDim2.new(h, -3, 0, -2)
                    UpdateColor()
                end
            end)

            -- SV drag
            local draggingSV = false
            svBox.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end end)
            UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = false end end)
            UserInputService.InputChanged:Connect(function(inp)
                if draggingSV and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local sx = math.clamp((Mouse.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                    local sy = math.clamp((Mouse.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                    s = sx
                    v2 = 1 - sy
                    svCursor.Position = UDim2.new(s, -5, 1-v2, -5)
                    UpdateColor()
                end
            end)

            hexInput.FocusLost:Connect(function()
                local hex = hexInput.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1,2), 16)
                    local g = tonumber(hex:sub(3,4), 16)
                    local b = tonumber(hex:sub(5,6), 16)
                    if r and g and b then
                        value = Color3.fromRGB(r, g, b)
                        h, s, v2 = Color3.toHSV(value)
                        hueThumb.Position = UDim2.new(h, -3, 0, -2)
                        svCursor.Position = UDim2.new(s, -5, 1-v2, -5)
                        UpdateColor()
                    end
                end
            end)

            preview.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    panel.Visible = true
                    Tween(panel, { Size = UDim2.new(1, -24, 0, 158) }, 0.2)
                else
                    Tween(panel, { Size = UDim2.new(1, -24, 0, 0) }, 0.15)
                    task.delay(0.15, function() panel.Visible = false end)
                end
            end)

            local cpObj = {
                SetValue = function(_, col)
                    value = col
                    h, s, v2 = Color3.toHSV(col)
                    preview.BackgroundColor3 = col
                    Koji.Flags[flagName] = col
                    task.spawn(callback, col)
                end,
                GetValue = function() return value end,
            }
            return cpObj
        end

        -- ════════════════════════════════════════
        --  CreateLabel
        -- ════════════════════════════════════════
        function tab:CreateLabel(text, color)
            local lbl = Create("TextLabel", {
                Text = text or "",
                Font = Fonts.Regular,
                TextSize = 12,
                TextColor3 = color or CurrentTheme.SubText,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -24, 0, 20),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = page,
            })
            local lblObj = {
                SetText = function(_, t) lbl.Text = t end,
                SetColor = function(_, c) lbl.TextColor3 = c end,
            }
            return lblObj
        end

        -- ════════════════════════════════════════
        --  CreateKeybind
        -- ════════════════════════════════════════
        function tab:CreateKeybind(options)
            options = options or {}
            local name     = options.Name     or "Keybind"
            local default  = options.Default  or Enum.KeyCode.Unknown
            local flagName = options.Flag     or name
            local callback = options.Callback or function() end

            local boundKey = default
            local listening = false
            Koji.Flags[flagName] = boundKey

            local elem = Create("Frame", {
                BackgroundColor3 = CurrentTheme.SecondBg,
                Size = UDim2.new(1, 0, 0, 38),
                Parent = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = elem })
            Create("UIStroke", { Color = CurrentTheme.Border, Thickness = 1, Parent = elem })

            Create("TextLabel", {
                Text = name,
                Font = Fonts.Semi,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -110, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = elem,
            })

            local keyBtn = Create("TextButton", {
                Text = boundKey.Name,
                Font = Fonts.Mono,
                TextSize = 11,
                TextColor3 = CurrentTheme.Text,
                BackgroundColor3 = CurrentTheme.ThirdBg,
                Size = UDim2.new(0, 90, 0, 24),
                Position = UDim2.new(1, -102, 0.5, -12),
                AutoButtonColor = false,
                Parent = elem,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyBtn })

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                keyBtn.TextColor3 = CurrentTheme.Accent
            end)

            local kbConn
            kbConn = UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    boundKey = input.KeyCode
                    Koji.Flags[flagName] = boundKey
                    keyBtn.Text = boundKey.Name
                    keyBtn.TextColor3 = CurrentTheme.Text
                    listening = false
                end
                if not gpe and not listening and input.KeyCode == boundKey then
                    task.spawn(callback, boundKey)
                end
            end)
            table.insert(Koji.Connections, kbConn)

            return {
                GetValue = function() return boundKey end,
                SetValue = function(_, k) boundKey = k; keyBtn.Text = k.Name end,
            }
        end

        return tab
    end

    -- ── Save/Load config ──
    function Window:SaveConfig()
        if configSaving.Enabled then
            SaveConfig(configSaving.FileName or "KojiConfig", configData)
        end
    end

    function Window:LoadConfig()
        if configSaving.Enabled then
            configData = LoadConfig(configSaving.FileName or "KojiConfig")
        end
    end

    function Window:Destroy()
        SafeDestroy(screenGui)
        for _, c in ipairs(Koji.Connections) do
            pcall(function() c:Disconnect() end)
        end
    end

    table.insert(Koji.ActiveWindows, Window)
    return Window
end

-- ──────────────────────────────────────────────────────────────
--  GLOBAL DESTROY
-- ──────────────────────────────────────────────────────────────
function Koji:Destroy()
    for _, win in ipairs(Koji.ActiveWindows) do
        win:Destroy()
    end
    for _, c in ipairs(Koji.Connections) do
        pcall(function() c:Disconnect() end)
    end
    Koji.ActiveWindows = {}
    Koji.Connections   = {}
    Koji.Flags         = {}
end

return Koji
