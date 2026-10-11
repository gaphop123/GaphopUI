--[[
    GaphopUI v4.0.0 – Liquid Glass Pro
    Fully backward-compatible with v3.3.0 + Rayfield Gen2 shim.
    Keep the original LucideSprites table from v3.3.0 exactly as-is below the header.
]]

-- ============================================================
-- 1. SERVICES
-- ============================================================
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")
local GuiService       = game:GetService("GuiService")
local TextService      = game:GetService("TextService")
local SoundService     = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

warn("[GaphopUI] v4.0.0 Liquid Glass Pro loading...")

-- ============================================================
-- 2. SAFE PARENT + RE-EXEC CLEANUP
-- ============================================================
local function GetSafeParent()
    if type(gethui) == "function" then
        local ok, res = pcall(gethui)
        if ok and res then return res end
    end
    if LocalPlayer then
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then pcall(function() pg = LocalPlayer:WaitForChild("PlayerGui", 3) end) end
        if pg then return pg end
    end
    if type(cloneref) == "function" then
        local ok, res = pcall(function() return cloneref(CoreGui) end)
        if ok and res then return res end
    end
    return CoreGui
end

local ParentUI = GetSafeParent()

-- Destroy previous instance completely (connections, blur, tasks)
do
    local old = ParentUI:FindFirstChild("GaphopUI_Engine")
    if old then
        pcall(function()
            if old:GetAttribute("GaphopDestroy") then
                -- already cleaned
            end
            old:Destroy()
        end)
    end
end

-- ============================================================
-- 3. CORE TABLE
-- ============================================================
local GaphopUI = {
    Version          = "4.0.0 Liquid Glass Pro",
    Flags            = {},
    Themes           = {},
    CurrentTheme     = "Dark",
    ToggleKey        = Enum.KeyCode.K,
    IsOpen           = true,
    IsMinimized      = false,
    Elements         = {},
    Connections      = {},
    WindowInstance   = nil,
    OpenButton       = nil,
    NotifyContainer  = nil,
    CallbackRegistry = {},
    RGBEnabled       = false,
    CurrentRGBColor  = Color3.fromRGB(0, 162, 255),
    MobileScale      = 0.82,
    UIScaleInstance  = nil,
    ConfigPath       = nil,
    WindowName       = "GaphopUI",
    AnimationToken   = 0,
    BlurEffect       = nil,
    FlagChanged      = {},
    HideNotifyShown  = false,
    ActiveTweens     = {},          -- tween manager
    DispatcherConn   = nil,
    ParticlePool     = {},
    RipplePool       = {},
    NotificationQueue = {},
    Settings = {
        Effects        = true,
        Blur           = true,
        Sheen          = true,
        Particles      = true,
        GlassPreset    = "Frosted", -- Frosted | Clear | Crystal
        AnimationSpeed = 1.0,
        Sounds         = false,
        ReducedMotion  = false,
    },
    Icons = { -- text fallback only
        settings="⚙", search="⌕", home="⌂", close="x", x="x",
        minimize="—", maximize="▢", refresh="↻", palette="◐",
        keyboard="⌨", sparkles="✦", moon="☾", sun="☀", info="ⓘ",
        bell="🔔", menu="☰", plus="+", minus="−", check="✓",
        slider="▭", layers="☰", cog="⚙", chevron="▾", shield="🛡",
        zap="⚡", star="★"
    },
}

-- ============================================================
-- 4. LUCIDE SPRITES – KEEP THE ORIGINAL TABLE FROM v3.3.0 HERE
-- ============================================================
--[[
    PASTE THE ENTIRE GaphopUI.LucideSprites = { ... } BLOCK
    FROM THE ATTACHED main.lua (v3.3.0) RIGHT HERE.
    Do not modify a single entry.
]]
GaphopUI.LucideSprites = GaphopUI.LucideSprites or {} -- placeholder; replace with full original table

-- ============================================================
-- 5. UTILS
-- ============================================================
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function SafePcall(fn, ...)
    local ok, a, b, c = pcall(fn, ...)
    if not ok then
        warn("[GaphopUI] pcall error:", a)
        return false
    end
    return true, a, b, c
end

local function EnsureFolder(name)
    if type(isfolder) == "function" and type(makefolder) == "function" then
        pcall(function()
            if not isfolder(name) then makefolder(name) end
        end)
    end
end

local function GetConfigPath(winName)
    local safe = (winName or "GaphopUI"):gsub("[^%w%-_]", "_")
    local folder = "GaphopUI/" .. safe
    return folder .. "/config.gpui.json", folder
end

local function Color3ToHex(c)
    return string.format("#%02X%02X%02X",
        math.floor(c.R * 255 + 0.5),
        math.floor(c.G * 255 + 0.5),
        math.floor(c.B * 255 + 0.5))
end

