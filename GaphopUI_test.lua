-- STREAMING_CHUNK:Initializing Core Roblox Services and Global Tables...
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

warn("This UI may have bugs. Please report any issues you find.")
warn("This is a GaphopUI test build. It is not intended for use.")

wait(2)

local loader1 = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/Roblox-Chams-Highlight/refs/heads/main/Highlight.lua"))() end)
local loader2 = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/Lua-Speed/refs/heads/main/speed.lua"))() end)

if not RunService:IsClient() then
return
end

local LocalPlayer = Players.LocalPlayer
local PlayerName = (LocalPlayer and LocalPlayer.Name) or "Player"
local PlayerUserId = (LocalPlayer and LocalPlayer.UserId) or 0

-- Ensure global environment tables exist to prevent nil indexing errors
if type(getgenv) == "function" then
local env = getgenv()
env.speed = env.speed or {}
env.chams = env.chams or {}
end

-- STREAMING_CHUNK:Resolving Safe Parent Container for UI Rendering...
local function GetSafeParent()
if type(gethui) == "function" then
local ok, res = pcall(gethui)
if ok and res then return res end
end

if LocalPlayer then
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then
        pcall(function() pg = LocalPlayer:WaitForChild("PlayerGui", 3) end)
    end
    if pg then return pg end
end

if type(cloneref) == "function" then
    local ok, res = pcall(function() return cloneref(CoreGui) end)
    if ok and res then return res end
end

return CoreGui


end

local ParentUI = GetSafeParent()

-- Clean up any existing instance to prevent duplicates
if ParentUI:FindFirstChild("GaphopUI_Engine") then
ParentUI:FindFirstChild("GaphopUI_Engine"):Destroy()
end

-- STREAMING_CHUNK:Defining Ultimate Library Configurations & Color Palettes...
local GaphopUI = {
Version = "3.1.0 KeySystem Integration",
Flags = {},
Themes = {},
CurrentTheme = "Dark",
ToggleKey = Enum.KeyCode.K,
IsOpen = true,
Elements = {},
Connections = {},
WindowInstance = nil,
OpenButton = nil,
NotifyContainer = nil,
AssetFolder = nil,
CallbackRegistry = {},
RGBEnabled = false,
RGBConnection = nil,
CurrentRGBColor = Color3.fromRGB(0, 162, 255),
Icons = {
settings = "⚙", search = "⌕", home = "⌂", close = "x", x = "x", minimize = "—", maximize = "▢",
refresh = "↻", palette = "◐", keyboard = "⌨", sparkles = "✦", moon = "☾", sun = "☀",
info = "ⓘ", bell = "🔔", menu = "☰", plus = "+", minus = "−", check = "✓", slider = "▭",
layers = "☰", cog = "⚙", chevron = "⌵", shield = "🛡", zap = "⚡", star = "★"
}
}

-- Mapping GaphopUI internal keywords directly to standard Lucide icons
GaphopUI.LucideSprites = {
x = {16898613869, {48, 48}, {869, 906}},
checksquare = {16898612819, {48, 48}, {771, 808}},
layers = {16898613613, {48, 48}, {49, 820}},
chevronup = {16898612819, {48, 48}, {710, 918}},
shieldalert = {16898613777, {48, 48}, {49, 771}},
}
GaphopUI.Icons.chevron = GaphopUI.LucideSprites.chevronup or GaphopUI.Icons.chevron
GaphopUI.Icons.close = GaphopUI.LucideSprites.x or GaphopUI.Icons.close

