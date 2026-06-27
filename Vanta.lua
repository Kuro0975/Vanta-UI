-- Vanta UI Library (Bundled)
-- Created by Kuro

local Modules = {}
local Cache = {}

local function custom_require(name)
    if Cache[name] then return Cache[name] end
    if Modules[name] then
        Cache[name] = Modules[name]()
        return Cache[name]
    end
    error("Module not found: " .. tostring(name))
end

Modules["Main"] = function()
local Vanta = {}
Vanta.Window = custom_require("Window")
Vanta.ThemeManager = custom_require("ThemeManager")
function Vanta.CreateWindow(options)
local windowObj = Vanta.Window.New(options)
windowObj.Tabs = {}
function windowObj.CreateTab(tabOptions)
local Tab = custom_require("Tab")
return Tab.New(windowObj, tabOptions)
end
local Notification = custom_require("Notification")
Notification.Init(windowObj.GUI)
function Vanta.Notify(notifOptions)
Notification.New(notifOptions)
end
return windowObj
end
return Vanta

end

Modules["Tab"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Tab = {}
function Tab.New(windowObj, options)
options = options or {}
local name = options.Name or "Tab"
if not windowObj.TabContainer then
windowObj.TabContainer = Creator.New("ScrollingFrame", {
Name = "TabContainer",
Size = UDim2.new(1, 0, 1, -100), 
Position = UDim2.new(0, 0, 0, 80),
BackgroundTransparency = 1,
ScrollBarThickness = 0,
Parent = windowObj.Sidebar
}, {
Creator.New("UIListLayout", {
Padding = UDim.new(0, 5),
HorizontalAlignment = Enum.HorizontalAlignment.Center
})
})
end
local tabButton = Creator.New("TextButton", {
Name = name .. "TabButton",
Size = UDim2.new(1, -20, 0, 35),
BackgroundColor3 = ThemeManager.GetColor("Sidebar"), 
BorderSizePixel = 0,
Text = "",
Parent = windowObj.TabContainer
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) })
})
local tabLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -40, 1, 0),
Position = UDim2.new(0, 40, 0, 0),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = tabButton
})
ThemeManager.Register(tabLabel, "TextColor3", "SubText")
local tabContent = Creator.New("ScrollingFrame", {
Name = name .. "Content",
Size = UDim2.new(1, -40, 1, -20),
Position = UDim2.new(0, 20, 0, 10),
BackgroundTransparency = 1,
ScrollBarThickness = 2,
ScrollBarImageColor3 = ThemeManager.GetColor("Stroke"),
Visible = false,
Parent = windowObj.ContentArea
}, {
Creator.New("UIListLayout", {
Padding = UDim.new(0, 10),
SortOrder = Enum.SortOrder.LayoutOrder
})
})
tabButton.MouseButton1Click:Connect(function()
for _, otherTab in pairs(windowObj.Tabs) do
otherTab.Content.Visible = false
otherTab.Label.TextColor3 = ThemeManager.GetColor("SubText")
otherTab.Button.BackgroundColor3 = ThemeManager.GetColor("Sidebar")
end
tabContent.Visible = true
tabLabel.TextColor3 = ThemeManager.GetColor("Text")
tabButton.BackgroundColor3 = ThemeManager.GetColor("ElementHover")
end)
local TabObj = {
Button = tabButton,
Label = tabLabel,
Content = tabContent,
Window = windowObj
}
table.insert(windowObj.Tabs, TabObj)
if #windowObj.Tabs == 1 then
tabContent.Visible = true
tabLabel.TextColor3 = ThemeManager.GetColor("Text")
tabButton.BackgroundColor3 = ThemeManager.GetColor("ElementHover")
end
function TabObj.CreateSection(sectionName)
local Section = custom_require("Section")
return Section.New(TabObj, sectionName)
end
return TabObj
end
return Tab

end

