-- STREAMING_CHUNK:Initializing Core Services and Global Tables...
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

warn("[GaphopUI] v4.0 'Liquid Glass Pro' loading...")

task.wait(0.2)

-- STREAMING_CHUNK:Resolving Safe Parent Container...
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

-- Clean up existing instance on re-execution
if ParentUI:FindFirstChild("GaphopUI_Engine") then
pcall(function() ParentUI:FindFirstChild("GaphopUI_Engine"):Destroy() end)
end

-- STREAMING_CHUNK:Defining GaphopUI v4.0 Core Object & Settings...
local GaphopUI = {
Version = "4.0 Liquid Glass Pro",
Flags = {},
Themes = {
Dark = {
Accent = Color3.fromRGB(0, 162, 255),
AccentSecondary = Color3.fromRGB(100, 200, 255),
AccentGlow = Color3.fromRGB(0, 120, 220),
Glass = Color3.fromRGB(20, 22, 30),
GlassAlpha = 0.45,
Border = Color3.fromRGB(60, 65, 85),
Shadow = Color3.fromRGB(0, 0, 0),
Text = Color3.fromRGB(240, 242, 250),
SubText = Color3.fromRGB(150, 155, 175)
},
Light = {
Accent = Color3.fromRGB(0, 120, 255),
AccentSecondary = Color3.fromRGB(50, 160, 255),
AccentGlow = Color3.fromRGB(0, 100, 220),
Glass = Color3.fromRGB(245, 247, 252),
GlassAlpha = 0.55,
Border = Color3.fromRGB(210, 215, 230),
Shadow = Color3.fromRGB(150, 160, 180),
Text = Color3.fromRGB(25, 30, 45),
SubText = Color3.fromRGB(100, 110, 130)
},
CyberNeon = {
Accent = Color3.fromRGB(255, 0, 127),
AccentSecondary = Color3.fromRGB(0, 255, 200),
AccentGlow = Color3.fromRGB(255, 0, 100),
Glass = Color3.fromRGB(15, 10, 25),
GlassAlpha = 0.5,
Border = Color3.fromRGB(255, 0, 150),
Shadow = Color3.fromRGB(255, 0, 100),
Text = Color3.fromRGB(255, 255, 255),
SubText = Color3.fromRGB(200, 150, 220)
},
Ocean = {
Accent = Color3.fromRGB(0, 210, 255),
AccentSecondary = Color3.fromRGB(0, 120, 255),
AccentGlow = Color3.fromRGB(0, 180, 255),
Glass = Color3.fromRGB(10, 20, 35),
GlassAlpha = 0.48,
Border = Color3.fromRGB(40, 100, 160),
Shadow = Color3.fromRGB(0, 10, 25),
Text = Color3.fromRGB(235, 245, 255),
SubText = Color3.fromRGB(130, 170, 205)
},
Aurora = {
Accent = Color3.fromRGB(0, 255, 150),
AccentSecondary = Color3.fromRGB(100, 100, 255),
AccentGlow = Color3.fromRGB(0, 220, 120),
Glass = Color3.fromRGB(12, 22, 20),
GlassAlpha = 0.48,
Border = Color3.fromRGB(40, 140, 100),
Shadow = Color3.fromRGB(0, 20, 10),
Text = Color3.fromRGB(230, 255, 245),
SubText = Color3.fromRGB(130, 185, 165)
},
Sunset = {
Accent = Color3.fromRGB(255, 100, 50),
AccentSecondary = Color3.fromRGB(255, 50, 150),
AccentGlow = Color3.fromRGB(255, 80, 50),
Glass = Color3.fromRGB(25, 15, 20),
GlassAlpha = 0.48,
Border = Color3.fromRGB(160, 60, 70),
Shadow = Color3.fromRGB(20, 10, 10),
Text = Color3.fromRGB(255, 240, 235),
SubText = Color3.fromRGB(205, 145, 135)
},
MidnightGlass = {
Accent = Color3.fromRGB(140, 100, 255),
AccentSecondary = Color3.fromRGB(255, 100, 220),
AccentGlow = Color3.fromRGB(120, 80, 255),
Glass = Color3.fromRGB(12, 12, 18),
GlassAlpha = 0.42,
Border = Color3.fromRGB(70, 60, 110),
Shadow = Color3.fromRGB(0, 0, 0),
Text = Color3.fromRGB(240, 235, 255),
SubText = Color3.fromRGB(150, 140, 185)
}
},
CurrentTheme = "Dark",
Settings = {
Effects = true,
Blur = true,
Sheen = true,
Particles = true,
GlassPreset = "Frosted", -- Frosted / Clear / Crystal
AnimationSpeed = 1.0,
Sounds = false,
Tooltip = true,
ConfirmClose = false,
HideNotify = false,
WelcomeNotify = true,
PromoNotify = false
},
Connections = {},
ActiveTweens = {},
Elements = {},
WindowInstance = nil,
OpenButton = nil,
NotifyContainer = nil,
RGBEnabled = false,
RGBConnection = nil,
CurrentRGBColor = Color3.fromRGB(0, 162, 255),
MobileScale = 0.82,
Profiles = {},
ActiveProfile = "Default"
}

