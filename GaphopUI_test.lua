-- STREAMING_CHUNK:Initializing Services and Local Variables...
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerMouse = LocalPlayer:GetMouse()

-- STREAMING_CHUNK:Resolving Safe Parent Container for UI Rendering...
local function GetSafeParent()
if type(gethui) == "function" then
local ok, res = pcall(gethui)
if ok and res then return res end
end

if type(cloneref) == "function" then
    local ok, res = pcall(function() return cloneref(CoreGui) end)
    if ok and res then return res end
end

local ok, res = pcall(function() return CoreGui end)
if ok and res then return res end

if LocalPlayer then
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then
        pcall(function() pg = LocalPlayer:WaitForChild("PlayerGui", 3) end)
    end
    if pg then return pg end
end

return fallback


end

local ParentUI = GetSafeParent()

-- STREAMING_CHUNK:Cleaning up existing instances...
if ParentUI then
for _, child in ipairs(ParentUI:GetChildren()) do
if child.Name == "GaphopUI_Engine" then
child:Destroy()
end
end
end

-- STREAMING_CHUNK:Defining Ultimate Library Configurations & Color Palettes...
local GaphopUI = {}
GaphopUI.Instances = {}

GaphopUI.Icons = {
info = "ⓘ", bell = "🔔", menu = "☰", plus = "+", minus = "−", check = "✓", slider = "▭",
layers = "☰", cog = "⚙", chevron = "⌵", shield = "🛡", zap = "⚡", star = "★", key = "🔑", copy = "📋"
}

GaphopUI.Themes = {
Dark = { Background = Color3.fromRGB(16, 17, 23), Card = Color3.fromRGB(25, 27, 38), CardHover = Color3.fromRGB(34, 37, 52), Header = Color3.fromRGB(20, 22, 31), Accent = Color3.fromRGB(0, 162, 255), AccentGlow = Color3.fromRGB(0, 140, 230), Text = Color3.fromRGB(245, 247, 252), SubText = Color3.fromRGB(150, 155, 175), Border = Color3.fromRGB(45, 50, 68), ToggleOn = Color3.fromRGB(0, 162, 255), ToggleOff = Color3.fromRGB(40, 44, 58), SliderBar = Color3.fromRGB(38, 42, 56), InputBackground = Color3.fromRGB(21, 23, 32), Shadow = Color3.fromRGB(0, 0, 0), Red = Color3.fromRGB(255, 75, 75), Green = Color3.fromRGB(75, 255, 120) },
Midnight = { Background = Color3.fromRGB(11, 11, 20), Card = Color3.fromRGB(20, 20, 36), CardHover = Color3.fromRGB(28, 28, 48), Header = Color3.fromRGB(15, 15, 26), Accent = Color3.fromRGB(130, 90, 255), AccentGlow = Color3.fromRGB(110, 70, 230), Text = Color3.fromRGB(245, 245, 255), SubText = Color3.fromRGB(145, 145, 178), Border = Color3.fromRGB(45, 45, 75), ToggleOn = Color3.fromRGB(130, 90, 255), ToggleOff = Color3.fromRGB(32, 32, 52), SliderBar = Color3.fromRGB(32, 32, 55), InputBackground = Color3.fromRGB(16, 16, 28), Shadow = Color3.fromRGB(0, 0, 0), Red = Color3.fromRGB(255, 75, 75), Green = Color3.fromRGB(75, 255, 120) }
}

-- STREAMING_CHUNK:Defining Utility and Tweening Helpers...
local function Tween(instance, info, properties)
local tweenInfo = TweenInfo.new(info[1], info[2] or Enum.EasingStyle.Quad, info[3] or Enum.EasingDirection.Out)
local tween = TweenService:Create(instance, tweenInfo, properties)
tween:Play()
return tween
end

local function MakeDraggable(topbarobject, object)
local Dragging = false
local DragInput
local DragStart
local StartPosition

