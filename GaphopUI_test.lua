-- STREAMING_CHUNK:Initializing Services and Core Environment...
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gethui = gethui or function()
local success, hui = pcall(function() return CoreGui end)
return success and hui or PlayerGui
end

local cloneref = cloneref or function(obj) return obj end

-- STREAMING_CHUNK:Defining GaphopUI Global Registry & Settings...
local GaphopUI = {
Version = "4.0.0",
Codename = "Liquid Glass Pro",
ActiveTweens = {},
Connections = {},
Flags = {},
Themes = {
Ocean = {
Main = Color3.fromRGB(15, 23, 42),
Secondary = Color3.fromRGB(30, 41, 59),
Accent = Color3.fromRGB(56, 189, 248),
Text = Color3.fromRGB(241, 245, 249),
SubText = Color3.fromRGB(148, 163, 184),
Border = Color3.fromRGB(51, 65, 85),
Glow = Color3.fromRGB(56, 189, 248)
},
Midnight = {
Main = Color3.fromRGB(10, 10, 12),
Secondary = Color3.fromRGB(20, 20, 26),
Accent = Color3.fromRGB(139, 92, 246),
Text = Color3.fromRGB(250, 250, 250),
SubText = Color3.fromRGB(161, 161, 170),
Border = Color3.fromRGB(39, 39, 42),
Glow = Color3.fromRGB(139, 92, 246)
},
Sunset = {
Main = Color3.fromRGB(24, 15, 23),
Secondary = Color3.fromRGB(42, 26, 40),
Accent = Color3.fromRGB(244, 63, 94),
Text = Color3.fromRGB(255, 241, 242),
SubText = Color3.fromRGB(219, 112, 147),
Border = Color3.fromRGB(68, 39, 61),
Glow = Color3.fromRGB(244, 63, 94)
}
},
Settings = {
Theme = "Ocean",
Effects = true,
AnimationSpeed = 1.0,
GlassTransparency = 0.35,
BlurIntensity = 15
}
}

-- STREAMING_CHUNK:Configuring Tween Manager and Animation Helpers...
local function SafeTween(instance, tweenInfo, properties)
if not instance or not instance.Parent then return end
if not GaphopUI.Settings.Effects then
for k, v in pairs(properties) do
pcall(function() instance[k] = v end)
end
return
end

local animSpeed = math.clamp(GaphopUI.Settings.AnimationSpeed or 1.0, 0.2, 3)
local scaledInfo

if typeof(tweenInfo) == "TweenInfo" then
    scaledInfo = TweenInfo.new(
        tweenInfo.Time / animSpeed,
        tweenInfo.EasingStyle,
        tweenInfo.EasingDirection,
        tweenInfo.RepeatCount,
        tweenInfo.Reverses,
        tweenInfo.DelayTime
    )
elseif typeof(tweenInfo) == "table" then
    local time = (tweenInfo[1] or 0.3) / animSpeed
    local style = tweenInfo[2] or Enum.EasingStyle.Quad
    local direction = tweenInfo[3] or Enum.EasingDirection.Out
    local repeatCount = tweenInfo[4] or 0
    local reverses = tweenInfo[5] or false
    local delayTime = tweenInfo[6] or 0
    scaledInfo = TweenInfo.new(time, style, direction, repeatCount, reverses, delayTime)
