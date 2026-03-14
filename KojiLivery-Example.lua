--[[
    ██╗  ██╗ ██████╗      ██╗██╗    ██╗   ██╗███████╗██████╗ ██╗   ██╗
    ██║ ██╔╝██╔═══██╗     ██║██║    ██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝
    █████╔╝ ██║   ██║     ██║██║    ██║   ██║█████╗  ██████╔╝ ╚████╔╝ 
    ██╔═██╗ ██║   ██║██   ██║██║    ╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝  
    ██║  ██╗╚██████╔╝╚█████╔╝██║     ╚████╔╝ ███████╗██║  ██║   ██║   
    ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚═╝      ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝   

    Koji Livery — Example Usage Script
    Shows every available component.
]]

-- Load library
local Koji = loadstring(game:HttpGet(
    'https://raw.githubusercontent.com/koji-project/koji-livery/main/KojiLivery.lua'
))()

-- ────────────────────────────────────────────────────────────
--  CREATE WINDOW
-- ────────────────────────────────────────────────────────────
local Window = Koji:CreateWindow({
    Name             = "Koji Hub",
    Icon             = 0,             -- Set to asset ID for an icon
    LoadingTitle     = "Koji Hub",
    LoadingSubtitle  = "by YourName",
    Theme            = "Midnight",    -- Midnight | Sakura | Ember | Arctic | Neon

    ConfigSaving = {
        Enabled  = true,
        FileName = "KojiHubConfig",
    },

    -- Enable key system if you want gating:
    KeySystem = false,
    KeySettings = {
        Title = "Key Required",
        Note  = "Get your key at discord.gg/example",
        Keys  = { "koji-example-key" },
    },
})

-- ────────────────────────────────────────────────────────────
--  TAB 1: MAIN
-- ────────────────────────────────────────────────────────────
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Movement")