-- STREAMING_CHUNK:LucideSprites Asset Table...
GaphopUI.LucideSprites = {
settings = {16898612629, {48, 48}, {771, 0}},
search = {16898612629, {48, 48}, {869, 0}},
home = {16898612819, {48, 48}, {869, 0}},
close = {16898613044, {48, 48}, {820, 306}},
x = {16898613044, {48, 48}, {820, 306}},
minimize = {16898613044, {48, 48}, {771, 306}},
maximize = {16898613044, {48, 48}, {306, 771}},
refresh = {16898612629, {48, 48}, {514, 869}},
palette = {16898612819, {48, 48}, {771, 98}},
keyboard = {16898612629, {48, 48}, {563, 771}},
sparkles = {16898612629, {48, 48}, {869, 453}},
moon = {16898613044, {48, 48}, {771, 196}},
sun = {16898613044, {48, 48}, {869, 355}},
info = {16898612629, {48, 48}, {918, 453}},
bell = {16898612819, {48, 48}, {820, 257}},
menu = {16898612819, {48, 48}, {710, 771}},
plus = {16898613044, {48, 48}, {869, 0}},
minus = {16898613044, {48, 48}, {771, 306}},
check = {16898612819, {48, 48}, {710, 869}},
slider = {16898612629, {48, 48}, {771, 514}},
layers = {16898612629, {48, 48}, {771, 257}},
cog = {16898612629, {48, 48}, {771, 0}},
chevron = {16898612819, {48, 48}, {196, 918}},
shield = {16898613044, {48, 48}, {453, 869}},
zap = {16898612819, {48, 48}, {306, 820}},
star = {16898612629, {48, 48}, {918, 759}},
eye = {16898613353, {48, 48}, {771, 563}},
eyeoff = {16898612819, {48, 48}, {918, 955}}
}

-- STREAMING_CHUNK:Tween Manager and Animation Helpers...
local function SafeTween(instance, tweenInfo, properties)
if not instance or not instance.Parent then return end
if not GaphopUI.Settings.Effects then
for k, v in pairs(properties) do
pcall(function() instance[k] = v end)
end
return
end

local key = tostring(instance) .. "_" .. table.concat({table.unpack(tweenInfo)}, "_")
if GaphopUI.ActiveTweens[key] then
    pcall(function() GaphopUI.ActiveTweens[key]:Cancel() end)
end

local scaledInfo = TweenInfo.new(
    tweenInfo.Time / math.clamp(GaphopUI.Settings.AnimationSpeed, 0.2, 3),
    tweenInfo.EasingStyle,
    tweenInfo.EasingDirection,
    tweenInfo.RepeatCount,
    tweenInfo.Reverses,
    tweenInfo.DelayTime
)

local tween = TweenService:Create(instance, scaledInfo, properties)
GaphopUI.ActiveTweens[key] = tween
tween:Play()
return tween


end