local function HexToColor3(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then return nil end
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    if r and g and b then
        return Color3.fromRGB(r, g, b)
    end
    return nil
end

local function DeepCopy(t)
    if type(t) ~= "table" then return t end
    local n = {}
    for k, v in pairs(t) do n[k] = DeepCopy(v) end
    return n
end

-- ============================================================
-- 6. TWEEN MANAGER (fixes a, b, e)
-- ============================================================
local TweenInfoCache = {}
local function GetTweenInfo(duration, style, dir)
    style = style or Enum.EasingStyle.Quint
    dir   = dir   or Enum.EasingDirection.Out
    local key = tostring(duration) .. tostring(style) .. tostring(dir)
    if not TweenInfoCache[key] then
        TweenInfoCache[key] = TweenInfo.new(duration, style, dir)
    end
    return TweenInfoCache[key]
end

local function CancelTween(inst, propGroup)
    local key = tostring(inst) .. (propGroup or "")
    local old = GaphopUI.ActiveTweens[key]
    if old then
        pcall(function() old:Cancel() end)
        GaphopUI.ActiveTweens[key] = nil
    end
end

local function TrackedTween(inst, duration, props, style, dir, propGroup)
    if not inst or not inst.Parent then return nil end
    if GaphopUI.Settings.ReducedMotion or not GaphopUI.Settings.Effects then
        for k, v in pairs(props) do
            pcall(function() inst[k] = v end)
        end
        return nil
    end
    local speed = math.clamp(GaphopUI.Settings.AnimationSpeed or 1, 0.5, 2)
    duration = duration / speed
    propGroup = propGroup or "default"
    CancelTween(inst, propGroup)
    local ti = GetTweenInfo(duration, style, dir)
    local tw = TweenService:Create(inst, ti, props)
    GaphopUI.ActiveTweens[tostring(inst) .. propGroup] = tw
    tw.Completed:Connect(function()
        GaphopUI.ActiveTweens[tostring(inst) .. propGroup] = nil
    end)
    tw:Play()
    return tw
end

local function Spring(inst, duration, props, style)
    return TrackedTween(inst, duration or 0.35, props, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "spring")
end

local function SoftSpring(inst, duration, props, style)
    -- Never use Back for size on layout cards
    return TrackedTween(inst, duration or 0.3, props, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out, "soft")
end

local function Snap(inst, props)
    for k, v in pairs(props) do
        pcall(function() inst[k] = v end)
    end
end

-- ============================================================
-- 7. CONNECTION REGISTRY
-- ============================================================
local function AddConnection(conn)
    if conn then
        table.insert(GaphopUI.Connections, conn)
    end
    return conn
end

local function DisconnectAll()
    for _, c in ipairs(GaphopUI.Connections) do
        pcall(function() c:Disconnect() end)
    end
    GaphopUI.Connections = {}
    if GaphopUI.DispatcherConn then
        pcall(function() GaphopUI.DispatcherConn:Disconnect() end)
        GaphopUI.DispatcherConn = nil
    end
end

-- ============================================================
-- 8. THEMES (all original + new)
-- ============================================================
local function MakeTheme(base)
    base.AccentSecondary = base.AccentSecondary or base.Accent
    base.AccentGlow      = base.AccentGlow or base.Accent
    base.Glass           = base.Glass or 0.18
    base.Border          = base.Border or Color3.fromRGB(60, 60, 70)
    base.Shadow          = base.Shadow or Color3.fromRGB(0, 0, 0)
    base.SubText         = base.SubText or Color3.fromRGB(160, 160, 170)
    base.Card            = base.Card or base.Background
    base.CardHover       = base.CardHover or base.Card
    base.Header          = base.Header or base.Background
    base.InputBackground = base.InputBackground or base.Card
    base.SliderBar       = base.SliderBar or Color3.fromRGB(40, 40, 50)
    return base
end

GaphopUI.Themes = {
    Dark = MakeTheme({
        Background = Color3.fromRGB(18, 18, 24),
        Card = Color3.fromRGB(28, 28, 36),
        CardHover = Color3.fromRGB(36, 36, 46),
        Header = Color3.fromRGB(22, 22, 30),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(150, 150, 160),
        Accent = Color3.fromRGB(0, 162, 255),
        AccentSecondary = Color3.fromRGB(0, 120, 220),
        AccentGlow = Color3.fromRGB(80, 180, 255),
        Border = Color3.fromRGB(55, 55, 70),
        Glass = 0.18,
        InputBackground = Color3.fromRGB(35, 35, 45),
        SliderBar = Color3.fromRGB(45, 45, 55),
    }),
    Midnight = MakeTheme({
        Background = Color3.fromRGB(10, 12, 22),
        Card = Color3.fromRGB(18, 22, 36),
        CardHover = Color3.fromRGB(26, 32, 50),
        Header = Color3.fromRGB(14, 16, 28),
        Text = Color3.fromRGB(230, 235, 255),
        SubText = Color3.fromRGB(140, 150, 180),
        Accent = Color3.fromRGB(120, 100, 255),
        AccentSecondary = Color3.fromRGB(80, 60, 220),
        Border = Color3.fromRGB(40, 45, 70),
        Glass = 0.20,
    }),
    CyberNeon = MakeTheme({
        Background = Color3.fromRGB(8, 10, 18),
        Card = Color3.fromRGB(14, 18, 32),
        CardHover = Color3.fromRGB(22, 28, 48),
        Header = Color3.fromRGB(10, 14, 26),
        Text = Color3.fromRGB(0, 255, 200),
        SubText = Color3.fromRGB(0, 180, 160),
        Accent = Color3.fromRGB(0, 255, 170),
        AccentSecondary = Color3.fromRGB(0, 200, 255),
        Border = Color3.fromRGB(0, 80, 70),
        Glass = 0.22,
    }),
    Emerald = MakeTheme({
        Background = Color3.fromRGB(12, 20, 16),
        Card = Color3.fromRGB(20, 32, 26),
        CardHover = Color3.fromRGB(28, 44, 36),
        Header = Color3.fromRGB(16, 26, 20),
        Text = Color3.fromRGB(220, 255, 230),
        SubText = Color3.fromRGB(140, 190, 160),
        Accent = Color3.fromRGB(0, 200, 120),
        AccentSecondary = Color3.fromRGB(0, 160, 90),
        Border = Color3.fromRGB(30, 70, 50),
        Glass = 0.18,
    }),
    Ocean = MakeTheme({
        Background = Color3.fromRGB(8, 16, 28),
        Card = Color3.fromRGB(14, 28, 46),
        CardHover = Color3.fromRGB(22, 40, 64),
        Header = Color3.fromRGB(10, 20, 36),
        Text = Color3.fromRGB(220, 240, 255),
        SubText = Color3.fromRGB(130, 170, 200),
        Accent = Color3.fromRGB(0, 180, 255),
        AccentSecondary = Color3.fromRGB(0, 120, 200),
        Border = Color3.fromRGB(30, 60, 90),
        Glass = 0.20,
    }),
    Light = MakeTheme({
        Background = Color3.fromRGB(245, 247, 252),
        Card = Color3.fromRGB(255, 255, 255),
        CardHover = Color3.fromRGB(240, 244, 255),
        Header = Color3.fromRGB(250, 252, 255),
        Text = Color3.fromRGB(30, 30, 40),
        SubText = Color3.fromRGB(90, 95, 110),
        Accent = Color3.fromRGB(0, 120, 255),
        AccentSecondary = Color3.fromRGB(0, 90, 210),
        Border = Color3.fromRGB(210, 215, 230),
        Glass = 0.12,
        InputBackground = Color3.fromRGB(235, 240, 250),
        SliderBar = Color3.fromRGB(220, 225, 240),
    }),
    Bloom = MakeTheme({
        Background = Color3.fromRGB(28, 12, 24),
        Card = Color3.fromRGB(42, 20, 38),
        CardHover = Color3.fromRGB(58, 28, 52),
        Header = Color3.fromRGB(34, 16, 30),
        Text = Color3.fromRGB(255, 230, 245),
        SubText = Color3.fromRGB(200, 150, 180),
        Accent = Color3.fromRGB(255, 80, 160),
        AccentSecondary = Color3.fromRGB(220, 40, 140),
        Border = Color3.fromRGB(80, 30, 60),
        Glass = 0.18,
    }),
    AmberGlow = MakeTheme({
        Background = Color3.fromRGB(22, 16, 8),
        Card = Color3.fromRGB(36, 26, 14),
        CardHover = Color3.fromRGB(50, 36, 20),
        Header = Color3.fromRGB(28, 20, 10),
        Text = Color3.fromRGB(255, 240, 210),
        SubText = Color3.fromRGB(200, 170, 120),
        Accent = Color3.fromRGB(255, 170, 40),
        AccentSecondary = Color3.fromRGB(230, 140, 20),
        Border = Color3.fromRGB(70, 50, 20),
        Glass = 0.18,
    }),
    Amethyst = MakeTheme({
        Background = Color3.fromRGB(18, 12, 28),
        Card = Color3.fromRGB(30, 20, 46),
        CardHover = Color3.fromRGB(42, 28, 64),
        Header = Color3.fromRGB(24, 16, 36),
        Text = Color3.fromRGB(240, 230, 255),
        SubText = Color3.fromRGB(170, 150, 200),
        Accent = Color3.fromRGB(170, 100, 255),
        AccentSecondary = Color3.fromRGB(130, 60, 220),
        Border = Color3.fromRGB(60, 40, 90),
        Glass = 0.20,
    }),
    Serenity = MakeTheme({
        Background = Color3.fromRGB(16, 22, 26),
        Card = Color3.fromRGB(26, 36, 42),
        CardHover = Color3.fromRGB(36, 48, 56),
        Header = Color3.fromRGB(20, 28, 34),
        Text = Color3.fromRGB(230, 245, 250),
        SubText = Color3.fromRGB(150, 180, 190),
        Accent = Color3.fromRGB(80, 200, 220),
        AccentSecondary = Color3.fromRGB(50, 160, 180),
        Border = Color3.fromRGB(40, 60, 70),
        Glass = 0.18,
    }),
    Crimson = MakeTheme({
        Background = Color3.fromRGB(22, 10, 12),
        Card = Color3.fromRGB(36, 16, 20),
        CardHover = Color3.fromRGB(50, 22, 28),
        Header = Color3.fromRGB(28, 12, 16),
        Text = Color3.fromRGB(255, 230, 230),
        SubText = Color3.fromRGB(200, 140, 140),
        Accent = Color3.fromRGB(255, 60, 80),
        AccentSecondary = Color3.fromRGB(220, 30, 50),
        Border = Color3.fromRGB(70, 25, 30),
        Glass = 0.18,
    }),
    Frost = MakeTheme({
        Background = Color3.fromRGB(14, 18, 26),
        Card = Color3.fromRGB(24, 30, 42),
        CardHover = Color3.fromRGB(34, 42, 58),
        Header = Color3.fromRGB(18, 24, 34),
        Text = Color3.fromRGB(230, 240, 255),
        SubText = Color3.fromRGB(150, 170, 200),
        Accent = Color3.fromRGB(140, 190, 255),
        AccentSecondary = Color3.fromRGB(100, 150, 230),
        Border = Color3.fromRGB(50, 65, 90),
        Glass = 0.22,
    }),
    Twilight = MakeTheme({
        Background = Color3.fromRGB(16, 12, 28),
        Card = Color3.fromRGB(28, 20, 46),
        CardHover = Color3.fromRGB(40, 28, 64),
        Header = Color3.fromRGB(22, 16, 36),
        Text = Color3.fromRGB(240, 230, 255),
        SubText = Color3.fromRGB(160, 140, 190),
        Accent = Color3.fromRGB(180, 100, 255),
        AccentSecondary = Color3.fromRGB(120, 60, 220),
        Border = Color3.fromRGB(55, 40, 80),
        Glass = 0.20,
    }),
    Forest = MakeTheme({
        Background = Color3.fromRGB(12, 18, 14),
        Card = Color3.fromRGB(20, 30, 24),
        CardHover = Color3.fromRGB(28, 42, 34),
        Header = Color3.fromRGB(16, 24, 18),
        Text = Color3.fromRGB(220, 245, 225),
        SubText = Color3.fromRGB(140, 180, 150),
        Accent = Color3.fromRGB(60, 180, 100),
        AccentSecondary = Color3.fromRGB(40, 140, 70),
        Border = Color3.fromRGB(30, 60, 40),
        Glass = 0.18,
    }),
    Sunset = MakeTheme({
        Background = Color3.fromRGB(24, 14, 12),
        Card = Color3.fromRGB(40, 24, 20),
        CardHover = Color3.fromRGB(56, 34, 28),
        Header = Color3.fromRGB(32, 18, 16),
        Text = Color3.fromRGB(255, 240, 230),
        SubText = Color3.fromRGB(210, 160, 140),
        Accent = Color3.fromRGB(255, 120, 60),
        AccentSecondary = Color3.fromRGB(255, 80, 40),
        Border = Color3.fromRGB(80, 40, 30),
        Glass = 0.18,
    }),
    Galaxy = MakeTheme({
        Background = Color3.fromRGB(10, 8, 20),
        Card = Color3.fromRGB(18, 14, 36),
        CardHover = Color3.fromRGB(28, 22, 54),
        Header = Color3.fromRGB(14, 10, 28),
        Text = Color3.fromRGB(230, 220, 255),
        SubText = Color3.fromRGB(150, 130, 190),
        Accent = Color3.fromRGB(160, 80, 255),
        AccentSecondary = Color3.fromRGB(100, 40, 220),
        Border = Color3.fromRGB(50, 30, 80),
        Glass = 0.22,
    }),
    Arctic = MakeTheme({
        Background = Color3.fromRGB(16, 20, 28),
        Card = Color3.fromRGB(26, 34, 46),
        CardHover = Color3.fromRGB(36, 46, 62),
        Header = Color3.fromRGB(20, 26, 36),
        Text = Color3.fromRGB(230, 245, 255),
        SubText = Color3.fromRGB(150, 180, 210),
        Accent = Color3.fromRGB(100, 200, 255),
        AccentSecondary = Color3.fromRGB(60, 150, 220),
        Border = Color3.fromRGB(40, 60, 80),
        Glass = 0.20,
    }),
    Obsidian = MakeTheme({
        Background = Color3.fromRGB(8, 8, 10),
        Card = Color3.fromRGB(16, 16, 20),
        CardHover = Color3.fromRGB(24, 24, 30),
        Header = Color3.fromRGB(12, 12, 14),
        Text = Color3.fromRGB(230, 230, 235),
        SubText = Color3.fromRGB(140, 140, 150),
        Accent = Color3.fromRGB(200, 200, 210),
        AccentSecondary = Color3.fromRGB(160, 160, 170),
        Border = Color3.fromRGB(40, 40, 50),
        Glass = 0.15,
    }),
    Rose = MakeTheme({
        Background = Color3.fromRGB(24, 12, 18),
        Card = Color3.fromRGB(40, 20, 30),
        CardHover = Color3.fromRGB(56, 28, 42),
        Header = Color3.fromRGB(32, 16, 24),
        Text = Color3.fromRGB(255, 235, 245),
        SubText = Color3.fromRGB(210, 150, 170),
        Accent = Color3.fromRGB(255, 100, 150),
        AccentSecondary = Color3.fromRGB(230, 60, 120),
        Border = Color3.fromRGB(80, 30, 50),
        Glass = 0.18,
    }),
    Mint = MakeTheme({
        Background = Color3.fromRGB(12, 22, 20),
        Card = Color3.fromRGB(20, 36, 34),
        CardHover = Color3.fromRGB(28, 50, 46),
        Header = Color3.fromRGB(16, 28, 26),
        Text = Color3.fromRGB(220, 255, 245),
        SubText = Color3.fromRGB(140, 190, 175),
        Accent = Color3.fromRGB(60, 220, 180),
        AccentSecondary = Color3.fromRGB(30, 180, 140),
        Border = Color3.fromRGB(30, 70, 60),
        Glass = 0.18,
    }),
    Carbon = MakeTheme({
        Background = Color3.fromRGB(14, 14, 16),
        Card = Color3.fromRGB(24, 24, 28),
        CardHover = Color3.fromRGB(34, 34, 40),
        Header = Color3.fromRGB(18, 18, 22),
        Text = Color3.fromRGB(235, 235, 240),
        SubText = Color3.fromRGB(150, 150, 160),
        Accent = Color3.fromRGB(100, 160, 255),
        AccentSecondary = Color3.fromRGB(70, 120, 220),
        Border = Color3.fromRGB(45, 45, 55),
        Glass = 0.16,
    }),
    Aurora = MakeTheme({
        Background = Color3.fromRGB(10, 14, 22),
        Card = Color3.fromRGB(16, 24, 38),
        CardHover = Color3.fromRGB(24, 36, 54),
        Header = Color3.fromRGB(12, 18, 30),
        Text = Color3.fromRGB(220, 245, 255),
        SubText = Color3.fromRGB(130, 180, 200),
        Accent = Color3.fromRGB(80, 255, 200),
        AccentSecondary = Color3.fromRGB(100, 160, 255),
        Border = Color3.fromRGB(30, 60, 80),
        Glass = 0.22,
    }),
    Sakura = MakeTheme({
        Background = Color3.fromRGB(28, 16, 22),
        Card = Color3.fromRGB(44, 26, 36),
        CardHover = Color3.fromRGB(60, 36, 50),
        Header = Color3.fromRGB(36, 20, 28),
        Text = Color3.fromRGB(255, 240, 250),
        SubText = Color3.fromRGB(210, 160, 180),
        Accent = Color3.fromRGB(255, 140, 180),
        AccentSecondary = Color3.fromRGB(255, 100, 150),
        Border = Color3.fromRGB(80, 40, 60),
        Glass = 0.18,
    }),
    Neon = MakeTheme({
        Background = Color3.fromRGB(6, 8, 14),
        Card = Color3.fromRGB(12, 16, 28),
        CardHover = Color3.fromRGB(20, 26, 44),
        Header = Color3.fromRGB(8, 12, 22),
        Text = Color3.fromRGB(0, 255, 255),
        SubText = Color3.fromRGB(0, 180, 200),
        Accent = Color3.fromRGB(0, 255, 180),
        AccentSecondary = Color3.fromRGB(180, 0, 255),
        Border = Color3.fromRGB(0, 70, 80),
        Glass = 0.24,
    }),
    -- New v4 themes
    ["Midnight Glass"] = MakeTheme({
        Background = Color3.fromRGB(6, 8, 16),
        Card = Color3.fromRGB(12, 16, 30),
        CardHover = Color3.fromRGB(20, 26, 48),
        Header = Color3.fromRGB(8, 12, 24),
        Text = Color3.fromRGB(230, 240, 255),
        SubText = Color3.fromRGB(130, 150, 190),
        Accent = Color3.fromRGB(100, 140, 255),
        AccentSecondary = Color3.fromRGB(60, 100, 220),
        Border = Color3.fromRGB(30, 40, 70),
        Glass = 0.28,
    }),
    ["Ocean Depth"] = MakeTheme({
        Background = Color3.fromRGB(4, 12, 22),
        Card = Color3.fromRGB(8, 22, 40),
        CardHover = Color3.fromRGB(14, 34, 58),
        Header = Color3.fromRGB(6, 16, 30),
        Text = Color3.fromRGB(210, 240, 255),
        SubText = Color3.fromRGB(100, 160, 200),
        Accent = Color3.fromRGB(0, 200, 255),
        AccentSecondary = Color3.fromRGB(0, 140, 200),
        Border = Color3.fromRGB(20, 50, 80),
        Glass = 0.26,
    }),
    ["Sunset Blaze"] = MakeTheme({
        Background = Color3.fromRGB(22, 10, 8),
        Card = Color3.fromRGB(38, 18, 14),
        CardHover = Color3.fromRGB(54, 26, 20),
        Header = Color3.fromRGB(30, 14, 10),
        Text = Color3.fromRGB(255, 240, 230),
        SubText = Color3.fromRGB(220, 160, 130),
        Accent = Color3.fromRGB(255, 100, 40),
        AccentSecondary = Color3.fromRGB(255, 60, 20),
        Border = Color3.fromRGB(80, 35, 20),
        Glass = 0.20,
    }),
    ["Aurora Borealis"] = MakeTheme({
        Background = Color3.fromRGB(6, 10, 18),
        Card = Color3.fromRGB(10, 18, 32),
        CardHover = Color3.fromRGB(16, 28, 48),
        Header = Color3.fromRGB(8, 14, 26),
        Text = Color3.fromRGB(220, 255, 250),
        SubText = Color3.fromRGB(120, 190, 180),
        Accent = Color3.fromRGB(80, 255, 200),
        AccentSecondary = Color3.fromRGB(120, 160, 255),
        Border = Color3.fromRGB(20, 50, 60),
        Glass = 0.25,
    }),
}

-- Glass intensity presets
local GlassPresets = {
    Frosted = { Glass = 0.22, StrokeT = 0.45, HighlightT = 0.65, SheenT = 0.85 },
    Clear   = { Glass = 0.35, StrokeT = 0.55, HighlightT = 0.75, SheenT = 0.90 },
    Crystal = { Glass = 0.12, StrokeT = 0.30, HighlightT = 0.50, SheenT = 0.70 },
}

-- ============================================================
-- 9. TRUE LIQUID GLASS (idempotent)
-- ============================================================
local function ClearGlassChildren(frame)
    for _, child in ipairs(frame:GetChildren()) do
        if child.Name:match("^GaphopGlass") or child.Name:match("^GaphopShadow") then
            child:Destroy()
        end
    end
end

local function ApplyLiquidGlass(frame, theme, opts)
    opts = opts or {}
    theme = theme or GaphopUI.Themes[GaphopUI.CurrentTheme]
    local preset = GlassPresets[GaphopUI.Settings.GlassPreset] or GlassPresets.Frosted

    -- Idempotent: remove previous glass layers
    ClearGlassChildren(frame)

    local transparency = opts.Transparency or theme.Glass or preset.Glass
    local radius = opts.Radius or 12
    local thickness = opts.Thickness or 1.4
    local strokeT = opts.StrokeTransparency or preset.StrokeT
    local borderColor = opts.BorderColor or theme.Accent
    local highlight = opts.Highlight ~= false
    local highlightHeight = opts.HighlightHeight or 1
    local highlightT = opts.HighlightTransparency or preset.HighlightT
    local innerGlow = opts.InnerGlow
    local sheen = opts.Sheen ~= false and GaphopUI.Settings.Sheen

    -- Base corner
    local corner = frame:FindFirstChildOfClass("UICorner")
    if not corner then
        corner = Instance.new("UICorner")
        corner.Parent = frame
    end
    corner.CornerRadius = UDim.new(0, radius)

    -- Outer stroke
    local stroke = frame:FindFirstChild("GaphopGlassStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = "GaphopGlassStroke"
        stroke.Parent = frame
    end
    stroke.Color = borderColor
    stroke.Thickness = thickness
    stroke.Transparency = strokeT
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Diagonal gradient fill
    local grad = frame:FindFirstChild("GaphopGlassGrad")
    if not grad then
        grad = Instance.new("UIGradient")
        grad.Name = "GaphopGlassGrad"
        grad.Parent = frame
    end
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.Card or theme.Background),
        ColorSequenceKeypoint.new(1, theme.Background),
    })
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, transparency * 0.6),
        NumberSequenceKeypoint.new(1, transparency),
    })
    grad.Rotation = 135

    -- Inner highlight (follows corners via UIStroke on a child)
    if highlight then
        local hl = Instance.new("Frame")
        hl.Name = "GaphopGlassHighlight"
        hl.Size = UDim2.new(1, -2, 0, highlightHeight + 2)
        hl.Position = UDim2.new(0, 1, 0, 1)
        hl.BackgroundColor3 = Color3.new(1, 1, 1)
        hl.BackgroundTransparency = highlightT
        hl.BorderSizePixel = 0
        hl.ZIndex = frame.ZIndex + 1
        hl.Parent = frame
        local hlCorner = Instance.new("UICorner")
        hlCorner.CornerRadius = UDim.new(0, math.max(0, radius - 1))
        hlCorner.Parent = hl
        local hlGrad = Instance.new("UIGradient")
        hlGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.4, 0.7),
            NumberSequenceKeypoint.new(1, 1),
        })
        hlGrad.Rotation = 90
        hlGrad.Parent = hl
    end

    -- Soft specular sheen (animated later by dispatcher)
    if sheen then
        local sheenFrame = Instance.new("Frame")
        sheenFrame.Name = "GaphopGlassSheen"
        sheenFrame.Size = UDim2.new(0.4, 0, 1.2, 0)
        sheenFrame.Position = UDim2.new(-0.5, 0, -0.1, 0)
        sheenFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        sheenFrame.BackgroundTransparency = 0.92
        sheenFrame.BorderSizePixel = 0
        sheenFrame.ZIndex = frame.ZIndex + 2
        sheenFrame.Parent = frame
        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, radius)
        sCorner.Parent = sheenFrame
        local sGrad = Instance.new("UIGradient")
        sGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.4, 0.7),
            NumberSequenceKeypoint.new(0.6, 0.7),
            NumberSequenceKeypoint.new(1, 1),
        })
        sGrad.Rotation = 20
        sGrad.Parent = sheenFrame
    end

    -- Multi-layer soft shadow (stacked frames)
    if opts.Shadow ~= false then
        for i = 1, 3 do
            local sh = Instance.new("Frame")
            sh.Name = "GaphopShadow" .. i
            sh.Size = UDim2.new(1, 4 + i * 2, 1, 4 + i * 2)
            sh.Position = UDim2.new(0, -2 - i, 0, -1 + i)
            sh.BackgroundColor3 = theme.Shadow or Color3.new(0, 0, 0)
            sh.BackgroundTransparency = 0.85 + i * 0.04
            sh.BorderSizePixel = 0
            sh.ZIndex = frame.ZIndex - 1
            sh.Parent = frame.Parent or frame
            local shCorner = Instance.new("UICorner")
            shCorner.CornerRadius = UDim.new(0, radius + i)
            shCorner.Parent = sh
            -- Reparent under frame for clipping if needed
            sh.Parent = frame
        end
    end

    return stroke