topbarobject.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPosition = object.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

topbarobject.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)


-- STREAMING_CHUNK:Applying Drag Logic via RunService...
RunService.RenderStepped:Connect(function()
if Dragging and DragInput then
local delta = DragInput.Position - DragStart
local targetPos = UDim2.new(
StartPosition.X.Scale, StartPosition.X.Offset + delta.X,
StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y
)
Tween(object, {0.15, Enum.EasingStyle.Sine}, {Position = targetPos})
end
end)
end

local function CreateCorner(parent, radius)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, radius or 8)
corner.Parent = parent
return corner
end

local function CreateStroke(parent, color, thickness, transparency)
local stroke = Instance.new("UIStroke")
stroke.Color = color or Color3.fromRGB(255, 255, 255)
stroke.Thickness = thickness or 1
stroke.Transparency = transparency or 0.8
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = parent
return stroke
end

-- STREAMING_CHUNK:Building Window and Key System Initialization...
function GaphopUI:CreateWindow(Options)
Options = Options or {}
local Title = Options.Name or "GaphopUI Engine"
local Theme = GaphopUI.Themes[Options.Theme] or GaphopUI.Themes.Dark
local KeySystemConfig = Options.KeySystem or nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GaphopUI_Engine"
ScreenGui.DisplayOrder = 999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = ParentUI end)
if not success and LocalPlayer then
    pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end

table.insert(GaphopUI.Instances, ScreenGui)

-- Container for notifications
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 300, 1, -20)
NotifContainer.Position = UDim2.new(1, -320, 0, 20)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Parent = NotifContainer


-- STREAMING_CHUNK:Constructing Main CanvasGroup Frame...
local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 420)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.GroupTransparency = 1 -- Hidden initially
MainFrame.Parent = ScreenGui
CreateCorner(MainFrame, 12)
CreateStroke(MainFrame, Theme.Border, 1, 0)
MakeDraggable(MainFrame, MainFrame)

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundColor3 = Theme.Header
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarLine = Instance.new("Frame")
TopbarLine.Size = UDim2.new(1, 0, 0, 1)
TopbarLine.Position = UDim2.new(0, 0, 1, 0)
TopbarLine.BackgroundColor3 = Theme.Border
TopbarLine.BorderSizePixel = 0
TopbarLine.Parent = Topbar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = Title
TitleText.TextColor3 = Theme.Text
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = Topbar


