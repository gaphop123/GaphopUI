-- STREAMING_CHUNK:Initializing Services and Setup

local TweenService = game:GetService("TweenService") local UserInputService = game:GetService("UserInputService") local CoreGui = game:GetService("CoreGui") local RunService = game:GetService("RunService")

-- Compatibility for Executor UI Parent (fallbacks for different environments) local TargetParent = (gethui and gethui()) or (RunService:IsStudio() and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")) or CoreGui

-- Compatibility for Clipboard local set_clipboard = setclipboard or toclipboard or set_clipboard or function(text) warn("Clipboard not supported on this executor. Text: " .. tostring(text)) end

-- STREAMING_CHUNK:Defining Utility Functions... -- UI Utility Functions local Utility = {}

function Utility:Create(className, properties) local instance = Instance.new(className) for k, v in pairs(properties or {}) do instance

$$k$$

 = v end return instance end

function Utility:Tween(instance, properties, duration, style, direction) style = style or Enum.EasingStyle.Quart direction = direction or Enum.EasingDirection.Out duration = duration or 0.5 local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties) tween:Play() return tween end

function Utility:MakeDraggable(topBar, frame) local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Utility:Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.15, Enum.EasingStyle.Sine)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

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
        update(input)
    end
end)



end

-- STREAMING_CHUNK:Defining Verification Logic Placeholder... -- Placeholder for website verification API local function VerifyKeyPlaceholder(input) -- REPLACE THIS WITH YOUR OWN HTTP VERIFICATION LOGIC! -- Example: -- local req = request or http_request or syn.request -- local res = req({Url = "https://yourwebsite.com/api/verify?key=" .. input, Method = "GET"}) -- return res.Body == "valid"

task.wait(0.8) -- Simulating network request delay
return false -- Default to false for security; change this according to your logic.



end

-- STREAMING_CHUNK:Initializing Library Structure... local Library = {}

function Library:KeySystem() local KeysysObj = {}