GaphopUI.Themes = {
Dark = { Background = Color3.fromRGB(16, 17, 23), Card = Color3.fromRGB(25, 27, 38), CardHover = Color3.fromRGB(34, 37, 52), Header = Color3.fromRGB(20, 22, 31), Accent = Color3.fromRGB(0, 162, 255), AccentGlow = Color3.fromRGB(0, 140, 230), Text = Color3.fromRGB(245, 247, 252), SubText = Color3.fromRGB(150, 155, 175), Border = Color3.fromRGB(45, 50, 68), ToggleOn = Color3.fromRGB(0, 162, 255), ToggleOff = Color3.fromRGB(40, 44, 58), SliderBar = Color3.fromRGB(38, 42, 56), InputBackground = Color3.fromRGB(21, 23, 32), Shadow = Color3.fromRGB(0, 0, 0) },
Midnight = { Background = Color3.fromRGB(11, 11, 20), Card = Color3.fromRGB(20, 20, 36), CardHover = Color3.fromRGB(28, 28, 48), Header = Color3.fromRGB(15, 15, 26), Accent = Color3.fromRGB(130, 90, 255), AccentGlow = Color3.fromRGB(110, 70, 230), Text = Color3.fromRGB(245, 245, 255), SubText = Color3.fromRGB(145, 145, 178), Border = Color3.fromRGB(45, 45, 75), ToggleOn = Color3.fromRGB(130, 90, 255), ToggleOff = Color3.fromRGB(32, 32, 52), SliderBar = Color3.fromRGB(32, 32, 55), InputBackground = Color3.fromRGB(16, 16, 28), Shadow = Color3.fromRGB(0, 0, 0) },
CyberNeon = { Background = Color3.fromRGB(10, 12, 18), Card = Color3.fromRGB(18, 22, 32), CardHover = Color3.fromRGB(26, 32, 46), Header = Color3.fromRGB(14, 16, 24), Accent = Color3.fromRGB(255, 0, 128), AccentGlow = Color3.fromRGB(210, 0, 105), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(160, 170, 190), Border = Color3.fromRGB(60, 30, 70), ToggleOn = Color3.fromRGB(255, 0, 128), ToggleOff = Color3.fromRGB(35, 30, 45), SliderBar = Color3.fromRGB(35, 30, 45), InputBackground = Color3.fromRGB(14, 16, 24), Shadow = Color3.fromRGB(0, 0, 0) },
Emerald = { Background = Color3.fromRGB(10, 18, 16), Card = Color3.fromRGB(18, 30, 26), CardHover = Color3.fromRGB(25, 42, 36), Header = Color3.fromRGB(14, 23, 20), Accent = Color3.fromRGB(16, 185, 129), AccentGlow = Color3.fromRGB(10, 150, 105), Text = Color3.fromRGB(240, 250, 245), SubText = Color3.fromRGB(140, 168, 155), Border = Color3.fromRGB(35, 60, 50), ToggleOn = Color3.fromRGB(16, 185, 129), ToggleOff = Color3.fromRGB(28, 45, 38), SliderBar = Color3.fromRGB(28, 45, 38), InputBackground = Color3.fromRGB(14, 24, 20), Shadow = Color3.fromRGB(0, 0, 0) },
}

-- STREAMING_CHUNK:Creating Main ScreenGui Container...
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GaphopUI_Engine"
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true
ScreenGui.Parent = ParentUI

-- STREAMING_CHUNK:Defining Animation Utility Helpers & Smooth Easing Physics...
local function Tween(instance, info, properties)
if not instance then return end
local tween = TweenService:Create(instance, info, properties)
tween:Play()
return tween
end

local function SpringTween(instance, duration, properties, style)
style = style or Enum.EasingStyle.Quart
local info = TweenInfo.new(duration or 0.3, style, Enum.EasingDirection.Out)
return Tween(instance, info, properties)
end

local function CreateRipple(parent, inputPosition)
if not parent then return end
local ripple = Instance.new("Frame")
ripple.Name = "RippleEffect"
ripple.AnchorPoint = Vector2.new(0.5, 0.5)
ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ripple.BackgroundTransparency = 0.75
ripple.ZIndex = (parent.ZIndex or 1) + 10
ripple.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = ripple

local parentAbsPos = parent.AbsolutePosition
local parentAbsSize = parent.AbsoluteSize
local relX = (inputPosition and inputPosition.X or (parentAbsPos.X + parentAbsSize.X/2)) - parentAbsPos.X
local relY = (inputPosition and inputPosition.Y or (parentAbsPos.Y + parentAbsSize.Y/2)) - parentAbsPos.Y

ripple.Position = UDim2.fromOffset(relX, relY)
ripple.Size = UDim2.fromOffset(0, 0)
ripple.Parent = parent

local maxSize = math.max(parentAbsSize.X, parentAbsSize.Y) * 2.5
Tween(ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(maxSize, maxSize),
    BackgroundTransparency = 1
})

task.delay(0.5, function()
    if ripple and ripple.Parent then ripple:Destroy() end
end)


end

local function CreateCorner(parent, radius)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, radius or 10)
corner.Parent = parent
return corner
end

local function CreateStroke(parent, color, thickness, transparency)
local stroke = Instance.new("UIStroke")
stroke.Color = color or GaphopUI.Themes[GaphopUI.CurrentTheme].Border
stroke.Thickness = thickness or 1
stroke.Transparency = transparency or 0.6
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = parent
return stroke
end

local function Color3ToHex(color)
if not color then return "#FFFFFF" end
return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