Modules["Window"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Window = {}
function Window.New(options)
options = options or {}
local title = options.Title or "Vanta UI"
local size = options.Size or UDim2.new(0, 650, 0, 450)
local gui = Creator.New("ScreenGui", {
Name = "VantaUI",
ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})
if gethui then
gui.Parent = gethui()
else
local players = game:GetService("Players")
if players.LocalPlayer then
gui.Parent = players.LocalPlayer:WaitForChild("PlayerGui")
end
end
local mainFrame = Creator.New("Frame", {
Name = "Main",
Size = size,
Position = UDim2.new(0.5, 0, 0.5, 0),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = ThemeManager.GetColor("Background"),
BackgroundTransparency = 0.15, 
BorderSizePixel = 0,
Parent = gui
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Transparency = 0.5, 
Thickness = 1
})
})
ThemeManager.Register(mainFrame, "BackgroundColor3", "Background")
local sidebar = Creator.New("Frame", {
Name = "Sidebar",
Size = UDim2.new(0, 200, 1, 0),
BackgroundColor3 = ThemeManager.GetColor("Sidebar"),
BackgroundTransparency = 0.3, 
BorderSizePixel = 0,
Parent = mainFrame
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("Frame", {
Name = "CornerHider",
Size = UDim2.new(0, 10, 1, 0),
Position = UDim2.new(1, -10, 0, 0),
BackgroundColor3 = ThemeManager.GetColor("Sidebar"),
BackgroundTransparency = 0.3,
BorderSizePixel = 0
})
})
ThemeManager.Register(sidebar, "BackgroundColor3", "Sidebar")
ThemeManager.Register(sidebar.CornerHider, "BackgroundColor3", "Sidebar")
local profileArea = Creator.New("Frame", {
Name = "ProfileArea",
Size = UDim2.new(1, 0, 0, 70),
BackgroundTransparency = 1,
Parent = sidebar
})
if options.Profile then
local profileImage = Creator.New("ImageLabel", {
Size = UDim2.new(0, 40, 0, 40),
Position = UDim2.new(0, 15, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
Image = options.Profile.Image or "",
ScaleType = Enum.ScaleType.Crop,
BackgroundTransparency = 1,
Parent = profileArea
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
})
local profileName = Creator.New("TextLabel", {
Size = UDim2.new(1, -70, 0, 20),
Position = UDim2.new(0, 65, 0.5, -10),
BackgroundTransparency = 1,
Text = options.Profile.Name or "User",
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("TitleFont"),
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = profileArea
})
ThemeManager.Register(profileName, "TextColor3", "Text")
if options.Profile.Status then
local profileStatus = Creator.New("TextLabel", {
Size = UDim2.new(1, -70, 0, 15),
Position = UDim2.new(0, 65, 0.5, 10),
BackgroundTransparency = 1,
Text = options.Profile.Status,
TextColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 12,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = profileArea
})
ThemeManager.Register(profileStatus, "TextColor3", "SubText")
end
end
local topbar = Creator.New("Frame", {
Name = "Topbar",
Size = UDim2.new(1, -200, 0, 50),
Position = UDim2.new(0, 200, 0, 0),
BackgroundTransparency = 1,
Parent = mainFrame
})
local searchBarContainer = Creator.New("Frame", {
Name = "SearchContainer",
Size = UDim2.new(0, 250, 0, 30),
Position = UDim2.new(0, 20, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
BackgroundTransparency = 0.5, 
Parent = topbar
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
Creator.New("UIStroke", { 
Color = ThemeManager.GetColor("Stroke"),
Transparency = 0.5
})
})
ThemeManager.Register(searchBarContainer, "BackgroundColor3", "ElementBackground")
local searchBox = Creator.New("TextBox", {
Size = UDim2.new(1, -30, 1, 0),
Position = UDim2.new(0, 30, 0, 0),
BackgroundTransparency = 1,
Text = "",
PlaceholderText = "Search...",
TextColor3 = ThemeManager.GetColor("Text"),
PlaceholderColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = searchBarContainer
})
ThemeManager.Register(searchBox, "TextColor3", "Text")
local contentArea = Creator.New("Frame", {
Name = "ContentArea",
Size = UDim2.new(1, -200, 1, -80),
Position = UDim2.new(0, 200, 0, 50),
BackgroundTransparency = 1,
Parent = mainFrame
})
local footer = Creator.New("Frame", {
Name = "Footer",
Size = UDim2.new(1, -200, 0, 30),
Position = UDim2.new(0, 200, 1, -30),
BackgroundTransparency = 1,
Parent = mainFrame
})
local footerText = Creator.New("TextLabel", {
Size = UDim2.new(1, -20, 1, 0),
Position = UDim2.new(0, 20, 0, 0),
BackgroundTransparency = 1,
Text = "UI Library created by Kuro",
TextColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 11,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = footer
})
ThemeManager.Register(footerText, "TextColor3", "SubText")
local minimizeButton = Creator.New("TextButton", {
Size = UDim2.new(0, 30, 0, 30),
Position = UDim2.new(1, -70, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
Text = "-",
TextColor3 = ThemeManager.GetColor("SubText"),
Font = Enum.Font.Code,
TextSize = 20,
Parent = topbar
})
ThemeManager.Register(minimizeButton, "TextColor3", "SubText")
local minimized = false
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
minimizeButton.MouseButton1Click:Connect(function()
minimized = not minimized
if minimized then
tweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 50)}):Play()
sidebar.Visible = false
contentArea.Visible = false
footer.Visible = false
else
tweenService:Create(mainFrame, tweenInfo, {Size = size}):Play()
sidebar.Visible = true
contentArea.Visible = true
footer.Visible = true
end
end)
local closeButton = Creator.New("TextButton", {
Size = UDim2.new(0, 30, 0, 30),
Position = UDim2.new(1, -40, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
Text = "X",
TextColor3 = ThemeManager.GetColor("SubText"),
Font = Enum.Font.Code,
TextSize = 20,
Parent = topbar
})
ThemeManager.Register(closeButton, "TextColor3", "SubText")
closeButton.MouseButton1Click:Connect(function()
gui:Destroy()
end)
local dragging
local dragInput
local dragStart
local startPos
local function update(input)
local delta = input.Position - dragStart
local camera = workspace.CurrentCamera
local viewportSize = camera.ViewportSize
local sizeX = mainFrame.AbsoluteSize.X
local sizeY = mainFrame.AbsoluteSize.Y
local startAbsX = (startPos.X.Scale * viewportSize.X) + startPos.X.Offset
local startAbsY = (startPos.Y.Scale * viewportSize.Y) + startPos.Y.Offset
local newX = startAbsX + delta.X
local newY = startAbsY + delta.Y
newX = math.clamp(newX, sizeX / 2, viewportSize.X - (sizeX / 2))
newY = math.clamp(newY, sizeY / 2, viewportSize.Y - (sizeY / 2))
mainFrame.Position = UDim2.new(0, newX, 0, newY)
end
mainFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = mainFrame.Position
local inputChanged
local inputEnded
inputChanged = input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
inputChanged:Disconnect()
if inputEnded then inputEnded:Disconnect() end
end
end)
end
end)
mainFrame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
if input == dragInput and dragging then
update(input)
end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
if input.KeyCode == Enum.KeyCode.RightShift then
gui.Enabled = not gui.Enabled
end
end)
local WindowObj = {
GUI = gui,
MainFrame = mainFrame,
ContentArea = contentArea,
Sidebar = sidebar
}
return WindowObj
end
return Window