-- Slider — Walk Speed
local speedSlider = MainTab:CreateSlider({
    Name        = "Walk Speed",
    Description = "Adjust player walk speed.",
    Min         = 16,
    Max         = 500,
    Default     = 16,
    Increment   = 1,
    Suffix      = " WS",
    Flag        = "WalkSpeed",
    Callback    = function(val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end,
})

-- Slider — Jump Power
MainTab:CreateSlider({
    Name      = "Jump Power",
    Min       = 7,
    Max       = 300,
    Default   = 50,
    Increment = 1,
    Suffix    = " JP",
    Flag      = "JumpPower",
    Callback  = function(val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = val
        end
    end,
})

-- Toggle — Infinite Jump
MainTab:CreateToggle({
    Name     = "Infinite Jump",
    Default  = false,
    Flag     = "InfJump",
    Callback = function(state)
        -- Your infinite jump logic here
    end,
})

-- Toggle — Noclip
MainTab:CreateToggle({
    Name        = "Noclip",
    Description = "Walk through walls.",
    Default     = false,
    Flag        = "Noclip",
    Callback    = function(state)
        -- Your noclip logic here
    end,
})

MainTab:CreateSection("Misc")

-- Button — Reset Character
MainTab:CreateButton({
    Name        = "Reset Character",
    Description = "Kills and respawns your character.",
    Callback    = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end,
})

-- Button — Rejoin
MainTab:CreateButton({
    Name     = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

-- Label
local versionLabel = MainTab:CreateLabel(
    "Koji Hub v1.0.0 — All rights reserved.",
    Color3.fromRGB(100, 100, 140)
)

-- ────────────────────────────────────────────────────────────
--  TAB 2: PLAYER
-- ────────────────────────────────────────────────────────────
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSection("Targeting")

-- Dropdown — Target Player
local players = {}
for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer then
        table.insert(players, p.Name)
    end
end

PlayerTab:CreateDropdown({
    Name     = "Target Player",
    Items    = players,
    Default  = nil,
    Flag     = "TargetPlayer",
    Callback = function(val)
        print("Target set to:", val)
    end,
})

-- Toggle — Show Nametags
PlayerTab:CreateToggle({
    Name     = "Show Nametags",
    Default  = true,
    Flag     = "Nametags",
    Callback = function(state)
        -- Toggle nametag logic
    end,
})

PlayerTab:CreateSection("Visuals")

-- Color Picker — ESP Color
PlayerTab:CreateColorPicker({
    Name     = "ESP Color",
    Default  = Color3.fromRGB(255, 50, 50),
    Flag     = "ESPColor",
    Callback = function(color)
        print("ESP Color:", color)
    end,
})

-- Toggle — ESP Boxes
PlayerTab:CreateToggle({
    Name     = "ESP Boxes",
    Default  = false,
    Flag     = "ESPBoxes",
    Callback = function(state)
        -- Your ESP drawing logic
    end,
})

-- Slider — ESP Line Thickness
PlayerTab:CreateSlider({
    Name      = "Box Thickness",
    Min       = 1,
    Max       = 5,
    Default   = 1,
    Increment = 0.5,
    Suffix    = "px",
    Flag      = "ESPThickness",
    Callback  = function(val)
        -- Update ESP line thickness
    end,
})

-- ────────────────────────────────────────────────────────────
--  TAB 3: SETTINGS
-- ────────────────────────────────────────────────────────────
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Interface")

-- Dropdown — Theme
SettingsTab:CreateDropdown({
    Name     = "UI Theme",
    Items    = { "Midnight", "Sakura", "Ember", "Arctic", "Neon" },
    Default  = "Midnight",
    Flag     = "UITheme",
    Callback = function(val)
        Koji:Notify({
            Title   = "Theme Changed",
            Content = "Reload the script to apply: " .. val,
            Type    = "Info",
        })
    end,
})

-- Keybind — Toggle UI
SettingsTab:CreateKeybind({
    Name     = "Toggle UI",
    Default  = Enum.KeyCode.RightShift,
    Flag     = "UIToggleKey",
    Callback = function(key)
        -- This fires when the key is pressed
        -- Window visibility is already handled automatically by RightShift
    end,
})

-- Toggle — Notifications
SettingsTab:CreateToggle({
    Name     = "Show Notifications",
    Default  = true,
    Flag     = "ShowNotifs",
    Callback = function(state) end,
})

-- Input — Discord Webhook (example)
SettingsTab:CreateInput({
    Name        = "Discord Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default     = "",
    Flag        = "Webhook",
    Callback    = function(text, enter)
        if enter then
            print("Webhook set:", text)
        end
    end,
})

SettingsTab:CreateSection("Debug")

SettingsTab:CreateButton({
    Name     = "Print All Flags",
    Callback = function()
        for k, v in pairs(Koji.Flags) do
            print("[Koji Flag]", k, "=", tostring(v))
        end
    end,
})

SettingsTab:CreateButton({
    Name     = "Test All Notifications",
    Callback = function()
        Koji:Notify({ Title = "Info Test",    Content = "This is an info notification.",    Type = "Info",    Duration = 4 })
        task.wait(0.6)
        Koji:Notify({ Title = "Success Test", Content = "Operation completed successfully.", Type = "Success", Duration = 4 })
        task.wait(0.6)
        Koji:Notify({ Title = "Warning Test", Content = "Something needs your attention.",  Type = "Warning", Duration = 4 })
        task.wait(0.6)
        Koji:Notify({ Title = "Error Test",   Content = "An error has occurred.",           Type = "Error",   Duration = 4 })
    end,
})

-- ────────────────────────────────────────────────────────────
--  STARTUP NOTIFICATION
-- ────────────────────────────────────────────────────────────
task.wait(2.5)
Koji:Notify({
    Title   = "Koji Hub",
    Content = "Loaded successfully! Press RightShift to toggle.",
    Type    = "Success",
    Duration = 6,
})