else
    scaledInfo = TweenInfo.new(0.3 / animSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

local key = tostring(instance) .. "_" .. tostring(properties)
if GaphopUI.ActiveTweens[key] then
    pcall(function() GaphopUI.ActiveTweens[key]:Cancel() end)
end

local tween = TweenService:Create(instance, scaledInfo, properties)
GaphopUI.ActiveTweens[key] = tween
tween:Play()
return tween


end

-- STREAMING_CHUNK:Constructing Liquid Glass Engine Styles...
local function ApplyGlassStyling(element, cornerRadius, customTransparency)
local currentTheme = GaphopUI.Themes[GaphopUI.Settings.Theme] or GaphopUI.Themes.Ocean

local corner = Instance.new("UICorner")
corner.CornerRadius = cornerRadius or UDim.new(0, 12)
corner.Parent = element

local stroke = Instance.new("UIStroke")
stroke.Name = "GlassOuterStroke"
stroke.Color = currentTheme.Border
stroke.Transparency = 0.4
stroke.Thickness = 1.2
stroke.Parent = element

local innerStroke = Instance.new("UIStroke")
innerStroke.Name = "GlassInnerStroke"
innerStroke.Color = currentTheme.Accent
innerStroke.Transparency = 0.8
innerStroke.Thickness = 0.8
innerStroke.Parent = element

if element:IsA("GuiObject") then
    element.BackgroundColor3 = currentTheme.Secondary
    element.BackgroundTransparency = customTransparency or GaphopUI.Settings.GlassTransparency
end

return stroke


end

-- STREAMING_CHUNK:Building Window and Layout Core...
function GaphopUI:CreateWindow(config)
config = config or {}
local windowName = config.Name or "GaphopUI v4.0"
local loadingTitle = config.LoadingTitle or "GaphopUI"
local loadingSubtitle = config.LoadingSubtitle or "Liquid Glass Pro"

local currentTheme = self.Themes[self.Settings.Theme] or self.Themes.Ocean

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GaphopUI_" .. math.random(1000, 9999)
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success, parent = pcall(function()
    return gethui()
end)
screenGui.Parent = success and parent or PlayerGui

-- Loading Screen Overlay
local loadOverlay = Instance.new("Frame")
loadOverlay.Name = "LoadingOverlay"
loadOverlay.Size = UDim2.new(1, 0, 1, 0)
loadOverlay.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
loadOverlay.BackgroundTransparency = 0.2
loadOverlay.ZIndex = 100
loadOverlay.Parent = screenGui

local loadCard = Instance.new("Frame")
loadCard.Size = UDim2.new(0, 380, 0, 180)
loadCard.Position = UDim2.new(0.5, -190, 0.5, -90)
loadCard.BackgroundColor3 = currentTheme.Main
loadCard.BackgroundTransparency = 0.1
loadCard.ZIndex = 101
loadCard.Parent = loadOverlay
ApplyGlassStyling(loadCard, UDim.new(0, 16), 0.1)

local loadTitleLabel = Instance.new("TextLabel")
loadTitleLabel.Size = UDim2.new(1, -40, 0, 40)
loadTitleLabel.Position = UDim2.new(0, 20, 0, 25)
loadTitleLabel.BackgroundTransparency = 1
loadTitleLabel.Font = Enum.Font.GothamBold
loadTitleLabel.Text = loadingTitle
loadTitleLabel.TextColor3 = currentTheme.Text
loadTitleLabel.TextSize = 22
loadTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
loadTitleLabel.ZIndex = 102
loadTitleLabel.Parent = loadCard

local loadSubLabel = Instance.new("TextLabel")
loadSubLabel.Size = UDim2.new(1, -40, 0, 30)
loadSubLabel.Position = UDim2.new(0, 20, 0, 70)
loadSubLabel.BackgroundTransparency = 1
loadSubLabel.Font = Enum.Font.GothamMedium
loadSubLabel.Text = loadingSubtitle
loadSubLabel.TextColor3 = currentTheme.SubText
loadSubLabel.TextSize = 14
loadSubLabel.TextXAlignment = Enum.TextXAlignment.Left
loadSubLabel.ZIndex = 102
loadSubLabel.Parent = loadCard

local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(1, -40, 0, 6)
loadBarBg.Position = UDim2.new(0, 20, 1, -35)
loadBarBg.BackgroundColor3 = currentTheme.Border
loadBarBg.ZIndex = 102
loadBarBg.Parent = loadCard
Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(1, 0)

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = currentTheme.Accent
loadBarFill.ZIndex = 103
loadBarFill.Parent = loadBarBg
Instance.new("UICorner", loadBarFill).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    print("-- [GaphopUI] v4.0 'Liquid Glass Pro' loading...")
    SafeTween(loadBarFill, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    task.wait(1.0)
    SafeTween(loadOverlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    SafeTween(loadCard, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    task.wait(0.5)
    loadOverlay:Destroy()
    print("-- [GaphopUI] v4.0 loaded successfully. Ready.")
end)

-- Main Window Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "WindowMain"
mainFrame.Size = UDim2.new(0, 680, 0, 460)
mainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
mainFrame.BackgroundColor3 = currentTheme.Main
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
ApplyGlassStyling(mainFrame, UDim.new(0, 14), 0.25)

-- Window Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 16, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = windowName
titleLabel.TextColor3 = currentTheme.Text
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Close & Minimize Buttons
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
closeBtn.BackgroundColor3 = currentTheme.Secondary
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "×"
closeBtn.TextColor3 = currentTheme.Text
closeBtn.TextSize = 18
closeBtn.Parent = topBar
ApplyGlassStyling(closeBtn, UDim.new(0, 8), 0.5)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Window Draggable logic
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Navigation Sidebar & Container
local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 180, 1, -55)
sidebar.Position = UDim2.new(0, 10, 0, 45)
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ScrollBarThickness = 2
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 6)
sidebarLayout.Parent = sidebar

local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -200, 1, -55)
contentContainer.Position = UDim2.new(0, 195, 0, 45)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local windowObj = {
    ScreenGui = screenGui,
    MainFrame = mainFrame,
    Sidebar = sidebar,
    ContentContainer = contentContainer,
    Tabs = {}
}