end

Modules["Button"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Button = {}
function Button.New(sectionObj, options)
options = options or {}
local name = options.Name or "Button"
local callback = options.Callback or function() end
local buttonFrame = Creator.New("TextButton", {
Name = "Button_" .. name,
Size = UDim2.new(1, 0, 0, 26),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
AutoButtonColor = false,
Text = "",
Parent = sectionObj.Container
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(buttonFrame, "BackgroundColor3", "ElementBackground")
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -20, 1, 0),
Position = UDim2.new(0, 10, 0, 0),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = buttonFrame
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local interactIcon = Creator.New("ImageLabel", {
Size = UDim2.new(0, 16, 0, 16),
Position = UDim2.new(1, -25, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
Image = "rbxassetid://10736932402", 
ImageColor3 = ThemeManager.GetColor("SubText"),
Parent = buttonFrame
})
ThemeManager.Register(interactIcon, "ImageColor3", "SubText")
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
buttonFrame.MouseEnter:Connect(function()
tweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementHover")}):Play()
end)
buttonFrame.MouseLeave:Connect(function()
tweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementBackground")}):Play()
end)
buttonFrame.MouseButton1Down:Connect(function()
tweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementPress")}):Play()
end)
buttonFrame.MouseButton1Up:Connect(function()
tweenService:Create(buttonFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementHover")}):Play()
callback()
end)
local ButtonObj = {
Instance = buttonFrame,
Update = function(self, newOptions)
if newOptions.Name then
titleLabel.Text = newOptions.Name
end
if newOptions.Callback then
callback = newOptions.Callback
end
end
}
table.insert(sectionObj.Elements, ButtonObj)
return ButtonObj
end
return Button

end

Modules["ColorPicker"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local ColorPicker = {}
function ColorPicker.New(sectionObj, options)
options = options or {}
local name = options.Name or "ColorPicker"
local defaultColor = options.Default or Color3.fromRGB(255, 255, 255)
local callback = options.Callback or function() end
local h, s, v = defaultColor:ToHSV()
local pickerFrame = Creator.New("Frame", {
Name = "ColorPicker_" .. name,
Size = UDim2.new(1, 0, 0, 30),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
Parent = sectionObj.Container,
ClipsDescendants = true
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(pickerFrame, "BackgroundColor3", "ElementBackground")
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -60, 1, 0),
Position = UDim2.new(0, 10, 0, 0),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = pickerFrame
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local colorPreview = Creator.New("Frame", {
Size = UDim2.new(0, 40, 0, 20),
Position = UDim2.new(1, -50, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundColor3 = defaultColor,
Parent = pickerFrame
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
Creator.New("UIStroke", { Color = ThemeManager.GetColor("Stroke"), Thickness = 1 })
})
local toggleButton = Creator.New("TextButton", {
Size = UDim2.new(1, 0, 0, 30),
BackgroundTransparency = 1,
Text = "",
Parent = pickerFrame
})
local dropdownArea = Creator.New("Frame", {
Size = UDim2.new(1, 0, 0, 70),
Position = UDim2.new(0, 0, 0, 30),
BackgroundTransparency = 1,
Parent = pickerFrame
})
local hueFrame = Creator.New("TextButton", {
Size = UDim2.new(1, -20, 0, 15),
Position = UDim2.new(0, 10, 0, 10),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
Text = "",
AutoButtonColor = false,
Parent = dropdownArea
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
Creator.New("UIGradient", {
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})
})
})
local hueIndicator = Creator.New("Frame", {
Size = UDim2.new(0, 4, 1, 4),
Position = UDim2.new(h, 0, 0.5, 0),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
Parent = hueFrame
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 2) }),
Creator.New("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1 })
})
local valFrame = Creator.New("TextButton", {
Size = UDim2.new(1, -20, 0, 15),
Position = UDim2.new(0, 10, 0, 35),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
Text = "",
AutoButtonColor = false,
Parent = dropdownArea
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
Creator.New("UIGradient", {
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
})
})
local valIndicator = Creator.New("Frame", {
Size = UDim2.new(0, 4, 1, 4),
Position = UDim2.new(v, 0, 0.5, 0),
AnchorPoint = Vector2.new(0.5, 0.5),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
Parent = valFrame
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 2) }),
Creator.New("UIStroke", { Color = Color3.fromRGB(0, 0, 0), Thickness = 1 })
})
local function updateColor()
local color = Color3.fromHSV(h, s, v)
colorPreview.BackgroundColor3 = color
valFrame.UIGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))
})
callback(color)
end
updateColor()
local userInputService = game:GetService("UserInputService")
local hueDragging = false
local valDragging = false
local function updateHue(input)
local pos = math.clamp((input.Position.X - hueFrame.AbsolutePosition.X) / hueFrame.AbsoluteSize.X, 0, 1)
h = pos
hueIndicator.Position = UDim2.new(pos, 0, 0.5, 0)
updateColor()
end
local function updateVal(input)
local pos = math.clamp((input.Position.X - valFrame.AbsolutePosition.X) / valFrame.AbsoluteSize.X, 0, 1)
v = pos
s = 1 
valIndicator.Position = UDim2.new(pos, 0, 0.5, 0)
updateColor()
end
hueFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
hueDragging = true
updateHue(input)
end
end)
valFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
valDragging = true
updateVal(input)
end
end)
userInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
hueDragging = false
valDragging = false
end
end)
userInputService.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
if hueDragging then updateHue(input) end
if valDragging then updateVal(input) end
end
end)
local isOpen = false
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
toggleButton.MouseButton1Click:Connect(function()
isOpen = not isOpen
local targetSize = isOpen and UDim2.new(1, 0, 0, 100) or UDim2.new(1, 0, 0, 30)
tweenService:Create(pickerFrame, tweenInfo, {Size = targetSize}):Play()
end)
local ColorPickerObj = {
Container = pickerFrame
}
return ColorPickerObj
end
return ColorPicker