-- STREAMING_CHUNK:Constructing Sidebar and Tab Containers...
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Theme.Header
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -160, 1, -45)
ContentContainer.Position = UDim2.new(0, 160, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Window = {
    Tabs = {},
    CurrentTab = nil
}


-- STREAMING_CHUNK:Implementing Notification System...
function Window:Notify(options)
local nTitle = options.Title or "Notification"
local nContent = options.Content or "Description here"
local duration = options.Duration or 3

    local NotifCard = Instance.new("Frame")
    NotifCard.Size = UDim2.new(1, 0, 0, 0)
    NotifCard.BackgroundColor3 = Theme.Card
    NotifCard.BackgroundTransparency = 1
    NotifCard.ClipsDescendants = true
    NotifCard.Parent = NotifContainer
    CreateCorner(NotifCard, 8)
    local stroke = CreateStroke(NotifCard, Theme.Border, 1, 1)

    local NTitleLabel = Instance.new("TextLabel")
    NTitleLabel.Size = UDim2.new(1, -20, 0, 25)
    NTitleLabel.Position = UDim2.new(0, 10, 0, 10)
    NTitleLabel.BackgroundTransparency = 1
    NTitleLabel.Text = nTitle
    NTitleLabel.TextColor3 = Theme.Text
    NTitleLabel.TextSize = 14
    NTitleLabel.Font = Enum.Font.GothamBold
    NTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    NTitleLabel.TextTransparency = 1
    NTitleLabel.Parent = NotifCard

    local NDescLabel = Instance.new("TextLabel")
    NDescLabel.Size = UDim2.new(1, -20, 0, 20)
    NDescLabel.Position = UDim2.new(0, 10, 0, 35)
    NDescLabel.BackgroundTransparency = 1
    NDescLabel.Text = nContent
    NDescLabel.TextColor3 = Theme.SubText
    NDescLabel.TextSize = 13
    NDescLabel.Font = Enum.Font.Gotham
    NDescLabel.TextXAlignment = Enum.TextXAlignment.Left
    NDescLabel.TextWrapped = true
    NDescLabel.TextTransparency = 1
    NDescLabel.Parent = NotifCard


-- STREAMING_CHUNK:Animating Notification Entrance and Exit...
NotifCard.Size = UDim2.new(1, 0, 0, 65)
NotifCard.Position = UDim2.new(1, 20, 0, 0)

    Tween(NotifCard, {0.4, Enum.EasingStyle.Back}, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0})
    Tween(stroke, {0.3}, {Transparency = 0})
    Tween(NTitleLabel, {0.3}, {TextTransparency = 0})
    Tween(NDescLabel, {0.3}, {TextTransparency = 0})

    task.delay(duration, function()
        Tween(NotifCard, {0.4, Enum.EasingStyle.Sine}, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
        Tween(stroke, {0.3}, {Transparency = 1})
        Tween(NTitleLabel, {0.3}, {TextTransparency = 1})
        Tween(NDescLabel, {0.3}, {TextTransparency = 1})
        task.wait(0.4)
        NotifCard:Destroy()
    end)
end


-- STREAMING_CHUNK:Implementing Key System Logic & UI...
local function ValidateKey(inputKey)
if not KeySystemConfig then return true end

    if KeySystemConfig.GrabKeyFromSite then
        local success, response = pcall(function()
            return game:HttpGet(KeySystemConfig.Key)
        end)
        if success and response then
            -- Try to find key in JSON or raw text
            if string.find(response, inputKey) then return true end
            pcall(function()
                local decoded = HttpService:JSONDecode(response)
                if decoded.key == inputKey or decoded.pass == inputKey then
                    return true
                end
            end)
        end
    else
        if type(KeySystemConfig.Key) == "table" then
            for _, k in pairs(KeySystemConfig.Key) do
                if k == inputKey then return true end
            end
        elseif KeySystemConfig.Key == inputKey then
            return true
        end
    end
    return false
end

if KeySystemConfig then
    local KeyFrame = Instance.new("CanvasGroup")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Size = UDim2.new(0, 400, 0, 250)
    KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    KeyFrame.BackgroundColor3 = Theme.Background
    KeyFrame.Parent = ScreenGui
    CreateCorner(KeyFrame, 12)
    local KeyStroke = CreateStroke(KeyFrame, Theme.Border, 1, 0)
    MakeDraggable(KeyFrame, KeyFrame)

    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1, 0, 0, 40)
    KTitle.BackgroundTransparency = 1
    KTitle.Text = Title .. " - Key System"
    KTitle.TextColor3 = Theme.Text
    KTitle.TextSize = 16
    KTitle.Font = Enum.Font.GothamBold
    KTitle.Parent = KeyFrame

    local KDesc = Instance.new("TextLabel")
    KDesc.Size = UDim2.new(1, -40, 0, 40)
    KDesc.Position = UDim2.new(0, 20, 0, 40)
    KDesc.BackgroundTransparency = 1
    KDesc.Text = KeySystemConfig.Description or "Vui lòng nhập key để tiếp tục."
    KDesc.TextColor3 = Theme.SubText
    KDesc.TextSize = 13
    KDesc.TextWrapped = true
    KDesc.Font = Enum.Font.Gotham
    KDesc.Parent = KeyFrame