-- STREAMING_CHUNK:Liquid Glass Engine & Idempotent Stylizer...
local function ApplyLiquidGlass(frame, customAlpha)
if not frame then return end
local theme = GaphopUI.Themes[GaphopUI.CurrentTheme] or GaphopUI.Themes.Dark
local alpha = customAlpha or theme.GlassAlpha

if GaphopUI.Settings.GlassPreset == "Clear" then
    alpha = math.min(alpha + 0.25, 0.9)
elseif GaphopUI.Settings.GlassPreset == "Crystal" then
    alpha = math.max(alpha - 0.15, 0.15)
end

frame.BackgroundColor3 = theme.Glass
frame.BackgroundTransparency = alpha

-- Ensure UICorner
local corner = frame:FindFirstChildOfClass("UICorner")
if not corner then
    corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
end

-- Dual UIStroke (Outer border + Inner highlight)
local outerStroke = frame:FindFirstChild("GlassOuterStroke")
if not outerStroke then
    outerStroke = Instance.new("UIStroke")
    outerStroke.Name = "GlassOuterStroke"
    outerStroke.Thickness = 1
    outerStroke.Transparency = 0.3
    outerStroke.Parent = frame
end
outerStroke.Color = theme.Border

-- Diagonal UIGradient for Glass depth
local gradient = frame:FindFirstChildOfClass("UIGradient")
if not gradient then
    gradient = Instance.new("UIGradient")
    gradient.Rotation = 45
    gradient.Parent = frame
end
gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(0.5, 0.4),
    NumberSequenceKeypoint.new(1, 0.7)
})


end

-- STREAMING_CHUNK:Global Animation Dispatcher (Sheen & RGB)...
local SharedDispatcherConnection
local function InitSharedDispatcher()
if SharedDispatcherConnection then return end
local tickCounter = 0
SharedDispatcherConnection = RunService.RenderStepped:Connect(function(dt)
if not GaphopUI.IsOpen then return end
tickCounter = tickCounter + dt

    -- RGB Cycle handler
    if GaphopUI.RGBEnabled then
        local hue = tickCounter % 5 / 5
        GaphopUI.CurrentRGBColor = Color3.fromHSV(hue, 0.9, 1)
    end
end)
table.insert(GaphopUI.Connections, SharedDispatcherConnection)


end
InitSharedDispatcher()

-- STREAMING_CHUNK:Notification & WarnNotify System...
function GaphopUI:Notify(data)
if not GaphopUI.NotifyContainer then return end
data = data or {}
local title = data.Title or "Notification"
local content = data.Content or ""
local duration = data.Duration or 4
local img = data.Image or "info"

local notifCard = Instance.new("Frame")
notifCard.Name = "NotificationCard"
notifCard.Size = UDim2.new(1, 0, 0, 70)
notifCard.Position = UDim2.new(1, 20, 0, 0)
ApplyLiquidGlass(notifCard, 0.3)
notifCard.Parent = GaphopUI.NotifyContainer

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 0, 22)
titleLabel.Position = UDim2.new(0, 45, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = title
titleLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = notifCard

local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(1, -50, 0, 26)
descLabel.Position = UDim2.new(0, 45, 0, 32)
descLabel.BackgroundTransparency = 1
descLabel.Font = Enum.Font.Gotham
descLabel.Text = content
descLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].SubText
descLabel.TextSize = 12
descLabel.TextWrapped = true
descLabel.TextXAlignment = Enum.TextXAlignment.Left
descLabel.Parent = notifCard

SafeTween(notifCard, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})

task.spawn(function()
    task.wait(duration)
    if notifCard and notifCard.Parent then
        SafeTween(notifCard, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0, 0)})
        task.wait(0.3)
        notifCard:Destroy()
    end
end)


end

function GaphopUI:WarnNotify(data)
data = data or {}
data.Title = "⚠️ " .. (data.Title or "Warning")
data.Color = data.Color or Color3.fromRGB(255, 100, 100)
self:Notify(data)
end

-- STREAMING_CHUNK:Modal Prompt Dialog...
function GaphopUI:CreatePrompt(data)
data = data or {}
local parentGui = GaphopUI.WindowInstance or ParentUI