end

Modules["Divider"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Divider = {}
function Divider.New(sectionObj)
local dividerFrame = Creator.New("Frame", {
Name = "Divider",
Size = UDim2.new(1, 0, 0, 1),
BackgroundColor3 = ThemeManager.GetColor("Divider"),
BorderSizePixel = 0,
Parent = sectionObj.Container
})
ThemeManager.Register(dividerFrame, "BackgroundColor3", "Divider")
local DividerObj = {
Instance = dividerFrame
}
table.insert(sectionObj.Elements, DividerObj)
return DividerObj
end
return Divider

end

Modules["Dropdown"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Dropdown = {}
function Dropdown.New(sectionObj, options)
options = options or {}
local name = options.Name or "Dropdown"
local items = options.Items or {}
local selected = options.Default
local callback = options.Callback or function() end
local isOpen = false
local dropdownFrame = Creator.New("Frame", {
Name = "Dropdown_" .. name,
Size = UDim2.new(1, 0, 0, 30),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
Parent = sectionObj.Container,
ClipsDescendants = true
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(dropdownFrame, "BackgroundColor3", "ElementBackground")
local toggleButton = Creator.New("TextButton", {
Size = UDim2.new(1, 0, 0, 30),
BackgroundTransparency = 1,
Text = "",
Parent = dropdownFrame
})
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -40, 1, 0),
Position = UDim2.new(0, 10, 0, 0),
BackgroundTransparency = 1,
Text = name .. (selected and (" - " .. selected) or ""),
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = toggleButton
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local chevron = Creator.New("ImageLabel", {
Size = UDim2.new(0, 16, 0, 16),
Position = UDim2.new(1, -25, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
Image = "rbxassetid://10736879829", 
ImageColor3 = ThemeManager.GetColor("SubText"),
Parent = toggleButton
})
ThemeManager.Register(chevron, "ImageColor3", "SubText")
local itemContainer = Creator.New("ScrollingFrame", {
Size = UDim2.new(1, 0, 1, -30),
Position = UDim2.new(0, 0, 0, 30),
BackgroundTransparency = 1,
ScrollBarThickness = 2,
ScrollBarImageColor3 = ThemeManager.GetColor("Stroke"),
CanvasSize = UDim2.new(0, 0, 0, 0),
Parent = dropdownFrame
}, {
Creator.New("UIListLayout", {
Padding = UDim.new(0, 2)
})
})
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local function refreshItems()
for _, child in pairs(itemContainer:GetChildren()) do
if child:IsA("TextButton") then child:Destroy() end
end
local ySize = 0
for _, item in ipairs(items) do
local itemButton = Creator.New("TextButton", {
Size = UDim2.new(1, -10, 0, 30),
Position = UDim2.new(0, 5, 0, 0),
BackgroundColor3 = ThemeManager.GetColor("ElementHover"),
BackgroundTransparency = (item == selected) and 0 or 1,
Text = "  " .. item,
TextColor3 = (item == selected) and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = itemContainer
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) })
})
itemButton.MouseButton1Click:Connect(function()
selected = item
titleLabel.Text = name .. " - " .. selected
callback(selected)
refreshItems()
end)
ySize = ySize + 32
end
itemContainer.CanvasSize = UDim2.new(0, 0, 0, ySize)
end
refreshItems()
toggleButton.MouseButton1Click:Connect(function()
isOpen = not isOpen
local targetSize = isOpen and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 30)
local targetRotation = isOpen and 180 or 0
tweenService:Create(dropdownFrame, tweenInfo, {Size = targetSize}):Play()
tweenService:Create(chevron, tweenInfo, {Rotation = targetRotation}):Play()
end)
local DropdownObj = {
Instance = dropdownFrame,
Set = function(self, value)
selected = value
titleLabel.Text = name .. " - " .. selected
refreshItems()
callback(selected)
end,
Refresh = function(self, newItems)
items = newItems
refreshItems()
end,
Get = function(self)
return selected
end
}
table.insert(sectionObj.Elements, DropdownObj)
return DropdownObj
end
return Dropdown

end

