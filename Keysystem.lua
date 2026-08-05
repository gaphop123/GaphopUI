-- STREAMING_CHUNK:Initializing Services and Core Variables...
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Find safe parent for GUI
local function GetSafeParent()
local success, parent = pcall(function()
return (gethui and gethui()) or CoreGui
end)
if not success or not parent then
parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end
return parent
end

local SafeParent = GetSafeParent()
local Library = {}

-- STREAMING_CHUNK:Setting up Utility Functions...
local Utility = {}
function Utility:Tween(instance, properties, duration, style, direction)
style = style or Enum.EasingStyle.Quad
direction = direction or Enum.EasingDirection.Out
local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
tween:Play()
return tween
end

-- Function to safely copy to clipboard
local function CopyToClipboard(text)
local success = false
if setclipboard then
pcall(function() setclipboard(text); success = true end)
elseif toclipboard then
pcall(function() toclipboard(text); success = true end)
else
-- Fallback if no clipboard functions exist
return false
end
return success
end

-- STREAMING_CHUNK:Building the Notify System...
function Library:Notify(Config)
Config = Config or {}
local Title = Config.Title or "Notification"
local Content = Config.Content or "This is a notification."
local Duration = Config.Duration or 3

-- Create or find NotifyScreen
local NotifyScreen = SafeParent:FindFirstChild("FluentNotifyUI")
if not NotifyScreen then
    NotifyScreen = Instance.new("ScreenGui")
    NotifyScreen.Name = "FluentNotifyUI"
    NotifyScreen.Parent = SafeParent
    NotifyScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local NotifyList = Instance.new("Frame")
    NotifyList.Name = "NotifyList"
    NotifyList.Size = UDim2.new(0, 300, 1, -20)
    NotifyList.Position = UDim2.new(1, -320, 0, 20)
    NotifyList.BackgroundTransparency = 1
    NotifyList.Parent = NotifyScreen

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = NotifyList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    UIListLayout.Padding = UDim.new(0, 10)
end

local NotifyList = NotifyScreen.NotifyList

-- Create Notification Frame
local NotifFrame = Instance.new("CanvasGroup")
NotifFrame.Size = UDim2.new(1, 0, 0, 80)
NotifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
NotifFrame.GroupTransparency = 1
NotifFrame.Parent = NotifyList

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = NotifFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 0.8
UIStroke.Parent = NotifFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 25)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = Title
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = NotifFrame

local ContentLabel = Instance.new("TextLabel")
ContentLabel.Size = UDim2.new(1, -20, 0, 35)
ContentLabel.Position = UDim2.new(0, 10, 0, 35)
ContentLabel.BackgroundTransparency = 1
ContentLabel.Text = Content
ContentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ContentLabel.TextSize = 14
ContentLabel.Font = Enum.Font.Gotham
ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
ContentLabel.TextWrapped = true
ContentLabel.Parent = NotifFrame

-- Animate In
Utility:Tween(NotifFrame, {GroupTransparency = 0}, 0.3)

-- Animate Out and Destroy
task.spawn(function()
    task.wait(Duration)
    local fadeOut = Utility:Tween(NotifFrame, {GroupTransparency = 1}, 0.3)
    fadeOut.Completed:Wait()
    NotifFrame:Destroy()
end)


end

-- STREAMING_CHUNK:Building the Key System Structure...
function Library:KeySystem()
local KeysysObj = {}