-- STREAMING_CHUNK:Implementing Smooth Window Dragging Mechanics...
local function MakeDraggable(gui, handle)
local dragging, dragInput, dragStart, startPos
handle = handle or gui

local conn1 = handle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = gui.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

local conn2 = handle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

local conn3 = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        SpringTween(gui, 0.12, {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }, Enum.EasingStyle.Sine)
    end
end)


end

-- STREAMING_CHUNK:Constructing Animated Notification Stack System...
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Name = "NotifyContainer"
NotifyContainer.Size = UDim2.new(0, 320, 1, -40)
NotifyContainer.Position = UDim2.new(1, -330, 0, 20)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.ZIndex = 100000 -- Ensure it's above Key System
NotifyContainer.Parent = ScreenGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Parent = NotifyContainer

GaphopUI.NotifyContainer = NotifyContainer

function GaphopUI:Notify(cfg)
cfg = cfg or {}
local titleText = cfg.Title or "Notification"
local contentText = cfg.Content or ""
local duration = cfg.Duration or 4
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

local card = Instance.new("Frame")
card.Size = UDim2.new(1, 0, 0, 72)
card.BackgroundColor3 = theme.Card
card.BackgroundTransparency = 0.12
card.Position = UDim2.new(1, 360, 0, 0)
card.ClipsDescendants = true
card.Parent = NotifyContainer

CreateCorner(card, 12)
CreateStroke(card, theme.Accent, 1, 0.4)

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 16)
padding.PaddingRight = UDim.new(0, 12)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = card

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 2)
title.BackgroundTransparency = 1
title.Text = titleText
title.TextColor3 = theme.Text
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = card

local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, 0, 0, 28)
content.Position = UDim2.new(0, 0, 0, 22)
content.BackgroundTransparency = 1
content.Text = contentText
content.TextColor3 = theme.SubText
content.TextSize = 12
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextXAlignment = Enum.TextXAlignment.Left
content.Parent = card

SpringTween(card, 0.45, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)

local timerBar = Instance.new("Frame")
timerBar.Size = UDim2.new(1, 0, 0, 3)
timerBar.Position = UDim2.new(0, 0, 1, -3)
timerBar.BackgroundColor3 = theme.Accent
timerBar.BorderSizePixel = 0
timerBar.Parent = card

Tween(timerBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
    Size = UDim2.new(0, 0, 0, 3)
})

