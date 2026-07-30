# GaphopUI_V2
---
## Loading the libary
---
```
loadstring(game:HttpGet('https://raw.githubusercontent.com/gaphop123/GaphopUI_V2/refs/heads/main/main.lua'))()

```
---
## Window 
---
```
task.defer(function()
    if not GaphopUI.WindowInstance then
        local Window = GaphopUI:CreateWindow({
            Name = "GaphopUI Ultimate",
            ShowText = "v3.0.0",
            LoadingTitle = "GaphopUI Engine",
            LoadingSubtitle = "Smooth Animations & RGB Loaded!"
        })

        -- Tab and Elements
    end
end)

return GaphopUI
```