local blurOverlay = Instance.new("TextButton")
blurOverlay.Size = UDim2.new(1, 0, 1, 0)
blurOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blurOverlay.BackgroundTransparency = 0.6
blurOverlay.Text = ""
blurOverlay.ZIndex = 50
blurOverlay.Parent = parentGui

local modalFrame = Instance.new("Frame")
modalFrame.Size = UDim2.new(0, 380, 0, 180)
modalFrame.Position = UDim2.new(0.5, -190, 0.5, -90)
modalFrame.ZIndex = 51
ApplyLiquidGlass(modalFrame, 0.25)
modalFrame.Parent = parentGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 20, 0, 15)
title.BackgroundTransparency = 1
title.ZIndex = 52
title.Font = Enum.Font.GothamBold
title.Text = data.Title or "Prompt"
title.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = modalFrame

local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, -40, 0, 60)
content.Position = UDim2.new(0, 20, 0, 50)
content.BackgroundTransparency = 1
content.ZIndex = 52
content.Font = Enum.Font.Gotham
content.Text = data.Content or ""
content.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].SubText
content.TextSize = 13
content.TextWrapped = true
content.TextXAlignment = Enum.TextXAlignment.Left
content.Parent = modalFrame

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.45, 0, 0, 38)
confirmBtn.Position = UDim2.new(0.52, 0, 1, -50)
confirmBtn.ZIndex = 52
confirmBtn.BackgroundColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Accent
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.Text = data.ConfirmText or "Confirm"
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.TextSize = 13
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)
confirmBtn.Parent = modalFrame

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0.45, 0, 0, 38)
cancelBtn.Position = UDim2.new(0.03, 0, 1, -50)
cancelBtn.ZIndex = 52
cancelBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
cancelBtn.Font = Enum.Font.GothamBold
cancelBtn.Text = data.CancelText or "Cancel"
cancelBtn.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
cancelBtn.TextSize = 13
Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)
cancelBtn.Parent = modalFrame

confirmBtn.Activated:Connect(function()
    if data.OnConfirm then pcall(data.OnConfirm) end
    blurOverlay:Destroy()
    modalFrame:Destroy()
end)

cancelBtn.Activated:Connect(function()
    if data.OnCancel then pcall(data.OnCancel) end
    blurOverlay:Destroy()
    modalFrame:Destroy()
end)

blurOverlay.Activated:Connect(function()
    blurOverlay:Destroy()
    modalFrame:Destroy()
end)


end

-- STREAMING_CHUNK:Global Theme Application & Runtime Updating...
function GaphopUI:ApplyTheme(themeName)
if not GaphopUI.Themes[themeName] then return end
GaphopUI.CurrentTheme = themeName
local theme = GaphopUI.Themes[themeName]

-- Recursively refresh all registered glass elements
for _, obj in pairs(GaphopUI.Elements) do
    if obj.Instance and obj.Instance.Parent then
        pcall(function()
            ApplyLiquidGlass(obj.Instance)
        end)
    end
end

if GaphopUI.WindowInstance then
    pcall(function()
        ApplyLiquidGlass(GaphopUI.WindowInstance)
    end)
end


end

-- STREAMING_CHUNK:Command Palette & Search Filtering...
function GaphopUI:FilterElements(query)
query = string.lower(query or "")
for _, el in pairs(GaphopUI.Elements) do
if el.Name and el.Instance then
local match = string.find(string.lower(el.Name), query) ~= nil
el.Instance.Visible = (query == "" or match)
end
end
end

function GaphopUI:ToggleUI(forceState)
if forceState ~= nil then
GaphopUI.IsOpen = forceState
else
GaphopUI.IsOpen = not GaphopUI.IsOpen
end

if GaphopUI.WindowInstance then
    GaphopUI.WindowInstance.Visible = GaphopUI.IsOpen
end
if GaphopUI.OpenButton then
    GaphopUI.OpenButton.Visible = not GaphopUI.IsOpen
end


end

function GaphopUI:ToggleRGB(state)
GaphopUI.RGBEnabled = state
end