task.delay(duration, function()
    if card and card.Parent then
        local exitTween = SpringTween(card, 0.35, {
            Position = UDim2.new(1, 360, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quart)

        if exitTween then
            exitTween.Completed:Connect(function() card:Destroy() end)
        else
            card:Destroy()
        end
    end
end)


end

-- STREAMING_CHUNK:Binding UI Component Engine with Spring & Ripple Animations...
local function RegisterElement(entry)
if entry then table.insert(GaphopUI.Elements, entry) end
end

local function BindElementMethods(TabObj, page, theme)
TabObj = TabObj or {}

function TabObj:makeButton(cfg)
    cfg = cfg or {}
    local btnName = cfg.Name or "Button"
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page
    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = btnName
    btn.TextColor3 = theme.Text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = card

    btn.MouseEnter:Connect(function() SpringTween(card, 0.2, {BackgroundColor3 = theme.CardHover}) end)
    btn.MouseLeave:Connect(function() SpringTween(card, 0.2, {BackgroundColor3 = theme.Card}) end)
    btn.MouseButton1Click:Connect(function(input)
        CreateRipple(card, input)
        SpringTween(card, 0.1, {Size = UDim2.new(1, -12, 0, 38)}).Completed:Connect(function()
            SpringTween(card, 0.15, {Size = UDim2.new(1, -6, 0, 42)})
        end)
        callback()
    end)
    RegisterElement({Type = "button", Card = card, Stroke = stroke, Button = btn, SearchText = btnName, Page = page})
end
TabObj.CreateButton = TabObj.makeButton
TabObj.AddButton = TabObj.makeButton

function TabObj:makeToggle(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Toggle"
    local state = cfg.CurrentValue or false
    local flag = cfg.Flag
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page
    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 44, 0, 22)
    switchBg.Position = UDim2.new(1, -54, 0.5, -11)
    switchBg.BackgroundColor3 = state and theme.ToggleOn or theme.ToggleOff
    switchBg.Text = ""
    switchBg.Parent = card
    CreateCorner(switchBg, 12)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = switchBg
    CreateCorner(knob, 10)

    switchBg.MouseButton1Click:Connect(function(input)
        CreateRipple(card, input)
        state = not state
        if flag then GaphopUI.Flags[flag] = state end
        SpringTween(switchBg, 0.25, {BackgroundColor3 = state and theme.ToggleOn or theme.ToggleOff})
        SpringTween(knob, 0.25, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, Enum.EasingStyle.Back)
        callback(state)
    end)
    if flag then GaphopUI.Flags[flag] = state end
    RegisterElement({Type = "toggle", Card = card, Stroke = stroke, Label = label, ToggleBg = switchBg, ToggleKnob = knob, ToggleState = state, SearchText = name, Page = page})
end
TabObj.CreateToggle = TabObj.makeToggle
TabObj.AddToggle = TabObj.makeToggle

function TabObj:makeSlider(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Slider"
    local range = cfg.Range or {0, 100}
    local minVal, maxVal = range[1] or 0, range[2] or 100
    local val = cfg.CurrentValue or minVal
    local suffix = cfg.Suffix or ""
    local flag = cfg.Flag
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 56)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = false
    card.Parent = page
    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 24)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 60, 0, 24)
    valLabel.Position = UDim2.new(1, -72, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(val) .. suffix
    valLabel.TextColor3 = theme.Accent
    valLabel.TextSize = 12
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = card

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -24, 0, 6)
    sliderTrack.Position = UDim2.new(0, 12, 0, 38)
    sliderTrack.BackgroundColor3 = theme.SliderBar
    sliderTrack.Parent = card
    CreateCorner(sliderTrack, 3)

    local initPercent = (val - minVal) / (maxVal - minVal)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(math.clamp(initPercent, 0, 1), 0, 1, 0)
    sliderFill.BackgroundColor3 = theme.Accent
    sliderFill.Parent = sliderTrack
    CreateCorner(sliderFill, 3)

    local dragging = false
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        local calculated = math.floor(minVal + (maxVal - minVal) * pos)
        SpringTween(sliderFill, 0.08, { Size = UDim2.new(pos, 0, 1, 0) }, Enum.EasingStyle.Sine)
        valLabel.Text = tostring(calculated) .. suffix
        if flag then GaphopUI.Flags[flag] = calculated end
        callback(calculated)
    end

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; UpdateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    RegisterElement({Type = "slider", Card = card, Stroke = stroke, Label = label, SliderTrack = sliderTrack, SliderFill = sliderFill, ValueLabel = valLabel, SearchText = name, Page = page})
end
TabObj.CreateSlider = TabObj.makeSlider
TabObj.AddSlider = TabObj.makeSlider

function TabObj:makeInput(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Input"
    local placeholder = cfg.PlaceholderText or "Type here..."
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page
    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 160, 0, 26)
    textBox.Position = UDim2.new(1, -172, 0.5, -13)
    textBox.BackgroundColor3 = theme.InputBackground
    textBox.Text = ""
    textBox.PlaceholderText = placeholder
    textBox.TextColor3 = theme.Text
    textBox.PlaceholderColor3 = theme.SubText
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.Parent = card
    CreateCorner(textBox, 6)
    local boxStroke = CreateStroke(textBox, theme.Border, 1, 0.4)

    textBox.Focused:Connect(function() SpringTween(boxStroke, 0.2, {Color = theme.Accent, Transparency = 0.1}) end)
    textBox.FocusLost:Connect(function() SpringTween(boxStroke, 0.2, {Color = theme.Border, Transparency = 0.4}); callback(textBox.Text) end)
    RegisterElement({Type = "input", Card = card, Stroke = stroke, Label = label, Input = textBox, SearchText = name, Page = page})
end
TabObj.CreateInput = TabObj.makeInput
TabObj.AddInput = TabObj.makeInput