end

-- ============================================================
-- 10. SHARED DISPATCHER (sheen, RGB, particles)
-- ============================================================
local sheenOffset = 0
local rgbHue = 0
local particleTime = 0

local function StartDispatcher()
    if GaphopUI.DispatcherConn then return end
    GaphopUI.DispatcherConn = RunService.Heartbeat:Connect(function(dt)
        if not GaphopUI.IsOpen or GaphopUI.IsMinimized then return end
        if not GaphopUI.Settings.Effects then return end

        -- Sheen sweep
        if GaphopUI.Settings.Sheen and GaphopUI.WindowInstance then
            sheenOffset = (sheenOffset + dt * 0.15) % 1.6
            for _, sheen in ipairs(GaphopUI.WindowInstance:GetDescendants()) do
                if sheen.Name == "GaphopGlassSheen" then
                    sheen.Position = UDim2.new(-0.5 + sheenOffset, 0, -0.1, 0)
                end
            end
        end

        -- RGB
        if GaphopUI.RGBEnabled then
            rgbHue = (rgbHue + dt * 0.12) % 1
            GaphopUI.CurrentRGBColor = Color3.fromHSV(rgbHue, 0.7, 1)
            -- Apply to registered accent elements (lightweight)
            if GaphopUI.WindowInstance then
                local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]
                -- update a few key strokes / fills that hold accent
            end
        end

        -- Particles (very light)
        if GaphopUI.Settings.Particles and not IsMobile() then
            particleTime = particleTime + dt
            -- pool managed separately
        end
    end)