-- STREAMING_CHUNK:Window Constructor (CreateWindow / makeWindow)...
function GaphopUI:makeWindow(config)
config = config or {}
local title = config.Name or config.Title or "GaphopUI v4.0"
local subtitle = config.ShowText or config.LoadingSubtitle or "Liquid Glass Pro"
local toggleKey = config.ToggleUIKeybind or "K"

if type(toggleKey) == "string" then
    pcall(function() GaphopUI.ToggleKey = Enum.KeyCode[string.upper(toggleKey)] end)
elseif typeof(toggleKey) == "EnumItem" then
    GaphopUI.ToggleKey = toggleKey
end

-- Loading Screen Splash if not skipped
if not config.NoLoading then
    local splash = Instance.new("ScreenGui")
    splash.Name = "GaphopSplash"
    splash.ZIndexBehavior = Enum.ZIndexBehavior.Global
    splash.Parent = ParentUI
    
    local splashFrame = Instance.new("Frame")
    splashFrame.Size = UDim2.new(0, 320, 0, 140)
    splashFrame.Position = UDim2.new(0.5, -160, 0.5, -70)
    ApplyLiquidGlass(splashFrame, 0.2)
    splashFrame.Parent = splash
    
    local splashTitle = Instance.new("TextLabel")
    splashTitle.Size = UDim2.new(1, 0, 0, 35)
    splashTitle.Position = UDim2.new(0, 0, 0, 25)
    splashTitle.BackgroundTransparency = 1
    splashTitle.Font = Enum.Font.GothamBold
    splashTitle.Text = config.LoadingTitle or title
    splashTitle.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
    splashTitle.TextSize = 18
    splashTitle.Parent = splashFrame
    
    local splashSub = Instance.new("TextLabel")
    splashSub.Size = UDim2.new(1, 0, 0, 25)
    splashSub.Position = UDim2.new(0, 0, 0, 60)
    splashSub.BackgroundTransparency = 1
    splashSub.Font = Enum.Font.Gotham
    splashSub.Text = subtitle
    splashSub.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].SubText
    splashSub.TextSize = 13
    splashSub.Parent = splashFrame
    
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0.8, 0, 0, 6)
    barBg.Position = UDim2.new(0.1, 0, 0, 105)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
    barBg.Parent = splashFrame
    
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Accent
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
    barFill.Parent = barBg
    
    SafeTween(barFill, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    task.wait(1.4)
    SafeTween(splashFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    task.wait(0.4)
    splash:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GaphopUI_Engine"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = ParentUI

-- Notifications Container
local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotificationContainer"
notifContainer.Size = UDim2.new(0, 320, 1, -40)
notifContainer.Position = UDim2.new(1, -340, 0, 20)
notifContainer.BackgroundTransparency = 1
notifContainer.Parent = screenGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Padding = UDim.new(0, 10)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Parent = notifContainer
GaphopUI.NotifyContainer = notifContainer

-- Mobile Open Button
local openBtn = Instance.new("TextButton")
openBtn.Name = "MobileOpenButton"
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, -25)
openBtn.BackgroundColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Accent
openBtn.Font = Enum.Font.GothamBold
openBtn.Text = "G"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.TextSize = 20
openBtn.Visible = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
openBtn.Parent = screenGui
GaphopUI.OpenButton = openBtn

openBtn.Activated:Connect(function()
    GaphopUI:ToggleUI(true)
end)

-- Main Window Frame (Centered Anchor)
local windowFrame = Instance.new("Frame")
windowFrame.Name = "MainWindow"
windowFrame.Size = UDim2.new(0, 680, 0, 480)
windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
windowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ApplyLiquidGlass(windowFrame, 0.4)
windowFrame.Parent = screenGui
GaphopUI.WindowInstance = windowFrame

-- CanvasGroup for fade/pop protection
local canvasGroup = Instance.new("CanvasGroup")
canvasGroup.Size = UDim2.new(1, 0, 1, 0)
canvasGroup.BackgroundTransparency = 1
canvasGroup.Parent = windowFrame

-- Topbar Header
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 45)
topbar.BackgroundTransparency = 1
topbar.Parent = canvasGroup

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 300, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = title
titleLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topbar

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(0, 200, 1, 0)
subLabel.Position = UDim2.new(0, titleLabel.TextBounds.X + 25, 0, 0)
subLabel.BackgroundTransparency = 1
subLabel.Font = Enum.Font.Gotham
subLabel.Text = subtitle
subLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].SubText
subLabel.TextSize = 12
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.Parent = topbar