function TabObj:makeDropdown(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Dropdown"
    local options = cfg.Options or {}
    local current = cfg.CurrentOption or options[1] or ""
    local flag = cfg.Flag
    local callback = cfg.Callback or function() end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = 0.3
    card.ClipsDescendants = true
    card.Parent = page
    local stroke = CreateStroke(card, theme.Border, 1, 0.6)
    CreateCorner(card, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 42)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card

    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0, 150, 0, 26)
    dropBtn.Position = UDim2.new(1, -162, 0, 8)
    dropBtn.BackgroundColor3 = theme.InputBackground
    dropBtn.Text = tostring(current) .. "   ▼"
    dropBtn.TextColor3 = theme.Text
    dropBtn.TextSize = 12
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.Parent = card
    CreateCorner(dropBtn, 6)

    local optionsContainer = Instance.new("Frame")
    optionsContainer.Size = UDim2.new(1, -24, 0, 0)
    optionsContainer.Position = UDim2.new(0, 12, 0, 40)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.ClipsDescendants = true
    optionsContainer.Parent = card
    
    local optLayout = Instance.new("UIListLayout")
    optLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optLayout.Padding = UDim.new(0, 4)
    optLayout.Parent = optionsContainer

    local isOpen = false
    local function RefreshDropdown()
        for _, child in ipairs(optionsContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in ipairs(options) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 24)
            btn.BackgroundColor3 = theme.InputBackground
            btn.Text = tostring(opt)
            btn.TextColor3 = theme.Text
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            btn.Parent = optionsContainer
            CreateCorner(btn, 4)
            
            btn.MouseButton1Click:Connect(function()
                isOpen = false
                current = opt
                dropBtn.Text = tostring(current) .. "   ▼"
                SpringTween(card, 0.35, {Size = UDim2.new(1, -6, 0, 42)}, Enum.EasingStyle.Quart)
                if flag then GaphopUI.Flags[flag] = current end
                callback(current)
            end)
        end
    end
    RefreshDropdown()

    dropBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(dropBtn, input)
        isOpen = not isOpen
        SpringTween(card, 0.35, {
            Size = UDim2.new(1, -6, 0, isOpen and (48 + #options * 28) or 42)
        }, Enum.EasingStyle.Quart)
    end)
    
    RegisterElement({Type = "dropdown", Card = card, Stroke = stroke, Label = label, DropdownButton = dropBtn, SearchText = name, Page = page})
end
TabObj.CreateDropdown = TabObj.makeDropdown
TabObj.AddDropdown = TabObj.makeDropdown


end

-- STREAMING_CHUNK:Constructing Key System Integration Module...
local function FetchWebsiteKey(url)
local success, response = pcall(function()
if type(syn) == "table" and syn.request then
return syn.request({Url = url, Method = "GET"}).Body
elseif type(http_request) == "function" then
return http_request({Url = url, Method = "GET"}).Body
elseif type(request) == "function" then
return request({Url = url, Method = "GET"}).Body
else
return game:HttpGet(url)
end
end)

if not success or not response then
    return nil
end

local jsonSuccess, decoded = pcall(function()
    return HttpService:JSONDecode(response)
end)

if jsonSuccess and type(decoded) == "table" then
    return decoded.key or decoded.password or decoded.pass or response
end

-- Return raw response, trimming empty spaces
return string.gsub(response, "^%s*(.-)%s*$", "%1")


end

local function CopyKeyLink(link)
local success = pcall(function()
if setclipboard then
setclipboard(link)
elseif toclipboard then
toclipboard(link)
else
error("No clipboard support")
end
end)
return success
end

function GaphopUI:CreateKeyWindow(cfg)
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

local keyModal = Instance.new("CanvasGroup")
keyModal.Size = UDim2.new(0, 420, 0, 260)
keyModal.Position = UDim2.fromScale(0.5, 0.45)
keyModal.AnchorPoint = Vector2.new(0.5, 0.5)
keyModal.BackgroundColor3 = theme.Background
keyModal.BackgroundTransparency = 0.1
keyModal.GroupTransparency = 1
keyModal.ZIndex = 500
keyModal.Parent = ScreenGui

CreateCorner(keyModal, 14)
CreateStroke(keyModal, theme.Border, 1.2, 0.3)
MakeDraggable(keyModal)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 20, 0, 15)
title.BackgroundTransparency = 1
title.Text = cfg.Title or "Key System"
title.TextColor3 = theme.Text
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = keyModal

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -40, 0, 40)
desc.Position = UDim2.new(0, 20, 0, 55)
desc.BackgroundTransparency = 1
desc.Text = cfg.Description
desc.TextColor3 = theme.SubText
desc.TextSize = 13
desc.Font = Enum.Font.Gotham
desc.TextWrapped = true
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.TextYAlignment = Enum.TextXAlignment.Top
desc.Parent = keyModal