-- STREAMING_CHUNK:Building Key Input Box and Buttons...
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 40)
KeyInput.Position = UDim2.new(0, 20, 0, 90)
KeyInput.BackgroundColor3 = Theme.InputBackground
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.TextColor3 = Theme.Text
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Gotham
KeyInput.Parent = KeyFrame
CreateCorner(KeyInput, 6)
CreateStroke(KeyInput, Theme.Border, 1, 0)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(0.45, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0, 20, 0, 150)
    VerifyBtn.BackgroundColor3 = Theme.Accent
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.TextSize = 14
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.Parent = KeyFrame
    CreateCorner(VerifyBtn, 6)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.45, 0, 0, 40)
    GetKeyBtn.Position = UDim2.new(1, -20 - (400 * 0.45), 0, 150)
    GetKeyBtn.BackgroundColor3 = Theme.CardHover
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.TextColor3 = Theme.Text
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Parent = KeyFrame
    CreateCorner(GetKeyBtn, 6)


-- STREAMING_CHUNK:Scripting Key Verification and Clipboard Actions...
GetKeyBtn.MouseButton1Click:Connect(function()
if KeySystemConfig.Link then
local link = KeySystemConfig.Link
if type(setclipboard) == "function" then
pcall(function() setclipboard(link) end)
Window:Notify({Title = "Thành công", Content = "Đã copy link lấy key vào bộ nhớ tạm!", Duration = 3})
elseif type(toclipboard) == "function" then
pcall(function() toclipboard(link) end)
Window:Notify({Title = "Thành công", Content = "Đã copy link lấy key vào bộ nhớ tạm!", Duration = 3})
else
KeyInput.Text = link
Window:Notify({Title = "Lưu ý", Content = "Executor không hỗ trợ copy, link đã dán vào ô nhập key. Hãy copy nó!", Duration = 5})
end
end
end)

    VerifyBtn.MouseButton1Click:Connect(function()
        local input = KeyInput.Text
        if ValidateKey(input) then
            VerifyBtn.Text = "Thành công!"
            VerifyBtn.BackgroundColor3 = Theme.Green
            Tween(KeyFrame, {0.5, Enum.EasingStyle.Sine}, {GroupTransparency = 1})
            task.wait(0.5)
            KeyFrame:Destroy()
            
            -- Show main UI
            MainFrame.Position = UDim2.new(0.5, -325, 0.5, -190)
            Tween(MainFrame, {0.5, Enum.EasingStyle.Quint}, {GroupTransparency = 0, Position = UDim2.new(0.5, -325, 0.5, -210)})
            Window:Notify({Title = "Xác thực thành công", Content = "Chào mừng tới " .. Title, Duration = 4})
        else
            VerifyBtn.Text = "Key Sai!"
            VerifyBtn.BackgroundColor3 = Theme.Red
            KeyStroke.Color = Theme.Red
            
            -- Shake effect
            local origPos = KeyFrame.Position
            for i = 1, 4 do
                KeyFrame.Position = origPos + UDim2.new(0, math.random(-5, 5), 0, math.random(-5, 5))
                task.wait(0.05)
            end
            KeyFrame.Position = origPos
            
            task.wait(1)
            VerifyBtn.Text = "Verify Key"
            VerifyBtn.BackgroundColor3 = Theme.Accent
            KeyStroke.Color = Theme.Border
        end
    end)
else
    -- If no key system, show UI immediately
    MainFrame.GroupTransparency = 0
end


