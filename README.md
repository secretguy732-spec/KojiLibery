# KojiLibery


```
██╗  ██╗ ██████╗      ██╗██╗    ██╗   ██╗███████╗██████╗ ██╗   ██╗
██║ ██╔╝██╔═══██╗     ██║██║    ██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝
█████╔╝ ██║   ██║     ██║██║    ██║   ██║█████╗  ██████╔╝ ╚████╔╝ 
██╔═██╗ ██║   ██║██   ██║██║    ╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝  
██║  ██╗╚██████╔╝╚█████╔╝██║     ╚████╔╝ ███████╗██║  ██║   ██║   
╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚═╝      ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝  
```

# Koji Livery

**A premium, open-source Roblox UI library built for exploit developers.**  
Clean, modern, highly customizable — with zero dependencies.

![Version](https://img.shields.io/badge/version-1.0.0-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Lua](https://img.shields.io/badge/language-Lua-orange?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Roblox-red?style=flat-square)
![Status](https://img.shields.io/badge/status-stable-brightgreen?style=flat-square)

</div>

---

## 📋 Table of Contents

- [Introduction](#-introduction)
- [Why Koji Livery?](#-why-koji-livery)
- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Window](#-window)
  - [CreateWindow](#createwindow)
  - [Window Options](#window-options)
  - [Window Controls](#window-controls)
- [Tabs & Sections](#-tabs--sections)
  - [CreateTab](#createtab)
  - [CreateSection](#createsection)
- [Components](#-components)
  - [CreateButton](#createbutton)
  - [CreateToggle](#createtoggle)
  - [CreateSlider](#createslider)
  - [CreateDropdown](#createdropdown)
  - [CreateInput](#createinput)
  - [CreateColorPicker](#createcolorpicker)
  - [CreateKeybind](#createkeybind)
  - [CreateLabel](#createlabel)
- [Notifications](#-notifications)
- [Themes](#-themes)
- [Flags System](#-flags-system)
- [Config Saving](#-config-saving)
- [Key System](#-key-system)
- [Full Example Script](#-full-example-script)
- [API Reference](#-api-reference)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)
- [Credits](#-credits)

---

## 📖 Introduction

**Koji Livery** adalah sebuah UI library untuk Roblox exploit yang dirancang dari nol dengan fokus pada estetika, kemudahan penggunaan, dan performa. Library ini memungkinkan developer script untuk membuat antarmuka pengguna yang profesional dan polished hanya dengan beberapa baris kode Lua.

Koji Livery menggunakan sistem yang sepenuhnya berbasis **Roblox Instance** — tidak ada dependency eksternal, tidak ada HTTP request tambahan setelah loading, dan kompatibel dengan hampir semua executor modern.

> **Catatan:** Library ini dibuat untuk tujuan edukasi dan pengembangan UI. Gunakan secara bertanggung jawab dan patuhi Terms of Service platform yang berlaku.

---

## 🤔 Why Koji Livery?

Ada banyak UI library Roblox di luar sana. Kenapa harus pakai Koji?

| Fitur | Koji Livery | Library Lain |
|-------|:-----------:|:------------:|
| Loading screen animasi | ✅ | ✅ |
| 5 built-in themes | ✅ | ⚠️ (biasanya 2-3) |
| Color picker lengkap (HSV + hex) | ✅ | ⚠️ |
| Config saving JSON | ✅ | ✅ |
| Multi-select dropdown | ✅ | ❌ |
| Notification system terpisah | ✅ | ⚠️ |
| Key system bawaan | ✅ | ✅ |
| Drag window | ✅ | ✅ |
| Flag global system | ✅ | ⚠️ |
| Zero dependency | ✅ | ✅ |
| Open source (MIT) | ✅ | ⚠️ |
| Dokumentasi lengkap | ✅ | ⚠️ |

---

## ✨ Features

### 🎨 Desain & Tampilan
- **5 built-in themes** premium: Midnight, Sakura, Ember, Arctic, Neon
- Animasi smooth dengan `TweenService` di semua komponen
- Loading screen dengan animated progress bar dan pulsing dots
- Drop shadow pada window utama
- MacOS-style window control buttons (close, minimize, hide)
- Sidebar tab navigation dengan accent bar animasi

### 🧩 Komponen Lengkap
- **Button** — dengan hover glow dan click feedback
- **Toggle** — switch animasi smooth kiri-kanan
- **Slider** — drag handle dengan fill bar real-time
- **Dropdown** — single dan multi-select, bisa di-refresh dinamis
- **Input** — text box dengan mode teks biasa dan numerik
- **ColorPicker** — HSV (hue strip + SV box) + hex input manual
- **Keybind** — click-to-rebind dengan global listener
- **Label** — teks yang bisa di-update programatik
- **Section** — pemisah visual antar grup komponen

### ⚙️ Sistem
- **Flags** — akses nilai semua komponen dari mana saja via `Koji.Flags["nama"]`
- **Config Saving** — auto-save JSON ke file system executor
- **Notifications** — toast notification independen dengan progress bar
- **Key System** — overlay gate sebelum window muncul
- **Drag & Drop** — window bisa dipindah bebas
- **Keyboard Toggle** — `RightShift` untuk show/hide window

---

## 📦 Installation

### Metode 1: loadstring via HttpGet (Direkomendasikan)

```lua
local Koji = loadstring(game:HttpGet(
    'https://raw.githubusercontent.com/koji-project/koji-livery/main/KojiLivery.lua'
))()
```

### Metode 2: File Lokal (Offline)

1. Download file `KojiLivery.lua` dari repository ini
2. Simpan ke folder executor kamu (biasanya di `workspace/` atau folder exploit)
3. Load dengan:

```lua
local Koji = loadfile("KojiLivery.lua")()
-- atau
local Koji = dofile("KojiLivery.lua")
```

### Metode 3: Copy-Paste Langsung

Salin seluruh isi `KojiLivery.lua` dan paste langsung di awal script kamu, lalu tambahkan kode hub di bawahnya.

### Persyaratan Executor

| Fitur | Executor API yang Dibutuhkan |
|-------|------------------------------|
| Load library | `HttpGet`, `loadstring` |
| Config saving | `writefile`, `readfile`, `isfile`, `isfolder`, `makefolder` |
| Semua fitur lain | Standar Roblox API |

> Executor populer seperti **Synapse X**, **KRNL**, **Fluxus**, **Electron**, **Delta**, dan **Arceus X** semuanya mendukung API di atas.

---

## 🚀 Quick Start

Ini adalah contoh paling minimal untuk membuat window yang berfungsi:

```lua
-- 1. Load library
local Koji = loadstring(game:HttpGet(
    'https://raw.githubusercontent.com/koji-project/koji-livery/main/KojiLivery.lua'
))()

-- 2. Buat window
local Window = Koji:CreateWindow({
    Name  = "My First Hub",
    Theme = "Midnight",
})

-- 3. Buat tab
local Tab = Window:CreateTab("Main")

-- 4. Tambah komponen
Tab:CreateButton({
    Name     = "Say Hello",
    Callback = function()
        print("Hello from Koji Livery!")
    end,
})

-- 5. Notifikasi startup
Koji:Notify({
    Title   = "Hub Loaded!",
    Content = "My First Hub is ready.",
    Type    = "Success",
})
```

Hanya 5 langkah — dan kamu sudah punya UI yang berfungsi penuh! 🎉

---

## 🪟 Window

### CreateWindow

`CreateWindow` adalah fungsi utama untuk membuat jendela UI. Dipanggil langsung dari objek `Koji`.

```lua
local Window = Koji:CreateWindow(options)
```

### Window Options

Berikut semua opsi yang bisa kamu berikan ke `CreateWindow`:

```lua
local Window = Koji:CreateWindow({

    -- ─── Tampilan ────────────────────────────────────────────
    Name            = "Koji Hub",       -- Judul window di top bar
    Icon            = 0,                -- Asset ID Roblox (number) atau URL gambar (string)
                                        -- Gunakan 0 atau nil untuk tidak pakai ikon
    LoadingTitle    = "Koji Hub",       -- Teks besar di loading screen
    LoadingSubtitle = "by YourName",    -- Sub-teks di loading screen
    Theme           = "Midnight",       -- Nama theme: Midnight | Sakura | Ember | Arctic | Neon

    -- ─── Perilaku ────────────────────────────────────────────
    HideOnClose     = false,            -- true = sembunyikan saat × ditekan
                                        -- false = hancurkan GUI sepenuhnya

    -- ─── Config Saving ───────────────────────────────────────
    ConfigSaving = {
        Enabled  = true,                -- Aktifkan penyimpanan config otomatis
        FileName = "MyHubConfig",       -- Nama file JSON (tanpa ekstensi)
                                        -- Disimpan di folder KojiLivery/
    },

    -- ─── Key System ──────────────────────────────────────────
    KeySystem = false,                  -- true = tampilkan overlay input kunci
    KeySettings = {
        Title = "Access Required",      -- Judul di overlay kunci
        Note  = "Get key at discord.gg/...", -- Petunjuk cara dapat kunci
        Keys  = {                       -- Daftar kunci yang valid
            "my-secret-key-2025",
            "vip-access-xyz",
        },
    },
})
```

### Window Controls

Setelah window dibuat, kamu mendapatkan objek `Window` dengan method berikut:

```lua
-- Simpan config secara manual
Window:SaveConfig()

-- Load config dari file
Window:LoadConfig()

-- Hancurkan window dan semua koneksi
Window:Destroy()
```

### Keyboard Shortcut

| Tombol | Aksi |
|--------|------|
| `RightShift` | Toggle show/hide window |
| Klik × (merah) | Close / destroy window |
| Klik ▪ (kuning) | Minimize ke top bar saja |
| Klik ● (hijau) | Hide window |

> Window bisa di-drag dengan cara klik dan tahan pada **top bar** lalu geser ke mana saja.

---

## 📑 Tabs & Sections

### CreateTab

Tab ditambahkan ke sidebar kiri window. Klik tab untuk berpindah halaman konten.

```lua
local Tab = Window:CreateTab(
    "Nama Tab",     -- String, wajib
    4483362458      -- Icon asset ID, opsional (bisa nil)
)
```

**Contoh membuat beberapa tab:**

```lua
local MainTab    = Window:CreateTab("Main",    4483362458)
local PlayerTab  = Window:CreateTab("Player",  4483362458)
local VisualTab  = Window:CreateTab("Visuals", 4483362458)
local SettingTab = Window:CreateTab("Settings")
```

Tab pertama yang dibuat akan **otomatis terpilih** saat window muncul.

---

### CreateSection

Section adalah pemisah visual dengan label untuk mengelompokkan komponen dalam satu tab.

```lua
Tab:CreateSection("Nama Section")
```

**Contoh penggunaan:**

```lua
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateSection("Melee")
-- tambah komponen melee di sini

CombatTab:CreateSection("Ranged")
-- tambah komponen ranged di sini

CombatTab:CreateSection("Defense")
-- tambah komponen defense di sini
```

---

## 🧩 Components

Semua komponen dipanggil dari objek **Tab**, bukan dari Window atau Koji langsung.

---

### CreateButton

Tombol yang menjalankan fungsi saat diklik.

```lua
Tab:CreateButton({
    Name        = "Nama Tombol",         -- Teks tombol (wajib)
    Description = "Deskripsi tombol.",   -- Sub-teks opsional
    Callback    = function()
        -- Kode yang dijalankan saat tombol ditekan
    end,
})
```

**Contoh lengkap:**

```lua
CombatTab:CreateButton({
    Name        = "Kill Aura",
    Description = "Menyerang semua player dalam radius.",
    Callback    = function()
        -- logika kill aura
        Koji:Notify({
            Title   = "Kill Aura",
            Content = "Diaktifkan!",
            Type    = "Success",
        })
    end,
})
```

---

### CreateToggle

Switch on/off dengan animasi. Menyimpan state boolean.

```lua
local myToggle = Tab:CreateToggle({
    Name        = "Nama Toggle",         -- Teks (wajib)
    Description = "Deskripsi.",          -- Sub-teks opsional
    Default     = false,                 -- State awal: true atau false
    Flag        = "NamaFlag",            -- Key untuk Koji.Flags (opsional)
    Callback    = function(state)
        -- state: boolean (true = on, false = off)
        print("Toggle state:", state)
    end,
})

-- Ubah nilai programatik:
myToggle:SetValue(true)

-- Baca nilai saat ini:
print(myToggle:GetValue())     -- true atau false
print(Koji.Flags["NamaFlag"])  -- sama seperti GetValue()
```

**Contoh:**

```lua
local infJump = MainTab:CreateToggle({
    Name     = "Infinite Jump",
    Default  = false,
    Flag     = "InfJump",
    Callback = function(state)
        -- aktifkan / nonaktifkan infinite jump
    end,
})

-- Dari tempat lain di script:
if Koji.Flags["InfJump"] then
    -- lakukan sesuatu saat infinite jump aktif
end
```

---

### CreateSlider

Slider geser untuk nilai numerik dalam rentang tertentu.

```lua
local mySlider = Tab:CreateSlider({
    Name        = "Nama Slider",     -- Teks (wajib)
    Description = "Deskripsi.",      -- Sub-teks opsional
    Min         = 0,                 -- Nilai minimum
    Max         = 100,               -- Nilai maksimum
    Default     = 50,                -- Nilai awal
    Increment   = 1,                 -- Langkah per perubahan (bisa desimal: 0.1, 0.5)
    Suffix      = "",                -- Teks di belakang nilai (contoh: " WS", "px", "%")
    Flag        = "NamaFlag",        -- Key untuk Koji.Flags
    Callback    = function(value)
        -- value: number
        print("Nilai slider:", value)
    end,
})

-- Ubah nilai:
mySlider:SetValue(75)

-- Baca nilai:
print(mySlider:GetValue())
```

**Contoh penggunaan nyata:**

```lua
-- Walk Speed slider
MainTab:CreateSlider({
    Name      = "Walk Speed",
    Min       = 16,
    Max       = 500,
    Default   = 16,
    Increment = 2,
    Suffix    = " WS",
    Flag      = "WalkSpeed",
    Callback  = function(val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end,
})

-- Transparency slider dengan desimal
VisualTab:CreateSlider({
    Name      = "ESP Transparency",
    Min       = 0,
    Max       = 1,
    Default   = 0.5,
    Increment = 0.05,
    Suffix    = "",
    Flag      = "ESPTransparency",
    Callback  = function(val)
        -- update transparency ESP
    end,
})
```

---

### CreateDropdown

Dropdown menu untuk memilih satu atau banyak item dari daftar.

```lua
local myDropdown = Tab:CreateDropdown({
    Name        = "Nama Dropdown",    -- Teks (wajib)
    Description = "Deskripsi.",       -- Sub-teks opsional
    Items       = { "Item1", "Item2", "Item3" }, -- Daftar pilihan (wajib)
    Default     = "Item1",            -- Pilihan awal (nil = tidak ada pilihan)
    Flag        = "NamaFlag",         -- Key untuk Koji.Flags
    Multi       = false,              -- false = single select, true = multi select
    Callback    = function(selected)
        -- single: selected = string
        -- multi:  selected = table of strings
    end,
})

-- Ubah nilai:
myDropdown:SetValue("Item2")         -- single select
myDropdown:SetValue({"Item1","Item3"}) -- multi select

-- Refresh daftar item secara dinamis:
myDropdown:Refresh({ "NewItem1", "NewItem2", "NewItem3" })

-- Baca nilai:
print(myDropdown:GetValue())
```

**Contoh — single select:**

```lua
-- Dropdown pilih gamemode
Tab:CreateDropdown({
    Name     = "Gamemode",
    Items    = { "Normal", "Hard", "Extreme", "Impossible" },
    Default  = "Normal",
    Flag     = "Gamemode",
    Callback = function(val)
        print("Gamemode dipilih:", val)
    end,
})
```

**Contoh — multi select:**

```lua
-- Dropdown pilih fitur ESP yang aktif
Tab:CreateDropdown({
    Name  = "ESP Features",
    Items = { "Boxes", "Names", "Health", "Distance", "Tracers" },
    Multi = true,
    Flag  = "ESPFeatures",
    Callback = function(selected)
        -- selected = { "Boxes", "Names" } (contoh)
        for _, feature in ipairs(selected) do
            print("Aktif:", feature)
        end
    end,
})
```

**Contoh — dropdown dinamis (list player):**

```lua
local players = {}
for _, p in ipairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer then
        table.insert(players, p.Name)
    end
end

local targetDrop = Tab:CreateDropdown({
    Name     = "Target Player",
    Items    = players,
    Flag     = "TargetPlayer",
    Callback = function(name) print("Target:", name) end,
})

-- Refresh saat player join/leave
game.Players.PlayerAdded:Connect(function()
    local newList = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(newList, p.Name)
        end
    end
    targetDrop:Refresh(newList)
end)
```

---

### CreateInput

Text box untuk input teks bebas atau angka dari pengguna.

```lua
local myInput = Tab:CreateInput({
    Name        = "Nama Input",           -- Teks label (wajib)
    Description = "Deskripsi.",           -- Sub-teks opsional
    Placeholder = "Ketik di sini...",     -- Placeholder teks
    Default     = "",                     -- Nilai awal
    Numeric     = false,                  -- true = hanya menerima angka
    Flag        = "NamaFlag",             -- Key untuk Koji.Flags
    Callback    = function(text, enter)
        -- text: nilai teks saat ini
        -- enter: boolean, true jika user tekan Enter
    end,
})

-- Ubah nilai:
myInput:SetValue("Hello World")

-- Baca nilai:
print(myInput:GetValue())
```

> Callback dipanggil setiap kali text box kehilangan fokus (klik di luar atau tekan Enter). Parameter `enter` bernilai `true` hanya saat user menekan tombol Enter.

**Contoh:**

```lua
-- Input nama player target
Tab:CreateInput({
    Name        = "Target Username",
    Placeholder = "Masukkan nama player...",
    Flag        = "TargetName",
    Callback    = function(text, enter)
        if enter and text ~= "" then
            local target = game.Players:FindFirstChild(text)
            if target then
                print("Target ditemukan:", target.Name)
            else
                Koji:Notify({
                    Title   = "Player Not Found",
                    Content = "'" .. text .. "' tidak ada di server.",
                    Type    = "Error",
                })
            end
        end
    end,
})

-- Input angka (numeric mode)
Tab:CreateInput({
    Name        = "Custom Speed",
    Placeholder = "Masukkan angka...",
    Numeric     = true,
    Flag        = "CustomSpeed",
    Callback    = function(num)
        print("Speed custom:", num) -- num sudah berupa number
    end,
})
```

---

### CreateColorPicker

Color picker lengkap dengan hue strip, saturation/value box, dan hex input.

```lua
local myColorPicker = Tab:CreateColorPicker({
    Name     = "Nama Color Picker",      -- Teks label (wajib)
    Default  = Color3.fromRGB(255, 0, 0), -- Warna awal
    Flag     = "NamaFlag",               -- Key untuk Koji.Flags
    Callback = function(color)
        -- color: Color3
        print("Warna dipilih:", color)
    end,
})

-- Ubah warna:
myColorPicker:SetValue(Color3.fromRGB(0, 255, 128))

-- Baca warna:
local currentColor = myColorPicker:GetValue()
```

**Cara menggunakan color picker:**
1. Klik kotak warna preview untuk membuka/tutup panel
2. Geser **hue strip** (bar pelangi di atas) untuk mengubah hue
3. Geser kursor di **SV box** untuk mengubah saturation (kiri-kanan) dan brightness (atas-bawah)
4. Ketik kode **hex** langsung di input box (format: `#RRGGBB`)

**Contoh penggunaan nyata:**

```lua
-- ESP Color picker
local espColor = VisualTab:CreateColorPicker({
    Name     = "ESP Box Color",
    Default  = Color3.fromRGB(255, 50, 50),
    Flag     = "ESPBoxColor",
    Callback = function(color)
        -- update semua ESP box highlight
        for _, highlight in ipairs(espHighlights) do
            highlight.OutlineColor = color
        end
    end,
})

-- Chams color picker
VisualTab:CreateColorPicker({
    Name     = "Chams Color",
    Default  = Color3.fromRGB(100, 160, 255),
    Flag     = "ChamsColor",
    Callback = function(color)
        -- update chams material color
    end,
})
```

---

### CreateKeybind

Komponen untuk bind tombol keyboard ke suatu aksi.

```lua
local myKeybind = Tab:CreateKeybind({
    Name     = "Nama Keybind",           -- Teks label (wajib)
    Default  = Enum.KeyCode.X,           -- Tombol default
    Flag     = "NamaFlag",               -- Key untuk Koji.Flags
    Callback = function(key)
        -- Dipanggil setiap kali tombol yang ter-bind ditekan
        -- key: Enum.KeyCode
        print("Tombol ditekan:", key.Name)
    end,
})

-- Baca keybind saat ini:
print(myKeybind:GetValue())       -- Enum.KeyCode

-- Set keybind secara kode:
myKeybind:SetValue(Enum.KeyCode.F)
```

**Cara rebind:**
1. Klik tombol keybind (menampilkan `...`)
2. Tekan tombol keyboard yang baru
3. Bind tersimpan otom