local inputCard = Instance.new("Frame")
inputCard.Size = UDim2.new(1, -40, 0, 44)
inputCard.Position = UDim2.new(0, 20, 0, 105)
inputCard.BackgroundColor3 = theme.InputBackground
inputCard.Parent = keyModal
CreateCorner(inputCard, 8)
local inputStroke = CreateStroke(inputCard, theme.Border, 1, 0.5)

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, 0)
textBox.Position = UDim2.new(0, 10, 0, 0)
textBox.BackgroundTransparency = 1
textBox.PlaceholderText = "Enter your key here..."
textBox.Text = ""
textBox.TextColor3 = theme.Text
textBox.PlaceholderColor3 = theme.SubText
textBox.TextSize = 14
textBox.Font = Enum.Font.Gotham
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.Parent = inputCard
textBox.ClearTextOnFocus = false

textBox.Focused:Connect(function() SpringTween(inputStroke, 0.2, {Color = theme.Accent, Transparency = 0.1}) end)
textBox.FocusLost:Connect(function() SpringTween(inputStroke, 0.2, {Color = theme.Border, Transparency = 0.5}) end)

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.5, -25, 0, 40)
submitBtn.Position = UDim2.new(0, 20, 1, -65)
submitBtn.BackgroundColor3 = theme.Accent
submitBtn.Text = "Check Key"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 14
submitBtn.Parent = keyModal
CreateCorner(submitBtn, 8)

local getBtn = Instance.new("TextButton")
getBtn.Size = UDim2.new(0.5, -25, 0, 40)
getBtn.Position = UDim2.new(0.5, 5, 1, -65)
getBtn.BackgroundColor3 = theme.Card
getBtn.Text = "Get Key"
getBtn.TextColor3 = theme.Text
getBtn.Font = Enum.Font.GothamBold
getBtn.TextSize = 14
getBtn.Parent = keyModal
CreateCorner(getBtn, 8)
CreateStroke(getBtn, theme.Border, 1, 0.3)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -40, 0, 20)
statusLbl.Position = UDim2.new(0, 20, 0, 155)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = ""
statusLbl.TextColor3 = Color3.fromRGB(230, 60, 60)
statusLbl.TextSize = 12
statusLbl.Font = Enum.Font.GothamMedium
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = keyModal

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 15)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = GaphopUI.Icons.close or "x"
closeBtn.TextColor3 = theme.SubText
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = keyModal
closeBtn.MouseButton1Click:Connect(function()
    SpringTween(keyModal, 0.3, {Position = UDim2.fromScale(0.5, 0.5), GroupTransparency = 1})
    task.wait(0.3)
    keyModal:Destroy()
end)

Tween(keyModal, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)})

getBtn.MouseButton1Click:Connect(function(input)
    CreateRipple(getBtn, input)
    local copied = CopyKeyLink(cfg.Link)
    if copied then
        GaphopUI:Notify({Title = "Key System", Content = "✔ Link copied!", Duration = 3})
        getBtn.Text = "Copied!"
        task.delay(2, function() if getBtn then getBtn.Text = "Get Key" end end)
    else
        textBox.Text = cfg.Link
        statusLbl.TextColor3 = theme.SubText
        statusLbl.Text = "Please copy the link from the textbox above."
    end
end)

local checking = false
submitBtn.MouseButton1Click:Connect(function(input)
    if checking then return end
    checking = true
    CreateRipple(submitBtn, input)
    
    local inputKey = textBox.Text
    submitBtn.Text = "Checking..."
    statusLbl.Text = "Checking key..."
    statusLbl.TextColor3 = theme.SubText

    task.spawn(function()
        local expected = cfg.Pass
        if cfg.GrabFromSite then
            local fetched = FetchWebsiteKey(cfg.Link)
            if not fetched then
                statusLbl.Text = "Unable to contact key server."
                statusLbl.TextColor3 = Color3.fromRGB(230, 60, 60)
                submitBtn.Text = "Check Key"
                checking = false
                return
            end
            expected = fetched
        end

        if inputKey == expected then
            statusLbl.Text = "✔ Access Granted"
            statusLbl.TextColor3 = Color3.fromRGB(40, 200, 100)
            submitBtn.Text = "Success"
            task.wait(0.5)
            SpringTween(keyModal, 0.4, {GroupTransparency = 1, Position = UDim2.fromScale(0.5, 0.55)})
            task.wait(0.4)
            keyModal:Destroy()
            if cfg.OnSuccess then cfg.OnSuccess() end
        else
            statusLbl.Text = "❌ Wrong Key"
            statusLbl.TextColor3 = Color3.fromRGB(230, 60, 60)
            submitBtn.Text = "Check Key"
            
            local initPos = keyModal.Position
            for i = 1, 4 do
                keyModal.Position = initPos + UDim2.fromOffset(math.random(-5, 5), math.random(-5, 5))
                task.wait(0.05)
            end
            keyModal.Position = initPos
            checking = false
        end
    end)
end)