-- STREAMING_CHUNK:Defining Tab Creation Functionality...
function Window:MakeTab(TabOptions)
local TName = TabOptions.Name or "Tab"
local TIcon = TabOptions.Icon or "layers"

    local TabButton = Instance.new("TextButton")
    TabButton.Name = TName
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Theme.Card
    TabButton.BackgroundTransparency = 1
    TabButton.Text = ""
    TabButton.Parent = Sidebar
    CreateCorner(TabButton, 6)

    local TabIcon = Instance.new("TextLabel")
    TabIcon.Size = UDim2.new(0, 30, 1, 0)
    TabIcon.Position = UDim2.new(0, 5, 0, 0)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = GaphopUI.Icons[TIcon] or GaphopUI.Icons["layers"]
    TabIcon.TextColor3 = Theme.SubText
    TabIcon.TextSize = 14
    TabIcon.Font = Enum.Font.Gotham
    TabIcon.Parent = TabButton

    local TabText = Instance.new("TextLabel")
    TabText.Size = UDim2.new(1, -35, 1, 0)
    TabText.Position = UDim2.new(0, 35, 0, 0)
    TabText.BackgroundTransparency = 1
    TabText.Text = TName
    TabText.TextColor3 = Theme.SubText
    TabText.TextSize = 14
    TabText.Font = Enum.Font.GothamBold
    TabText.TextXAlignment = Enum.TextXAlignment.Left
    TabText.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = TName .. "Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = Theme.Border
    TabPage.Visible = false
    TabPage.Parent = ContentContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = TabPage

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingBottom = UDim.new(0, 10)
    PagePadding.PaddingLeft = UDim.new(0, 10)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.Parent = TabPage


-- STREAMING_CHUNK:Tab Switch Logic and Auto-Size Scrolling...
PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
end)

    local function SelectTab()
        if Window.CurrentTab then
            Tween(Window.CurrentTab.Btn, {0.2}, {BackgroundTransparency = 1})
            Tween(Window.CurrentTab.Text, {0.2}, {TextColor3 = Theme.SubText})
            Tween(Window.CurrentTab.Icon, {0.2}, {TextColor3 = Theme.SubText})
            Window.CurrentTab.Page.Visible = false
        end
        Window.CurrentTab = {Btn = TabButton, Text = TabText, Icon = TabIcon, Page = TabPage}
        
        Tween(TabButton, {0.2}, {BackgroundTransparency = 0})
        Tween(TabText, {0.2}, {TextColor3 = Theme.Text})
        Tween(TabIcon, {0.2}, {TextColor3 = Theme.Accent})
        TabPage.Visible = true
    end

    TabButton.MouseButton1Click:Connect(SelectTab)

    if #Window.Tabs == 0 then
        SelectTab()
    end
    table.insert(Window.Tabs, TabPage)

    local Elements = {}


-- STREAMING_CHUNK:Implementing AddButton Function...
function Elements:AddButton(BtnOptions)
local BName = BtnOptions.Name or "Button"
local Callback = BtnOptions.Callback or function() end

        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
        ButtonFrame.BackgroundColor3 = Theme.Card
        ButtonFrame.Text = ""
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.Parent = TabPage
        CreateCorner(ButtonFrame, 6)
        CreateStroke(ButtonFrame, Theme.Border, 1, 0)

        local BText = Instance.new("TextLabel")
        BText.Size = UDim2.new(1, -20, 1, 0)
        BText.Position = UDim2.new(0, 15, 0, 0)
        BText.BackgroundTransparency = 1
        BText.Text = BName
        BText.TextColor3 = Theme.Text
        BText.TextSize = 14
        BText.Font = Enum.Font.Gotham
        BText.TextXAlignment = Enum.TextXAlignment.Left
        BText.Parent = ButtonFrame

        local BIcon = Instance.new("TextLabel")
        BIcon.Size = UDim2.new(0, 20, 1, 0)
        BIcon.Position = UDim2.new(1, -30, 0, 0)
        BIcon.BackgroundTransparency = 1
        BIcon.Text = "→"
        BIcon.TextColor3 = Theme.SubText
        BIcon.TextSize = 16
        BIcon.Font = Enum.Font.GothamBold
        BIcon.Parent = ButtonFrame

        ButtonFrame.MouseEnter:Connect(function()
            Tween(ButtonFrame, {0.2}, {BackgroundColor3 = Theme.CardHover})
            Tween(BIcon, {0.2}, {Position = UDim2.new(1, -25, 0, 0), TextColor3 = Theme.Text})
        end)

        ButtonFrame.MouseLeave:Connect(function()
            Tween(ButtonFrame, {0.2}, {BackgroundColor3 = Theme.Card})
            Tween(BIcon, {0.2}, {Position = UDim2.new(1, -30, 0, 0), TextColor3 = Theme.SubText})
        end)

        ButtonFrame.MouseButton1Click:Connect(function()
            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 0, 0, 0)
            circle.Position = UDim2.new(0.5, 0, 0.5, 0)
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.BackgroundColor3 = Theme.Text
            circle.BackgroundTransparency = 0.8
            circle.Parent = ButtonFrame
            CreateCorner(circle, 999)
            
            Tween(circle, {0.4}, {Size = UDim2.new(1, 50, 1, 50), BackgroundTransparency = 1})
            task.wait(0.4)
            circle:Destroy()
            
            pcall(Callback)
        end)
    end


