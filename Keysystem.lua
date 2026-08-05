-- STREAMING_CHUNK:Initializing Core Services and Library...
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}

-- Lấy Parent an toàn nhất cho UI (Hỗ trợ mọi Executor)
local function getParent()
local success, parent = pcall(function()
return (gethui and gethui()) or CoreGui
end)
if not success or not parent then
parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end
return parent
end

local GuiParent = getParent()

-- Hàm tiện ích tạo Animation mượt mà (Tween)
local Utility = {}
function Utility:Tween(instance, properties, duration)
duration = duration or 0.3
local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(instance, tweenInfo, properties)
tween:Play()
return tween
end

-- Hàm Kéo thả mượt mà (Hỗ trợ PC & Mobile)
function Utility:MakeDraggable(topbarobject, object)
local Dragging = nil
local DragInput = nil
local DragStart = nil
local StartPosition = nil

local function Update(input)
    local Delta = input.Position - DragStart
    local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    Utility:Tween(object, {Position = pos}, 0.15)
end

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

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        Update(input)
    end
end)


end

-- STREAMING_CHUNK:Building Global Notification System...
-- Tạo GUI thông báo riêng biệt để không bị xoá khi đóng Key System
local NotifyGui = GuiParent:FindFirstChild("FluentNotifications")
if not NotifyGui then
NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "FluentNotifications"
NotifyGui.Parent = GuiParent
NotifyGui.ResetOnSpawn = false

local NotifyList = Instance.new("Frame")
NotifyList.Name = "NotifyList"
NotifyList.Size = UDim2.new(0, 300, 1, -20)
NotifyList.Position = UDim2.new(1, -320, 0, 10)
NotifyList.BackgroundTransparency = 1
NotifyList.Parent = NotifyGui

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ListLayout.Padding = UDim.new(0, 10)
ListLayout.Parent = NotifyList


end

function Library:Notify(options)
options = options or {}
local title = options.Title or "Notification"
local content = options.Content or ""
local duration = options.Duration or 3.5
local typeStr = options.Type or "info" -- info, success, error

local NotifyList = NotifyGui:FindFirstChild("NotifyList")
if not NotifyList then return end

local colors = {
    info = Color3.fromRGB(59, 130, 246),
    success = Color3.fromRGB(34, 197, 94),
    error = Color3.fromRGB(239, 68, 68)
}
local stripColor = colors[typeStr] or colors.info

local Notification = Instance.new("Frame")
Notification.Name = "Notification"
Notification.Size = UDim2.new(1, 0, 0, 60)
Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Notification.BackgroundTransparency = 1 -- Khởi tạo tàng hình
Notification.BorderSizePixel = 0
Notification.ClipsDescendants = true
Notification.Parent = NotifyList

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Notification

local ColorStrip = Instance.new("Frame")
ColorStrip.Size = UDim2.new(0, 4, 1, 0)
ColorStrip.BackgroundColor3 = stripColor
ColorStrip.BorderSizePixel = 0
ColorStrip.Parent = Notification