function windowObj:CreateTab(tabName, icon)
    local tabIndex = #windowObj.Tabs + 1
    
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 38)
    tabButton.BackgroundColor3 = tabIndex == 1 and currentTheme.Accent or currentTheme.Secondary
    tabButton.BackgroundTransparency = tabIndex == 1 and 0.1 or 0.7
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.Text = "  " .. tabName
    tabButton.TextColor3 = currentTheme.Text
    tabButton.TextSize = 13
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Parent = sidebar
    ApplyGlassStyling(tabButton, UDim.new(0, 8), tabIndex == 1 and 0.1 or 0.7)
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = tabName .. "_Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Visible = tabIndex == 1
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.ScrollBarThickness = 3
    tabContent.Parent = contentContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.Parent = tabContent
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingRight = UDim.new(0, 8)
    tabPadding.Parent = tabContent
    
    tabButton.MouseButton1Click:Connect(function()
        for _, t in ipairs(windowObj.Tabs) do
            t.Content.Visible = false
            SafeTween(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.7})
            t.Button.BackgroundColor3 = currentTheme.Secondary
        end
        tabContent.Visible = true
        SafeTween(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1})
        tabButton.BackgroundColor3 = currentTheme.Accent
    end)
    
    local tabObj = {
        Button = tabButton,
        Content = tabContent
    }
    
    table.insert(windowObj.Tabs, tabObj)
    
    function tabObj:CreateSection(sectionName)
        local secLabel = Instance.new("TextLabel")
        secLabel.Size = UDim2.new(1, 0, 0, 24)
        secLabel.BackgroundTransparency = 1
        secLabel.Font = Enum.Font.GothamBold
        secLabel.Text = sectionName:upper()
        secLabel.TextColor3 = currentTheme.SubText
        secLabel.TextSize = 11
        secLabel.TextXAlignment = Enum.TextXAlignment.Left
        secLabel.Parent = tabContent
        return secLabel
    end
    
    function tabObj:CreateButton(btnConfig)
        btnConfig = btnConfig or {}
        local name = btnConfig.Name or "Button"
        local callback = btnConfig.Callback or function() end
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = currentTheme.Secondary
        btn.Font = Enum.Font.GothamMedium
        btn.Text = "  " .. name
        btn.TextColor3 = currentTheme.Text
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = tabContent
        ApplyGlassStyling(btn, UDim.new(0, 10), 0.5)
        
        btn.MouseButton1Click:Connect(function()
            SafeTween(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2})
            task.delay(0.1, function()
                SafeTween(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5})
            end)
            task.spawn(callback)
        end)
    end
    
    function tabObj:CreateToggle(toggleConfig)
        toggleConfig = toggleConfig or {}
        local name = toggleConfig.Name or "Toggle"
        local default = toggleConfig.CurrentValue or false
        local callback = toggleConfig.Callback or function() end
        
        local toggled = default
        GaphopUI.Flags[name] = toggled
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 44)
        container.BackgroundColor3 = currentTheme.Secondary
        container.Parent = tabContent
        ApplyGlassStyling(container, UDim.new(0, 10), 0.5)
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -70, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = name
        lbl.TextColor3 = currentTheme.Text
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = container
        
        local switchBg = Instance.new("Frame")
        switchBg.Size = UDim2.new(0, 44, 0, 22)
        switchBg.Position = UDim2.new(1, -54, 0.5, -11)
        switchBg.BackgroundColor3 = toggled and currentTheme.Accent or currentTheme.Border
        switchBg.Parent = container
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
        
        local switchDot = Instance.new("Frame")
        switchDot.Size = UDim2.new(0, 18, 0, 18)
        switchDot.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        switchDot.BackgroundColor3 = currentTheme.Text
        switchDot.Parent = switchBg
        Instance.new("UICorner", switchDot).CornerRadius = UDim.new(1, 0)
        
        local function updateToggle(state)
            toggled = state
            GaphopUI.Flags[name] = toggled
            SafeTween(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = toggled and currentTheme.Accent or currentTheme.Border})
            SafeTween(switchDot, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
            task.spawn(function() callback(toggled) end)
        end
        
        container.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                updateToggle(not toggled)
            end
        end)
    end
    
    function tabObj:CreateSlider(sliderConfig)
        sliderConfig = sliderConfig or {}
        local name = sliderConfig.Name or "Slider"
        local range = sliderConfig.Range or {0, 100}
        local default = sliderConfig.CurrentValue or range[1]
        local suffix = sliderConfig.Suffix or ""
        local callback = sliderConfig.Callback or function() end
        
        local min, max = range[1], range[2]
        local value = math.clamp(default, min, max)
        GaphopUI.Flags[name] = value
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 60)
        container.BackgroundColor3 = currentTheme.Secondary
        container.Parent = tabContent
        ApplyGlassStyling(container, UDim.new(0, 10), 0.5)
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -120, 0, 24)
        lbl.Position = UDim2.new(0, 14, 0, 8)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = name
        lbl.TextColor3 = currentTheme.Text
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = container
        
        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0, 100, 0, 24)
        valLbl.Position = UDim2.new(1, -114, 0, 8)
        valLbl.BackgroundTransparency = 1
        valLbl.Font = Enum.Font.GothamBold
        valLbl.Text = tostring(value) .. suffix
        valLbl.TextColor3 = currentTheme.Accent
        valLbl.TextSize = 13
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.Parent = container
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, -28, 0, 6)
        sliderBar.Position = UDim2.new(0, 14, 0, 40)
        sliderBar.BackgroundColor3 = currentTheme.Border
        sliderBar.Parent = container
        Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = currentTheme.Accent
        sliderFill.Parent = sliderBar
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
        
        local sliding = false
        local function updateSlider(input)
            local posRatio = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * posRatio)
            GaphopUI.Flags[name] = value
            sliderFill.Size = UDim2.new(posRatio, 0, 1, 0)
            valLbl.Text = tostring(value) .. suffix
            task.spawn(function() callback(value) end)
        end
        
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
    end
    
    return tabObj
end

return windowObj


end

-- STREAMING_CHUNK:Debug and Diagnostic Utility...
function GaphopUI:Debug()
print("-- [GaphopUI] Running Diagnostic Suite v4.0...")
local testWin = self:CreateWindow({
Name = "Diagnostic Test Window",
LoadingTitle = "Diagnostics",
LoadingSubtitle = "Testing Liquid Glass Engine"
})
local tab = testWin:CreateTab("Diagnostics", "terminal")
tab:CreateSection("System Status")
tab:CreateButton({
Name = "Print Success Status",
Callback = function()
print("-- [GaphopUI] Test Button Clicked successfully!")
end
})
tab:CreateToggle({
Name = "Test Toggle Switch",
CurrentValue = true,
Callback = function(v)
print("-- [GaphopUI] Toggle state changed:", v)
end
})
tab:CreateSlider({
Name = "Test Slider",
Range = {0, 100},
CurrentValue = 50,
Suffix = "%",
Callback = function(v)
print("-- [GaphopUI] Slider value:", v)
end
})
end

return GaphopUI