end

local function StopDispatcher()
    if GaphopUI.DispatcherConn then
        GaphopUI.DispatcherConn:Disconnect()
        GaphopUI.DispatcherConn = nil
    end
end

-- ============================================================
-- 11. ICON CREATOR (Lucide preferred)
-- ============================================================
function GaphopUI:CreateIcon(parent, iconName, size, color, opts)
    opts = opts or {}
    color = color or Color3.new(1, 1, 1)
    size = size or UDim2.fromOffset(16, 16)

    local key = tostring(iconName or ""):lower():gsub("%s", ""):gsub("-", "")
    local sprite = GaphopUI.LucideSprites[key]

    if sprite then
        local img = Instance.new("ImageLabel")
        img.Name = "GaphopIcon"
        img.Size = size
        img.Position = opts.Position or UDim2.fromOffset(0, 0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://" .. tostring(sprite[1])
        img.ImageRectSize = Vector2.new(sprite[2][1], sprite[2][2])
        img.ImageRectOffset = Vector2.new(sprite[3][1], sprite[3][2])
        img.ImageColor3 = color
        img.ScaleType = Enum.ScaleType.Fit
        img.Parent = parent
        return img
    end

    -- Text fallback
    local lbl = Instance.new("TextLabel")
    lbl.Name = "GaphopIcon"
    lbl.Size = size
    lbl.Position = opts.Position or UDim2.fromOffset(0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = GaphopUI.Icons[key] or tostring(iconName or "?")
    lbl.TextColor3 = color
    lbl.TextSize = opts.TextSize or 14
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = parent
    return lbl
end

-- ============================================================
-- 12. RIPPLE (correct input position + pool)
-- ============================================================
local function CreateRipple(parent, inputObj, color)
    if not GaphopUI.Settings.Effects or GaphopUI.Settings.ReducedMotion then return end
    color = color or Color3.new(1, 1, 1)

    local mousePos
    if inputObj and inputObj.Position then
        mousePos = Vector2.new(inputObj.Position.X, inputObj.Position.Y)
    else
        mousePos = UserInputService:GetMouseLocation()
    end

    local absPos = parent.AbsolutePosition
    local absSize = parent.AbsoluteSize
    local relX = mousePos.X - absPos.X
    local relY = mousePos.Y - absPos.Y

    local ripple = Instance.new("Frame")
    ripple.Name = "GaphopRipple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.fromOffset(relX, relY)
    ripple.Size = UDim2.fromOffset(0, 0)
    ripple.BackgroundColor3 = color
    ripple.BackgroundTransparency = 0.6
    ripple.BorderSizePixel = 0
    ripple.ZIndex = parent.ZIndex + 5
    ripple.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple

    local maxDim = math.max(absSize.X, absSize.Y) * 2.2
    Spring(ripple, 0.45, {
        Size = UDim2.fromOffset(maxDim, maxDim),
        BackgroundTransparency = 1,
    }, Enum.EasingStyle.Quad)

    task.delay(0.5, function()
        if ripple and ripple.Parent then ripple:Destroy() end
    end)
end

-- ============================================================
-- 13. CONFIG SAVE / LOAD
-- ============================================================
local function SaveConfig()
    if not GaphopUI.ConfigPath then return end
    local data = {
        Version = GaphopUI.Version,
        Theme = GaphopUI.CurrentTheme,
        RGBEnabled = GaphopUI.RGBEnabled,
        ToggleKey = GaphopUI.ToggleKey and GaphopUI.ToggleKey.Name or "K",
        Settings = GaphopUI.Settings,
        Flags = {},
    }
    for k, v in pairs(GaphopUI.Flags) do
        if typeof(v) == "Color3" then
            data.Flags[k] = { __color = true, R = v.R, G = v.G, B = v.B }
        elseif typeof(v) == "EnumItem" then
            data.Flags[k] = { __enum = true, Name = v.Name }
        else
            data.Flags[k] = v
        end
    end
    pcall(function()
        if type(writefile) == "function" then
            writefile(GaphopUI.ConfigPath, HttpService:JSONEncode(data))
        end
    end)
end

local saveDebounce = false
local function DebouncedSave()
    if saveDebounce then return end
    saveDebounce = true
    task.delay(0.6, function()
        SaveConfig()
        saveDebounce = false
    end)
end

local function LoadConfig(winName)
    local path = GaphopUI.ConfigPath
    if not path or type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    local ok, raw = pcall(function()
        if isfile(path) then return readfile(path) end
    end)
    if not ok or not raw then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(data) ~= "table" then return end

    if data.Theme and GaphopUI.Themes[data.Theme] then
        GaphopUI.CurrentTheme = data.Theme
    end
    if data.RGBEnabled ~= nil then GaphopUI.RGBEnabled = data.RGBEnabled end
    if data.ToggleKey and Enum.KeyCode[data.ToggleKey] then
        GaphopUI.ToggleKey = Enum.KeyCode[data.ToggleKey]
    end
    if type(data.Settings) == "table" then
        for k, v in pairs(data.Settings) do
            if GaphopUI.Settings[k] ~= nil then GaphopUI.Settings[k] = v end
        end
    end
    if type(data.Flags) == "table" then
        for k, v in pairs(data.Flags) do
            if type(v) == "table" and v.__color then
                GaphopUI.Flags[k] = Color3.new(v.R, v.G, v.B)
            elseif type(v) == "table" and v.__enum and Enum.KeyCode[v.Name] then
                GaphopUI.Flags[k] = Enum.KeyCode[v.Name]
            else
                GaphopUI.Flags[k] = v
            end
        end
    end
end

-- ============================================================
-- 14. NOTIFICATIONS
-- ============================================================
local function EnsureNotifyContainer()
    if GaphopUI.NotifyContainer and GaphopUI.NotifyContainer.Parent then return end
    local gui = ParentUI:FindFirstChild("GaphopUI_Engine")
    if not gui then return end
    local cont = Instance.new("Frame")
    cont.Name = "NotifyContainer"
    cont.Size = UDim2.new(0, 320, 1, -20)
    cont.Position = UDim2.new(1, -340, 0, 10)
    cont.BackgroundTransparency = 1
    cont.ZIndex = 200
    cont.Parent = gui
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = cont
    GaphopUI.NotifyContainer = cont
end

function GaphopUI:Notify(cfg)
    cfg = cfg or {}
    EnsureNotifyContainer()
    local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]
    local duration = cfg.Duration or 4
    local title = cfg.Title or "Notification"
    local content = cfg.Content or ""
    local image = cfg.Image

    -- Queue limit
    local children = GaphopUI.NotifyContainer:GetChildren()
    local count = 0
    for _, c in ipairs(children) do if c:IsA("Frame") then count += 1 end end
    if count >= 5 then
        for _, c in ipairs(children) do
            if c:IsA("Frame") then c:Destroy() break end
        end
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = theme.Glass or 0.2
    card.ClipsDescendants = true
    card.ZIndex = 201
    card.Parent = GaphopUI.NotifyContainer
    ApplyLiquidGlass(card, theme, { Radius = 12, Thickness = 1.2, Highlight = true })

    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -50, 0, 20)
    titleL.Position = UDim2.new(0, 14, 0, 10)
    titleL.BackgroundTransparency = 1
    titleL.Text = title
    titleL.TextColor3 = theme.Text
    titleL.TextSize = 14
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.ZIndex = 202
    titleL.Parent = card

    local contentL = Instance.new("TextLabel")
    contentL.Size = UDim2.new(1, -24, 0, 32)
    contentL.Position = UDim2.new(0, 14, 0, 32)
    contentL.BackgroundTransparency = 1
    contentL.Text = content
    contentL.TextColor3 = theme.SubText
    contentL.TextSize = 12
    contentL.Font = Enum.Font.Gotham
    contentL.TextWrapped = true
    contentL.TextXAlignment = Enum.TextXAlignment.Left
    contentL.ZIndex = 202
    contentL.Parent = card

    local progress = Instance.new("Frame")
    progress.Size = UDim2.new(1, 0, 0, 3)
    progress.Position = UDim2.new(0, 0, 1, -3)
    progress.BackgroundColor3 = theme.Accent
    progress.BorderSizePixel = 0
    progress.ZIndex = 203
    progress.Parent = card

    -- Spring in
    SoftSpring(card, 0.4, { Size = UDim2.new(1, 0, 0, 72) }, Enum.EasingStyle.Back)

    local start = tick()
    local paused = false
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not card or not card.Parent then
            if conn then conn:Disconnect() end
            return
        end
        if paused then return end
        local elapsed = tick() - start
        local t = math.clamp(1 - elapsed / duration, 0, 1)
        progress.Size = UDim2.new(t, 0, 0, 3)
        if elapsed >= duration then
            SoftSpring(card, 0.3, { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 })
            task.delay(0.35, function() if card then card:Destroy() end end)
            conn:Disconnect()
        end
    end)
    AddConnection(conn)

    card.MouseEnter:Connect(function() paused = true end)
    card.MouseLeave:Connect(function() paused = false end)

    -- Click to dismiss
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 204
    btn.Parent = card
    btn.MouseButton1Click:Connect(function()
        SoftSpring(card, 0.25, { Size = UDim2.new(1, 0, 0, 0) })
        task.delay(0.3, function() if card then card:Destroy() end end)
        if conn then conn:Disconnect() end
    end)
end

function GaphopUI:WarnNotify(cfg)
    cfg = cfg or {}
    cfg.Title = cfg.Title or "Warning"
    cfg.Color = cfg.Color or Color3.fromRGB(255, 180, 0)
    self:Notify(cfg)
end