end

-- STREAMING_CHUNK:Architecting Main Window & Loader Sequence...
function GaphopUI:CreateWindow(cfg)
cfg = cfg or {}
local Name = cfg.Name or "GaphopUI"
local ShowText = cfg.ShowText or "V2"
local LoadingTitle = cfg.LoadingTitle or "GaphopUI Engine"
local LoadingSubtitle = cfg.LoadingSubtitle or "GaphopUI is loaded!"

local useKey = cfg.key == true
local grabKeyFromSite = cfg.grabkeyformsite == true
local keyDescription = cfg.description or "Please obtain a key from our website before using this script."
local keyLink = cfg.link or "https://example.com/getkey"
local keyPass = cfg.pass or "nokey"

local WindowObj = {}
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

-- Setup window instantly to allow immediate API calls, but keep it hidden
local window = Instance.new("Frame")
window.Name = "MainWindow"
window.Size = UDim2.new(0, 680, 0, 440)
window.Position = UDim2.fromScale(0.5, 0.5)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = theme.Background
window.BackgroundTransparency = 0.15
window.ClipsDescendants = true
window.Visible = false
window.Parent = ScreenGui
window:SetAttribute("NormalSize", window.Size)
GaphopUI.WindowInstance = window

CreateCorner(window, 12)
CreateStroke(window, theme.Border, 1, 0.3)

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = theme.Header
topBar.BorderSizePixel = 0
topBar.Parent = window
MakeDraggable(window, topBar)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 300, 1, 0)
titleLbl.Position = UDim2.new(0, 16, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = Name .. " <font color='#" .. Color3ToHex(theme.Accent) .. "'>" .. ShowText .. "</font>"
titleLbl.RichText = true
titleLbl.TextColor3 = theme.Text
titleLbl.TextSize = 16
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = topBar

local sideBar = Instance.new("Frame")
sideBar.Name = "SideBar"
sideBar.Size = UDim2.new(0, 160, 1, -40)
sideBar.Position = UDim2.new(0, 0, 0, 40)
sideBar.BackgroundColor3 = theme.Card
sideBar.BackgroundTransparency = 0.5
sideBar.BorderSizePixel = 0
sideBar.Parent = window

local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, 0, 1, -20)
tabContainer.Position = UDim2.new(0, 0, 0, 10)
tabContainer.BackgroundTransparency = 1
tabContainer.ScrollBarThickness = 0
tabContainer.Parent = sideBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabContainer

local tabPad = Instance.new("UIPadding")
tabPad.PaddingLeft = UDim.new(0, 10)
tabPad.PaddingRight = UDim.new(0, 10)
tabPad.Parent = tabContainer

local pageContainer = Instance.new("Frame")
pageContainer.Name = "PageContainer"
pageContainer.Size = UDim2.new(1, -160, 1, -40)
pageContainer.Position = UDim2.new(0, 160, 0, 40)
pageContainer.BackgroundTransparency = 1
pageContainer.Parent = window

local firstTab = true