-- STREAMING_CHUNK:Implementing AddToggle Function...
function Elements:AddToggle(TogOptions)
local TName = TogOptions.Name or "Toggle"
local Default = TogOptions.Default or false
local Callback = TogOptions.Callback or function() end
local State = Default

        local ToggleFrame = Instance.new("TextButton")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Theme.Card
        ToggleFrame.Text = ""
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.Parent = TabPage
        CreateCorner(ToggleFrame, 6)
        CreateStroke(ToggleFrame, Theme.Border, 1, 0)

        local TText = Instance.new("TextLabel")
        TText.Size = UDim2.new(1, -60, 1, 0)
        TText.Position = UDim2.new(0, 15, 0, 0)
        TText.BackgroundTransparency = 1
        TText.Text = TName
        TText.TextColor3 = Theme.Text
        TText.TextSize = 14
        TText.Font = Enum.Font.Gotham
        TText.TextXAlignment = Enum.TextXAlignment.Left
        TText.Parent = ToggleFrame

        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 40, 0, 20)
        Switch.Position = UDim2.new(1, -55, 0.5, -10)
        Switch.BackgroundColor3 = State and Theme.ToggleOn or Theme.ToggleOff
        Switch.Parent = ToggleFrame
        CreateCorner(Switch, 10)

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 16, 0, 16)
        Indicator.Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.Parent = Switch
        CreateCorner(Indicator, 8)
        
        -- Initial callback
        pcall(Callback, State)

        ToggleFrame.MouseButton1Click:Connect(function()
            State = not State
            if State then
                Tween(Switch, {0.3}, {BackgroundColor3 = Theme.ToggleOn})
                Tween(Indicator, {0.3, Enum.EasingStyle.Back}, {Position = UDim2.new(1, -18, 0.5, -8)})
            else
                Tween(Switch, {0.3}, {BackgroundColor3 = Theme.ToggleOff})
                Tween(Indicator, {0.3, Enum.EasingStyle.Back}, {Position = UDim2.new(0, 2, 0.5, -8)})
            end
            pcall(Callback, State)
        end)
    end