-- ============================================================
-- 15. PROMPT
-- ============================================================
function GaphopUI:CreatePrompt(cfg)
    cfg = cfg or {}
    local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]
    local gui = ParentUI:FindFirstChild("GaphopUI_Engine")
    if not gui then return end

    local overlay = Instance.new("Frame")
    overlay.Name = "GaphopPromptOverlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.55
    overlay.ZIndex = 300
    overlay.Parent = gui

    local modal = Instance.new("Frame")
    modal.Size = UDim2.fromOffset(340, 180)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.Position = UDim2.fromScale(0.5, 0.5)
    modal.BackgroundColor3 = theme.Background
    modal.BackgroundTransparency = theme.Glass or 0.15
    modal.ZIndex = 301
    modal.Parent = overlay
    ApplyLiquidGlass(modal, theme, { Radius = 16, Thickness = 1.5 })

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 28)
    title.Position = UDim2.new(0, 12, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = cfg.Title or "Confirm"
    title.TextColor3 = theme.Text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 302
    title.Parent = modal

    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -24, 0, 50)
    content.Position = UDim2.new(0, 12, 0, 48)
    content.BackgroundTransparency = 1
    content.Text = cfg.Content or ""
    content.TextColor3 = theme.SubText
    content.TextSize = 13
    content.Font = Enum.Font.Gotham
    content.TextWrapped = true
    content.ZIndex = 302
    content.Parent = modal

    local function close()
        SoftSpring(modal, 0.25, { Size = UDim2.fromOffset(320, 0), BackgroundTransparency = 1 })
        Spring(overlay, 0.25, { BackgroundTransparency = 1 })
        task.delay(0.3, function() if overlay then overlay:Destroy() end end)
    end

    local confBtn = Instance.new("TextButton")
    confBtn.Size = UDim2.new(0, 120, 0, 34)
    confBtn.Position = UDim2.new(1, -140, 1, -50)
    confBtn.BackgroundColor3 = theme.Accent
    confBtn.Text = cfg.ConfirmText or "Confirm"
    confBtn.TextColor3 = Color3.new(1, 1, 1)
    confBtn.TextSize = 13
    confBtn.Font = Enum.Font.GothamBold
    confBtn.ZIndex = 302
    confBtn.Parent = modal
    Instance.new("UICorner", confBtn).CornerRadius = UDim.new(0, 8)
    confBtn.MouseButton1Click:Connect(function()
        close()
        if cfg.OnConfirm then pcall(cfg.OnConfirm) end
    end)

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0, 100, 0, 34)
    cancelBtn.Position = UDim2.new(1, -250, 1, -50)
    cancelBtn.BackgroundColor3 = theme.Card
    cancelBtn.Text = cfg.CancelText or "Cancel"
    cancelBtn.TextColor3 = theme.Text
    cancelBtn.TextSize = 13
    cancelBtn.Font = Enum.Font.Gotham
    cancelBtn.ZIndex = 302
    cancelBtn.Parent = modal
    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)
    cancelBtn.MouseButton1Click:Connect(function()
        close()
        if cfg.OnCancel then pcall(cfg.OnCancel) end
    end)

    SoftSpring(modal, 0.35, { Size = UDim2.fromOffset(340, 180) }, Enum.EasingStyle.Back)
end

-- ============================================================
-- 16. TOGGLE UI (fixed forceState logic + animation token)
-- ============================================================
function GaphopUI:ToggleUI(forceState)
    local shouldOpen
    if forceState == nil then
        shouldOpen = not GaphopUI.IsOpen
    else
        shouldOpen = forceState and true or false
    end

    if shouldOpen == GaphopUI.IsOpen then return end

    GaphopUI.AnimationToken = GaphopUI.AnimationToken + 1
    local token = GaphopUI.AnimationToken
    local win = GaphopUI.WindowInstance
    if not win then return end

    local content = win:FindFirstChild("ContentCanvas")
    local theme = GaphopUI.Themes[GaphopUI.CurrentTheme]

    if shouldOpen then
        GaphopUI.IsOpen = true
        win.Visible = true
        if content then
            content.GroupTransparency = 1
            content.UIScale.Scale = 0.94
        end
        SoftSpring(win, 0.4, { Size = win:GetAttribute("NormalSize") or UDim2.fromOffset(720, 480) })
        if content then
            Spring(content, 0.4, { GroupTransparency = 0 })
            Spring(content.UIScale, 0.4, { Scale = 1 })
        end
        if GaphopUI.Settings.Blur then
            pcall(function()
                if not GaphopUI.BlurEffect then
                    GaphopUI.BlurEffect = Instance.new("BlurEffect")
                    GaphopUI.BlurEffect.Size = 0
                    GaphopUI.BlurEffect.Parent = Lighting
                end
                Spring(GaphopUI.BlurEffect, 0.4, { Size = 12 })
            end)
        end
        StartDispatcher()
    else
        GaphopUI.IsOpen = false
        if content then
            Spring(content, 0.3, { GroupTransparency = 1 })
            Spring(content.UIScale, 0.3, { Scale = 0.94 })
        end
        SoftSpring(win, 0.3, { Size = UDim2.fromOffset(0, 0) })
        task.delay(0.32, function()
            if GaphopUI.AnimationToken == token then
                win.Visible = false
            end
        end)
        if GaphopUI.BlurEffect then
            Spring(GaphopUI.BlurEffect, 0.3, { Size = 0 })
        end
        StopDispatcher()

        if not GaphopUI.HideNotifyShown and (cfg and cfg.HideNotify) then
            GaphopUI.HideNotifyShown = true
            GaphopUI:Notify({
                Title = "UI Hidden",
                Content = "Press [" .. (GaphopUI.ToggleKey and GaphopUI.ToggleKey.Name or "K") .. "] to show again",
                Duration = 3,
            })
        end
    end
end

-- ============================================================
-- 17. APPLY THEME
-- ============================================================
function GaphopUI:ApplyTheme(name)
    if not GaphopUI.Themes[name] then return end
    GaphopUI.CurrentTheme = name
    local theme = GaphopUI.Themes[name]
    -- Live retint is handled by registered elements + glass refresh
    if GaphopUI.WindowInstance then
        -- Force re-apply glass on main surfaces
        for _, desc in ipairs(GaphopUI.WindowInstance:GetDescendants()) do
            if desc:IsA("Frame") and desc:GetAttribute("GaphopGlass") then
                ApplyLiquidGlass(desc, theme, { Radius = desc:GetAttribute("GlassRadius") or 12 })
            end
        end
    end
    DebouncedSave()
end

function GaphopUI:ToggleRGB(state)
    if state == nil then state = not GaphopUI.RGBEnabled end
    GaphopUI.RGBEnabled = state
    if state then StartDispatcher() else -- RGB stops automatically when flag is false
    end
    DebouncedSave()
end

function GaphopUI:FilterElements(query)
    query = (query or ""):lower()
    for _, el in ipairs(GaphopUI.Elements) do
        if el.Card and el.Card.Parent then
            local match = query == "" or (el.SearchText or ""):lower():find(query, 1, true)
            el.Card.Visible = match and true or false
        end
    end
end

-- ============================================================
-- 18. DESTROY
-- ============================================================
function GaphopUI:Destroy()
    DisconnectAll()
    StopDispatcher()
    if GaphopUI.BlurEffect then
        pcall(function() GaphopUI.BlurEffect:Destroy() end)
        GaphopUI.BlurEffect = nil
    end
    local eng = ParentUI:FindFirstChild("GaphopUI_Engine")
    if eng then eng:Destroy() end
    GaphopUI.WindowInstance = nil
    GaphopUI.Elements = {}
    GaphopUI.ActiveTweens = {}
end

-- ============================================================
-- 19. ELEMENT REGISTRATION + COMMON OBJECT API
-- ============================================================
local function RegisterElement(data)
    table.insert(GaphopUI.Elements, data)
    return data
end

local function MakeElementObject(base)
    base = base or {}
    function base:SetVisible(v)
        if self.Card then self.Card.Visible = v end
    end
    function base:SetLocked(v)
        self.Locked = v
        if self.Card then
            self.Card.BackgroundTransparency = v and 0.6 or (GaphopUI.Themes[GaphopUI.CurrentTheme].Glass or 0.32)
        end
    end
    function base:Destroy()
        if self.Card then self.Card:Destroy() end
    end
    function base:SetName(t)
        if self.Label then self.Label.Text = t end
    end
    function base:SetDescription(t)
        if self.DescLabel then self.DescLabel.Text = t end
    end
    base.Changed = Instance.new("BindableEvent")
    return base
end

