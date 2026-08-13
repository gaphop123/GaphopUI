-- STREAMING_CHUNK:Initializing Services and Core Variables...
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local function GetSafeParent()
	local success, parent = pcall(function()
		return (gethui and gethui()) or CoreGui
	end)
	if not success or not parent then
		parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	return parent
end

local SafeParent = GetSafeParent()
local Library = {}

-- STREAMING_CHUNK:Utility Functions...
local Utility = {}

function Utility:Tween(instance, properties, duration, style, direction)
	style = style or Enum.EasingStyle.Quint
	direction = direction or Enum.EasingDirection.Out
	local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
	tween:Play()
	return tween
end

function Utility:Create(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	if props and props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

local function CopyToClipboard(text)
	local success = false
	if setclipboard then
		pcall(function() setclipboard(text); success = true end)
	elseif toclipboard then
		pcall(function() toclipboard(text); success = true end)
	elseif syn and syn.write_clipboard then
		pcall(function() syn.write_clipboard(text); success = true end)
	end
	return success
end

local function FormatTimeLeft(expiryTime)
	local diff = expiryTime - os.time()
	if diff <= 0 then return "Expired" end

	local days = math.floor(diff / 86400)
	local hours = math.floor((diff % 86400) / 3600)
	local mins = math.floor((diff % 3600) / 60)

	local timeString = ""
	if days > 0 then timeString = timeString .. days .. "d " end
	if hours > 0 or days > 0 then timeString = timeString .. hours .. "h " end
	timeString = timeString .. mins .. "m"

	return timeString
end

-- File System
local FolderName = "FluentKeySystemData"

local function SaveKeyData(fileName, keyStr, durationSeconds)
	if not writefile then return false end
	pcall(function()
		if makefolder and not isfolder(FolderName) then
			makefolder(FolderName)
		end
		local data = {
			Key = keyStr,
			Expiry = os.time() + durationSeconds
		}
		writefile(FolderName .. "/" .. fileName .. ".json", HttpService:JSONEncode(data))
	end)
end

local function LoadKeyData(fileName)
	if not (readfile and isfile) then return nil end
	local success, data = pcall(function()
		local path = FolderName .. "/" .. fileName .. ".json"
		if isfile(path) then
			return HttpService:JSONDecode(readfile(path))
		end
	end)
	return success and data or nil
end

-- STREAMING_CHUNK:Notification System...
function Library:Notify(Config)
	Config = Config or {}
	local Title = Config.Title or "Notification"
	local Content = Config.Content or "This is a notification."
	local Duration = Config.Duration or 3.5

	local NotifyScreen = SafeParent:FindFirstChild("FluentNotifyUI")
	if not NotifyScreen then
		NotifyScreen = Utility:Create("ScreenGui", {
			Name = "FluentNotifyUI",
			Parent = SafeParent,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ResetOnSpawn = false
		})

		local NotifyList = Utility:Create("Frame", {
			Name = "NotifyList",
			Size = UDim2.new(0, 320, 1, -24),
			Position = UDim2.new(1, -340, 0, 20),
			BackgroundTransparency = 1,
			Parent = NotifyScreen
		})

		Utility:Create("UIListLayout", {
			Parent = NotifyList,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 12)
		})
	end

	local NotifyList = NotifyScreen.NotifyList

	local NotifFrame = Utility:Create("CanvasGroup", {
		Size = UDim2.new(1, 0, 0, 78),
		BackgroundColor3 = Color3.fromRGB(18, 18, 24),
		GroupTransparency = 1,
		Parent = NotifyList
	})

	Utility:Create("UICorner", {
		CornerRadius = UDim.new(0, 10),
		Parent = NotifFrame
	})

	local Stroke = Utility:Create("UIStroke", {
		Color = Color3.fromRGB(80, 80, 100),
		Transparency = 0.55,
		Thickness = 1,
		Parent = NotifFrame
	})

	-- Accent bar
	local Accent = Utility:Create("Frame", {
		Size = UDim2.new(0, 4, 1, -16),
		Position = UDim2.new(0, 8, 0, 8),
		BackgroundColor3 = Color3.fromRGB(0, 170, 255),
		BorderSizePixel = 0,
		Parent = NotifFrame
	})
	Utility:Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = Accent
	})

	local TitleLabel = Utility:Create("TextLabel", {
		Size = UDim2.new(1, -28, 0, 24),
		Position = UDim2.new(0, 22, 0, 10),
		BackgroundTransparency = 1,
		Text = Title,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = NotifFrame
	})

	local ContentLabel = Utility:Create("TextLabel", {
		Size = UDim2.new(1, -28, 0, 36),
		Position = UDim2.new(0, 22, 0, 34),
		BackgroundTransparency = 1,
		Text = Content,
		TextColor3 = Color3.fromRGB(180, 185, 200),
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = NotifFrame
	})

	Utility:Tween(NotifFrame, {GroupTransparency = 0}, 0.35)

	task.spawn(function()
		task.wait(Duration)
		local fadeOut = Utility:Tween(NotifFrame, {GroupTransparency = 1}, 0.3)
		fadeOut.Completed:Wait()
		NotifFrame:Destroy()
	end)