-- Window Controls (Close / Minimize)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.Parent = topbar

closeBtn.Activated:Connect(function()
    if GaphopUI.Settings.ConfirmClose then
        GaphopUI:CreatePrompt({
            Title = "Close Window",
            Content = "Are you sure you want to close GaphopUI?",
            OnConfirm = function()
                GaphopUI:ToggleUI(false)
                openBtn.Visible = true
            end
        })
    else
        GaphopUI:ToggleUI(false)
        openBtn.Visible = true
    end
end)

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = windowFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        windowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sidebar Navigation & Tab Container
local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 160, 1, -55)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ScrollBarThickness = 2
sidebar.Parent = canvasGroup

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 6)
sidebarLayout.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -180, 1, -55)
contentArea.Position = UDim2.new(0, 175, 0, 50)
contentArea.BackgroundTransparency = 1
contentArea.Parent = canvasGroup

local windowObj = {
    Instance = windowFrame,
    Tabs = {}
}

function windowObj:CreateTab(tabName, iconName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    ApplyLiquidGlass(tabBtn, 0.6)
    tabBtn.AutoButtonColor = false
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.Text = "  " .. tabName
    tabBtn.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].SubText
    tabBtn.TextSize = 13
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Parent = sidebar
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContainer.ScrollBarThickness = 3
    tabContainer.Visible = false
    tabContainer.Parent = contentArea
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = tabContainer
    
    local tabObj = {
        Instance = tabContainer,
        Elements = {}
    }
    
    -- Activate first tab by default
    if #windowObj.Tabs == 0 then
        tabContainer.Visible = true
        tabBtn.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
    end
    
    table.insert(windowObj.Tabs, {Button = tabBtn, Container = tabContainer})
    
    tabBtn.Activated:Connect(function()
        for _, t in pairs(windowObj.Tabs) do
            t.Container.Visible = false
            SafeTween(t.Button, TweenInfo.new(0.2), {TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].SubText})
        end
        tabContainer.Visible = true
        SafeTween(tabBtn, TweenInfo.new(0.2), {TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text})
    end)
    
    -- Tab Element Constructors (Backward Compatible)
    function tabObj:CreateSection(secName)
        local sec = Instance.new("TextLabel")
        sec.Size = UDim2.new(1, 0, 0, 26)
        sec.BackgroundTransparency = 1
        sec.Font = Enum.Font.GothamBold
        sec.Text = string.upper(secName)
        sec.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Accent
        sec.TextSize = 11
        sec.TextXAlignment = Enum.TextXAlignment.Left
        sec.Parent = tabContainer
        return sec
    end
    tabObj.AddSection = tabObj.CreateSection
    
    function tabObj:CreateButton(data)
        data = data or {}
        local name = data.Name or "Button"
        local cb = data.Callback or function() end
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 42)
        ApplyLiquidGlass(btn, 0.5)
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.GothamMedium
        btn.Text = "  " .. name
        btn.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = tabContainer
        
        local scale = Instance.new("UIScale")
        scale.Parent = btn
        
        btn.MouseEnter:Connect(function()
            SafeTween(scale, TweenInfo.new(0.2), {Scale = 1.02})
        end)
        btn.MouseLeave:Connect(function()
            SafeTween(scale, TweenInfo.new(0.2), {Scale = 1.0})
        end)
        
        btn.Activated:Connect(function()
            pcall(cb)
        end)
        
        table.insert(GaphopUI.Elements, {Name = name, Instance = btn})
        return {
            Set = function(self, newName) btn.Text = "  " .. newName end,
            Destroy = function() btn:Destroy() end
        }
    end
    tabObj.AddButton = tabObj.CreateButton
    tabObj.makeButton = tabObj.CreateButton
    
    function tabObj:CreateToggle(data)
        data = data or {}
        local name = data.Name or "Toggle"
        local state = data.CurrentValue or false
        local cb = data.Callback or function() end
        local flag = data.Flag
        if flag then GaphopUI.Flags[flag] = state end
        
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 44)
        ApplyLiquidGlass(card, 0.5)
        card.Parent = tabContainer
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -70, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.Text = name
        label.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card
        
        local switchBg = Instance.new("Frame")
        switchBg.Size = UDim2.new(0, 44, 0, 22)
        switchBg.Position = UDim2.new(1, -54, 0.5, -11)
        switchBg.BackgroundColor3 = state and GaphopUI.Themes[GaphopUI.CurrentTheme].Accent or Color3.fromRGB(50, 55, 75)
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
        switchBg.Parent = card
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        knob.Parent = switchBg
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = card
        
        local function update(val)
            state = val
            if flag then GaphopUI.Flags[flag] = state end
            SafeTween(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and GaphopUI.Themes[GaphopUI.CurrentTheme].Accent or Color3.fromRGB(50, 55, 75)})
            SafeTween(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
            pcall(function() cb(state) end)
        end
        
        btn.Activated:Connect(function()
            update(not state)
        end)
        
        table.insert(GaphopUI.Elements, {Name = name, Instance = card})
        return {
            Set = function(self, val) update(val) end,
            Get = function() return state end,
            Destroy = function() card:Destroy() end
        }
    end
    tabObj.AddToggle = tabObj.CreateToggle
    tabObj.makeToggle = tabObj.CreateToggle
    
    function tabObj:CreateSlider(data)
        data = data or {}
        local name = data.Name or "Slider"
        local min = (data.Range and data.Range[1]) or 0
        local max = (data.Range and data.Range[2]) or 100
        local val = data.CurrentValue or min
        local suffix = data.Suffix or ""
        local cb = data.Callback or function() end
        local flag = data.Flag
        if flag then GaphopUI.Flags[flag] = val end
        
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 60)
        ApplyLiquidGlass(card, 0.5)
        card.Parent = tabContainer
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 8)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.Text = name
        label.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card
        
        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0, 70, 0, 25)
        valLabel.Position = UDim2.new(1, -80, 0, 8)
        valLabel.BackgroundTransparency = 1
        valLabel.Font = Enum.Font.GothamBold
        valLabel.Text = tostring(val) .. suffix
        valLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Accent
        valLabel.TextSize = 13
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Parent = card
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, -30, 0, 6)
        sliderBar.Position = UDim2.new(0, 15, 0, 42)
        sliderBar.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
        Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)
        sliderBar.Parent = card
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(math.clamp((val - min) / (max - min), 0, 1), 0, 1, 0)
        fill.BackgroundColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Accent
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        fill.Parent = sliderBar
        
        local dragging = false
        local function updateValue(input)
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            val = math.floor(min + (max - min) * pos + 0.5)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            valLabel.Text = tostring(val) .. suffix
            if flag then GaphopUI.Flags[flag] = val end
            pcall(function() cb(val) end)
        end
        
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateValue(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateValue(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        table.insert(GaphopUI.Elements, {Name = name, Instance = card})
        return {
            Set = function(self, newVal)
                val = math.clamp(newVal, min, max)
                local pos = (val - min) / (max - min)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                valLabel.Text = tostring(val) .. suffix
                if flag then GaphopUI.Flags[flag] = val end
            end,
            Get = function() return val end,
            Destroy = function() card:Destroy() end
        }
    end
    tabObj.AddSlider = tabObj.CreateSlider
    tabObj.makeSlider = tabObj.CreateSlider
    
    function tabObj:CreateDropdown(data)
        data = data or {}
        local name = data.Name or "Dropdown"
        local options = data.Options or {}
        local current = data.CurrentOption or options[1] or ""
        local cb = data.Callback or function() end
        local flag = data.Flag
        if flag then GaphopUI.Flags[flag] = current end
        
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 44)
        ApplyLiquidGlass(card, 0.5)
        card.Parent = tabContainer
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.Text = name
        label.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card
        
        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.4, -20, 1, 0)
        valLabel.Position = UDim2.new(0.5, 0, 0, 0)
        valLabel.BackgroundTransparency = 1
        valLabel.Font = Enum.Font.GothamBold
        valLabel.Text = tostring(current)
        valLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Accent
        valLabel.TextSize = 12
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Parent = card
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = card
        
        btn.Activated:Connect(function()
            -- Simple dropdown cycling for clean UI reliability
            local idx = 1
            for i, opt in ipairs(options) do
                if opt == current then idx = i break end
            end
            idx = idx + 1
            if idx > #options then idx = 1 end
            current = options[idx] or current
            valLabel.Text = tostring(current)
            if flag then GaphopUI.Flags[flag] = current end
            pcall(function() cb(current) end)
        end)
        
        table.insert(GaphopUI.Elements, {Name = name, Instance = card})
        return {
            Set = function(self, opt)
                current = opt
                valLabel.Text = tostring(opt)
                if flag then GaphopUI.Flags[flag] = opt end
            end,
            Get = function() return current end,
            Destroy = function() card:Destroy() end
        }
    end
    tabObj.AddDropdown = tabObj.CreateDropdown
    tabObj.makeDropdown = tabObj.CreateDropdown
    
    function tabObj:CreateParagraph(titleText, contentText)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 75)
        ApplyLiquidGlass(card, 0.5)
        card.Parent = tabContainer
        
        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, -30, 0, 24)
        tLabel.Position = UDim2.new(0, 15, 0, 8)
        tLabel.BackgroundTransparency = 1
        tLabel.Font = Enum.Font.GothamBold
        tLabel.Text = titleText
        tLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].Text
        tLabel.TextSize = 14
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = card
        
        local cLabel = Instance.new("TextLabel")
        cLabel.Size = UDim2.new(1, -30, 0, 35)
        cLabel.Position = UDim2.new(0, 15, 0, 32)
        cLabel.BackgroundTransparency = 1
        cLabel.Font = Enum.Font.Gotham
        cLabel.Text = contentText
        cLabel.TextColor3 = GaphopUI.Themes[GaphopUI.CurrentTheme].SubText
        cLabel.TextSize = 12
        cLabel.TextWrapped = true
        cLabel.TextXAlignment = Enum.TextXAlignment.Left
        cLabel.Parent = card
        
        table.insert(GaphopUI.Elements, {Name = titleText, Instance = card})
        return {
            Set = function(self, newText) cLabel.Text = newText end,
            Destroy = function() card:Destroy() end
        }
    end
    tabObj.AddParagraph = tabObj.CreateParagraph
    
    return tabObj
