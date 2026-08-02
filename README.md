# GaphopUI
---
![GaphopUI](https://raw.githubusercontent.com/gaphop123/GaphopUI_V2/main/main.png)
---
# Creator
---
## Roblox820kchg

🔗 **Profile:** https://www.roblox.com/users/4156564022/profile

![Roblox820kchg](https://raw.githubusercontent.com/gaphop123/GaphopUI/main/820.png)

---

## Roblox810kchg

🔗 **Profile:** https://www.roblox.com/users/1523725321/profile

![Roblox810kchg](https://raw.githubusercontent.com/gaphop123/GaphopUI/main/810.webp)
---
##Website
> **Note:** srry for using AI to make website
https://gaphopui.netlify.app/

## Loading the libary
---
```lua
local GaphopUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/gaphop123/GaphopUI/refs/heads/main/main.lua"))()

```
---
## Window 
---
```lua
local Window = GaphopUI:CreateWindow({
    Name = "GaphopUI",
    ShowText = "V2", -- Remove this if you don't want it
    Icon = "eye", -- Remove this if you don't want it
    LoadingTitle = "GaphopUI Engine",
    LoadingSubtitle = "GaphopUI is loaded!"
})
```




---

# Tab

## Create Tab

Creates a new tab inside the window.

```lua
local GeneralTab = Window:CreateTab("General", "home")
```

---

# Section

## Create Section ⚠️

> **Note:** This feature currently has a bug.

Creates a labeled section to organize UI elements.

```lua
GeneralTab:CreateSection("Smooth Animation Controls")
```

---

# Notification

## Notify

Displays a notification.

```lua
GaphopUI:Notify({
    Title = "Success",
    Content = "GaphopUI loaded successfully!"
})
```

---

# Prompt

## Create Prompt

Displays a confirmation dialog.

```lua
GaphopUI:CreatePrompt({
    Title = "Execute Script?",
    Content = "Are you sure you want to run this module?",
    OnConfirm = function()
        print("Confirmed!")
    end
})
```

---

# Button

## Create Button

Creates a clickable button.

```lua
GeneralTab:CreateButton({
    Name = "Modal Prompt Test",
    Callback = function()

    end
})
```

---

# Toggle

## Create Toggle

Creates an ON/OFF toggle.

```lua
GeneralTab:CreateToggle({
    Name = "Sample Toggle",
    CurrentValue = true,
    Callback = function(state)

    end
})
```

---

# Slider

## Create Slider

Creates a slider.

```lua
GeneralTab:CreateSlider({
    Name = "Sample Slider",
    Range = {0, 100},
    CurrentValue = 50,
    Suffix = "%",
    Callback = function(value)

    end
})
```

---

# Input

## Create Input

Creates a text input box.

```lua
GeneralTab:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Type here...",
    Callback = function(text)

    end
})
```

---

# Dropdown

## Create Dropdown

Creates a dropdown menu.

```lua
GeneralTab:CreateDropdown({
    Name = "Aimbot Part",
    Options = {
        "Head",
        "HumanoidRootPart",
        "Torso"
    },
    CurrentOption = "Head",
    Callback = function(option)

    end
})
```

---

# Color Picker

## Create Color Picker

Creates a color picker.

```lua
GeneralTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(0, 162, 255),
    Callback = function(color)

    end
})
```

---

# Keybind

## Create Keybind

Creates a keybind selector.

```lua
GeneralTab:CreateKeybind({
    Name = "Quick Action",
    CurrentKeybind = Enum.KeyCode.Q,
    Callback = function(key)

    end
})
```

---

# Complete Example

```lua
local Window = GaphopUI:CreateWindow({
    Name = "Ultimate Animation",
    Icon = "sparkles",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please wait"
})

local DemoTab1 = Window:CreateTab("General", "home")

DemoTab1:CreateSection("Smooth Animation Controls")

DemoTab1:CreateButton({
    Name = "Modal Prompt Test",
    Callback = function()

    end
})

DemoTab1:CreateToggle({
    Name = "Sample Toggle",
    CurrentValue = true,
    Callback = function(val)

    end
})

DemoTab1:CreateSlider({
    Name = "Sample Slider",
    Range = {0, 100},
    CurrentValue = 50,
    Suffix = "%",
    Callback = function(val)

    end
})

local DemoTab2 = Window:CreateTab("Components", "sparkles")

DemoTab2:CreateSection("Inputs & Selectors")

DemoTab2:CreateInput({
    Name = "Speed Multiplier",
    PlaceholderText = "Enter value...",
    Callback = function(text)

    end
})

DemoTab2:CreateDropdown({
    Name = "Aimbot Part",
    Options = {
        "Head",
        "HumanoidRootPart",
        "Torso"
    },
    CurrentOption = "Head",
    Callback = function(selected)

    end
})

DemoTab2:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(0, 162, 255),
    Callback = function(color)

    end
})

GaphopUI:Notify({
    Title = "Ultimate Animation",
    Content = "GaphopUI Ripple & Spring Physics active!"
})

GaphopUI:CreatePrompt({
    Title = "Execute Script?",
    Content = "Are you sure you want to run this module?",
    OnConfirm = function()

    end
})
```