local StripCorner = Instance.new("UICorner")
StripCorner.CornerRadius = UDim.new(0, 8)
StripCorner.Parent = ColorStrip

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 20)
TitleLabel.Position = UDim2.new(0, 15, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = title
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextTransparency = 1
TitleLabel.Parent = Notification

local ContentLabel = Instance.new("TextLabel")
ContentLabel.Size = UDim2.new(1, -20, 0, 20)
ContentLabel.Position = UDim2.new(0, 15, 0, 30)
ContentLabel.BackgroundTransparency = 1
ContentLabel.Font = Enum.Font.Gotham
ContentLabel.Text = content
ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ContentLabel.TextSize = 13
ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
ContentLabel.TextTransparency = 1
ContentLabel.Parent = Notification

-- Hiệu ứng trượt và hiện ra
Notification.Size = UDim2.new(1, 0, 0, 0)
Utility:Tween(Notification, {Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 0}, 0.3)
Utility:Tween(TitleLabel, {TextTransparency = 0}, 0.3)
Utility:Tween(ContentLabel, {TextTransparency = 0}, 0.3)

-- Tự động dọn dẹp
task.delay(duration, function()
    Utility:Tween(TitleLabel, {TextTransparency = 1}, 0.3)
    Utility:Tween(ContentLabel, {TextTransparency = 1}, 0.3)
    local hideTween = Utility:Tween(Notification, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
    hideTween.Completed:Connect(function()
        Notification:Destroy()
    end)
end)


end

-- STREAMING_CHUNK:Constructing Key System Base...
function Library:KeySystem()
local KeysysObj = {}

function KeysysObj:Notify(options)
    Library:Notify(options)
end

function KeysysObj:Key(Config)
    Config = Config or {}
    local Title = Config.Title or "Key System"
    local Description = Config.Description or "Please enter your access key."
    
    -- Fix triệt để logic boolean của ShowGetKey & GetKeyFromSite
    local ShowGetKey = (Config.ShowGetKey ~= false) 
    local GetKeyFromSite = (Config.GetKeyFromSite ~= false)
    
    local Link = Config.Link or ""
    local KeyPass = Config.KeyPass or ""
    local Callback = Config.Callback or function() end

    -- Xóa UI cũ nếu bị trùng lặp khi chạy lại script
    local oldGui = GuiParent:FindFirstChild("FluentKeySystemUI")
    if oldGui then oldGui:Destroy() end

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "FluentKeySystemUI"
    MainGui.Parent = GuiParent
    MainGui.ResetOnSpawn = false

    -- Lớp nền mờ tối
    local Backdrop = Instance.new("Frame")
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Backdrop.BackgroundTransparency = 1
    Backdrop.BorderSizePixel = 0
    Backdrop.Parent = MainGui

    -- Khung UI Chính
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 240)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -120)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = Backdrop

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(50, 50, 60)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    -- STREAMING_CHUNK:Adding UI Elements (Title, Input, Buttons)...
    -- Topbar (Dùng để kéo thả)
    local Topbar = Instance.new("Frame")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = MainFrame
    Utility:MakeDraggable(Topbar, MainFrame)

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -30, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = Title
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = Topbar

    local DescText = Instance.new("TextLabel")
    DescText.Size = UDim2.new(1, -30, 0, 20)
    DescText.Position = UDim2.new(0, 15, 0, 50)
    DescText.BackgroundTransparency = 1
    DescText.Font = Enum.Font.Gotham
    DescText.Text = Description
    DescText.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescText.TextSize = 13
    DescText.TextXAlignment = Enum.TextXAlignment.Left
    DescText.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -30, 0, 40)
    KeyInput.Position = UDim2.new(0, 15, 0, 85)
    KeyInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    KeyInput.PlaceholderText = "Enter Key Here..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = MainFrame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = KeyInput

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(60, 60, 75)
    InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    InputStroke.Parent = KeyInput

    -- Container chứa 2 nút
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, -30, 0, 40)
    ButtonContainer.Position = UDim2.new(0, 15, 0, 140)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ButtonContainer

    -- STREAMING_CHUNK:Configuring Submit & Get Key Logic...
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    GetKeyBtn.Font = Enum.Font.GothamSemibold
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Parent = ButtonContainer

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 6)
    GetKeyCorner.Parent = GetKeyBtn

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    SubmitBtn.Font = Enum.Font.GothamSemibold
    SubmitBtn.Text = "Submit Key"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 14
    SubmitBtn.Parent = ButtonContainer

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = SubmitBtn

    -- Xử lý độ rộng của nút dựa trên Config (Fix lỗi giao diện bị lệch)
    if ShowGetKey == false then
        GetKeyBtn.Visible = false
        SubmitBtn.Size = UDim2.new(1, 0, 1, 0) -- Full width
    else
        GetKeyBtn.Visible = true
        GetKeyBtn.Size = UDim2.new(0.5, -5, 1, 0)
        SubmitBtn.Size = UDim2.new(0.5, -5, 1, 0)
    end

    -- Animation Hiện UI mượt mà
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    MainFrame.GroupTransparency = 1
    Utility:Tween(Backdrop, {BackgroundTransparency = 0.5}, 0.3)
    Utility:Tween(MainFrame, {Position = UDim2.new(0.5, -200, 0.5, -120), GroupTransparency = 0}, 0.4)

    -- STREAMING_CHUNK:Executing Buttons Scripts...
    -- Nút Get Key (Copy link)
    GetKeyBtn.MouseButton1Click:Connect(function()
        Utility:Tween(GetKeyBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}, 0.1)
        task.wait(0.1)
        Utility:Tween(GetKeyBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}, 0.1)
        
        local copied = false
        pcall(function()
            if setclipboard then setclipboard(Link) copied = true
            elseif toclipboard then toclipboard(Link) copied = true
            end
        end)

        if copied then
            Library:Notify({Title = "Copied", Content = "Key link copied to clipboard!", Type = "success"})
        else
            Library:Notify({Title = "Error", Content = "Your executor does not support clipboard. Link: " .. Link, Type = "error"})
        end
    end)

    -- Nút Submit (Kiểm tra Key)
    local isChecking = false

    local function SubmitAction()
        if isChecking then return end
        isChecking = true
        
        SubmitBtn.Text = "Checking..."
        Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}, 0.2)
        
        local inputText = KeyInput.Text
        local success = false

        -- Logic xác minh sửa theo đúng yêu cầu
        if GetKeyFromSite == false then
            -- So sánh trực tiếp với KeyPass
            success = (inputText == KeyPass)
        else
            -- Gọi API Web từ dev nếu có
            if Config.VerifyKey then
                local pcallSuccess, verifyResult = pcall(function() return Config.VerifyKey(inputText) end)
                success = pcallSuccess and verifyResult
            end
        end

        if success then
            SubmitBtn.Text = "Success!"
            Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94)}, 0.2)
            Library:Notify({Title = "Success", Content = "Key correct! Loading script...", Type = "success"})
            
            -- Đóng UI
            task.wait(0.5)
            Utility:Tween(Backdrop, {BackgroundTransparency = 1}, 0.3)
            local hideTween = Utility:Tween(MainFrame, {Position = UDim2.new(0.5, -200, 0.5, -140), GroupTransparency = 1}, 0.3)
            
            hideTween.Completed:Connect(function()
                MainGui:Destroy()
                -- Thực thi Script của bạn an toàn
                pcall(function() Callback(true) end)
            end)
        else
            SubmitBtn.Text = "Submit Key"
            Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(239, 68, 68)}, 0.15)
            Library:Notify({Title = "Error", Content = "Invalid Key!", Type = "error"})
            
            -- Hiệu ứng rung khung nhập (Shake Error)
            local startPos = KeyInput.Position
            for i = 1, 4 do
                Utility:Tween(KeyInput, {Position = startPos + UDim2.new(0, (i%2==0 and -5 or 5), 0, 0)}, 0.05)
                task.wait(0.05)
            end
            Utility:Tween(KeyInput, {Position = startPos}, 0.05)
            
            task.wait(0.5)
            Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}, 0.2)
            pcall(function() Callback(false) end)
            isChecking = false
        end
    end

    SubmitBtn.MouseButton1Click:Connect(SubmitAction)
    
    -- Nhấn Enter trong TextBox để Submit
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then SubmitAction() end
    end)
end

return KeysysObj


end

return Library