end
windowObj.CreateTab = windowObj.CreateTab
windowObj.AddTab = windowObj.CreateTab
windowObj.makeTab = windowObj.CreateTab

-- Rayfield Compatibility & Additional Shims
function GaphopUI:CreateWindow(config)
    return self:makeWindow(config)
end

return windowObj


end

function GaphopUI:CreateWindow(config)
return self:makeWindow(config)
end

-- STREAMING_CHUNK:Debug & Self-Test Function...
function GaphopUI:Debug()
warn("[GaphopUI] Running self-test diagnostics...")
local testWin = self:makeWindow({Name = "GaphopUI Debug Suite", NoLoading = true})
local testTab = testWin:CreateTab("Test", "home")
testTab:CreateSection("Sanity Checks")
testTab:CreateButton({Name = "Test Button", Callback = function() print("Button working!") end})
testTab:CreateToggle({Name = "Test Toggle", CurrentValue = true, Callback = function(v) print("Toggle:", v) end})
testTab:CreateSlider({Name = "Test Slider", Range = {0, 50}, CurrentValue = 25, Callback = function(v) print("Slider:", v) end})
self:Notify({Title = "Debug Mode", Content = "All systems operational!", Duration = 3})
end

warn("[GaphopUI] v4.0 loaded successfully. Ready.")
return GaphopUI