-- ============================================================
-- 20. BIND ELEMENT METHODS (Tab methods)
-- ============================================================
local function BindElementMethods(TabObj, page, theme)
    -- Button
    function TabObj:makeButton(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Button"
        local callback = cfg.Callback or function() end
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 44)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.32
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11, Thickness = 1, Highlight = true })

        local scale = Instance.new("UIScale")
        scale.Parent = card

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -24, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Parent = card

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromScale(1, 1)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = card

        btn.MouseEnter:Connect(function()
            if TabObj.Locked then return end
            Spring(scale, 0.18, { Scale = 1.02 })
            Spring(card, 0.18, { BackgroundTransparency = 0.18 })
        end)
        btn.MouseLeave:Connect(function()
            Spring(scale, 0.18, { Scale = 1 })
            Spring(card, 0.18, { BackgroundTransparency = 0.32 })
        end)
        btn.Activated:Connect(function()
            if TabObj.Locked then return end
            CreateRipple(card, nil, theme.Accent)
            Spring(scale, 0.08, { Scale = 0.97 })
            task.delay(0.08, function() Spring(scale, 0.15, { Scale = 1 }) end)
            SafePcall(callback)
        end)

        local obj = MakeElementObject({ Card = card, Label = label, Type = "button" })
        RegisterElement({ Type = "button", Card = card, Label = label, SearchText = name, Page = page })
        return obj
    end
    TabObj.CreateButton = TabObj.makeButton
    TabObj.AddButton = TabObj.makeButton

    -- Toggle (liquid knob)
    function TabObj:makeToggle(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Toggle"
        local current = cfg.CurrentValue
        if current == nil then current = false end
        if cfg.Flag and GaphopUI.Flags[cfg.Flag] ~= nil then current = GaphopUI.Flags[cfg.Flag] end
        local callback = cfg.Callback or function() end
        local flag = cfg.Flag

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 44)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.32
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11 })

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Parent = card

        local track = Instance.new("Frame")
        track.Size = UDim2.fromOffset(44, 24)
        track.Position = UDim2.new(1, -56, 0.5, -12)
        track.BackgroundColor3 = current and theme.Accent or theme.SliderBar
        track.Parent = card
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(20, 20)
        knob.Position = current and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        knob.BackgroundColor3 = Color3.new(1, 1, 1)
        knob.Parent = track
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function setState(val, animate)
            current = val
            if flag then GaphopUI.Flags[flag] = val end
            local targetPos = val and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local targetCol = val and theme.Accent or theme.SliderBar
            if animate and GaphopUI.Settings.Effects then
                -- stretch
                Spring(knob, 0.12, { Size = UDim2.fromOffset(26, 18) })
                task.delay(0.1, function()
                    Spring(knob, 0.2, { Size = UDim2.fromOffset(20, 20), Position = targetPos })
                end)
                Spring(track, 0.25, { BackgroundColor3 = targetCol })
            else
                knob.Position = targetPos
                track.BackgroundColor3 = targetCol
            end
            SafePcall(callback, val)
        end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromScale(1, 1)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = card
        btn.Activated:Connect(function()
            setState(not current, true)
            DebouncedSave()
        end)

        local obj = MakeElementObject({ Card = card, Label = label, Type = "toggle" })
        function obj:Set(v) setState(v, true) end
        function obj:Get() return current end
        RegisterElement({ Type = "toggle", Card = card, Label = label, SearchText = name, Page = page })
        return obj
    end
    TabObj.CreateToggle = TabObj.makeToggle
    TabObj.AddToggle = TabObj.makeToggle

    -- Slider
    function TabObj:makeSlider(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Slider"
        local range = cfg.Range or {0, 100}
        local min, max = range[1] or 0, range[2] or 100
        local current = cfg.CurrentValue or min
        if cfg.Flag and GaphopUI.Flags[cfg.Flag] ~= nil then current = GaphopUI.Flags[cfg.Flag] end
        local suffix = cfg.Suffix or ""
        local increment = cfg.Increment or 1
        local callback = cfg.Callback or function() end
        local flag = cfg.Flag

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 56)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.32
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11 })

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 20)
        label.Position = UDim2.new(0, 12, 0, 6)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local valueL = Instance.new("TextLabel")
        valueL.Size = UDim2.new(0.35, 0, 0, 20)
        valueL.Position = UDim2.new(0.62, 0, 0, 6)
        valueL.BackgroundTransparency = 1
        valueL.Text = tostring(current) .. suffix
        valueL.TextColor3 = theme.Accent
        valueL.TextSize = 12
        valueL.Font = Enum.Font.GothamBold
        valueL.TextXAlignment = Enum.TextXAlignment.Right
        valueL.Parent = card

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -24, 0, 6)
        bar.Position = UDim2.new(0, 12, 0, 36)
        bar.BackgroundColor3 = theme.SliderBar
        bar.Parent = card
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = theme.Accent
        fill.Parent = bar
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new((current - min) / (max - min), 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.new(1, 1, 1)
        knob.Parent = bar
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function update(val, fire)
            val = math.clamp(math.floor(val / increment + 0.5) * increment, min, max)
            current = val
            local alpha = (val - min) / (max - min)
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            knob.Position = UDim2.new(alpha, 0, 0.5, 0)
            valueL.Text = tostring(val) .. suffix
            if flag then GaphopUI.Flags[flag] = val end
            if fire then SafePcall(callback, val) end
        end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromScale(1, 1)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = card

        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                Spring(knob, 0.12, { Size = UDim2.fromOffset(20, 20) })
            end
        end)
        AddConnection(UserInputService.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
                Spring(knob, 0.15, { Size = UDim2.fromOffset(16, 16) })
                DebouncedSave()
            end
        end))
        AddConnection(UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                update(min + rel * (max - min), true)
            end
        end))

        local obj = MakeElementObject({ Card = card, Label = label, Type = "slider" })
        function obj:Set(v) update(v, true) end
        function obj:Get() return current end
        RegisterElement({ Type = "slider", Card = card, Label = label, SearchText = name, Page = page })
        return obj
    end
    TabObj.CreateSlider = TabObj.makeSlider
    TabObj.AddSlider = TabObj.makeSlider

    -- Input
    function TabObj:makeInput(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Input"
        local placeholder = cfg.PlaceholderText or ""
        local callback = cfg.Callback or function() end
        local live = cfg.LiveUpdate
        local clearAfter = cfg.RemoveTextAfterFocusLost

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 44)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.32
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11 })

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.35, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.55, 0, 0, 28)
        box.Position = UDim2.new(0.4, 0, 0.5, -14)
        box.BackgroundColor3 = theme.InputBackground
        box.Text = ""
        box.PlaceholderText = placeholder
        box.TextColor3 = theme.Text
        box.PlaceholderColor3 = theme.SubText
        box.TextSize = 12
        box.Font = Enum.Font.Gotham
        box.ClearTextOnFocus = false
        box.Parent = card
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

        box.FocusLost:Connect(function(enter)
            SafePcall(callback, box.Text)
            if clearAfter then box.Text = "" end
        end)
        if live then
            box:GetPropertyChangedSignal("Text"):Connect(function()
                SafePcall(callback, box.Text)
            end)
        end

        local obj = MakeElementObject({ Card = card, Label = label, Type = "input" })
        function obj:Set(t) box.Text = tostring(t) end
        function obj:Get() return box.Text end
        RegisterElement({ Type = "input", Card = card, Label = label, SearchText = name, Page = page })
        return obj
    end
    TabObj.CreateInput = TabObj.makeInput
    TabObj.AddInput = TabObj.makeInput

    -- Dropdown (simplified solid implementation)
    function TabObj:makeDropdown(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Dropdown"
        local options = cfg.Options or {}
        local current = cfg.CurrentOption or options[1]
        if cfg.Flag and GaphopUI.Flags[cfg.Flag] ~= nil then current = GaphopUI.Flags[cfg.Flag] end
        local callback = cfg.Callback or function() end
        local flag = cfg.Flag
        local multi = cfg.MultipleOptions

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 44)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.32
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11 })

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(0.5, 0, 0, 28)
        dropBtn.Position = UDim2.new(0.45, 0, 0.5, -14)
        dropBtn.BackgroundColor3 = theme.InputBackground
        dropBtn.Text = tostring(current) .. "  ▾"
        dropBtn.TextColor3 = theme.Text
        dropBtn.TextSize = 12
        dropBtn.Font = Enum.Font.Gotham
        dropBtn.Parent = card
        Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)

        -- Popup created on demand in ScreenGui top layer
        local popup
        local function closePopup()
            if popup then
                SoftSpring(popup, 0.2, { Size = UDim2.fromOffset(popup.AbsoluteSize.X, 0) })
                task.delay(0.22, function() if popup then popup:Destroy() popup = nil end end)
            end
        end

        dropBtn.Activated:Connect(function()
            if popup then closePopup() return end
            local gui = ParentUI:FindFirstChild("GaphopUI_Engine")
            if not gui then return end
            popup = Instance.new("Frame")
            popup.Size = UDim2.fromOffset(math.max(180, dropBtn.AbsoluteSize.X), 0)
            popup.Position = UDim2.fromOffset(dropBtn.AbsolutePosition.X, dropBtn.AbsolutePosition.Y + dropBtn.AbsoluteSize.Y + 4)
            popup.BackgroundColor3 = theme.Card
            popup.BackgroundTransparency = 0.15
            popup.ZIndex = 250
            popup.ClipsDescendants = true
            popup.Parent = gui
            ApplyLiquidGlass(popup, theme, { Radius = 10 })

            local list = Instance.new("UIListLayout")
            list.Parent = popup
            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 32)
                optBtn.BackgroundTransparency = 1
                optBtn.Text = "  " .. tostring(opt)
                optBtn.TextColor3 = theme.Text
                optBtn.TextSize = 12
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.ZIndex = 251
                optBtn.Parent = popup
                optBtn.MouseEnter:Connect(function()
                    optBtn.BackgroundTransparency = 0.7
                    optBtn.BackgroundColor3 = theme.Accent
                end)
                optBtn.MouseLeave:Connect(function()
                    optBtn.BackgroundTransparency = 1
                end)
                optBtn.Activated:Connect(function()
                    current = opt
                    dropBtn.Text = tostring(opt) .. "  ▾"
                    if flag then GaphopUI.Flags[flag] = opt end
                    SafePcall(callback, opt)
                    closePopup()
                    DebouncedSave()
                end)
            end
            SoftSpring(popup, 0.25, { Size = UDim2.fromOffset(popup.AbsoluteSize.X, #options * 32 + 4) })
        end)

        local obj = MakeElementObject({ Card = card, Label = label, Type = "dropdown" })
        function obj:Set(v) current = v; dropBtn.Text = tostring(v) .. "  ▾" end
        function obj:Get() return current end
        RegisterElement({ Type = "dropdown", Card = card, Label = label, SearchText = name, Page = page })
        return obj
    end
    TabObj.CreateDropdown = TabObj.makeDropdown
    TabObj.AddDropdown = TabObj.makeDropdown

    -- Keybind
    function TabObj:makeKeybind(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Keybind"
        local current = cfg.CurrentKeybind or Enum.KeyCode.E
        if cfg.Flag and GaphopUI.Flags[cfg.Flag] then current = GaphopUI.Flags[cfg.Flag] end
        local callback = cfg.Callback or function() end
        local flag = cfg.Flag

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 44)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.32
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11 })

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.fromOffset(90, 28)
        bindBtn.Position = UDim2.new(1, -102, 0.5, -14)
        bindBtn.BackgroundColor3 = theme.InputBackground
        bindBtn.Text = current.Name
        bindBtn.TextColor3 = theme.Text
        bindBtn.TextSize = 12
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.Parent = card
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 6)

        local listening = false
        bindBtn.Activated:Connect(function()
            listening = true
            bindBtn.Text = "..."
            Spring(bindBtn, 0.15, { BackgroundColor3 = theme.Accent })
        end)

        AddConnection(UserInputService.InputBegan:Connect(function(input, gp)
            if not listening then return end
            if input.KeyCode == Enum.KeyCode.Escape then
                listening = false
                bindBtn.Text = current.Name
                Spring(bindBtn, 0.15, { BackgroundColor3 = theme.InputBackground })
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                current = input.KeyCode
                bindBtn.Text = current.Name
                listening = false
                Spring(bindBtn, 0.15, { BackgroundColor3 = theme.InputBackground })
                if flag then GaphopUI.Flags[flag] = current end
                SafePcall(callback, current)
                DebouncedSave()
            end
        end))

        local obj = MakeElementObject({ Card = card, Label = label, Type = "keybind" })
        function obj:Set(k) current = k; bindBtn.Text = k.Name end
        function obj:Get() return current end
        RegisterElement({ Type = "keybind", Card = card, Label = label, SearchText = name, Page = page })
        return obj
    end
    TabObj.CreateKeybind = TabObj.makeKeybind
    TabObj.AddKeybind = TabObj.makeKeybind

    -- ColorPicker (hex + display for now; full HSV can be expanded)
    function TabObj:makeColorPicker(cfg)
        cfg = cfg or {}
        local name = cfg.Name or "Color"
        local current = cfg.Color or Color3.fromRGB(0, 162, 255)
        if cfg.Flag and GaphopUI.Flags[cfg.Flag] then current = GaphopUI.Flags[cfg.Flag] end
        local callback = cfg.Callback or function() end
        local flag = cfg.Flag

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 44)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.32
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11 })

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local display = Instance.new("Frame")
        display.Size = UDim2.fromOffset(24, 24)
        display.Position = UDim2.new(1, -36, 0.5, -12)
        display.BackgroundColor3 = current
        display.Parent = card
        Instance.new("UICorner", display).CornerRadius = UDim.new(0, 6)

        local hex = Instance.new("TextBox")
        hex.Size = UDim2.fromOffset(80, 24)
        hex.Position = UDim2.new(1, -124, 0.5, -12)
        hex.BackgroundColor3 = theme.InputBackground
        hex.Text = Color3ToHex(current)
        hex.TextColor3 = theme.Text
        hex.TextSize = 12
        hex.Font = Enum.Font.Gotham
        hex.Parent = card
        Instance.new("UICorner", hex).CornerRadius = UDim.new(0, 6)

        hex.FocusLost:Connect(function()
            local c = HexToColor3(hex.Text)
            if c then
                current = c
                display.BackgroundColor3 = c
                if flag then GaphopUI.Flags[flag] = c end
                SafePcall(callback, c)
                DebouncedSave()
            end
            hex.Text = Color3ToHex(current)
        end)

        local obj = MakeElementObject({ Card = card, Label = label, Type = "colorpicker" })
        function obj:Set(c) current = c; display.BackgroundColor3 = c; hex.Text = Color3ToHex(c) end
        function obj:Get() return current end
        RegisterElement({ Type = "colorpicker", Card = card, Label = label, SearchText = name, Page = page })
        return obj
    end
    TabObj.CreateColorPicker = TabObj.makeColorPicker
    TabObj.AddColorPicker = TabObj.makeColorPicker

    -- Label
    function TabObj:makeLabel(cfg)
        cfg = cfg or {}
        local title = type(cfg) == "string" and cfg or (cfg.Name or "Label")
        local desc = type(cfg) == "table" and (cfg.Label or cfg.Description) or ""

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, desc ~= "" and 52 or 36)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.4
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 10 })

        local titleL = Instance.new("TextLabel")
        titleL.Size = UDim2.new(1, -20, 0, desc ~= "" and 20 or 36)
        titleL.Position = UDim2.new(0, 12, 0, desc ~= "" and 6 or 0)
        titleL.BackgroundTransparency = 1
        titleL.Text = title
        titleL.TextColor3 = theme.Text
        titleL.TextSize = 13
        titleL.Font = Enum.Font.GothamMedium
        titleL.TextXAlignment = Enum.TextXAlignment.Left
        titleL.Parent = card

        local descL
        if desc ~= "" then
            descL = Instance.new("TextLabel")
            descL.Size = UDim2.new(1, -20, 0, 16)
            descL.Position = UDim2.new(0, 12, 0, 28)
            descL.BackgroundTransparency = 1
            descL.Text = desc
            descL.TextColor3 = theme.SubText
            descL.TextSize = 11
            descL.Font = Enum.Font.Gotham
            descL.TextXAlignment = Enum.TextXAlignment.Left
            descL.Parent = card
        end

        local obj = MakeElementObject({ Card = card, Label = titleL, DescLabel = descL, Type = "label" })
        function obj:Set(t) titleL.Text = t end
        function obj:SetDescription(t)
            if descL then descL.Text = t end
        end
        RegisterElement({ Type = "label", Card = card, Label = titleL, SearchText = title, Page = page })
        return obj
    end
    TabObj.CreateLabel = TabObj.makeLabel
    TabObj.AddLabel = TabObj.makeLabel

    -- Section
    function TabObj:CreateSection(text)
        local secName = type(text) == "table" and (text.Name or text.Title) or tostring(text or "Section")
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -8, 0, 28)
        container.BackgroundTransparency = 1
        container.Parent = page

        local accent = Instance.new("Frame")
        accent.Size = UDim2.fromOffset(3, 14)
        accent.Position = UDim2.new(0, 4, 0.5, -7)
        accent.BackgroundColor3 = theme.Accent
        accent.BorderSizePixel = 0
        accent.Parent = container
        Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 2)

        local secL = Instance.new("TextLabel")
        secL.Size = UDim2.new(1, -20, 1, 0)
        secL.Position = UDim2.new(0, 14, 0, 0)
        secL.BackgroundTransparency = 1
        secL.Text = secName:upper()
        secL.TextColor3 = theme.Accent
        secL.TextSize = 11
        secL.Font = Enum.Font.GothamBold
        secL.TextXAlignment = Enum.TextXAlignment.Left
        secL.Parent = container

        RegisterElement({ Type = "section", Card = container, Label = secL, SearchText = secName, Page = page })
        return container
    end
    TabObj.makeSection = TabObj.CreateSection
    TabObj.AddSection = TabObj.CreateSection

    -- Paragraph
    function TabObj:CreateParagraph(cfg)
        cfg = type(cfg) == "string" and { Title = cfg } or (cfg or {})
        local titleText = cfg.Title or cfg.Name or "Paragraph"
        local contentText = cfg.Content or ""

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -8, 0, 64)
        card.BackgroundColor3 = theme.Card
        card.BackgroundTransparency = 0.38
        card.Parent = page
        ApplyLiquidGlass(card, theme, { Radius = 11 })

        local pTitle = Instance.new("TextLabel")
        pTitle.Size = UDim2.new(1, -20, 0, 20)
        pTitle.Position = UDim2.new(0, 12, 0, 8)
        pTitle.BackgroundTransparency = 1
        pTitle.Text = titleText
        pTitle.TextColor3 = theme.Text
        pTitle.TextSize = 13
        pTitle.Font = Enum.Font.GothamBold
        pTitle.TextXAlignment = Enum.TextXAlignment.Left
        pTitle.Parent = card

        local pContent = Instance.new("TextLabel")
        pContent.Size = UDim2.new(1, -20, 0, 28)
        pContent.Position = UDim2.new(0, 12, 0, 30)
        pContent.BackgroundTransparency = 1
        pContent.Text = contentText
        pContent.TextColor3 = theme.SubText
        pContent.TextSize = 11
        pContent.Font = Enum.Font.Gotham
        pContent.TextWrapped = true
        pContent.TextXAlignment = Enum.TextXAlignment.Left
        pContent.Parent = card

        RegisterElement({ Type = "paragraph", Card = card, Label = pTitle, SearchText = titleText, Page = page })
    end
    TabObj.makeParagraph = TabObj.CreateParagraph
    TabObj.AddParagraph = TabObj.CreateParagraph

    -- Divider / Row stubs for API completeness
    function TabObj:CreateDivider()
        local d = Instance.new("Frame")
        d.Size = UDim2.new(1, -8, 0, 1)
        d.BackgroundColor3 = theme.Border
        d.BackgroundTransparency = 0.6
        d.BorderSizePixel = 0
        d.Parent = page
        return d
    end

    function TabObj:CreateRow()
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -8, 0, 44)
        row.BackgroundTransparency = 1
        row.Parent = page
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 8)
        layout.Parent = row
        return row
    end

    return TabObj