function KeysysObj:Key(Config)
    Config = Config or {}
    local TitleText = Config.Title or "Key System"
    local DescText = Config.Description or "Please enter your access key."
    local ShowGetKey = Config.ShowGetKey
    if ShowGetKey == nil then ShowGetKey = true end
    
    local GetKeyFromSite = Config.GetKeyFromSite
    if GetKeyFromSite == nil then GetKeyFromSite = true end
    
    local Link = Config.Link or ""
    local KeyPass = Config.KeyPass or ""
    local Callback = Config.Callback or function() end

    -- Remove existing UI if exists
    local existingUI = SafeParent:FindFirstChild("FluentKeySystemUI")
    if existingUI then existingUI:Destroy() end

    -- Main GUI
    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "FluentKeySystemUI"
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainGui.Parent = SafeParent

    local Backdrop = Instance.new("Frame")
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Backdrop.BackgroundTransparency = 1
    Backdrop.BorderSizePixel = 0
    Backdrop.Parent = MainGui

    -- The Main UI Container (MUST BE CanvasGroup for GroupTransparency)
    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Size = UDim2.new(0, 420, 0, 260)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -110) -- Starts slightly lower for animation
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.GroupTransparency = 1
    MainFrame.Parent = Backdrop

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.8
    MainStroke.Parent = MainFrame

    -- STREAMING_CHUNK:Creating UI Elements (Top Bar & Body)...
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TitleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseBtn.TextSize = 16
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -30, 0, 40)
    Desc.Position = UDim2.new(0, 15, 0, 45)
    Desc.BackgroundTransparency = 1
    Desc.Text = DescText
    Desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    Desc.TextSize = 14
    Desc.Font = Enum.Font.Gotham
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextYAlignment = Enum.TextYAlignment.Top
    Desc.TextWrapped = true
    Desc.Parent = MainFrame

    local TextBoxContainer = Instance.new("Frame")
    TextBoxContainer.Size = UDim2.new(1, -30, 0, 45)
    TextBoxContainer.Position = UDim2.new(0, 15, 0, 95)
    TextBoxContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TextBoxContainer.Parent = MainFrame

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(0, 6)
    TBCorner.Parent = TextBoxContainer

    local TBStroke = Instance.new("UIStroke")
    TBStroke.Color = Color3.fromRGB(255, 255, 255)
    TBStroke.Transparency = 0.8
    TBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TBStroke.Parent = TextBoxContainer

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "Enter Key Here..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = TextBoxContainer

    -- STREAMING_CHUNK:Creating Action Buttons...
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, -30, 0, 40)
    ButtonContainer.Position = UDim2.new(0, 15, 1, -55)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = MainFrame

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    SubmitBtn.Text = "Check Key"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 14
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Parent = ButtonContainer

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = SubmitBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Parent = ButtonContainer

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 6)
    GetKeyCorner.Parent = GetKeyBtn

    -- Layout Logic based on ShowGetKey
    if ShowGetKey then
        SubmitBtn.Size = UDim2.new(0.5, -5, 1, 0)
        SubmitBtn.Position = UDim2.new(0.5, 5, 0, 0)
        
        GetKeyBtn.Size = UDim2.new(0.5, -5, 1, 0)
        GetKeyBtn.Position = UDim2.new(0, 0, 0, 0)
        GetKeyBtn.Visible = true
    else
        SubmitBtn.Size = UDim2.new(1, 0, 1, 0)
        SubmitBtn.Position = UDim2.new(0, 0, 0, 0)
        GetKeyBtn.Visible = false
    end

    -- STREAMING_CHUNK:Adding Animations and Dragging...
    -- Opening Animation
    Utility:Tween(Backdrop, {BackgroundTransparency = 0.4}, 0.3)
    Utility:Tween(MainFrame, {Position = UDim2.new(0.5, -210, 0.5, -130), GroupTransparency = 0}, 0.4, Enum.EasingStyle.Back)

    -- Close Animation Function
    local function CloseUI()
        Utility:Tween(Backdrop, {BackgroundTransparency = 1}, 0.3)
        local closeTween = Utility:Tween(MainFrame, {Position = UDim2.new(0.5, -210, 0.5, -110), GroupTransparency = 1}, 0.3)
        closeTween.Completed:Wait()
        MainGui:Destroy()
    end

    CloseBtn.MouseButton1Click:Connect(CloseUI)

    -- Error Shake Animation
    local function ShakeUI()
        local originalPos = MainFrame.Position
        for i = 1, 5 do
            MainFrame.Position = originalPos + UDim2.new(0, math.random(-5, 5), 0, math.random(-5, 5))
            task.wait(0.05)
        end
        MainFrame.Position = originalPos
    end

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- STREAMING_CHUNK:Key Verification Logic...
    local isChecking = false

    -- Placeholder for website verification
    local function VerifyKeyFromSite(inputKey)
        -- Replace this with your actual HTTP verification
        -- Example: return game:HttpGet("https://yoursite.com/verify?key=" .. inputKey) == "true"
        task.wait(1) -- Simulate network delay
        return false
    end

    local function CheckInput()
        if isChecking then return end
        isChecking = true
        SubmitBtn.Text = "Checking..."
        local inputText = KeyInput.Text

        local successResult = false

        if GetKeyFromSite then
            -- Verify using Website logic
            successResult = VerifyKeyFromSite(inputText)
        else
            -- Verify directly using KeyPass string
            if inputText == KeyPass and KeyPass ~= "" then
                successResult = true
            end
        end

        if successResult then
            SubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
            SubmitBtn.Text = "Success!"
            Library:Notify({
                Title = "Success",
                Content = "Key accepted. Loading script...",
                Duration = 3
            })
            task.wait(0.5)
            CloseUI()
            
            -- Safely execute user callback
            pcall(function()
                Callback(true)
            end)
        else
            ShakeUI()
            SubmitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            SubmitBtn.Text = "Invalid Key"
            Library:Notify({
                Title = "Error",
                Content = "The key you entered is invalid or expired.",
                Duration = 3
            })
            task.wait(1)
            SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            SubmitBtn.Text = "Check Key"
        end
        
        isChecking = false
    end

    SubmitBtn.MouseButton1Click:Connect(CheckInput)
    
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            CheckInput()
        end
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        local copied = CopyToClipboard(Link)
        if copied then
            Library:Notify({
                Title = "Link Copied",
                Content = "Get Key link has been copied to your clipboard.",
                Duration = 5
            })
        else
            Library:Notify({
                Title = "Action Required",
                Content = "Please manually visit: " .. Link,
                Duration = 7
            })
        end
    end)

end

return KeysysObj


end

return Library