end

function Library:WarnNotify(Config)
	Config = Config or {}
	local Title = Config.Title or "Warning"
	local Content = Config.Content or "This is a warning."
	local Duration = Config.Duration or 5

	local NotifyScreen = SafeParent:FindFirstChild("FluentWarnNotifyUI")
	if not NotifyScreen then
		NotifyScreen = Utility:Create("ScreenGui", {
			Name = "FluentWarnNotifyUI",
			Parent = SafeParent,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ResetOnSpawn = false
		})

		local NotifyList = Utility:Create("Frame", {
			Name = "NotifyList",
			Size = UDim2.new(0, 340, 1, -24),
			Position = UDim2.new(1, -360, 0, 20),
			BackgroundTransparency = 1,
			Parent = NotifyScreen
		})

		Utility:Create("UIListLayout", {
			Parent = NotifyList,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 12)
		})
	end

	local NotifyList = NotifyScreen.NotifyList

	local NotifFrame = Utility:Create("CanvasGroup", {
		Size = UDim2.new(1, 0, 0, 88),
		BackgroundColor3 = Color3.fromRGB(32, 22, 14),
		GroupTransparency = 1,
		Parent = NotifyList
	})

	Utility:Create("UICorner", {
		CornerRadius = UDim.new(0, 10),
		Parent = NotifFrame
	})

	Utility:Create("UIStroke", {
		Color = Color3.fromRGB(255, 160, 40),
		Transparency = 0.3,
		Thickness = 1.4,
		Parent = NotifFrame
	})

	local Icon = Utility:Create("TextLabel", {
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(0, 12, 0, 12),
		BackgroundTransparency = 1,
		Text = "⚠",
		TextColor3 = Color3.fromRGB(255, 190, 50),
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		Parent = NotifFrame
	})

	local TitleLabel = Utility:Create("TextLabel", {
		Size = UDim2.new(1, -52, 0, 24),
		Position = UDim2.new(0, 44, 0, 12),
		BackgroundTransparency = 1,
		Text = Title,
		TextColor3 = Color3.fromRGB(255, 220, 140),
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = NotifFrame
	})

	local ContentLabel = Utility:Create("TextLabel", {
		Size = UDim2.new(1, -24, 0, 42),
		Position = UDim2.new(0, 12, 0, 40),
		BackgroundTransparency = 1,
		Text = Content,
		TextColor3 = Color3.fromRGB(230, 230, 230),
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = NotifFrame
	})

	Utility:Tween(NotifFrame, {GroupTransparency = 0}, 0.35)

	task.spawn(function()
		task.wait(Duration)
		local fadeOut = Utility:Tween(NotifFrame, {GroupTransparency = 1}, 0.3)
		fadeOut.Completed:Wait()
		NotifFrame:Destroy()
	end)
end