-- STREAMING_CHUNK:Implementing AddSlider Function...
function Elements:AddSlider(SliOptions)
local SName = SliOptions.Name or "Slider"
local Min = SliOptions.Min or 0
local Max = SliOptions.Max or 100
local Default = SliOptions.Default or Min
local Callback = SliOptions.Callback or function() end

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 55)
        SliderFrame.BackgroundColor3 = Theme.Card
        SliderFrame.Parent = TabPage
        CreateCorner(SliderFrame, 6)
        CreateStroke(SliderFrame, Theme.Border, 1, 0)

        local SText = Instance.new("TextLabel")
        SText.Size = UDim2.new(1, -20, 0, 25)
        SText.Position = UDim2.new(0, 15, 0, 5)
        SText.BackgroundTransparency = 1
        SText.Text = SName
        SText.TextColor3 = Theme.Text
        SText.TextSize = 14
        SText.Font = Enum.Font.Gotham
        SText.TextXAlignment = Enum.TextXAlignment.Left
        SText.Parent = SliderFrame

        local SValue = Instance.new("TextLabel")
        SValue.Size = UDim2.new(0, 40, 0, 25)
        SValue.Position = UDim2.new(1, -55, 0, 5)
        SValue.BackgroundTransparency = 1
        SValue.Text = tostring(Default)
        SValue.TextColor3 = Theme.SubText
        SValue.TextSize = 14
        SValue.Font = Enum.Font.GothamBold
        SValue.TextXAlignment = Enum.TextXAlignment.Right
        SValue.Parent = SliderFrame

        local BarBg = Instance.new("TextButton")
        BarBg.Size = UDim2.new(1, -30, 0, 6)
        BarBg.Position = UDim2.new(0, 15, 0, 35)
        BarBg.BackgroundColor3 = Theme.SliderBar
        BarBg.Text = ""
        BarBg.AutoButtonColor = false
        BarBg.Parent = SliderFrame
        CreateCorner(BarBg, 3)

        local BarFill = Instance.new("Frame")
        local startSize = math.clamp((Default - Min) / (Max - Min), 0, 1)
        BarFill.Size = UDim2.new(startSize, 0, 1, 0)
        BarFill.BackgroundColor3 = Theme.Accent
        BarFill.Parent = BarBg
        CreateCorner(BarFill, 3)

        local Sliding = false
        
        local function UpdateSlider(input)
            local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(Min + ((Max - Min) * pos))
            Tween(BarFill, {0.1}, {Size = UDim2.new(pos, 0, 1, 0)})
            SValue.Text = tostring(value)
            pcall(Callback, value)
        end

        BarBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Sliding = true
                UpdateSlider(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Sliding = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input)
            end
        end)
    end


-- STREAMING_CHUNK:Implementing AddTextbox Function...
function Elements:AddTextbox(TBoxOptions)
local TName = TBoxOptions.Name or "Textbox"
local Default = TBoxOptions.Default or ""
local PlaceHolder = TBoxOptions.PlaceholderText or "Enter here..."
local Callback = TBoxOptions.Callback or function() end

        local BoxFrame = Instance.new("Frame")
        BoxFrame.Size = UDim2.new(1, 0, 0, 45)
        BoxFrame.BackgroundColor3 = Theme.Card
        BoxFrame.Parent = TabPage
        CreateCorner(BoxFrame, 6)
        CreateStroke(BoxFrame, Theme.Border, 1, 0)

        local BText = Instance.new("TextLabel")
        BText.Size = UDim2.new(0.5, -15, 1, 0)
        BText.Position = UDim2.new(0, 15, 0, 0)
        BText.BackgroundTransparency = 1
        BText.Text = TName
        BText.TextColor3 = Theme.Text
        BText.TextSize = 14
        BText.Font = Enum.Font.Gotham
        BText.TextXAlignment = Enum.TextXAlignment.Left
        BText.Parent = BoxFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(0.5, -15, 0, 25)
        Input.Position = UDim2.new(0.5, 0, 0.5, -12.5)
        Input.BackgroundColor3 = Theme.InputBackground
        Input.Text = Default
        Input.PlaceholderText = PlaceHolder
        Input.TextColor3 = Theme.Text
        Input.TextSize = 13
        Input.Font = Enum.Font.Gotham
        Input.Parent = BoxFrame
        CreateCorner(Input, 4)
        CreateStroke(Input, Theme.Border, 1, 0)

        Input.FocusLost:Connect(function()
            pcall(Callback, Input.Text)
        end)
    end

    return Elements
end

return Window


end

return GaphopUI
