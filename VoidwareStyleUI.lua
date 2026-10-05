--[[
    VoidwareStyleUI.lua
    UI Shell เลียนแบบสไตล์ภาพตัวอย่าง: ไอคอนมุมจอ -> เปิด panel
    มี Sidebar tab + Content panel, Toggle switch, Search bar
    ทุกอย่างเป็นแค่ "โครง UI" เปล่าๆ ไม่มีฟังก์ชันใดๆ ผูกอยู่
    ผู้ใช้สามารถนำ callback ของตัวเองไปใส่ในแต่ละ element เองได้

    วิธีใช้: ใส่เป็น LocalScript ไว้ใน StarterGui
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- CONFIG
------------------------------------------------------------
local THEME = {
    Background   = Color3.fromRGB(58, 38, 72),
    Panel        = Color3.fromRGB(70, 46, 88),
    PanelLight   = Color3.fromRGB(82, 54, 102),
    Accent       = Color3.fromRGB(255, 255, 255),
    TextPrimary  = Color3.fromRGB(240, 235, 245),
    TextMuted    = Color3.fromRGB(190, 175, 200),
    ToggleOff    = Color3.fromRGB(100, 75, 120),
    ToggleOn     = Color3.fromRGB(255, 255, 255),
}

local TWEEN_FAST = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_OPEN = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

------------------------------------------------------------
-- ROOT
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidwareStyleUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

------------------------------------------------------------
-- TOGGLE ICON (มุมจอ กดเปิด/ปิด)
------------------------------------------------------------
local iconButton = Instance.new("ImageButton")
iconButton.Name = "ToggleIcon"
iconButton.Size = UDim2.new(0, 46, 0, 46)
iconButton.Position = UDim2.new(0, 20, 0, 20)
iconButton.BackgroundColor3 = THEME.Panel
iconButton.AutoButtonColor = false
iconButton.Image = "" -- ใส่ rbxassetid ของไอคอนคุณเองตรงนี้
iconButton.ScaleType = Enum.ScaleType.Fit
iconButton.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 12)
iconCorner.Parent = iconButton

------------------------------------------------------------
-- MAIN WINDOW
------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 560, 0, 400)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
mainFrame.BackgroundColor3 = THEME.Background
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Drag support
do
    local dragging, dragStart, startPos
    local topBarForDrag = mainFrame

    topBarForDrag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
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

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

------------------------------------------------------------
-- TOP BAR
------------------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 56)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 200, 0, 20)
titleLabel.Position = UDim2.new(0, 56, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "My UI"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = THEME.TextPrimary
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(0, 200, 0, 16)
subtitleLabel.Position = UDim2.new(0, 56, 0, 30)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "yourdomain.example"
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextSize = 12
subtitleLabel.TextColor3 = THEME.TextMuted
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -44, 0, 12)
closeButton.BackgroundTransparency = 1
closeButton.Text = "✕"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.TextColor3 = THEME.TextPrimary
closeButton.Parent = topBar

------------------------------------------------------------
-- SEARCH BAR
------------------------------------------------------------
local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(0, 150, 0, 34)
searchBox.Position = UDim2.new(0, 14, 0, 62)
searchBox.BackgroundColor3 = THEME.Panel
searchBox.PlaceholderText = "  Search"
searchBox.Text = ""
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 13
searchBox.TextColor3 = THEME.TextPrimary
searchBox.PlaceholderColor3 = THEME.TextMuted
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 10)
searchCorner.Parent = searchBox

------------------------------------------------------------
-- SIDEBAR
------------------------------------------------------------
local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 150, 1, -108)
sidebar.Position = UDim2.new(0, 14, 0, 104)
sidebar.BackgroundTransparency = 1
sidebar.ScrollBarThickness = 3
sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.Parent = mainFrame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebar

local TAB_NAMES = {
    "Information", "Fun", "Automation", "Bring Stuff",
    "Main", "Fishing", "Teleport", "Visuals",
}

------------------------------------------------------------
-- CONTENT PANEL
------------------------------------------------------------
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -196, 1, -108)
content.Position = UDim2.new(0, 182, 0, 104)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

------------------------------------------------------------
-- HELPER: สร้างปุ่ม tab บน sidebar
------------------------------------------------------------
local tabButtons = {}
local tabPages = {}

local function createTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = THEME.Panel
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.LayoutOrder = order
    btn.Parent = sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = THEME.TextMuted
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    tabButtons[name] = { button = btn, label = label }
    return btn
end