function KeysysObj:Key(Config)
    -- Setup Configuration Defaults
    Config.Title = Config.Title or "Key System"
    Config.Description = Config.Description or "Please enter your access key."
    Config.ShowGetKey = Config.ShowGetKey == nil and true or Config.ShowGetKey
    Config.GetKeyFromSite = Config.GetKeyFromSite == nil and true or Config.GetKeyFromSite
    Config.Link = Config.Link or "https://example.com"
    Config.KeyPass = Config.KeyPass or "DEFAULT_KEY"
    Config.Callback = Config.Callback or function() end
    
    local isChecking = false
    
    -- STREAMING_CHUNK:Constructing Main UI Containers...
    -- Main ScreenGui
    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "FluentKeySystem_" .. math.random(1000, 9999),
        Parent = TargetParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })
    
    -- Center Alignment Container
    local Container = Utility:Create("Frame", {
        Name = "Container",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })

    -- CanvasGroup for Global Transparency Tweens (Fade In/Out)
    local MainFrame = Utility:Create("CanvasGroup", {
        Name = "MainFrame",
        Parent = Container,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 420, 0, 260),
        BackgroundColor3 = Color3.fromRGB(24, 24, 27), -- Zinc 900
        BorderSizePixel = 0,
        GroupTransparency = 1 -- Start hidden
    })
    
    -- Main Rounded Corner
    Utility:Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Subtle Border (UIStroke)
    Utility:Create("UIStroke", {
        Parent = MainFrame,
        Color = Color3.fromRGB(63, 63, 70), -- Zinc 700
        Thickness = 1
    })
    
    -- Drop Shadow
    local Shadow = Utility:Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 47, 1, 47),
        BackgroundTransparency = 1,
        Image = "rbxassetid://4743306766",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(21, 21, 279, 279),
        ZIndex = -1
    })
    
    -- STREAMING_CHUNK:Constructing Top Bar & Typography...
    -- Top Bar
    local TopBar = Utility:Create("Frame", {
        Name = "TopBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    local TitleText = Utility:Create("TextLabel", {
        Name = "Title",
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -55, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Config.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close Button
    local CloseBtn = Utility:Create("TextButton", {
        Name = "CloseBtn",
        Parent = TopBar,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = "X",
        TextColor3 = Color3.fromRGB(161, 161, 170), -- Zinc 400
        TextSize = 14
    })
    
    CloseBtn.MouseEnter:Connect(function() Utility:Tween(CloseBtn, {TextColor3 = Color3.fromRGB(244, 63, 94)}, 0.2) end)
    CloseBtn.MouseLeave:Connect(function() Utility:Tween(CloseBtn, {TextColor3 = Color3.fromRGB(161, 161, 170)}, 0.2) end)
    CloseBtn.MouseButton1Click:Connect(function()
        Utility:Tween(MainFrame, {GroupTransparency = 1, Size = UDim2.new(0, 380, 0, 240)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    Utility:MakeDraggable(TopBar, MainFrame)
    
    -- Description
    local DescriptionText = Utility:Create("TextLabel", {
        Name = "Description",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 50),
        Size = UDim2.new(1, -40, 0, 40),
        Font = Enum.Font.Gotham,
        Text = Config.Description,
        TextColor3 = Color3.fromRGB(161, 161, 170),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    -- STREAMING_CHUNK:Constructing Inputs & Buttons...
    -- Input Field (TextBox)
    local InputBg = Utility:Create("Frame", {
        Name = "InputBg",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(39, 39, 42), -- Zinc 800
        Position = UDim2.new(0, 20, 0, 110),
        Size = UDim2.new(1, -40, 0, 42)
    })
    Utility:Create("UICorner", {Parent = InputBg, CornerRadius = UDim.new(0, 6)})
    Utility:Create("UIStroke", {Parent = InputBg, Color = Color3.fromRGB(63, 63, 70), Thickness = 1})
    
    local KeyInput = Utility:Create("TextBox", {
        Name = "KeyInput",
        Parent = InputBg,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.Gotham,
        PlaceholderText = "Enter Key Here...",
        PlaceholderColor3 = Color3.fromRGB(113, 113, 122),
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    })
    
    -- Buttons Container
    local ButtonContainer = Utility:Create("Frame", {
        Name = "ButtonContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 1, -70),
        Size = UDim2.new(1, -40, 0, 42)
    })
    
    Utility:Create("UIListLayout", {
        Parent = ButtonContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })
    
    -- STREAMING_CHUNK:Button Functions & Configurations...
    -- Helper function to create stylish buttons
    local function CreateButton(name, text, layoutOrder, isPrimary)
        local Btn = Utility:Create("TextButton", {
            Name = name,
            Parent = ButtonContainer,
            BackgroundColor3 = isPrimary and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(39, 39, 42), -- Blue 500 or Zinc 800
            Size = UDim2.new(0.5, -5, 1, 0), -- Dynamic sizing
            Font = Enum.Font.GothamBold,
            Text = text,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            AutoButtonColor = false,
            LayoutOrder = layoutOrder
        })
        Utility:Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
        
        if not isPrimary then
            Utility:Create("UIStroke", {Parent = Btn, Color = Color3.fromRGB(63, 63, 70), Thickness = 1})
        end
        
        -- Hover animations
        Btn.MouseEnter:Connect(function()
            if isChecking then return end
            Utility:Tween(Btn, {BackgroundColor3 = isPrimary and Color3.fromRGB(96, 165, 250) or Color3.fromRGB(63, 63, 70)}, 0.2)
        end)
        Btn.MouseLeave:Connect(function()
            if isChecking then return end
            Utility:Tween(Btn, {BackgroundColor3 = isPrimary and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(39, 39, 42)}, 0.2)
        end)
        
        return Btn
    end
    
    local GetKeyBtn = nil
    if Config.ShowGetKey and Config.GetKeyFromSite then
        GetKeyBtn = CreateButton("GetKeyBtn", "Get Key", 1, false)
    end
    
    -- If GetKeyBtn exists, buttons are 50% width, else Submit is 100% width
    local submitWidth = GetKeyBtn and UDim2.new(0.5, -5, 1, 0) or UDim2.new(1, 0, 1, 0)
    local SubmitBtn = CreateButton("SubmitBtn", "Submit Key", 2, true)
    SubmitBtn.Size = submitWidth

    -- STREAMING_CHUNK:Implementing Notification System...
    -- Notification System Setup
    local function ShowNotification(message, isError)
        local Notif = Utility:Create("Frame", {
            Parent = ScreenGui,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, -50), -- Starts off-screen (top)
            Size = UDim2.new(0, 250, 0, 40),
            BackgroundColor3 = Color3.fromRGB(24, 24, 27),
        })
        Utility:Create("UICorner", {Parent = Notif, CornerRadius = UDim.new(0, 6)})
        Utility:Create("UIStroke", {Parent = Notif, Color = isError and Color3.fromRGB(244, 63, 94) or Color3.fromRGB(34, 197, 94), Thickness = 1})
        
        Utility:Create("TextLabel", {
            Parent = Notif,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = message,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13
        })
        
        -- Slide in
        Utility:Tween(Notif, {Position = UDim2.new(0.5, 0, 0, 20)}, 0.4, Enum.EasingStyle.Back)
        
        -- Wait & Slide out
        task.delay(2.5, function()
            local outTween = Utility:Tween(Notif, {Position = UDim2.new(0.5, 0, 0, -50)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            outTween.Completed:Wait()
            Notif:Destroy()
        end)
    end
    
    -- Error Shake Animation
    local function ShakeUI()
        local originalPos = MainFrame.Position
        local offset = 8
        for i = 1, 4 do
            Utility:Tween(MainFrame, {Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + (i%2==0 and offset or -offset), originalPos.Y.Scale, originalPos.Y.Offset)}, 0.05).Completed:Wait()
        end
        Utility:Tween(MainFrame, {Position = originalPos}, 0.05)
    end
    
    -- STREAMING_CHUNK:Binding Actions and Final Logic...
    -- Verification Execution Logic
    local function SubmitLogic()
        if isChecking then return end
        isChecking = true
        
        local inputText = KeyInput.Text
        SubmitBtn.Text = "Checking..."
        Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(71, 85, 105)}, 0.2)
        
        local success = false
        
        if Config.GetKeyFromSite then
            -- Delegate logic to the custom VerifyKey function
            success = VerifyKeyPlaceholder(inputText)
        else
            -- Offline / Basic matching string
            success = (inputText == Config.KeyPass)
            task.wait(0.3) -- UX buffer
        end
        
        if success then
            SubmitBtn.Text = "Success!"
            Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(34, 197, 94)}, 0.2) -- Green
            ShowNotification("Key Validated. Loading...", false)
            
            task.wait(0.8)
            -- Fade out and close
            Utility:Tween(MainFrame, {GroupTransparency = 1, Size = UDim2.new(0, 440, 0, 280)}, 0.4)
            task.wait(0.4)
            ScreenGui:Destroy()
            
            -- Execute Callback
            Config.Callback(true)
        else
            -- Fail
            SubmitBtn.Text = "Submit Key"
            Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(59, 130, 246)}, 0.2)
            ShowNotification("Invalid Key!", true)
            ShakeUI()
            Config.Callback(false)
        end
        
        isChecking = false
    end

    -- Events Binding
    SubmitBtn.MouseButton1Click:Connect(SubmitLogic)
    
    -- Allow "Enter" Key submission
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitLogic()
        end
    end)
    
    if GetKeyBtn then
        GetKeyBtn.MouseButton1Click:Connect(function()
            if isChecking then return end
            set_clipboard(Config.Link)
            ShowNotification("Link copied to clipboard!", false)
        end)
    end
    
    -- Startup Animation (Fade In)
    MainFrame.Size = UDim2.new(0, 400, 0, 240)
    Utility:Tween(MainFrame, {GroupTransparency = 0, Size = UDim2.new(0, 420, 0, 260)}, 0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
    
end

return KeysysObj



end

return Library