Modules["Keybind"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Keybind = {}
function Keybind.New(sectionObj, options)
options = options or {}
local name = options.Name or "Keybind"
local currentKey = options.Default or Enum.KeyCode.E
local callback = options.Callback or function() end
local isListening = false
local keybindContainer = Creator.New("Frame", {
Name = "Keybind_" .. name,
Size = UDim2.new(1, 0, 0, 35),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
Parent = sectionObj.Container
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(keybindContainer, "BackgroundColor3", "ElementBackground")
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -60, 1, 0),
Position = UDim2.new(0, 10, 0, 0),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = keybindContainer
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local bindButton = Creator.New("TextButton", {
Size = UDim2.new(0, 60, 0, 20),
Position = UDim2.new(1, -70, 0.5, -10),
BackgroundColor3 = ThemeManager.GetColor("Sidebar"),
Text = currentKey.Name,
TextColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 12,
Parent = keybindContainer
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(bindButton, "TextColor3", "SubText")
ThemeManager.Register(bindButton, "BackgroundColor3", "Sidebar")
local userInputService = game:GetService("UserInputService")
bindButton.MouseButton1Click:Connect(function()
isListening = true
bindButton.Text = "..."
bindButton.TextColor3 = ThemeManager.GetColor("Accent")
end)
userInputService.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end
if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
isListening = false
currentKey = input.KeyCode
bindButton.Text = currentKey.Name
bindButton.TextColor3 = ThemeManager.GetColor("SubText")
elseif not isListening and input.KeyCode == currentKey then
callback(currentKey)
end
end)
local KeybindObj = {
Instance = keybindContainer,
Set = function(self, newKey)
if typeof(newKey) == "EnumItem" then
currentKey = newKey
bindButton.Text = currentKey.Name
end
end,
Get = function(self)
return currentKey
end
}
table.insert(sectionObj.Elements, KeybindObj)
return KeybindObj
end
return Keybind

end

Modules["Label"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Label = {}
function Label.New(sectionObj, options)
options = options or {}
local text = options.Text or "Label"
local labelText = Creator.New("TextLabel", {
Name = "Label_" .. text,
Size = UDim2.new(1, 0, 0, 20),
BackgroundTransparency = 1,
Text = text,
TextColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
TextWrapped = true,
Parent = sectionObj.Container
})
ThemeManager.Register(labelText, "TextColor3", "SubText")
local function updateSize()
labelText.Size = UDim2.new(1, 0, 0, labelText.TextBounds.Y + 10)
end
labelText:GetPropertyChangedSignal("TextBounds"):Connect(updateSize)
updateSize()
local LabelObj = {
Instance = labelText,
Set = function(self, newText)
labelText.Text = tostring(newText)
end
}
table.insert(sectionObj.Elements, LabelObj)
return LabelObj
end
return Label

end

Modules["ProgressBar"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local ProgressBar = {}
function ProgressBar.New(sectionObj, options)
options = options or {}
local name = options.Name or "Progress"
local percent = options.Default or 0
local progressContainer = Creator.New("Frame", {
Name = "Progress_" .. name,
Size = UDim2.new(1, 0, 0, 45),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
Parent = sectionObj.Container
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(progressContainer, "BackgroundColor3", "ElementBackground")
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -20, 0, 15),
Position = UDim2.new(0, 10, 0, 4),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 12,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = progressContainer
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local percentLabel = Creator.New("TextLabel", {
Size = UDim2.new(0, 40, 0, 15),
Position = UDim2.new(1, -50, 0, 4),
BackgroundTransparency = 1,
Text = tostring(math.floor(percent)) .. "%",
TextColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 11,
TextXAlignment = Enum.TextXAlignment.Right,
Parent = progressContainer
})
ThemeManager.Register(percentLabel, "TextColor3", "SubText")
local trackFrame = Creator.New("Frame", {
Size = UDim2.new(1, -20, 0, 8),
Position = UDim2.new(0, 10, 0, 25),
BackgroundColor3 = ThemeManager.GetColor("Sidebar"),
Parent = progressContainer
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
})
local fillFrame = Creator.New("Frame", {
Size = UDim2.new(math.clamp(percent / 100, 0, 1), 0, 1, 0),
BackgroundColor3 = ThemeManager.GetColor("Accent"),
Parent = trackFrame
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
})
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local ProgressObj = {
Instance = progressContainer,
Set = function(self, newPercent)
percent = math.clamp(newPercent, 0, 100)
percentLabel.Text = tostring(math.floor(percent)) .. "%"
tweenService:Create(fillFrame, tweenInfo, {Size = UDim2.new(percent / 100, 0, 1, 0)}):Play()
end,
Get = function(self)
return percent
end
}
table.insert(sectionObj.Elements, ProgressObj)
return ProgressObj
end
return ProgressBar

end

Modules["Section"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Section = {}
function Section.New(tabObj, sectionName)
local sectionFrame = Creator.New("Frame", {
Name = "Section_" .. sectionName,
Size = UDim2.new(1, 0, 0, 0),
BackgroundTransparency = 1,
Parent = tabObj.Content
}, {
Creator.New("UIListLayout", {
Padding = UDim.new(0, 5),
SortOrder = Enum.SortOrder.LayoutOrder
})
})
local titleButton = Creator.New("TextButton", {
Name = "SectionTitle",
Size = UDim2.new(1, 0, 0, 20),
BackgroundTransparency = 1,
Text = "- " .. sectionName,
TextColor3 = ThemeManager.GetColor("Accent"),
Font = ThemeManager.GetColor("TitleFont"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = sectionFrame
})
ThemeManager.Register(titleButton, "TextColor3", "Accent")
local contentFrame = Creator.New("Frame", {
Name = "Content",
Size = UDim2.new(1, 0, 0, 0),
BackgroundTransparency = 1,
Parent = sectionFrame
}, {
Creator.New("UIListLayout", {
Padding = UDim.new(0, 6),
SortOrder = Enum.SortOrder.LayoutOrder
})
})
local isCollapsed = false
titleButton.MouseButton1Click:Connect(function()
isCollapsed = not isCollapsed
contentFrame.Visible = not isCollapsed
titleButton.Text = (isCollapsed and "+ " or "- ") .. sectionName
end)
local SectionObj = {
Container = contentFrame,
Tab = tabObj,
Elements = {}
}
local lastY = -1
contentFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
local newY = contentFrame.UIListLayout.AbsoluteContentSize.Y
if newY ~= lastY then
lastY = newY
contentFrame.Size = UDim2.new(1, 0, 0, newY)
end
end)
local lastSectionY = -1
sectionFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
local newY = sectionFrame.UIListLayout.AbsoluteContentSize.Y
if newY ~= lastSectionY then
lastSectionY = newY
sectionFrame.Size = UDim2.new(1, 0, 0, newY)
end
end)
function SectionObj.CreateButton(options)
local Button = custom_require("Button")
return Button.New(SectionObj, options)
end
function SectionObj.CreateToggle(options)
local Toggle = custom_require("Toggle")
return Toggle.New(SectionObj, options)
end
function SectionObj.CreateSlider(options)
local Slider = custom_require("Slider")
return Slider.New(SectionObj, options)
end
function SectionObj.CreateDropdown(options)
local Dropdown = custom_require("Dropdown")
return Dropdown.New(SectionObj, options)
end
function SectionObj.CreateTextbox(options)
local Textbox = custom_require("Textbox")
return Textbox.New(SectionObj, options)
end
function SectionObj.CreateDivider()
local Divider = custom_require("Divider")
return Divider.New(SectionObj)
end
function SectionObj.CreateLabel(options)
local Label = custom_require("Label")
return Label.New(SectionObj, options)
end
function SectionObj.CreateKeybind(options)
local Keybind = custom_require("Keybind")
local keybindObj = Keybind.New(SectionObj, options)
table.insert(SectionObj.Elements, keybindObj)
return keybindObj
end
function SectionObj.CreateColorPicker(options)
local ColorPicker = custom_require("ColorPicker")
local cpObj = ColorPicker.New(SectionObj, options)
table.insert(SectionObj.Elements, cpObj)
return cpObj
end
function SectionObj.CreateProgressBar(options)
local ProgressBar = custom_require("ProgressBar")
return ProgressBar.New(SectionObj, options)
end
return SectionObj
end
return Section

end

Modules["Slider"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Slider = {}
function Slider.New(sectionObj, options)
options = options or {}
local name = options.Name or "Slider"
local min = options.Min or 0
local max = options.Max or 100
local value = options.Default or min
local callback = options.Callback or function() end
value = math.clamp(value, min, max)
local sliderFrame = Creator.New("TextButton", {
Name = "Slider_" .. name,
Size = UDim2.new(1, 0, 0, 36),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
AutoButtonColor = false,
Text = "",
Parent = sectionObj.Container
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(sliderFrame, "BackgroundColor3", "ElementBackground")
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -20, 0, 20),
Position = UDim2.new(0, 10, 0, 5),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = sliderFrame
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local valueLabel = Creator.New("TextLabel", {
Size = UDim2.new(0, 50, 0, 20),
Position = UDim2.new(1, -60, 0, 5),
BackgroundTransparency = 1,
Text = tostring(value),
TextColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 12,
TextXAlignment = Enum.TextXAlignment.Right,
Parent = sliderFrame
})
ThemeManager.Register(valueLabel, "TextColor3", "SubText")
local trackFrame = Creator.New("Frame", {
Size = UDim2.new(1, -20, 0, 6),
Position = UDim2.new(0, 10, 1, -12),
BackgroundColor3 = ThemeManager.GetColor("Sidebar"),
Parent = sliderFrame
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
})
local fillFrame = Creator.New("Frame", {
Size = UDim2.new(0, 0, 1, 0), 
BackgroundColor3 = ThemeManager.GetColor("Accent"),
Parent = trackFrame
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
})
local function updateVisuals()
local percent = (value - min) / (max - min)
percent = math.clamp(percent, 0, 1)
fillFrame.Size = UDim2.new(percent, 0, 1, 0)
valueLabel.Text = tostring(math.floor(value * 10) / 10) 
end
updateVisuals()
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
sliderFrame.MouseEnter:Connect(function()
tweenService:Create(sliderFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementHover")}):Play()
end)
sliderFrame.MouseLeave:Connect(function()
tweenService:Create(sliderFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementBackground")}):Play()
end)
local userInputService = game:GetService("UserInputService")
local dragging = false
local inputChangedConn
local inputEndedConn
local function updateValue(input)
local pos = math.clamp((input.Position.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X, 0, 1)
value = min + ((max - min) * pos)
if options.Step then
value = math.floor(value / options.Step + 0.5) * options.Step
else
value = math.floor(value)
end
updateVisuals()
callback(value)
end
sliderFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
updateValue(input)
if not inputChangedConn then
inputChangedConn = userInputService.InputChanged:Connect(function(input2)
if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
updateValue(input2)
end
end)
end
if not inputEndedConn then
inputEndedConn = userInputService.InputEnded:Connect(function(input2)
if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
dragging = false
if inputChangedConn then inputChangedConn:Disconnect(); inputChangedConn = nil end
if inputEndedConn then inputEndedConn:Disconnect(); inputEndedConn = nil end
end
end)
end
end
end)
local SliderObj = {
Instance = sliderFrame,
Set = function(self, newValue)
value = math.clamp(newValue, min, max)
updateVisuals()
callback(value)
end,
Get = function(self)
return value
end
}
table.insert(sectionObj.Elements, SliderObj)
return SliderObj
end
return Slider

end

Modules["Textbox"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Textbox = {}
function Textbox.New(sectionObj, options)
options = options or {}
local name = options.Name or "Textbox"
local placeholder = options.Placeholder or "Type here..."
local value = options.Default or ""
local clearOnFocus = options.ClearOnFocus or false
local callback = options.Callback or function() end
local textboxContainer = Creator.New("Frame", {
Name = "Textbox_" .. name,
Size = UDim2.new(1, 0, 0, 45),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
Parent = sectionObj.Container
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(textboxContainer, "BackgroundColor3", "ElementBackground")
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -20, 0, 15),
Position = UDim2.new(0, 10, 0, 4),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 12,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = textboxContainer
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local inputBoxContainer = Creator.New("Frame", {
Size = UDim2.new(1, -20, 0, 20),
Position = UDim2.new(0, 10, 0, 20),
BackgroundColor3 = ThemeManager.GetColor("Sidebar"),
Parent = textboxContainer
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
local inputField = Creator.New("TextBox", {
Size = UDim2.new(1, -10, 1, 0),
Position = UDim2.new(0, 5, 0, 0),
BackgroundTransparency = 1,
Text = value,
PlaceholderText = placeholder,
TextColor3 = ThemeManager.GetColor("Text"),
PlaceholderColor3 = ThemeManager.GetColor("SubText"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
ClearTextOnFocus = clearOnFocus,
Parent = inputBoxContainer
})
ThemeManager.Register(inputField, "TextColor3", "Text")
inputField.FocusLost:Connect(function(enterPressed)
value = inputField.Text
callback(value)
end)
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
inputField.Focused:Connect(function()
tweenService:Create(inputBoxContainer.UIStroke, tweenInfo, {Color = ThemeManager.GetColor("Accent")}):Play()
end)
inputField.FocusLost:Connect(function()
tweenService:Create(inputBoxContainer.UIStroke, tweenInfo, {Color = ThemeManager.GetColor("Stroke")}):Play()
end)
local TextboxObj = {
Instance = textboxContainer,
Set = function(self, newValue)
value = tostring(newValue)
inputField.Text = value
callback(value)
end,
Get = function(self)
return value
end
}
table.insert(sectionObj.Elements, TextboxObj)
return TextboxObj
end
return Textbox

end

Modules["Toggle"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Toggle = {}
function Toggle.New(sectionObj, options)
options = options or {}
local name = options.Name or "Toggle"
local state = options.Default or false
local callback = options.Callback or function() end
local toggleFrame = Creator.New("TextButton", {
Name = "Toggle_" .. name,
Size = UDim2.new(1, 0, 0, 26),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
AutoButtonColor = false,
Text = "",
Parent = sectionObj.Container
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
ThemeManager.Register(toggleFrame, "BackgroundColor3", "ElementBackground")
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -60, 1, 0),
Position = UDim2.new(0, 10, 0, 0),
BackgroundTransparency = 1,
Text = name,
TextColor3 = ThemeManager.GetColor("Text"),
Font = ThemeManager.GetColor("Font"),
TextSize = 13,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = toggleFrame
})
ThemeManager.Register(titleLabel, "TextColor3", "Text")
local switchContainer = Creator.New("Frame", {
Size = UDim2.new(0, 40, 0, 20),
Position = UDim2.new(1, -50, 0.5, -10),
BackgroundColor3 = state and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("Sidebar"),
Parent = toggleFrame
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1
})
})
local switchKnob = Creator.New("Frame", {
Size = UDim2.new(0, 16, 0, 16),
Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
BackgroundColor3 = Color3.fromRGB(255, 255, 255),
Parent = switchContainer
}, {
Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
})
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function updateVisuals()
local bgTarget = state and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("Sidebar")
local knobPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
tweenService:Create(switchContainer, tweenInfo, {BackgroundColor3 = bgTarget}):Play()
tweenService:Create(switchKnob, tweenInfo, {Position = knobPos}):Play()
end
toggleFrame.MouseButton1Click:Connect(function()
state = not state
updateVisuals()
callback(state)
end)
toggleFrame.MouseEnter:Connect(function()
tweenService:Create(toggleFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementHover")}):Play()
end)
toggleFrame.MouseLeave:Connect(function()
tweenService:Create(toggleFrame, tweenInfo, {BackgroundColor3 = ThemeManager.GetColor("ElementBackground")}):Play()
end)
local ToggleObj = {
Instance = toggleFrame,
Set = function(self, newState)
state = newState
updateVisuals()
callback(state)
end,
Get = function(self)
return state
end
}
table.insert(sectionObj.Elements, ToggleObj)
return ToggleObj
end
return Toggle

end

Modules["Notification"] = function()
local Creator = custom_require("Creator")
local ThemeManager = custom_require("ThemeManager")
local Notification = {}
local container = nil
function Notification.Init(gui)
if not container then
container = Creator.New("Frame", {
Name = "NotificationContainer",
Size = UDim2.new(0, 300, 1, -20),
Position = UDim2.new(1, -320, 0, 10), 
BackgroundTransparency = 1,
Parent = gui
}, {
Creator.New("UIListLayout", {
Padding = UDim.new(0, 10),
SortOrder = Enum.SortOrder.LayoutOrder,
VerticalAlignment = Enum.VerticalAlignment.Bottom
})
})
end
end
function Notification.New(options)
options = options or {}
local title = options.Title or "Notification"
local content = options.Content or ""
local duration = options.Duration or 5
if not container then
warn("Vanta: Notification container not initialized.")
return
end
local notifFrame = Creator.New("Frame", {
Name = "Notification",
Size = UDim2.new(1, 0, 0, 70),
BackgroundColor3 = ThemeManager.GetColor("ElementBackground"),
BackgroundTransparency = 1, 
Parent = container
}, {
Creator.New("UICorner", { CornerRadius = ThemeManager.GetColor("CornerRadius") }),
Creator.New("UIStroke", {
Color = ThemeManager.GetColor("Stroke"),
Thickness = 1,
Transparency = 1 
})
})
local titleLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -20, 0, 20),
Position = UDim2.new(0, 10, 0, 10),
BackgroundTransparency = 1,
Text = title,
TextColor3 = ThemeManager.GetColor("Text"),
TextTransparency = 1,
Font = ThemeManager.GetColor("TitleFont"),
TextSize = 14,
TextXAlignment = Enum.TextXAlignment.Left,
Parent = notifFrame
})
local contentLabel = Creator.New("TextLabel", {
Size = UDim2.new(1, -20, 0, 30),
Position = UDim2.new(0, 10, 0, 30),
BackgroundTransparency = 1,
Text = content,
TextColor3 = ThemeManager.GetColor("SubText"),
TextTransparency = 1,
Font = ThemeManager.GetColor("Font"),
TextSize = 12,
TextXAlignment = Enum.TextXAlignment.Left,
TextWrapped = true,
Parent = notifFrame
})
local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
tweenService:Create(notifFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
tweenService:Create(notifFrame.UIStroke, tweenInfo, {Transparency = 0}):Play()
tweenService:Create(titleLabel, tweenInfo, {TextTransparency = 0}):Play()
tweenService:Create(contentLabel, tweenInfo, {TextTransparency = 0}):Play()
task.delay(duration, function()
local fadeOut = tweenService:Create(notifFrame, tweenInfo, {BackgroundTransparency = 1})
tweenService:Create(notifFrame.UIStroke, tweenInfo, {Transparency = 1}):Play()
tweenService:Create(titleLabel, tweenInfo, {TextTransparency = 1}):Play()
tweenService:Create(contentLabel, tweenInfo, {TextTransparency = 1}):Play()
fadeOut.Completed:Connect(function()
notifFrame:Destroy()
end)
fadeOut:Play()
end)
end
return Notification

end

Modules["Search"] = function()
local Search = {}
Search.Registry = {}
function Search.Register(name, elementObj, tabObj)
table.insert(Search.Registry, {
Name = name:lower(),
Element = elementObj,
Tab = tabObj
})
end
function Search.Init(searchBox, windowObj)
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
local query = searchBox.Text:lower()
if query == "" then
for _, entry in ipairs(Search.Registry) do
if entry.Element.Instance then
entry.Element.Instance.Visible = true
end
end
return
end
for _, entry in ipairs(Search.Registry) do
if entry.Element.Instance then
if string.find(entry.Name, query, 1, true) then
entry.Element.Instance.Visible = true
else
entry.Element.Instance.Visible = false
end
end
end
end)
end
return Search

end

Modules["Default"] = function()
local DefaultTheme = {
Background = Color3.fromRGB(24, 24, 24),
Sidebar = Color3.fromRGB(32, 32, 32),
Topbar = Color3.fromRGB(32, 32, 32),
ElementBackground = Color3.fromRGB(42, 42, 42),
ElementHover = Color3.fromRGB(52, 52, 52),
ElementPress = Color3.fromRGB(30, 30, 30),
Accent = Color3.fromRGB(66, 150, 250),
Divider = Color3.fromRGB(55, 55, 55),
Stroke = Color3.fromRGB(48, 48, 48),
Text = Color3.fromRGB(240, 240, 240),
SubText = Color3.fromRGB(160, 160, 160),
Font = Enum.Font.Code,
TitleFont = Enum.Font.Code,
CornerRadius = UDim.new(0, 3),
Padding = UDim.new(0, 10),
Success = Color3.fromRGB(50, 200, 50),
Warning = Color3.fromRGB(200, 150, 50),
Error = Color3.fromRGB(200, 50, 50)
}
return DefaultTheme

end

Modules["ThemeManager"] = function()
local DefaultTheme = custom_require("Default")
local ThemeManager = {
CurrentTheme = DefaultTheme,
ThemeListeners = {}
}
function ThemeManager.Register(instance, property, themeKey)
if not ThemeManager.ThemeListeners[instance] then
ThemeManager.ThemeListeners[instance] = {}
end
ThemeManager.ThemeListeners[instance][property] = themeKey
ThemeManager.Apply(instance, property, themeKey)
end
function ThemeManager.Apply(instance, property, themeKey)
if ThemeManager.CurrentTheme[themeKey] then
instance[property] = ThemeManager.CurrentTheme[themeKey]
end
end
function ThemeManager.GetColor(themeKey)
return ThemeManager.CurrentTheme[themeKey] or Color3.fromRGB(255, 255, 255)
end
function ThemeManager.SetTheme(newTheme)
ThemeManager.CurrentTheme = newTheme
for instance, props in pairs(ThemeManager.ThemeListeners) do
if instance.Parent then
for prop, themeKey in pairs(props) do
ThemeManager.Apply(instance, prop, themeKey)
end
else
ThemeManager.ThemeListeners[instance] = nil 
end
end
end
return ThemeManager

end

Modules["Creator"] = function()
local Creator = {}
function Creator.New(class, properties, children)
local instance = Instance.new(class)
if properties then
for prop, value in pairs(properties) do
if prop ~= "Parent" then
instance[prop] = value
end
end
if properties.Parent then
instance.Parent = properties.Parent
end
end
if children then
for _, child in pairs(children) do
if typeof(child) == "Instance" then
child.Parent = instance
end
end
end
return instance
end
return Creator

end

-- Initialize the library
return custom_require("Main")