------------------------------------------------------------
-- HELPER: สร้างแถว toggle ในหน้า content
------------------------------------------------------------
local function createToggleRow(parent, title, desc, order, default, onChanged)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, desc and 56 or 44)
    row.BackgroundColor3 = THEME.Panel
    row.LayoutOrder = order
    row.Parent = parent

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 10)
    rowCorner.Parent = row

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -80, 0, 18)
    titleLbl.Position = UDim2.new(0, 14, 0, desc and 8 or 13)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = THEME.TextPrimary
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = row

    if desc then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, -80, 0, 16)
        descLbl.Position = UDim2.new(0, 14, 0, 28)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextSize = 11
        descLbl.TextColor3 = THEME.TextMuted
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.Parent = row
    end

    -- Toggle switch
    local switchBG = Instance.new("Frame")
    switchBG.Size = UDim2.new(0, 42, 0, 22)
    switchBG.Position = UDim2.new(1, -56, 0.5, -11)
    switchBG.BackgroundColor3 = default and THEME.ToggleOn or THEME.ToggleOff
    switchBG.Parent = row

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBG

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = default and THEME.Panel or THEME.Accent
    knob.Parent = switchBG

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = switchBG

    local state = default or false
    clickArea.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(switchBG, TWEEN_FAST, {
            BackgroundColor3 = state and THEME.ToggleOn or THEME.ToggleOff
        }):Play()
        TweenService:Create(knob, TWEEN_FAST, {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = state and THEME.Panel or THEME.Accent
        }):Play()
        if onChanged then
            onChanged(state)
        end
    end)

    return row
end

------------------------------------------------------------
-- HELPER: สร้าง section header (เช่น "Coordinates", "Credits")
------------------------------------------------------------
local function createSectionHeader(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextColor3 = THEME.TextPrimary
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order
    lbl.Parent = parent
    return lbl
end

------------------------------------------------------------
-- HELPER: สร้างหน้า content ว่างๆ สำหรับแต่ละ tab
------------------------------------------------------------
local function createTabPage(name)
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    tabPages[name] = page
    return page
end

------------------------------------------------------------
-- สร้าง tab ทั้งหมด + หน้าตัวอย่างว่างๆ
------------------------------------------------------------
local currentTab = nil

local function selectTab(name)
    if currentTab == name then return end
    currentTab = name

    for tabName, data in pairs(tabButtons) do
        local isActive = tabName == name
        TweenService:Create(data.button, TWEEN_FAST, {
            BackgroundTransparency = isActive and 0 or 1
        }):Play()
        TweenService:Create(data.label, TWEEN_FAST, {
            TextColor3 = isActive and THEME.TextPrimary or THEME.TextMuted
        }):Play()
    end

    for pageName, page in pairs(tabPages) do
        page.Visible = pageName == name
    end
end

for i, name in ipairs(TAB_NAMES) do
    local btn = createTabButton(name, i)
    local page = createTabPage(name)

    -- ตัวอย่าง element เปล่าๆ ในแต่ละหน้า (ผู้ใช้ไปแก้ callback เองได้)
    createToggleRow(page, name .. " Example", "Example description text", 1, false, function(state)
        -- ใส่ logic ของคุณเองตรงนี้
    end)

    btn.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end

-- Credits section ใน tab แรก (Information) ตามภาพตัวอย่าง
do
    local infoPage = tabPages["Information"]
    createSectionHeader(infoPage, "Credits", 2)

    local creditRow = Instance.new("Frame")
    creditRow.Size = UDim2.new(1, 0, 0, 40)
    creditRow.BackgroundColor3 = THEME.Panel
    creditRow.LayoutOrder = 3
    creditRow.Parent = infoPage

    local creditCorner = Instance.new("UICorner")
    creditCorner.CornerRadius = UDim.new(0, 10)
    creditCorner.Parent = creditRow

    local creditLbl = Instance.new("TextLabel")
    creditLbl.Size = UDim2.new(1, -16, 1, 0)
    creditLbl.Position = UDim2.new(0, 14, 0, 0)
    creditLbl.BackgroundTransparency = 1
    creditLbl.Text = "your name - script dev"
    creditLbl.Font = Enum.Font.Gotham
    creditLbl.TextSize = 13
    creditLbl.TextColor3 = THEME.TextPrimary
    creditLbl.TextXAlignment = Enum.TextXAlignment.Left
    creditLbl.Parent = creditRow
end

selectTab(TAB_NAMES[1])

------------------------------------------------------------
-- OPEN / CLOSE ANIMATION
------------------------------------------------------------
local isOpen = false

local function openUI()
    isOpen = true
    mainFrame.Size = UDim2.new(0, 560, 0, 0)
    mainFrame.Position = UDim2.new(0.5, -280, 0.5, -10)
    mainFrame.Visible = true
    TweenService:Create(mainFrame, TWEEN_OPEN, {
        Size = UDim2.new(0, 560, 0, 400),
        Position = UDim2.new(0.5, -280, 0.5, -200),
    }):Play()
end

local function closeUI()
    isOpen = false
    local tween = TweenService:Create(mainFrame, TWEEN_OPEN, {
        Size = UDim2.new(0, 560, 0, 0),
        Position = UDim2.new(0.5, -280, 0.5, -10),
    })
    tween:Play()
    tween.Completed:Connect(function()
        if not isOpen then
            mainFrame.Visible = false
        end
    end)
end

iconButton.MouseButton1Click:Connect(function()
    if isOpen then
        closeUI()
    else
        openUI()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    closeUI()
end)