-- STREAMING_CHUNK:Key System...
function Library:KeySystem()
	local KeysysObj = {}

	function KeysysObj:Key(Config)
		Config = Config or {}
		local TitleText = Config.Title or "Key System"
		local DescText = Config.Description or "Enter your key to continue."
		local FileName = Config.FileName or TitleText:gsub("%s+", "") .. "_Key"
		local ShowGetKey = Config.ShowGetKey
		if ShowGetKey == nil then ShowGetKey = true end
		local GetKeyFromSite = Config.GetKeyFromSite
		if GetKeyFromSite == nil then GetKeyFromSite = true end
		local Link = Config.Link or ""
		local KeyPass = Config.KeyPass or ""
		local Callback = Config.Callback or function() end

		-- Auto-load saved key
		local SavedData = LoadKeyData(FileName)
		if SavedData and SavedData.Key and SavedData.Expiry then
			if os.time() < SavedData.Expiry then
				local TimeLeftStr = FormatTimeLeft(SavedData.Expiry)
				Library:Notify({
					Title = TitleText .. " • Verified",
					Content = "Key loaded successfully • " .. TimeLeftStr .. " remaining",
					Duration = 4.5
				})
				pcall(function() Callback(true) end)
				return
			end
		end

		-- Destroy existing UI
		local existingUI = SafeParent:FindFirstChild("FluentKeySystemUI")
		if existingUI then existingUI:Destroy() end

		local MainGui = Utility:Create("ScreenGui", {
			Name = "FluentKeySystemUI",
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ResetOnSpawn = false,
			Parent = SafeParent
		})

		-- Backdrop
		local Backdrop = Utility:Create("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = MainGui
		})

		-- Main Container
		local MainFrame = Utility:Create("CanvasGroup", {
			Size = UDim2.new(0, 440, 0, 280),
			Position = UDim2.new(0.5, -220, 0.5, -120),
			BackgroundColor3 = Color3.fromRGB(16, 16, 22),
			BorderSizePixel = 0,
			GroupTransparency = 1,
			Parent = Backdrop
		})

		Utility:Create("UISizeConstraint", {
			MaxSize = Vector2.new(440, 280),
			MinSize = Vector2.new(320, 260),
			Parent = MainFrame
		})

		Utility:Create("UICorner", {
			CornerRadius = UDim.new(0, 14),
			Parent = MainFrame
		})

		local MainStroke = Utility:Create("UIStroke", {
			Color = Color3.fromRGB(70, 70, 95),
			Transparency = 0.55,
			Thickness = 1.2,
			Parent = MainFrame
		})

		-- Soft inner glow layer
		local InnerGlow = Utility:Create("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundColor3 = Color3.fromRGB(22, 22, 30),
			BackgroundTransparency = 0.6,
			BorderSizePixel = 0,
			Parent = MainFrame
		})
		Utility:Create("UICorner", {
			CornerRadius = UDim.new(0, 13),
			Parent = InnerGlow
		})

		-- Top Bar
		local TopBar = Utility:Create("Frame", {
			Size = UDim2.new(1, 0, 0, 48),
			BackgroundTransparency = 1,
			Parent = MainFrame
		})

		local Title = Utility:Create("TextLabel", {
			Size = UDim2.new(1, -60, 1, 0),
			Position = UDim2.new(0, 20, 0, 0),
			BackgroundTransparency = 1,
			Text = TitleText,
			TextColor3 = Color3.fromRGB(245, 245, 255),
			TextSize = 18,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = TopBar
		})

		-- Accent line under title
		local AccentLine = Utility:Create("Frame", {
			Size = UDim2.new(0, 36, 0, 3),
			Position = UDim2.new(0, 20, 1, -6),
			BackgroundColor3 = Color3.fromRGB(0, 170, 255),
			BorderSizePixel = 0,
			Parent = TopBar
		})
		Utility:Create("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = AccentLine
		})

		-- Close Button
		local CloseBtn = Utility:Create("TextButton", {
			Size = UDim2.new(0, 32, 0, 32),
			Position = UDim2.new(1, -42, 0.5, -16),
			BackgroundColor3 = Color3.fromRGB(40, 40, 52),
			Text = "×",
			TextColor3 = Color3.fromRGB(200, 200, 215),
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			AutoButtonColor = false,
			Parent = TopBar
		})
		Utility:Create("UICorner", {
			CornerRadius = UDim.new(0, 8),
			Parent = CloseBtn
		})

		CloseBtn.MouseEnter:Connect(function()
			Utility:Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(220, 60, 70), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.18)
		end)
		CloseBtn.MouseLeave:Connect(function()
			Utility:Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 52), TextColor3 = Color3.fromRGB(200, 200, 215)}, 0.18)
		end)

		-- Description
		local Desc = Utility:Create("TextLabel", {
			Size = UDim2.new(1, -40, 0, 36),
			Position = UDim2.new(0, 20, 0, 56),
			BackgroundTransparency = 1,
			Text = DescText,
			TextColor3 = Color3.fromRGB(160, 165, 185),
			TextSize = 14,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Parent = MainFrame
		})

		-- TextBox Container
		local TextBoxContainer = Utility:Create("Frame", {
			Size = UDim2.new(1, -40, 0, 48),
			Position = UDim2.new(0, 20, 0, 104),
			BackgroundColor3 = Color3.fromRGB(26, 26, 34),
			Parent = MainFrame
		})
		Utility:Create("UICorner", {
			CornerRadius = UDim.new(0, 10),
			Parent = TextBoxContainer
		})

		local TBStroke = Utility:Create("UIStroke", {
			Color = Color3.fromRGB(60, 60, 80),
			Transparency = 0.4,
			Thickness = 1.2,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Parent = TextBoxContainer
		})

		local KeyInput = Utility:Create("TextBox", {
			Size = UDim2.new(1, -24, 1, 0),
			Position = UDim2.new(0, 12, 0, 0),
			BackgroundTransparency = 1,
			PlaceholderText = "Paste your key here...",
			PlaceholderColor3 = Color3.fromRGB(110, 115, 140),
			Text = "",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 15,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClearTextOnFocus = false,
			Parent = TextBoxContainer
		})

		KeyInput.Focused:Connect(function()
			Utility:Tween(TBStroke, {Color = Color3.fromRGB(0, 170, 255), Transparency = 0.15}, 0.25)
			Utility:Tween(TextBoxContainer, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.25)
		end)
		KeyInput.FocusLost:Connect(function()
			Utility:Tween(TBStroke, {Color = Color3.fromRGB(60, 60, 80), Transparency = 0.4}, 0.25)
			Utility:Tween(TextBoxContainer, {BackgroundColor3 = Color3.fromRGB(26, 26, 34)}, 0.25)
		end)

		-- Button Container
		local ButtonContainer = Utility:Create("Frame", {
			Size = UDim2.new(1, -40, 0, 44),
			Position = UDim2.new(0, 20, 1, -64),
			BackgroundTransparency = 1,
			Parent = MainFrame
		})

		local SubmitBtn = Utility:Create("TextButton", {
			BackgroundColor3 = Color3.fromRGB(0, 145, 255),
			Text = "Verify Key",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 15,
			Font = Enum.Font.GothamBold,
			AutoButtonColor = false,
			Parent = ButtonContainer
		})
		Utility:Create("UICorner", {
			CornerRadius = UDim.new(0, 10),
			Parent = SubmitBtn
		})

		local GetKeyBtn = Utility:Create("TextButton", {
			BackgroundColor3 = Color3.fromRGB(40, 40, 52),
			Text = "Get Key",
			TextColor3 = Color3.fromRGB(230, 230, 240),
			TextSize = 15,
			Font = Enum.Font.GothamBold,
			AutoButtonColor = false,
			Parent = ButtonContainer
		})
		Utility:Create("UICorner", {
			CornerRadius = UDim.new(0, 10),
			Parent = GetKeyBtn
		})

		if ShowGetKey and GetKeyFromSite then
			SubmitBtn.Size = UDim2.new(0.58, -6, 1, 0)
			SubmitBtn.Position = UDim2.new(0.42, 6, 0, 0)
			GetKeyBtn.Size = UDim2.new(0.42, -6, 1, 0)
			GetKeyBtn.Position = UDim2.new(0, 0, 0, 0)
			GetKeyBtn.Visible = true
		else
			SubmitBtn.Size = UDim2.new(1, 0, 1, 0)
			SubmitBtn.Position = UDim2.new(0, 0, 0, 0)
			GetKeyBtn.Visible = false
		end

		-- Hover effects for buttons
		SubmitBtn.MouseEnter:Connect(function()
			if SubmitBtn.Text == "Verify Key" then
				Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(30, 165, 255)}, 0.18)
			end
		end)
		SubmitBtn.MouseLeave:Connect(function()
			if SubmitBtn.Text == "Verify Key" then
				Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(0, 145, 255)}, 0.18)
			end
		end)

		GetKeyBtn.MouseEnter:Connect(function()
			Utility:Tween(GetKeyBtn, {BackgroundColor3 = Color3.fromRGB(55, 55, 70)}, 0.18)
		end)
		GetKeyBtn.MouseLeave:Connect(function()
			Utility:Tween(GetKeyBtn, {BackgroundColor3 = Color3.fromRGB(40, 40, 52)}, 0.18)
		end)

		-- Entrance Animation
		Utility:Tween(Backdrop, {BackgroundTransparency = 0.45}, 0.4)
		Utility:Tween(MainFrame, {
			Position = UDim2.new(0.5, -220, 0.5, -140),
			GroupTransparency = 0
		}, 0.55, Enum.EasingStyle.Back)

		-- Slight scale pop
		MainFrame.Size = UDim2.new(0, 420, 0, 265)
		Utility:Tween(MainFrame, {Size = UDim2.new(0, 440, 0, 280)}, 0.55, Enum.EasingStyle.Back)

		local function CloseUI()
			Utility:Tween(Backdrop, {BackgroundTransparency = 1}, 0.3)
			local closeTween = Utility:Tween(MainFrame, {
				Position = UDim2.new(0.5, -220, 0.5, -110),
				GroupTransparency = 1,
				Size = UDim2.new(0, 420, 0, 260)
			}, 0.32)
			closeTween.Completed:Wait()
			MainGui:Destroy()
		end

		CloseBtn.MouseButton1Click:Connect(CloseUI)

		-- Shake
		local function ShakeUI()
			local originalPos = MainFrame.Position
			for i = 1, 6 do
				MainFrame.Position = originalPos + UDim2.new(0, math.random(-8, 8), 0, math.random(-5, 5))
				task.wait(0.04)
			end
			MainFrame.Position = originalPos
		end

		-- Dragging
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

		-- Verification Logic
		local isChecking = false

		-- Replace this with your real API later
		local function VerifyKeyFromSite(inputKey)
			-- Example real implementation:
			-- local url = "https://your-api.com/check?key=" .. HttpService:UrlEncode(inputKey)
			-- local res = game:HttpGet(url)
			-- return res == "valid"

			task.wait(1.4) -- Simulate network delay
			return (string.len(inputKey) >= 5)
		end

		local function CheckInput()
			if isChecking then return end
			isChecking = true

			local inputText = KeyInput.Text
			SubmitBtn.Text = "Checking..."
			Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}, 0.2)

			local successResult = false
			local expireDuration = 0

			if GetKeyFromSite then
				successResult = VerifyKeyFromSite(inputText)
				expireDuration = 86400 -- 24 hours
			else
				if inputText == KeyPass and KeyPass ~= "" then
					successResult = true
					expireDuration = 2592000 -- 30 days
				end
			end

			if successResult then
				-- Success state
				SubmitBtn.Text = "Success!"
				Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(40, 180, 90)}, 0.25)
				Utility:Tween(MainStroke, {Color = Color3.fromRGB(40, 200, 100), Transparency = 0.2}, 0.3)
				Utility:Tween(AccentLine, {BackgroundColor3 = Color3.fromRGB(40, 200, 100), Size = UDim2.new(0, 80, 0, 3)}, 0.35)

				SaveKeyData(FileName, inputText, expireDuration)

				Library:Notify({
					Title = "Access Granted",
					Content = "Key accepted. Loading script...",
					Duration = 3
				})

				task.wait(0.7)
				CloseUI()
				pcall(function() Callback(true) end)
			else
				-- Invalid state
				ShakeUI()
				SubmitBtn.Text = "Invalid Key"
				Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(210, 55, 55)}, 0.2)
				Utility:Tween(MainStroke, {Color = Color3.fromRGB(220, 60, 60), Transparency = 0.15}, 0.25)
				Utility:Tween(TBStroke, {Color = Color3.fromRGB(220, 60, 60)}, 0.2)

				Library:Notify({
					Title = "Access Denied",
					Content = "The key you entered is invalid or expired.",
					Duration = 3.5
				})

				task.wait(1.15)

				-- Reset
				SubmitBtn.Text = "Verify Key"
				Utility:Tween(SubmitBtn, {BackgroundColor3 = Color3.fromRGB(0, 145, 255)}, 0.25)
				Utility:Tween(MainStroke, {Color = Color3.fromRGB(70, 70, 95), Transparency = 0.55}, 0.3)
				Utility:Tween(TBStroke, {Color = Color3.fromRGB(60, 60, 80)}, 0.25)
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
					Duration = 4.5
				})
			else
				Library:Notify({
					Title = "Manual Action Required",
					Content = "Please visit: " .. Link,
					Duration = 7
				})
			end
		end)
	end

	return KeysysObj
end

return Library