function WindowObj:makeTab(cfgTab)
    cfgTab = cfgTab or {}
    local tabName = cfgTab.Name or "Tab"
    local iconId = cfgTab.Icon or "layers"

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundColor3 = theme.Accent
    tabBtn.BackgroundTransparency = firstTab and 0.1 or 1
    tabBtn.Text = ""
    tabBtn.Parent = tabContainer
    CreateCorner(tabBtn, 8)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 36, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = GaphopUI.Icons[iconId] or iconId
    iconLbl.TextColor3 = firstTab and Color3.fromRGB(255,255,255) or theme.SubText
    iconLbl.TextSize = 16
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.Parent = tabBtn

    local titleLblTab = Instance.new("TextLabel")
    titleLblTab.Size = UDim2.new(1, -36, 1, 0)
    titleLblTab.Position = UDim2.new(0, 36, 0, 0)
    titleLblTab.BackgroundTransparency = 1
    titleLblTab.Text = tabName
    titleLblTab.TextColor3 = firstTab and Color3.fromRGB(255,255,255) or theme.SubText
    titleLblTab.TextSize = 13
    titleLblTab.Font = Enum.Font.GothamMedium
    titleLblTab.TextXAlignment = Enum.TextXAlignment.Left
    titleLblTab.Parent = tabBtn

    local pageScroll = Instance.new("ScrollingFrame")
    pageScroll.Size = UDim2.new(1, 0, 1, 0)
    pageScroll.BackgroundTransparency = 1
    pageScroll.ScrollBarThickness = 2
    pageScroll.ScrollBarImageColor3 = theme.Border
    pageScroll.Visible = firstTab
    pageScroll.Parent = pageContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = pageScroll
    
    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop = UDim.new(0, 12)
    pagePad.PaddingLeft = UDim.new(0, 12)
    pagePad.PaddingRight = UDim.new(0, 12)
    pagePad.PaddingBottom = UDim.new(0, 12)
    pagePad.Parent = pageScroll

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pageScroll.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 24)
    end)

    tabBtn.MouseButton1Click:Connect(function(input)
        CreateRipple(tabBtn, input)
        for _, child in ipairs(tabContainer:GetChildren()) do
            if child:IsA("TextButton") then
                SpringTween(child, 0.2, {BackgroundTransparency = 1})
                child:FindFirstChild("TextLabel").TextColor3 = theme.SubText
                child:GetChildren()[2].TextColor3 = theme.SubText
            end
        end
        for _, page in ipairs(pageContainer:GetChildren()) do
            if page:IsA("ScrollingFrame") then page.Visible = false end
        end
        SpringTween(tabBtn, 0.3, {BackgroundTransparency = 0.1})
        iconLbl.TextColor3 = Color3.fromRGB(255,255,255)
        titleLblTab.TextColor3 = Color3.fromRGB(255,255,255)
        pageScroll.Visible = true
    end)

    firstTab = false
    local TabObj = {}
    BindElementMethods(TabObj, pageScroll, theme)
    return TabObj
end
WindowObj.CreateTab = WindowObj.makeTab
WindowObj.AddTab = WindowObj.makeTab

local function TriggerMainLoadingScreen()
    local loadingFrame = Instance.new("CanvasGroup")
    loadingFrame.Size = UDim2.fromOffset(300, 150)
    loadingFrame.Position = UDim2.fromScale(0.5, 0.5)
    loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingFrame.BackgroundColor3 = theme.Background
    loadingFrame.BackgroundTransparency = 0.1
    loadingFrame.GroupTransparency = 1
    loadingFrame.Parent = ScreenGui
    CreateCorner(loadingFrame, 12)
    CreateStroke(loadingFrame, theme.Border, 1, 0.5)

    local loadTitle = Instance.new("TextLabel")
    loadTitle.Size = UDim2.new(1, 0, 0, 30)
    loadTitle.Position = UDim2.new(0, 0, 0, 30)
    loadTitle.BackgroundTransparency = 1
    loadTitle.Text = LoadingTitle
    loadTitle.TextColor3 = theme.Text
    loadTitle.Font = Enum.Font.GothamBold
    loadTitle.TextSize = 18
    loadTitle.Parent = loadingFrame

    local loadSub = Instance.new("TextLabel")
    loadSub.Size = UDim2.new(1, 0, 0, 20)
    loadSub.Position = UDim2.new(0, 0, 0, 60)
    loadSub.BackgroundTransparency = 1
    loadSub.Text = LoadingSubtitle
    loadSub.TextColor3 = theme.SubText
    loadSub.Font = Enum.Font.Gotham
    loadSub.TextSize = 13
    loadSub.Parent = loadingFrame

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 240, 0, 6)
    barBg.Position = UDim2.new(0.5, -120, 0, 100)
    barBg.BackgroundColor3 = theme.Border
    barBg.Parent = loadingFrame
    CreateCorner(barBg, 3)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = theme.Accent
    barFill.Parent = barBg
    CreateCorner(barFill, 3)

    Tween(loadingFrame, TweenInfo.new(0.3), {GroupTransparency = 0})

    Tween(barFill, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 1, 0)}).Completed:Connect(function()
        SpringTween(loadingFrame, 0.3, {Size = UDim2.fromOffset(300, 0), GroupTransparency = 1})
        task.wait(0.3)
        loadingFrame:Destroy()

        window.Visible = true
        window.Size = UDim2.new(0, 680, 0, 0)
        SpringTween(window, 0.5, {Size = UDim2.new(0, 680, 0, 440)}, Enum.EasingStyle.Back)
    end)
end

if useKey then
    GaphopUI:CreateKeyWindow({
        Title = Name .. " " .. ShowText,
        Description = keyDescription,
        Link = keyLink,
        Pass = keyPass,
        GrabFromSite = grabKeyFromSite,
        OnSuccess = TriggerMainLoadingScreen
    })
else
    TriggerMainLoadingScreen()
end

return WindowObj


end

return GaphopUI