end

-- ============================================================
-- 21. MAIN WINDOW
-- ============================================================
local ScreenGui
local function EnsureScreenGui()
    if ScreenGui and ScreenGui.Parent then return ScreenGui end
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GaphopUI_Engine"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = ParentUI
    return ScreenGui
end

function GaphopUI:makeWindow(cfg)
    cfg = cfg or {}
    GaphopUI.IsOpen = true
    GaphopUI.IsMinimized = false

    local winName = cfg.Name or cfg.Title or "GaphopUI"
    GaphopUI.WindowName = winName
    local configPath, hubFolder = GetConfigPath(winName)
    GaphopUI.ConfigPath = configPath
    EnsureFolder("GaphopUI")
    EnsureFolder(hubFolder)
    LoadConfig(winName)

    if cfg.ToggleUIKeybind and Enum.KeyCode[cfg.ToggleUIKeybind] then
        GaphopUI.ToggleKey = Enum.KeyCode[cfg.ToggleUIKeybind]
    end

    local theme = GaphopUI.Themes[GaphopUI.CurrentTheme] or GaphopUI.Themes.Dark
    local isMobile = IsMobile()
    local winW, winH = 720, 480
    if isMobile then
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(400, 700)
        winW = math.clamp(math.floor(vp.X * 0.92), 300, 420)
        winH = math.clamp(math.floor(vp.Y * 0.72), 380, 520)
    end

    EnsureScreenGui()

    -- Main window with center anchor
    local WindowFrame = Instance.new("Frame")
    WindowFrame.Name = "MainWindow"
    WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    WindowFrame.Size = UDim2.fromOffset(winW, winH)
    WindowFrame.Position = UDim2.fromScale(0.5, 0.5)
    WindowFrame.BackgroundColor3 = theme.Background
    WindowFrame.BackgroundTransparency = theme.Glass or 0.18
    WindowFrame.ClipsDescendants = true
    WindowFrame.Visible = false
    WindowFrame.Parent = ScreenGui
    WindowFrame:SetAttribute("NormalSize", UDim2.fromOffset(winW, winH))
    WindowFrame:SetAttribute("IsMaximized", false)
    ApplyLiquidGlass(WindowFrame, theme, {
        Radius = 20, Thickness = 1.6, Highlight = true, Sheen = true, InnerGlow = true
    })
    GaphopUI.WindowInstance = WindowFrame

    -- Content CanvasGroup for fade
    local contentCanvas = Instance.new("CanvasGroup")
    contentCanvas.Name = "ContentCanvas"
    contentCanvas.Size = UDim2.fromScale(1, 1)
    contentCanvas.BackgroundTransparency = 1
    contentCanvas.GroupTransparency = 0
    contentCanvas.Parent = WindowFrame
    local contentScale = Instance.new("UIScale")
    contentScale.Name = "UIScale"
    contentScale.Scale = 1
    contentScale.Parent = contentCanvas

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 52)
    TopBar.BackgroundColor3 = theme.Header
    TopBar.BackgroundTransparency = (theme.Glass or 0.2) + 0.1
    TopBar.Parent = contentCanvas
    ApplyLiquidGlass(TopBar, theme, { Radius = 18, Thickness = 1.1, Highlight = true })

    -- Drag
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = WindowFrame.Position
        end
    end)
    AddConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    AddConnection(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            WindowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0, 260, 1, 0)
    titleText.Position = UDim2.new(0, 42, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = (cfg.ShowText and (winName .. " · " .. cfg.ShowText)) or winName
    titleText.TextColor3 = theme.Text
    titleText.TextSize = 15
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = TopBar

    if cfg.Icon then
        GaphopUI:CreateIcon(TopBar, cfg.Icon, UDim2.fromOffset(18, 18), theme.Accent, {
            Position = UDim2.new(0, 14, 0.5, -9)
        })
    end

    -- Window controls
    local function CreateTopButton(icon, cb, hoverColor)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(32, 32)
        btn.BackgroundColor3 = theme.Card
        btn.BackgroundTransparency = 0.6
        btn.Text = ""
        btn.Parent = TopBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        GaphopUI:CreateIcon(btn, icon, UDim2.fromScale(1, 1), theme.SubText, { TextSize = 13 })
        btn.MouseEnter:Connect(function()
            Spring(btn, 0.15, { BackgroundColor3 = hoverColor or theme.CardHover, BackgroundTransparency = 0.2 })
        end)
        btn.MouseLeave:Connect(function()
            Spring(btn, 0.15, { BackgroundColor3 = theme.Card, BackgroundTransparency = 0.6 })
        end)
        btn.Activated:Connect(function()
            CreateRipple(btn)
            cb()
        end)
        return btn
    end

    local closeBtn = CreateTopButton("close", function()
        if cfg.ConfirmClose then
            GaphopUI:CreatePrompt({
                Title = "Close UI?",
                Content = "Are you sure you want to close this window?",
                OnConfirm = function() GaphopUI:ToggleUI(false) end
            })
        else
            GaphopUI:ToggleUI(false)
        end
    end, Color3.fromRGB(220, 60, 60))
    closeBtn.Position = UDim2.new(1, -42, 0.5, -16)

    local maxBtn = CreateTopButton("maximize", function()
        local isMax = WindowFrame:GetAttribute("IsMaximized")
        local vp = workspace.CurrentCamera.ViewportSize
        if not isMax then
            WindowFrame:SetAttribute("IsMaximized", true)
            local tw = math.min(900, vp.X - 40)
            local th = math.min(600, vp.Y - 40)
            SoftSpring(WindowFrame, 0.4, {
                Size = UDim2.fromOffset(tw, th),
                Position = UDim2.fromScale(0.5, 0.5)
            })
            WindowFrame:SetAttribute("NormalSize", UDim2.fromOffset(tw, th))
        else
            WindowFrame:SetAttribute("IsMaximized", false)
            SoftSpring(WindowFrame, 0.4, {
                Size = UDim2.fromOffset(winW, winH),
                Position = UDim2.fromScale(0.5, 0.5)
            })
            WindowFrame:SetAttribute("NormalSize", UDim2.fromOffset(winW, winH))
        end
    end)
    maxBtn.Position = UDim2.new(1, -80, 0.5, -16)

    -- SideBar + Content
    local sideW = isMobile and 56 or 168
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, sideW, 1, -64)
    SideBar.Position = UDim2.new(0, 10, 0, 56)
    SideBar.BackgroundColor3 = theme.Card
    SideBar.BackgroundTransparency = (theme.Glass or 0.2) + 0.12
    SideBar.Parent = contentCanvas
    ApplyLiquidGlass(SideBar, theme, { Radius = 14, Thickness = 1.1 })

    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -8, 1, -8)
    tabList.Position = UDim2.new(0, 4, 0, 4)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 2
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.CanvasSize = UDim2.fromOffset(0, 0)
    tabList.Parent = SideBar
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabList

    local TabIndicator = Instance.new("Frame")
    TabIndicator.Name = "TabIndicator"
    TabIndicator.Size = UDim2.new(1, 0, 0, 38)
    TabIndicator.BackgroundColor3 = theme.Accent
    TabIndicator.BackgroundTransparency = 0.82
    TabIndicator.Visible = false
    TabIndicator.ZIndex = 2
    TabIndicator.Parent = tabList
    Instance.new("UICorner", TabIndicator).CornerRadius = UDim.new(0, 10)

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -(sideW + 28), 1, -64)
    ContentArea.Position = UDim2.new(0, sideW + 22, 0, 56)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = contentCanvas

    local Tabs = {}
    local WindowObj = {}

    function WindowObj:CreateTab(tabName, iconId)
        tabName = tabName or "Tab"
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 38)
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = ""
        tabBtn.ZIndex = 5
        tabBtn.Parent = tabList
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)

        local tabIcon = GaphopUI:CreateIcon(tabBtn, iconId, UDim2.fromOffset(18, 18), theme.SubText, {
            Position = UDim2.new(0, isMobile and 18 or 10, 0.5, -9)
        })

        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -48, 1, 0)
        tabLabel.Position = UDim2.new(0, 36, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = isMobile and "" or tabName
        tabLabel.TextColor3 = theme.SubText
        tabLabel.TextSize = 13
        tabLabel.Font = Enum.Font.GothamMedium
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Visible = not isMobile
        tabLabel.Parent = tabBtn

        local page = Instance.new("ScrollingFrame")
        page.Name = "TabPage_" .. tabName
        page.Size = UDim2.new(1, -10, 1, -10)
        page.Position = UDim2.new(0, 5, 0, 5)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 3
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.fromOffset(0, 0)
        page.Parent = ContentArea
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 8)
        pageLayout.Parent = page
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(0, pageLayout.AbsoluteContentSize.Y + 12)
        end)

        local TabObj = { Btn = tabBtn, Label = tabLabel, Icon = tabIcon, Page = page }

        local function SwitchToThisTab()
            for _, t in pairs(Tabs) do
                Spring(t.Label, 0.2, { TextColor3 = theme.SubText })
                t.Page.Visible = false
            end
            TabIndicator.Visible = true
            SoftSpring(TabIndicator, 0.3, {
                Position = UDim2.new(0, 0, 0, tabBtn.AbsolutePosition.Y - tabList.AbsolutePosition.Y),
                Size = tabBtn.Size,
                BackgroundTransparency = 0.78
            })
            Spring(tabLabel, 0.2, { TextColor3 = theme.Text })
            page.Visible = true
            page.Position = UDim2.new(0, 12, 0, 5)
            Spring(page, 0.3, { Position = UDim2.new(0, 5, 0, 5) })
        end

        tabBtn.Activated:Connect(function()
            CreateRipple(tabBtn)
            SwitchToThisTab()
        end)

        if #Tabs == 0 then SwitchToThisTab() end
        table.insert(Tabs, TabObj)
        return BindElementMethods(TabObj, page, theme)
    end
    WindowObj.AddTab = WindowObj.CreateTab
    WindowObj.makeTab = WindowObj.CreateTab

    -- Global toggle key
    AddConnection(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == GaphopUI.ToggleKey then
            -- ignore if typing in TextBox
            local focused = UserInputService:GetFocusedTextBox()
            if focused then return end
            GaphopUI:ToggleUI()
        end
    end))

    -- Loading / show
    local function ShowWindow()
        WindowFrame.Visible = true
        contentCanvas.GroupTransparency = 1
        contentScale.Scale = 0.94
        SoftSpring(WindowFrame, 0.45, { Size = UDim2.fromOffset(winW, winH) }, Enum.EasingStyle.Back)
        Spring(contentCanvas, 0.4, { GroupTransparency = 0 })
        Spring(contentScale, 0.4, { Scale = 1 })
        if GaphopUI.Settings.Blur then
            pcall(function()
                GaphopUI.BlurEffect = Instance.new("BlurEffect")
                GaphopUI.BlurEffect.Size = 0
                GaphopUI.BlurEffect.Parent = Lighting
                Spring(GaphopUI.BlurEffect, 0.4, { Size = 10 })
            end)
        end
        StartDispatcher()

        if cfg.WelcomeNotify ~= false then
            local pname = LocalPlayer and LocalPlayer.Name or "Player"
            GaphopUI:Notify({
                Title = "Welcome, " .. pname,
                Content = "GaphopUI v4.0 Liquid Glass Pro loaded!",
                Duration = 4,
            })
        end
        if cfg.PromoNotify then
            task.spawn(function()
                while GaphopUI.WindowInstance and GaphopUI.WindowInstance.Parent do
                    task.wait(300)
                    GaphopUI:Notify({
                        Title = "Enjoying GaphopUI?",
                        Content = "Consider starring the repo on GitHub!",
                        Duration = 6,
                    })
                end
            end)
        end
    end

    if not cfg.NoLoading then
        -- Simple loading splash
        local splash = Instance.new("Frame")
        splash.Size = UDim2.fromOffset(0, 0)
        splash.AnchorPoint = Vector2.new(0.5, 0.5)
        splash.Position = UDim2.fromScale(0.5, 0.5)
        splash.BackgroundColor3 = theme.Background
        splash.BackgroundTransparency = 0.2
        splash.ZIndex = 100
        splash.Parent = ScreenGui
        ApplyLiquidGlass(splash, theme, { Radius = 18 })
        SoftSpring(splash, 0.4, { Size = UDim2.fromOffset(320, 160) })
        local st = Instance.new("TextLabel")
        st.Size = UDim2.new(1, 0, 1, 0)
        st.BackgroundTransparency = 1
        st.Text = cfg.LoadingTitle or "GaphopUI Engine"
        st.TextColor3 = theme.Text
        st.TextSize = 18
        st.Font = Enum.Font.GothamBold
        st.ZIndex = 101
        st.Parent = splash
        task.delay(1.1, function()
            SoftSpring(splash, 0.3, { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 })
            task.delay(0.35, function()
                if splash then splash:Destroy() end
                ShowWindow()
            end)
        end)
    else
        ShowWindow()
    end

    return WindowObj
