# 🚀 GaphopUI (V2.5)

---
![GaphopUI](https://raw.githubusercontent.com/gaphop123/GaphopUI_V2/main/main.png)
---

**GaphopUI** is a modern, feature-packed UI Library built for Roblox scripts. Powered by **Liquid Glass Treatment**, **Spring Physics Animations**, 1500+ Lucide icons, automatic mobile scaling, and built-in configuration management.

---

## 📌 Key Features

* 🎨 **Liquid Glass Treatment**: Glossy glassmorphism aesthetics with dynamic edge highlights.
* ⚡ **Spring Animations**: Ultra-smooth motion physics powered by soft springs.
* 🔍 **Global Search & Filter**: Instant element filtering across all tabs (`GaphopUI:FilterElements`).
* 🎨 **25+ Built-in Themes**: Dynamic runtime theme switching and rainbow RGB mode.
* 📱 **Mobile Auto-Scale**: Smart responsive scaling (`MobileScale = 0.82`) with a floating toggle button.
* 📁 **Config System**: Automatically saves theme, keybinds, RGB state, and toggle states to `GaphopUI/config.json`.
* 🎯 **1500+ Lucide Icons**: Full support for Lucide icon names and `rbxassetid://` asset IDs.

---

## ⚡ Bootstrapping

```lua
local GaphopUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gaphop123/GaphopUI/refs/heads/main/main.lua"))()

-- Create Window
local Window = GaphopUI:makeWindow({ -- Alias: CreateWindow
    Name = "My Script Hub",
    Icon = "sparkles",              -- Lucide icon name or rbxassetid
    ShowText = "v2.5",              -- Optional subtitle next to title
    ToggleUIKeybind = "K",          -- Keybind to hide/show UI
    NoLoading = false,              -- Set to true to skip splash screen
    LoadingTitle = "GaphopUI Engine",
    LoadingSubtitle = "by Gaphop"
})

-- Create Tab
local MainTab = Window:CreateTab("Main", "home") -- Aliases: AddTab, makeTab
```

---

## 🛠️ Components API

### 1. Button
```lua
MainTab:makeButton({ -- Aliases: CreateButton, AddButton
    Name = "Execute Script",
    Callback = function()
        print("Button Clicked!")
    end
})
```

### 2. Toggle
```lua
MainTab:makeToggle({ -- Aliases: CreateToggle, AddToggle
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmFlag",      -- Optional config key
    Callback = function(state)  -- boolean
        print("Toggle State:", state)
    end
})
```

### 3. Slider
```lua
MainTab:makeSlider({ -- Aliases: CreateSlider, AddSlider
    Name = "WalkSpeed",
    Range = {16, 250},
    CurrentValue = 16,
    Suffix = " WS",             -- Optional suffix
    Flag = "SpeedFlag",
    Callback = function(value)  -- number
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
```

### 4. Input (TextBox)
```lua
MainTab:makeInput({ -- Aliases: CreateInput, AddInput
    Name = "Target Player",
    PlaceholderText = "Type username...",
    Callback = function(text)   -- string (fires on FocusLost)
        print("Input Text:", text)
    end
})
```

### 5. Dropdown
```lua
MainTab:makeDropdown({ -- Aliases: CreateDropdown, AddDropdown
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = "Head",
    Flag = "AimbotPart",
    Callback = function(option) -- string
        print("Selected:", option)
    end
})
```

### 6. Keybind
```lua
MainTab:makeKeybind({ -- Aliases: CreateKeybind, AddKeybind
    Name = "Aimbot Key",
    CurrentKeybind = Enum.KeyCode.E,
    Flag = "AimbotKeybind",
    Callback = function(keycode) -- Enum.KeyCode
        print("Bound Key:", keycode)
    end
})
```

### 7. Color Picker
```lua
MainTab:makeColorPicker({ -- Aliases: CreateColorPicker, AddColorPicker
    Name = "ESP Color",
    Color = Color3.fromRGB(0, 162, 255),
    Flag = "ESPColor",
    Callback = function(color)  -- Color3
        print("Selected Color:", color)
    end
})
```

### 8. Prompt (Modal Dialog)
```lua
GaphopUI:CreatePrompt({
    Title = "Confirmation",
    Content = "Are you sure you want to proceed?",
    ConfirmText = "Confirm",
    CancelText = "Cancel",
    OnConfirm = function()
        print("Confirmed")
    end,
    OnCancel = function()
        print("Cancelled")
    end
})
```

---

## 🎨 Static & Display Elements

```lua
-- Section Header
MainTab:CreateSection("Combat Settings") -- Aliases: AddSection (Accepts string or table {Name/Title})

-- Static Paragraph
MainTab:CreateParagraph("Information", "This script is running version 2.5.") -- Aliases: AddParagraph

-- Interactive Label
local MyLabel = MainTab:CreateLabel("Current Status: Idle") -- Aliases: makeLabel
MyLabel:Set("Current Status: Active")
MyLabel:SetDescription("Updated 5 seconds ago")
```

---

## 🔔 Notifications

```lua
-- Standard Notification
GaphopUI:Notify({
    Title = "Success",
    Content = "Settings saved successfully!",
    Duration = 4,
    Image = "check" -- Lucide icon name, rbxassetid, or player headshot
})

-- Warning Notification
GaphopUI:WarnNotify({
    Title = "Caution",
    Content = "High risk feature enabled!",
    Duration = 5,
    Color = Color3.fromRGB(255, 180, 0), -- Optional custom accent color
    Image = "alert-triangle"
})
```

---

## ⚙️ Utility APIs

| API Method | Description |
| :--- | :--- |
| `GaphopUI:ApplyTheme("CyberNeon")` | Changes the UI theme live (25+ built-in presets). |
| `GaphopUI:ToggleRGB(true)` | Enables or disables live RGB cycling. |
| `GaphopUI:ToggleUI(state)` | Manually shows or hides the main UI frame. |
| `GaphopUI:FilterElements(query)` | Filters UI components across all tabs matching the query string. |

---

## 📜 Complete Minimal Example

```lua
local GaphopUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gaphop123/GaphopUI/refs/heads/main/main.lua"))()

local Window = GaphopUI:CreateWindow({
    Name = "Ultimate Hub",
    Icon = "sparkles",
    ShowText = "v2.5",
    LoadingTitle = "GaphopUI Engine",
    LoadingSubtitle = "Loading modules..."
})

-- Tab 1: General
local MainTab = Window:CreateTab("General", "home")
MainTab:CreateSection("Movement Controls")

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    CurrentValue = 16,
    Suffix = " WS",
    Callback = function(val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        _G.InfJump = state
    end
})

-- Tab 2: Visuals
local VisualTab = Window:CreateTab("Visuals", "eye")
VisualTab:CreateSection("ESP Options")

VisualTab:CreateColorPicker({
    Name = "Box Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        -- Custom ESP color logic
    end
})

VisualTab:CreateDropdown({
    Name = "Target Type",
    Options = {"All", "Enemies", "Team"},
    CurrentOption = "Enemies",
    Callback = function(selected)
        print("Targeting:", selected)
    end
})

-- Show Initialization Notification
GaphopUI:Notify({
    Title = "GaphopUI V2.5",
    Content = "Loaded with Liquid Glass effects & Spring Physics!",
    Duration = 5,
    Image = "sparkles"
})
```

---

## 👨‍💻 Authors & Credits

* **Roblox820kchg**: [Roblox Profile](https://www.roblox.com/users/4156564022/profile)
* **Roblox810kchg**: [Roblox Profile](https://www.roblox.com/users/1523725321/profile)
* 🌐 **Website Key System**: [Gaphop Key System](https://gaphop123.github.io/GPWST)