end

GaphopUI.CreateWindow = GaphopUI.makeWindow

-- Flags helpers
function GaphopUI:SetFlag(name, value)
    self.Flags[name] = value
    if self.FlagChanged[name] then
        for _, cb in ipairs(self.FlagChanged[name]) do pcall(cb, value) end
    end
    DebouncedSave()
end
function GaphopUI:GetFlag(name)
    return self.Flags[name]
end
function GaphopUI:OnFlagChanged(name, cb)
    self.FlagChanged[name] = self.FlagChanged[name] or {}
    table.insert(self.FlagChanged[name], cb)
end

-- Debug self-test
function GaphopUI:Debug()
    local w = self:CreateWindow({ Name = "GaphopUI Debug", NoLoading = true, WelcomeNotify = false })
    local t = w:CreateTab("All Elements", "settings")
    t:CreateSection("Buttons & Toggles")
    t:CreateButton({ Name = "Test Button", Callback = function() print("Button") end })
    t:CreateToggle({ Name = "Test Toggle", CurrentValue = false, Callback = print })
    t:CreateSlider({ Name = "Test Slider", Range = {0, 100}, CurrentValue = 50, Callback = print })
    t:CreateInput({ Name = "Test Input", PlaceholderText = "Type...", Callback = print })
    t:CreateDropdown({ Name = "Test Drop", Options = {"A", "B", "C"}, CurrentOption = "A", Callback = print })
    t:CreateKeybind({ Name = "Test Key", CurrentKeybind = Enum.KeyCode.F, Callback = print })
    t:CreateColorPicker({ Name = "Test Color", Color = Color3.fromRGB(0, 162, 255), Callback = print })
    t:CreateLabel({ Name = "Status Label", Description = "Debug running" })
    t:CreateParagraph({ Title = "Info", Content = "All core elements rendered." })
    self:Notify({ Title = "Debug", Content = "Self-test window opened", Duration = 3 })
end

return GaphopUI
