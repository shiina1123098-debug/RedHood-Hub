--// RedHood Hub v4 - Full Edition
--// Integrado con funciones de RedHood Hub
--// UI via pastebin loader

--// ============================================
--// SERVICIOS
--// ============================================

local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser   = game:GetService("VirtualUser")
local VIM           = game:GetService("VirtualInputManager")

local player        = Players.LocalPlayer
local muscleEvent   = player:WaitForChild("muscleEvent")

--// ============================================
--// DESTRUIR INSTANCIA PREVIA
--// ============================================

if player.PlayerGui:FindFirstChild("RedHoodHub") then
    player.PlayerGui.RedHoodHub:Destroy()
end

--// ============================================
--// SCREENGUI
--// ============================================

local gui = Instance.new("ScreenGui")
gui.Name = "RedHoodHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

--// ============================================
--// UTILIDADES
--// ============================================

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(80, 0, 0)
    s.Thickness = thickness or 1.2
    s.Transparency = transparency or 0.4
    s.Parent = parent
    return s
end

local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

--// ============================================
--// ============================================
--// UTILIDADES
--// ============================================

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(150, 20, 45)
    s.Thickness = thickness or 1.2
    s.Transparency = transparency or 0.35
    s.Parent = parent
    return s
end

local function MakeGradient(parent, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c0),
        ColorSequenceKeypoint.new(1, c1)
    })
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- Paleta central
local C = {
    BG_DEEP   = Color3.fromRGB(7,  4,  11),
    BG_MID    = Color3.fromRGB(13, 7,  19),
    BG_SURF   = Color3.fromRGB(19, 9,  26),
    BG_ELEM   = Color3.fromRGB(24, 10, 20),
    BG_ELEM2  = Color3.fromRGB(20, 8,  28),
    ACC       = Color3.fromRGB(190, 25, 52),
    ACC_BR    = Color3.fromRGB(245, 58, 85),
    ACC_GLOW  = Color3.fromRGB(255, 85, 108),
    ACC_DIM   = Color3.fromRGB(88,  14, 30),
    STROKE    = Color3.fromRGB(155, 22, 48),
    STROKE_DIM= Color3.fromRGB(70,  12, 25),
    TXT_W     = Color3.fromRGB(252, 236, 242),
    TXT_M     = Color3.fromRGB(198, 148, 168),
    TXT_D     = Color3.fromRGB(95,  52,  72),
}

--// ============================================
--// NOTIFICACION
--// ============================================

local _notifStack = 0
local function Notify(text, duration)
    duration = duration or 3
    _notifStack = _notifStack + 1
    local slot = _notifStack

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 285, 0, 52)
    notif.Position = UDim2.new(1, -295, 1, 10)
    notif.BackgroundColor3 = C.BG_MID
    notif.BackgroundTransparency = 0.04
    notif.BorderSizePixel = 0
    notif.ZIndex = 200
    notif.Parent = gui
    MakeCorner(notif, 14)
    MakeStroke(notif, C.STROKE, 1.2, 0.25)
    MakeGradient(notif, C.BG_SURF, C.BG_DEEP, 130)

    -- Barra de color izquierda
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0.65, 0)
    bar.Position = UDim2.new(0, 6, 0.175, 0)
    bar.BackgroundColor3 = C.ACC_BR
    bar.BorderSizePixel = 0
    bar.ZIndex = 202
    bar.Parent = notif
    MakeCorner(bar, 3)

    -- Ãcono circulito rojo
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 7, 0, 7)
    dot.Position = UDim2.new(0, 16, 0.5, -3)
    dot.BackgroundColor3 = C.ACC_GLOW
    dot.BorderSizePixel = 0
    dot.ZIndex = 202
    dot.Parent = notif
    MakeCorner(dot, 4)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -34, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.TXT_W
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.ZIndex = 201
    label.Parent = notif

    -- Barra de progreso de tiempo
    local progBg = Instance.new("Frame")
    progBg.Size = UDim2.new(1, -16, 0, 2)
    progBg.Position = UDim2.new(0, 8, 1, -4)
    progBg.BackgroundColor3 = C.ACC_DIM
    progBg.BackgroundTransparency = 0.4
    progBg.BorderSizePixel = 0
    progBg.ZIndex = 202
    progBg.Parent = notif
    MakeCorner(progBg, 1)

    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(1, 0, 1, 0)
    progFill.BackgroundColor3 = C.ACC_BR
    progFill.BorderSizePixel = 0
    progFill.ZIndex = 203
    progFill.Parent = progBg
    MakeCorner(progFill, 1)

    local yTarget = -58 - (slot - 1) * 60
    Tween(notif, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -295, 1, yTarget)
    })
    TweenService:Create(progFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.spawn(function()
        task.wait(duration)
        Tween(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, -295, 1, 10)
        })
        task.wait(0.35)
        _notifStack = math.max(0, _notifStack - 1)
        if notif and notif.Parent then notif:Destroy() end
    end)
end

--// ============================================
--// MAIN FRAME
--// ============================================

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 598, 0, 375)
Main.Position = UDim2.new(0.5, -299, 0.5, -187)
Main.BackgroundColor3 = C.BG_DEEP
Main.BackgroundTransparency = 0.04
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = gui
MakeCorner(Main, 22)
MakeStroke(Main, C.STROKE, 1.5, 0.15)
MakeGradient(Main, C.BG_MID, C.BG_DEEP, 150)

-- Brillo sutil en esquina superior izquierda
local mainGlow = Instance.new("Frame")
mainGlow.Size = UDim2.new(0, 260, 0, 180)
mainGlow.Position = UDim2.new(0, -40, 0, -60)
mainGlow.BackgroundColor3 = C.ACC
mainGlow.BackgroundTransparency = 0.91
mainGlow.BorderSizePixel = 0
mainGlow.ZIndex = 1
mainGlow.Parent = Main
MakeCorner(mainGlow, 90)

--// ============================================
--// HEADER
--// ============================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = C.BG_SURF
Header.BackgroundTransparency = 0.0
Header.BorderSizePixel = 0
Header.ZIndex = 5
Header.Parent = Main
MakeCorner(Header, 22)
MakeGradient(Header, C.BG_ELEM, C.BG_DEEP, 170)

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, -24, 0, 1)
HeaderLine.Position = UDim2.new(0, 12, 1, -1)
HeaderLine.BackgroundColor3 = C.STROKE
HeaderLine.BackgroundTransparency = 0.2
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 6
HeaderLine.Parent = Header
MakeCorner(HeaderLine, 1)

-- Logo - borde con pulso animado
local LogoBorder = Instance.new("Frame")
LogoBorder.Size = UDim2.new(0, 36, 0, 36)
LogoBorder.Position = UDim2.new(0, 9, 0.5, -18)
LogoBorder.BackgroundColor3 = C.ACC_DIM
LogoBorder.BorderSizePixel = 0
LogoBorder.ZIndex = 7
LogoBorder.Parent = Header
MakeCorner(LogoBorder, 18)
local logoBorderStroke = MakeStroke(LogoBorder, C.ACC_BR, 1.8, 0.0)

local LogoImg = Instance.new("ImageLabel")
LogoImg.Size = UDim2.new(1, -4, 1, -4)
LogoImg.Position = UDim2.new(0, 2, 0, 2)
LogoImg.BackgroundTransparency = 1
LogoImg.Image = "rbxassetid://95596426520626"
LogoImg.ScaleType = Enum.ScaleType.Crop
LogoImg.ZIndex = 8
LogoImg.Parent = LogoBorder
MakeCorner(LogoImg, 16)

-- Pulso del logo
task.spawn(function()
    local t = 0
    while gui.Parent do
        t = t + 0.04
        pcall(function()
            logoBorderStroke.Transparency = 0.1 + math.abs(math.sin(t * 1.4)) * 0.65
        end)
        task.wait(0.04)
    end
end)

-- TÃ­tulo con subtÃ­tulo
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 140, 0, 28)
Title.Position = UDim2.new(0, 53, 0.5, -20)
Title.BackgroundTransparency = 1
Title.Text = "RedHood Hub"
Title.TextColor3 = C.TXT_W
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6
Title.Parent = Header

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.ACC_GLOW),
    ColorSequenceKeypoint.new(0.55, C.TXT_W),
    ColorSequenceKeypoint.new(1, C.TXT_M),
})
TitleGrad.Rotation = 0
TitleGrad.Parent = Title

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 140, 0, 16)
SubTitle.Position = UDim2.new(0, 53, 0.5, 8)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "v4  .  Muscle Legends"
SubTitle.TextColor3 = C.TXT_D
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 6
SubTitle.Parent = Header

-- Botones Min / Close
local function MakeHeaderBtn(xOff, icon, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(1, xOff, 0.5, -14)
    btn.Text = icon
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = C.BG_ELEM2
    btn.BackgroundTransparency = 0.15
    btn.TextColor3 = C.TXT_M
    btn.BorderSizePixel = 0
    btn.ZIndex = 7
    btn.Parent = Header
    MakeCorner(btn, 9)
    MakeStroke(btn, C.STROKE_DIM, 1, 0.4)
    btn.MouseEnter:Connect(function()
        Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor, TextColor3 = C.TXT_W})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.BG_ELEM2, TextColor3 = C.TXT_M})
    end)
    return btn
end

local MinBtn   = MakeHeaderBtn(-68, "-", Color3.fromRGB(200, 160, 20))
local CloseBtn = MakeHeaderBtn(-34, "x", Color3.fromRGB(190, 30, 50))

--// ============================================
--// SIDEBAR
--// ============================================

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 122, 1, -70)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = C.BG_MID
Sidebar.BackgroundTransparency = 0.0
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
Sidebar.Parent = Main
MakeCorner(Sidebar, 22)
MakeGradient(Sidebar, C.BG_ELEM2, C.BG_DEEP, 180)

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, -20)
SidebarLine.Position = UDim2.new(1, 0, 0, 10)
SidebarLine.BackgroundColor3 = C.STROKE_DIM
SidebarLine.BackgroundTransparency = 0.3
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Parent = Main

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 3)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 10)
SidebarPad.Parent = Sidebar

--// ============================================
--// CONTENT AREA
--// ============================================

-- Status bar inferior
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 20)
StatusBar.Position = UDim2.new(0, 0, 1, -20)
StatusBar.BackgroundColor3 = C.BG_DEEP
StatusBar.BackgroundTransparency = 0.0
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 4
StatusBar.Parent = Main

local StatusLine = Instance.new("Frame")
StatusLine.Size = UDim2.new(1, -16, 0, 1)
StatusLine.Position = UDim2.new(0, 8, 0, 0)
StatusLine.BackgroundColor3 = C.STROKE_DIM
StatusLine.BackgroundTransparency = 0.4
StatusLine.BorderSizePixel = 0
StatusLine.ZIndex = 5
StatusLine.Parent = StatusBar
MakeCorner(StatusLine, 1)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.6, 0, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "RedHood Hub v4  .  Muscle Legends"
StatusLabel.TextColor3 = C.TXT_D
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 5
StatusLabel.Parent = StatusBar

local StatusRight = Instance.new("TextLabel")
StatusRight.Size = UDim2.new(0.4, -10, 1, 0)
StatusRight.Position = UDim2.new(0.6, 0, 0, 0)
StatusRight.BackgroundTransparency = 1
StatusRight.Text = "By Shiina"
StatusRight.TextColor3 = C.TXT_D
StatusRight.TextSize = 10
StatusRight.Font = Enum.Font.Gotham
StatusRight.TextXAlignment = Enum.TextXAlignment.Right
StatusRight.ZIndex = 5
StatusRight.Parent = StatusBar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -132, 1, -78)
ContentArea.Position = UDim2.new(0, 128, 0, 53)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 4
ContentArea.Parent = Main

--// ============================================
--// SISTEMA DE TABS
--// ============================================

local currentTab = nil

local function SwitchTab(tabData)
    if currentTab == tabData then return end
    if currentTab then
        currentTab.panel.Visible = false
        Tween(currentTab.btn,       TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, BackgroundColor3 = C.BG_ELEM2})
        Tween(currentTab.label,     TweenInfo.new(0.22), {TextColor3 = C.TXT_D})
        Tween(currentTab.indicator, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1})
    end
    currentTab = tabData
    tabData.panel.Visible = true
    Tween(tabData.btn,       TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.72, BackgroundColor3 = C.ACC})
    Tween(tabData.label,     TweenInfo.new(0.22), {TextColor3 = C.TXT_W})
    Tween(tabData.indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0.6, 0), BackgroundTransparency = 0})
end

local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.BackgroundColor3 = C.ACC
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.Parent = Sidebar
    MakeCorner(btn, 11)

    -- Fondo activo con gradiente
    local btnGrad = MakeGradient(btn, C.ACC, Color3.fromRGB(100, 12, 30), 160)

    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, -16, 1, 0)
    btnLabel.Position = UDim2.new(0, 14, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = (icon and (icon .. "  ") or "") .. name
    btnLabel.TextColor3 = C.TXT_D
    btnLabel.TextSize = 12
    btnLabel.Font = Enum.Font.GothamSemibold
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.ZIndex = 6
    btnLabel.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.BackgroundColor3 = C.ACC_GLOW
    indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = 1
    indicator.ZIndex = 7
    indicator.Parent = btn
    MakeCorner(indicator, 2)

    local panel = Instance.new("ScrollingFrame")
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    panel.Visible = false
    panel.ZIndex = 4
    panel.ScrollBarThickness = 2
    panel.ScrollBarImageColor3 = C.STROKE
    panel.CanvasSize = UDim2.new(0, 0, 0, 0)
    panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    panel.Parent = ContentArea

    local panelLayout = Instance.new("UIListLayout")
    panelLayout.Padding = UDim.new(0, 7)
    panelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    panelLayout.Parent = panel

    local panelPad = Instance.new("UIPadding")
    panelPad.PaddingTop    = UDim.new(0, 8)
    panelPad.PaddingRight  = UDim.new(0, 6)
    panelPad.PaddingBottom = UDim.new(0, 8)
    panelPad.Parent = panel

    local tabData = {btn = btn, panel = panel, label = btnLabel, indicator = indicator}

    btn.MouseEnter:Connect(function()
        if currentTab ~= tabData then
            Tween(btn,      TweenInfo.new(0.18), {BackgroundTransparency = 0.88, BackgroundColor3 = C.ACC})
            Tween(btnLabel, TweenInfo.new(0.18), {TextColor3 = C.TXT_M})
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= tabData then
            Tween(btn,      TweenInfo.new(0.18), {BackgroundTransparency = 1})
            Tween(btnLabel, TweenInfo.new(0.18), {TextColor3 = C.TXT_D})
        end
    end)
    btn.Activated:Connect(function() SwitchTab(tabData) end)

    return panel, tabData
end

--// ============================================
--// COMPONENTES UI
--// ============================================

local _layoutCounter = {}
local function _nextOrder(parent)
    local key = tostring(parent)
    _layoutCounter[key] = (_layoutCounter[key] or 0) + 1
    return _layoutCounter[key]
end

-- LABEL de seccion
local function CreateLabel(parent, text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 26)
    row.BackgroundTransparency = 1
    row.ZIndex = 5
    row.LayoutOrder = _nextOrder(parent)
    row.Parent = parent

    -- lÃ­nea decorativa izquierda
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 0.55, 0)
    bar.Position = UDim2.new(0, 0, 0.225, 0)
    bar.BackgroundColor3 = C.ACC_BR
    bar.BorderSizePixel = 0
    bar.ZIndex = 6
    bar.Parent = row
    MakeCorner(bar, 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = C.ACC_BR
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = row
    return row
end

-- TOGGLE
local function CreateToggle(parent, labelText, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = C.BG_ELEM
    row.BackgroundTransparency = 0.0
    row.BorderSizePixel = 0
    row.ZIndex = 5
    row.LayoutOrder = _nextOrder(parent)
    row.Parent = parent
    MakeCorner(row, 11)
    MakeStroke(row, C.STROKE_DIM, 1, 0.5)
    MakeGradient(row, C.BG_SURF, C.BG_ELEM2, 165)

    -- Acento izquierdo (se ilumina al activar)
    local leftAccent = Instance.new("Frame")
    leftAccent.Size = UDim2.new(0, 3, 0.6, 0)
    leftAccent.Position = UDim2.new(0, 0, 0.2, 0)
    leftAccent.BackgroundColor3 = C.ACC_DIM
    leftAccent.BackgroundTransparency = 0.0
    leftAccent.BorderSizePixel = 0
    leftAccent.ZIndex = 7
    leftAccent.Parent = row
    MakeCorner(leftAccent, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = C.TXT_M
    lbl.TextSize = 13
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = row

    -- Pill toggle
    local togBg = Instance.new("Frame")
    togBg.Size = UDim2.new(0, 42, 0, 22)
    togBg.Position = UDim2.new(1, -52, 0.5, -11)
    togBg.BackgroundColor3 = C.BG_DEEP
    togBg.BorderSizePixel = 0
    togBg.ZIndex = 6
    togBg.Parent = row
    MakeCorner(togBg, 11)
    MakeStroke(togBg, C.STROKE_DIM, 1, 0.45)

    local togDot = Instance.new("Frame")
    togDot.Size = UDim2.new(0, 16, 0, 16)
    togDot.Position = UDim2.new(0, 3, 0.5, -8)
    togDot.BackgroundColor3 = C.TXT_D
    togDot.BorderSizePixel = 0
    togDot.ZIndex = 7
    togDot.Parent = togBg
    MakeCorner(togDot, 8)

    local togBtn = Instance.new("TextButton")
    togBtn.Size = UDim2.new(1, 0, 1, 0)
    togBtn.BackgroundTransparency = 1
    togBtn.Text = ""
    togBtn.ZIndex = 8
    togBtn.Parent = togBg

    local state = false
    local obj = {}
    function obj:Set(val)
        state = val
        if state then
            Tween(togBg,      TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = C.ACC})
            Tween(togDot,     TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 23, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            Tween(lbl,        TweenInfo.new(0.2),  {TextColor3 = C.TXT_W})
            Tween(leftAccent, TweenInfo.new(0.2),  {BackgroundColor3 = C.ACC_BR})
            Tween(row,        TweenInfo.new(0.2),  {BackgroundColor3 = C.BG_ELEM2})
        else
            Tween(togBg,      TweenInfo.new(0.22), {BackgroundColor3 = C.BG_DEEP})
            Tween(togDot,     TweenInfo.new(0.22), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = C.TXT_D})
            Tween(lbl,        TweenInfo.new(0.2),  {TextColor3 = C.TXT_M})
            Tween(leftAccent, TweenInfo.new(0.2),  {BackgroundColor3 = C.ACC_DIM})
            Tween(row,        TweenInfo.new(0.2),  {BackgroundColor3 = C.BG_ELEM})
        end
        if callback then callback(state) end
    end
    togBtn.Activated:Connect(function() obj:Set(not state) end)
    return row, obj
end

-- BOTON
local function CreateButton(parent, labelText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = C.ACC
    btn.BackgroundTransparency = 0.1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.LayoutOrder = _nextOrder(parent)
    btn.Parent = parent
    MakeCorner(btn, 11)
    MakeStroke(btn, C.STROKE, 1, 0.35)
    MakeGradient(btn, Color3.fromRGB(220, 35, 60), C.ACC_DIM, 165)

    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, -20, 1, 0)
    btnLabel.Position = UDim2.new(0, 14, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = labelText
    btnLabel.TextColor3 = C.TXT_W
    btnLabel.TextSize = 13
    btnLabel.Font = Enum.Font.GothamSemibold
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.ZIndex = 6
    btnLabel.Parent = btn

    -- Flecha derecha
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = ">"
    arrow.TextColor3 = C.ACC_GLOW
    arrow.TextSize = 16
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 6
    arrow.Parent = btn

    btn.MouseEnter:Connect(function()
        Tween(btn,    TweenInfo.new(0.15), {BackgroundTransparency = 0.0, BackgroundColor3 = C.ACC_BR})
        Tween(arrow,  TweenInfo.new(0.15), {Position = UDim2.new(1, -18, 0, 0)})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn,    TweenInfo.new(0.18), {BackgroundTransparency = 0.1, BackgroundColor3 = C.ACC})
        Tween(arrow,  TweenInfo.new(0.15), {Position = UDim2.new(1, -22, 0, 0)})
    end)
    btn.Activated:Connect(function()
        Tween(btn, TweenInfo.new(0.07), {BackgroundColor3 = C.ACC_GLOW})
        task.spawn(function()
            task.wait(0.13)
            Tween(btn, TweenInfo.new(0.18), {BackgroundColor3 = C.ACC})
        end)
        if callback then callback() end
    end)
    return btn
end

-- DROPDOWN
local function CreateDropdown(parent, labelText, options, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 36)
    container.BackgroundColor3 = C.BG_ELEM
    container.BackgroundTransparency = 0.0
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.ZIndex = 5
    container.LayoutOrder = _nextOrder(parent)
    container.Parent = parent
    MakeCorner(container, 11)
    MakeStroke(container, C.STROKE_DIM, 1, 0.4)
    MakeGradient(container, C.BG_SURF, C.BG_ELEM2, 165)

    local layout = Instance.new("UIListLayout")
    layout.Parent = container

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1
    header.Text = ""
    header.ZIndex = 6
    header.Parent = container

    local hLabel = Instance.new("TextLabel")
    hLabel.Size = UDim2.new(1, -36, 1, 0)
    hLabel.Position = UDim2.new(0, 12, 0, 0)
    hLabel.BackgroundTransparency = 1
    hLabel.Text = labelText .. ":  -"
    hLabel.TextColor3 = C.TXT_M
    hLabel.TextSize = 12
    hLabel.Font = Enum.Font.GothamSemibold
    hLabel.TextXAlignment = Enum.TextXAlignment.Left
    hLabel.ZIndex = 7
    hLabel.Parent = header

    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.new(0, 24, 1, 0)
    chevron.Position = UDim2.new(1, -26, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Text = ">"
    chevron.TextColor3 = C.ACC_BR
    chevron.TextSize = 14
    chevron.Font = Enum.Font.GothamBold
    chevron.ZIndex = 7
    chevron.Parent = header

    local sepLine = Instance.new("Frame")
    sepLine.Size = UDim2.new(1, -16, 0, 1)
    sepLine.Position = UDim2.new(0, 8, 0, 35)
    sepLine.BackgroundColor3 = C.STROKE_DIM
    sepLine.BackgroundTransparency = 0.5
    sepLine.BorderSizePixel = 0
    sepLine.ZIndex = 6
    sepLine.Visible = false
    sepLine.Parent = container

    local open = false
    local selected = nil
    local optBtns = {}

    for _, opt in ipairs(options) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, 28)
        ob.BackgroundColor3 = C.BG_DEEP
        ob.BackgroundTransparency = 0.1
        ob.Text = ""
        ob.ZIndex = 7
        ob.Visible = false
        ob.Parent = container

        local obLabel = Instance.new("TextLabel")
        obLabel.Size = UDim2.new(1, -14, 1, 0)
        obLabel.Position = UDim2.new(0, 18, 0, 0)
        obLabel.BackgroundTransparency = 1
        obLabel.Text = opt
        obLabel.TextColor3 = C.TXT_M
        obLabel.TextSize = 12
        obLabel.Font = Enum.Font.Gotham
        obLabel.TextXAlignment = Enum.TextXAlignment.Left
        obLabel.ZIndex = 8
        obLabel.Parent = ob

        local obDot = Instance.new("Frame")
        obDot.Size = UDim2.new(0, 5, 0, 5)
        obDot.Position = UDim2.new(0, 9, 0.5, -2)
        obDot.BackgroundColor3 = C.ACC_DIM
        obDot.BorderSizePixel = 0
        obDot.ZIndex = 8
        obDot.Parent = ob
        MakeCorner(obDot, 3)

        table.insert(optBtns, {frame = ob, dot = obDot, label = obLabel})

        ob.MouseEnter:Connect(function()
            Tween(ob,      TweenInfo.new(0.12), {BackgroundColor3 = C.BG_SURF, BackgroundTransparency = 0.0})
            Tween(obLabel, TweenInfo.new(0.12), {TextColor3 = C.TXT_W})
            Tween(obDot,   TweenInfo.new(0.12), {BackgroundColor3 = C.ACC_BR})
        end)
        ob.MouseLeave:Connect(function()
            Tween(ob,      TweenInfo.new(0.12), {BackgroundColor3 = C.BG_DEEP, BackgroundTransparency = 0.1})
            Tween(obLabel, TweenInfo.new(0.12), {TextColor3 = C.TXT_M})
            Tween(obDot,   TweenInfo.new(0.12), {BackgroundColor3 = C.ACC_DIM})
        end)
        ob.Activated:Connect(function()
            selected = opt
            hLabel.Text = labelText .. ":  " .. opt
            hLabel.TextColor3 = C.TXT_W
            open = false
            sepLine.Visible = false
            Tween(chevron, TweenInfo.new(0.2), {Rotation = 0, TextColor3 = C.ACC_BR})
            Tween(container, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 36)})
            for _, b in ipairs(optBtns) do b.frame.Visible = false end
            if callback then callback(opt) end
        end)
    end

    header.Activated:Connect(function()
        open = not open
        if open then
            sepLine.Visible = true
            Tween(chevron, TweenInfo.new(0.2), {Rotation = 90, TextColor3 = C.ACC_GLOW})
            Tween(container, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 36 + #optBtns * 28)})
            for _, b in ipairs(optBtns) do b.frame.Visible = true end
        else
            sepLine.Visible = false
            Tween(chevron, TweenInfo.new(0.2), {Rotation = 0, TextColor3 = C.ACC_BR})
            Tween(container, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 36)})
            for _, b in ipairs(optBtns) do b.frame.Visible = false end
        end
    end)

    local obj = {}
    function obj:GetSelected() return selected end
    return container, obj
end

-- TEXTBOX
local function CreateTextBox(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = C.BG_DEEP
    frame.BackgroundTransparency = 0.0
    frame.BorderSizePixel = 0
    frame.ZIndex = 5
    frame.LayoutOrder = _nextOrder(parent)
    frame.Parent = parent
    MakeCorner(frame, 11)
    local tbStroke = MakeStroke(frame, C.STROKE_DIM, 1, 0.45)
    MakeGradient(frame, C.BG_MID, C.BG_DEEP, 165)

    local prefix = Instance.new("TextLabel")
    prefix.Size = UDim2.new(0, 20, 1, 0)
    prefix.BackgroundTransparency = 1
    prefix.Text = ">"
    prefix.TextColor3 = C.ACC_DIM
    prefix.TextSize = 14
    prefix.Font = Enum.Font.GothamBold
    prefix.ZIndex = 6
    prefix.Parent = frame

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -26, 1, 0)
    tb.Position = UDim2.new(0, 20, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.PlaceholderText = placeholder
    tb.PlaceholderColor3 = C.TXT_D
    tb.TextColor3 = C.TXT_W
    tb.TextSize = 12
    tb.Font = Enum.Font.Gotham
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ZIndex = 6
    tb.Parent = frame

    tb.Focused:Connect(function()
        Tween(tbStroke, TweenInfo.new(0.15), {Color = C.ACC_BR, Transparency = 0.1})
        Tween(prefix,   TweenInfo.new(0.15), {TextColor3 = C.ACC_GLOW})
    end)
    tb.FocusLost:Connect(function(enter)
        Tween(tbStroke, TweenInfo.new(0.2), {Color = C.STROKE_DIM, Transparency = 0.45})
        Tween(prefix,   TweenInfo.new(0.2), {TextColor3 = C.ACC_DIM})
        if enter and callback then callback(tb.Text) end
    end)
    return frame
end

--// FUNCIONES COMPARTIDAS (RedHood Hub)
--// ============================================

local function formatNumber(num)
    local abs = math.abs(num)
    local sign = num < 0 and "-" or ""
    if abs >= 1e15 then return sign .. string.format("%.2fQ",  abs/1e15)
    elseif abs >= 1e12 then return sign .. string.format("%.2fT",  abs/1e12)
    elseif abs >= 1e9  then return sign .. string.format("%.2fB",  abs/1e9)
    elseif abs >= 1e6  then return sign .. string.format("%.2fM",  abs/1e6)
    elseif abs >= 1e3  then return sign .. string.format("%.2fK",  abs/1e3)
    else return sign .. string.format("%.0f", abs) end
end

local function checkCharacter()
    if not player.Character then
        repeat task.wait() until player.Character
    end
    return player.Character
end

local function isPlayerAlive(p)
    return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and
           p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

local function pressE()
    VIM:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, "E", false, game)
end

--// ============================================
--// ANTI AFK (auto)
--// ============================================

local antiAFKConn
local function setupAntiAFK()
    if antiAFKConn then antiAFKConn:Disconnect() end
    antiAFKConn = player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
setupAntiAFK()

--// ============================================
--// REMOVE PORTALS / ADS (auto)
--// ============================================

local function removePortals()
    for _, p in pairs(game:GetDescendants()) do
        if p.Name == "RobloxForwardPortals" then p:Destroy() end
    end
    if _G.AdRemovalConn then _G.AdRemovalConn:Disconnect() end
    _G.AdRemovalConn = game.DescendantAdded:Connect(function(d)
        if d.Name == "RobloxForwardPortals" then d:Destroy() end
    end)
end
removePortals()

--// ============================================
--// ===  TABS  ==================================
--// ============================================

-- TAB: PLAYER
local playerPanel, playerTab = CreateTab("Player", nil)

CreateLabel(playerPanel, "General")
CreateToggle(playerPanel, "Stats HUD", function(v)
    statsHud.Visible = v
    Notify("Stats HUD " .. (v and "ON" or "OFF"))
end)
CreateToggle(playerPanel, "Infinite Jump", function(v)
    _G.IJActive = v
    if v then
        _G.IJConn = UIS.JumpRequest:Connect(function()
            if player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
        Notify("Infinite Jump ON")
    else
        if _G.IJConn then _G.IJConn:Disconnect(); _G.IJConn = nil end
        Notify("Infinite Jump OFF")
    end
end)

CreateToggle(playerPanel, "No Clip", function(v)
    _G.NoClipActive = v
    if v then
        _G.NoClipConn = RunService.Stepped:Connect(function()
            if player.Character then
                for _, p in ipairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
        Notify("NoClip ON")
    else
        if _G.NoClipConn then _G.NoClipConn:Disconnect(); _G.NoClipConn = nil end
        Notify("NoClip OFF")
    end
end)

CreateToggle(playerPanel, "Walk on Water", function(v)
    if v and not _G.WaterFloor then
        local p = Instance.new("Part")
        p.Name = "WaterFloor"
        p.Size = Vector3.new(100000, 1, 100000)
        p.CFrame = CFrame.new(0, -9.5, 0)
        p.Anchored = true
        p.Transparency = 1
        p.CanCollide = true
        p.Locked = true
        p.Parent = workspace
        _G.WaterFloor = p
        Notify("Walk on Water ON")
    elseif not v and _G.WaterFloor then
        _G.WaterFloor:Destroy()
        _G.WaterFloor = nil
        Notify("Walk on Water OFF")
    end
end)

CreateToggle(playerPanel, "Anti Fling", function(v)
    _G.AntiFlingActive = v
    local char = workspace:FindFirstChild(player.Name)
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            if v then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(100000, 0, 100000)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.P = 1250
                bv.Parent = root
            else
                local bv = root:FindFirstChild("BodyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
    Notify("Anti Fling " .. (v and "ON" or "OFF"))
end)

CreateToggle(playerPanel, "Lock Position", function(v)
    _G.LockPosActive = v
    if v then
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp  = char:WaitForChild("HumanoidRootPart")
        local lockPos = hrp.Position
        task.spawn(function()
            while _G.LockPosActive do
                hrp.Velocity    = Vector3.new(0,0,0)
                hrp.RotVelocity = Vector3.new(0,0,0)
                hrp.CFrame      = CFrame.new(lockPos)
                task.wait(0.05)
            end
        end)
        Notify("Lock Position ON")
    else
        Notify("Lock Position OFF")
    end
end)

local flySpeed = 80
CreateTextBox(playerPanel, "Fly Speed (default 80)", function(v)
    local n = tonumber(v)
    if n and n > 0 then flySpeed = n; Notify("Fly speed -> " .. n) end
end)

-- ============================================
-- FLY UI (mobile buttons)
-- ============================================
local flyGui = Instance.new("Frame")
flyGui.Size = UDim2.new(0, 220, 0, 150)
flyGui.Position = UDim2.new(0, 10, 1, -165)
flyGui.BackgroundTransparency = 1
flyGui.ZIndex = 200
flyGui.Visible = false
flyGui.Parent = gui

local function makeFlyBtn(text, x, y, w, h)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, w or 58, 0, h or 50)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = C.BG_MID
    btn.BackgroundTransparency = 0.08
    btn.Text = text
    btn.TextColor3 = C.ACC_GLOW
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 201
    btn.Parent = flyGui
    MakeCorner(btn, 11)
    MakeStroke(btn, C.STROKE, 1.2, 0.25)
    return btn
end

-- Layout: [Q] [W] [E]
--         [A] [S] [D]
--            [DN]
local flyW  = makeFlyBtn("W",  62, 0)   -- adelante
local flyA  = makeFlyBtn("A",  0,  55)  -- izquierda
local flyS  = makeFlyBtn("S",  62, 55)  -- atrÃ¡s
local flyD  = makeFlyBtn("D",  124, 55) -- derecha
local flyUp = makeFlyBtn("^",  124, 0)  -- subir
local flyDn = makeFlyBtn("v",  0,   0)  -- bajar

-- Estado tÃ¡ctil
local _flyKeys = {w=false, a=false, s=false, d=false, up=false, dn=false}
local function bindFlyBtn(btn, key)
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            _flyKeys[key] = true
            Tween(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0, BackgroundColor3 = C.ACC})
        end
    end)
    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            _flyKeys[key] = false
            Tween(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.08, BackgroundColor3 = C.BG_MID})
        end
    end)
end
bindFlyBtn(flyW,  "w")
bindFlyBtn(flyA,  "a")
bindFlyBtn(flyS,  "s")
bindFlyBtn(flyD,  "d")
bindFlyBtn(flyUp, "up")
bindFlyBtn(flyDn, "dn")

local function startFlyLoop(hrp, hum, bv, bg)
    task.spawn(function()
        while _G.FlyActive and hrp and hrp.Parent do
            local cam = workspace.CurrentCamera
            local move = Vector3.new(0, 0, 0)
            -- PC keys
            local wDown  = UIS:IsKeyDown(Enum.KeyCode.W)      or _flyKeys.w
            local sDown  = UIS:IsKeyDown(Enum.KeyCode.S)      or _flyKeys.s
            local aDown  = UIS:IsKeyDown(Enum.KeyCode.A)      or _flyKeys.a
            local dDown  = UIS:IsKeyDown(Enum.KeyCode.D)      or _flyKeys.d
            local upDown = UIS:IsKeyDown(Enum.KeyCode.Space)  or _flyKeys.up
            local dnDown = UIS:IsKeyDown(Enum.KeyCode.LeftControl)
                        or UIS:IsKeyDown(Enum.KeyCode.LeftShift) or _flyKeys.dn

            if wDown  then move = move + cam.CFrame.LookVector  end
            if sDown  then move = move - cam.CFrame.LookVector  end
            if aDown  then move = move - cam.CFrame.RightVector end
            if dDown  then move = move + cam.CFrame.RightVector end
            if upDown then move = move + Vector3.new(0, 1, 0)   end
            if dnDown then move = move - Vector3.new(0, 1, 0)   end

            bv.Velocity = (move.Magnitude > 0 and move.Unit or move) * flySpeed
            bg.CFrame   = cam.CFrame
            task.wait(0.03)
        end
        local cb = hrp:FindFirstChild("FlyBV"); if cb then cb:Destroy() end
        local cg = hrp:FindFirstChild("FlyBG"); if cg then cg:Destroy() end
        if hum then hum.PlatformStand = false end
        flyGui.Visible = false
    end)
end

local function activateFly(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand = true
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyBV"; bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5); bv.Parent = hrp
    local bg = Instance.new("BodyGyro")
    bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.D = 100; bg.CFrame = hrp.CFrame; bg.Parent = hrp
    -- Mostrar botones solo en movil
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
        flyGui.Visible = true
    end
    startFlyLoop(hrp, hum, bv, bg)
end

CreateToggle(playerPanel, "Fly Mode", function(v)
    _G.FlyActive = v
    if v then
        activateFly(player.Character or player.CharacterAdded:Wait())
        if UIS.TouchEnabled and not UIS.KeyboardEnabled then
            Notify("Fly ON  |  Botones en pantalla")
        else
            Notify("Fly ON  |  WASD + Space / Ctrl")
        end
    else
        _G.FlyActive = false
        flyGui.Visible = false
        local char = player.Character
        if char then
            local cb = char:FindFirstChild("FlyBV"); if cb then cb:Destroy() end
            local cg = char:FindFirstChild("FlyBG"); if cg then cg:Destroy() end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        Notify("Fly OFF")
    end
end)

CreateLabel(playerPanel, "Velocidad / Size")
local speedVal = 120
CreateTextBox(playerPanel, "Speed (default 120)", function(v)
    local n = tonumber(v)
    if n and n > 0 then speedVal = n; Notify("Speed -> " .. n) end
end)
CreateToggle(playerPanel, "Set Speed", function(v)
    _G.SpeedActive = v
    task.spawn(function()
        while _G.SpeedActive do
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSpeed", speedVal)
            end
            task.wait(0.15)
        end
    end)
end)

local sizeVal = 2
CreateTextBox(playerPanel, "Size (default 2)", function(v)
    local n = tonumber(v)
    if n and n > 0 then sizeVal = n; Notify("Size -> " .. n) end
end)
CreateToggle(playerPanel, "Set Size", function(v)
    _G.SizeActive = v
    task.spawn(function()
        while _G.SizeActive do
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeVal)
            end
            task.wait(0.15)
        end
    end)
end)

CreateToggle(playerPanel, "Speed Hack (+50)", function(v)
    _G.SpeedHackActive = v
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = v and 50 or 16
        Notify(v and "Speed -> 50" or "Speed -> 16 (normal)")
    end
end)

CreateLabel(playerPanel, "Misc")
CreateButton(playerPanel, "Resetear Personaje", function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

-- TAB: FARMING
local farmPanel, farmTab = CreateTab("Farming", nil)

CreateLabel(farmPanel, "Fast Rep")
local repsPerTick = 1
CreateTextBox(farmPanel, "Rep Speed (default 1)", function(v)
    local n = tonumber(v)
    if n and n > 0 then repsPerTick = math.floor(n); Notify("Rep speed -> " .. repsPerTick) end
end)

local function getPing()
    local stats = game:GetService("Stats")
    local pingStat = stats:FindFirstChild("PerformanceStats") and stats.PerformanceStats:FindFirstChild("Ping")
    return pingStat and pingStat:GetValue() or 0
end

local function fastRepLoop()
    while _G.FastRepActive do
        local t0 = tick()
        while tick() - t0 < 0.75 and _G.FastRepActive do
            for _ = 1, repsPerTick do
                muscleEvent:FireServer("rep")
            end
            task.wait(0.02)
        end
        while _G.FastRepActive and getPing() >= 350 do
            task.wait(1)
        end
    end
end

CreateToggle(farmPanel, "Fast Rep", function(v)
    _G.FastRepActive = v
    if v then task.spawn(fastRepLoop) end
    Notify("Fast Rep " .. (v and "ON" or "OFF"))
end)

CreateLabel(farmPanel, "Auto Farm (Tools)")
local selectedTool = nil
CreateDropdown(farmPanel, "Select Tool", {
    "Weight","Pushups","Situps","Handstands","Fast Punch","Stomp","Ground Slam"
}, function(sel) selectedTool = sel end)

CreateToggle(farmPanel, "Auto Farm", function(v)
    _G.AutoFarmActive = v
    if v then
        task.spawn(function()
            while _G.AutoFarmActive do
                local p = player
                if selectedTool == "Weight" then
                    if not p.Character:FindFirstChild("Weight") then
                        local t = p.Backpack:FindFirstChild("Weight")
                        if t then p.Character.Humanoid:EquipTool(t) end
                    end
                    p.muscleEvent:FireServer("rep")
                elseif selectedTool == "Pushups" then
                    if not p.Character:FindFirstChild("Pushups") then
                        local t = p.Backpack:FindFirstChild("Pushups")
                        if t then p.Character.Humanoid:EquipTool(t) end
                    end
                    p.muscleEvent:FireServer("rep")
                elseif selectedTool == "Situps" then
                    if not p.Character:FindFirstChild("Situps") then
                        local t = p.Backpack:FindFirstChild("Situps")
                        if t then p.Character.Humanoid:EquipTool(t) end
                    end
                    p.muscleEvent:FireServer("rep")
                elseif selectedTool == "Handstands" then
                    if not p.Character:FindFirstChild("Handstands") then
                        local t = p.Backpack:FindFirstChild("Handstands")
                        if t then p.Character.Humanoid:EquipTool(t) end
                    end
                    p.muscleEvent:FireServer("rep")
                elseif selectedTool == "Fast Punch" then
                    local punch = p.Backpack:FindFirstChild("Punch")
                    if punch then punch.Parent = p.Character end
                    p.muscleEvent:FireServer("punch", "leftHand")
                    task.wait(0.12)
                    p.muscleEvent:FireServer("punch", "rightHand")
                    task.wait(0.12)
                elseif selectedTool == "Stomp" then
                    local stomp = p.Backpack:FindFirstChild("Stomp")
                    if stomp then stomp.Parent = p.Character end
                    p.muscleEvent:FireServer("stomp")
                    task.wait(0.05)
                elseif selectedTool == "Ground Slam" then
                    local gs = p.Backpack:FindFirstChild("Ground Slam")
                    if gs then gs.Parent = p.Character end
                    p.muscleEvent:FireServer("slam")
                    task.wait(0.05)
                end
                task.wait(0.05)
            end
        end)
    end
    Notify("Auto Farm " .. (v and "ON" or "OFF"))
end)

CreateLabel(farmPanel, "Rocks")
local rockData = {
    ["Tiny Rock"] = 0, ["Starter Island"] = 100, ["Punching Rock"] = 1000,
    ["Golden Rock"] = 5000, ["Frost Rock"] = 150000, ["Mythical Rock"] = 400000,
    ["Eternal Rock"] = 750000, ["Legend Rock"] = 1000000,
    ["Muscle King Rock"] = 5000000, ["Jungle Rock"] = 10000000
}
local rockNames = {}
for k in pairs(rockData) do table.insert(rockNames, k) end

local selectedRock = nil
CreateDropdown(farmPanel, "Select Rock", rockNames, function(sel)
    selectedRock = sel
end)

local function gettool()
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == "Punch" and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:EquipTool(v)
        end
    end
    player.muscleEvent:FireServer("punch", "leftHand")
    task.wait(0.12)
    player.muscleEvent:FireServer("punch", "rightHand")
end

-- ============================================
-- TRACKER: Pet Bug Stat
-- ============================================

-- ============================================
-- STATS HUD (overlay persistente)
-- ============================================

local statsHud = Instance.new("Frame")
statsHud.Size = UDim2.new(0, 190, 0, 76)
statsHud.Position = UDim2.new(0, 10, 0, 10)
statsHud.BackgroundColor3 = C.BG_MID
statsHud.BackgroundTransparency = 0.04
statsHud.BorderSizePixel = 0
statsHud.ZIndex = 100
statsHud.Visible = false
statsHud.Parent = gui
MakeCorner(statsHud, 14)
MakeStroke(statsHud, C.STROKE, 1.5, 0.2)
MakeGradient(statsHud, C.BG_SURF, C.BG_DEEP, 145)

local statsTitle = Instance.new("TextLabel")
statsTitle.Size = UDim2.new(1, 0, 0, 20)
statsTitle.Position = UDim2.new(0, 0, 0, 3)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "STATS"
statsTitle.TextColor3 = C.ACC_GLOW
statsTitle.TextSize = 10
statsTitle.Font = Enum.Font.GothamBold
statsTitle.ZIndex = 101
statsTitle.Parent = statsHud

local function makeStatLine(yOff, label)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 16)
    lbl.Position = UDim2.new(0, 8, 0, yOff)
    lbl.BackgroundTransparency = 1
    lbl.Text = label .. "  -"
    lbl.TextColor3 = C.TXT_M
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 101
    lbl.Parent = statsHud
    return lbl
end

local statStrLbl  = makeStatLine(22, "Strength")
local statRebLbl  = makeStatLine(38, "Rebirths")
local statDurLbl  = makeStatLine(54, "Durability")

-- Loop de actualizacion
task.spawn(function()
    while gui.Parent do
        if statsHud.Visible then
            pcall(function()
                statStrLbl.Text = "Strength    " .. formatNumber(player.leaderstats.Strength.Value)
                statRebLbl.Text = "Rebirths    " .. formatNumber(player.leaderstats.Rebirths.Value)
                statDurLbl.Text = "Durability  " .. formatNumber(player.Durability.Value)
            end)
        end
        task.wait(0.5)
    end
end)

local trackerGui = Instance.new("Frame")
trackerGui.Size = UDim2.new(0, 220, 0, 110)
trackerGui.Position = UDim2.new(1, -230, 0, 80)
trackerGui.BackgroundColor3 = C.BG_MID
trackerGui.BackgroundTransparency = 0.04
trackerGui.BorderSizePixel = 0
trackerGui.ZIndex = 100
trackerGui.Visible = false
trackerGui.Parent = gui
MakeCorner(trackerGui, 14)
MakeStroke(trackerGui, C.STROKE, 1.5, 0.2)

local trackerTitle = Instance.new("TextLabel")
trackerTitle.Size = UDim2.new(1, 0, 0, 22)
trackerTitle.Position = UDim2.new(0, 0, 0, 6)
trackerTitle.BackgroundTransparency = 1
trackerTitle.Text = "Pet Bug Tracker"
trackerTitle.TextColor3 = C.ACC_GLOW
trackerTitle.TextSize = 13
trackerTitle.Font = Enum.Font.GothamBold
trackerTitle.ZIndex = 101
trackerTitle.Parent = trackerGui

local trackerStatMin = Instance.new("TextLabel")
trackerStatMin.Size = UDim2.new(1, -12, 0, 18)
trackerStatMin.Position = UDim2.new(0, 6, 0, 30)
trackerStatMin.BackgroundTransparency = 1
trackerStatMin.Text = "Stat/min:  0"
trackerStatMin.TextColor3 = C.TXT_M
trackerStatMin.TextSize = 12
trackerStatMin.Font = Enum.Font.GothamSemibold
trackerStatMin.TextXAlignment = Enum.TextXAlignment.Left
trackerStatMin.ZIndex = 101
trackerStatMin.Parent = trackerGui

local trackerStatTotal = Instance.new("TextLabel")
trackerStatTotal.Size = UDim2.new(1, -12, 0, 18)
trackerStatTotal.Position = UDim2.new(0, 6, 0, 51)
trackerStatTotal.BackgroundTransparency = 1
trackerStatTotal.Text = "Stat total:  0"
trackerStatTotal.TextColor3 = C.TXT_M
trackerStatTotal.TextSize = 12
trackerStatTotal.Font = Enum.Font.GothamSemibold
trackerStatTotal.TextXAlignment = Enum.TextXAlignment.Left
trackerStatTotal.ZIndex = 101
trackerStatTotal.Parent = trackerGui

local trackerTime = Instance.new("TextLabel")
trackerTime.Size = UDim2.new(1, -12, 0, 18)
trackerTime.Position = UDim2.new(0, 6, 0, 72)
trackerTime.BackgroundTransparency = 1
trackerTime.Text = "Tiempo:  0s"
trackerTime.TextColor3 = C.TXT_D
trackerTime.TextSize = 11
trackerTime.Font = Enum.Font.Gotham
trackerTime.TextXAlignment = Enum.TextXAlignment.Left
trackerTime.ZIndex = 101
trackerTime.Parent = trackerGui

local trackerHits = Instance.new("TextLabel")
trackerHits.Size = UDim2.new(1, -12, 0, 18)
trackerHits.Position = UDim2.new(0, 6, 0, 90)
trackerHits.BackgroundTransparency = 1
trackerHits.Text = "Golpes:  0"
trackerHits.TextColor3 = C.TXT_D
trackerHits.TextSize = 11
trackerHits.Font = Enum.Font.Gotham
trackerHits.TextXAlignment = Enum.TextXAlignment.Left
trackerHits.ZIndex = 101
trackerHits.Parent = trackerGui

local function formatTime(secs)
    local h = math.floor(secs / 3600)
    local m = math.floor((secs % 3600) / 60)
    local s = secs % 60
    if h > 0 then
        return string.format("%dh %02dm %02ds", h, m, s)
    elseif m > 0 then
        return string.format("%dm %02ds", m, s)
    else
        return string.format("%ds", s)
    end
end

-- Variables del tracker
local _rockHits = 0
local _rockStartTime = 0
local _rockStatPerHit = 5
local _trackerConn = nil

local function startTracker()
    _rockHits = 0
    _rockStartTime = tick()
    trackerGui.Visible = true
    if _trackerConn then _trackerConn:Disconnect() end

    -- Escuchar cambio real de Durability (golpes que el servidor acepta)
    local lastDura = player.Durability.Value
    _trackerConn = player.Durability.Changed:Connect(function(newVal)
        if not getgenv().RockFarmRunning then return end
        if newVal > lastDura then  -- Durabilidad subiÃƒÆ’Ã‚Â³ = golpe aceptado
            _rockHits = _rockHits + 1
        end
        lastDura = newVal
    end)

    -- Loop de display separado
    task.spawn(function()
        while getgenv().RockFarmRunning or trackerGui.Visible do
            local elapsed = math.floor(tick() - _rockStartTime)
            local totalStat = _rockHits * _rockStatPerHit
            local statPerMin = elapsed > 0 and math.floor((totalStat / elapsed) * 60) or 0
            trackerStatMin.Text   = "Stat/min:  " .. formatNumber(statPerMin)
            trackerStatTotal.Text = "Stat total:  " .. formatNumber(totalStat)
            trackerTime.Text      = "Tiempo:  " .. formatTime(elapsed)
            trackerHits.Text      = "Golpes:  " .. _rockHits
            task.wait(0.5)
        end
    end)
end

local function stopTracker()
    trackerGui.Visible = false
    if _trackerConn then _trackerConn:Disconnect(); _trackerConn = nil end
end

CreateToggle(farmPanel, "Auto Rock", function(v)
    getgenv().RockFarmRunning = v
    if v and selectedRock then
        startTracker()
        task.spawn(function()
            local reqDura = rockData[selectedRock]
            while getgenv().RockFarmRunning do
                task.wait(0.25)
                if player.Durability.Value >= reqDura then
                    for _, obj in pairs(workspace.machinesFolder:GetDescendants()) do
                        if obj.Name == "neededDurability" and obj.Value == reqDura
                            and player.Character:FindFirstChild("LeftHand")
                            and player.Character:FindFirstChild("RightHand") then
                            local rock = obj.Parent:FindFirstChild("Rock")
                            if rock then
                                firetouchinterest(rock, player.Character.RightHand, 0)
                                firetouchinterest(rock, player.Character.RightHand, 1)
                                firetouchinterest(rock, player.Character.LeftHand, 0)
                                firetouchinterest(rock, player.Character.LeftHand, 1)
                                gettool()
                            end
                        end
                    end
                end
            end
        end)
    else
        stopTracker()
    end
    Notify("Auto Rock " .. (v and "ON" or "OFF"))
end)

-- Textbox para ajustar stat por golpe (por si cambia con otro rebirth)
CreateTextBox(farmPanel, "Stat por golpe (default 5)", function(v)
    local n = tonumber(v)
    if n and n > 0 then
        _rockStatPerHit = n
        Notify("Stat/golpe -> " .. n)
    end
end)

CreateLabel(farmPanel, "Gyms / Machines")
local gymPositions = {
    ["Bench Press"] = {
        ["Jungle Gym"]      = CFrame.new(-8173,  64, 1898),
        ["Muscle King Gym"] = CFrame.new(-8590.06, 46.02, -6043.35),
        ["Legend Gym"]      = CFrame.new(4111.92, 1020.47, -3799.97),
    },
    ["Squat"] = {
        ["Jungle Gym"]      = CFrame.new(-8352, 34, 2878),
        ["Muscle King Gym"] = CFrame.new(-8940.12, 13.16, -5699.13),
        ["Legend Gym"]      = CFrame.new(4305, 987.83, -4124.23),
    },
    ["Pull Up"] = {
        ["Jungle Gym"]      = CFrame.new(-8666, 34, 2070),
        ["Muscle King Gym"] = CFrame.new(-8940.12, 13.16, -5699.13),
        ["Legend Gym"]      = CFrame.new(4305, 987.83, -4124.23),
    },
    ["Boulder"] = {
        ["Jungle Gym"]      = CFrame.new(-8621, 34, 2684),
        ["Muscle King Gym"] = CFrame.new(-8940.12, 13.16, -5699.13),
        ["Legend Gym"]      = CFrame.new(4305, 987.83, -4124.23),
    },
}
local selectedGym = nil
local selectedMachine = nil
local gymWorking = false

CreateDropdown(farmPanel, "Select Gym", {"Jungle Gym","Muscle King Gym","Legend Gym"}, function(g)
    selectedGym = g
end)
CreateDropdown(farmPanel, "Select Machine", {"Bench Press","Squat","Pull Up","Boulder"}, function(m)
    selectedMachine = m
end)

CreateToggle(farmPanel, "Auto Machine", function(v)
    gymWorking = v
    if v and selectedGym and selectedMachine then
        task.spawn(function()
            -- TP inicial a la maquina y presionar E
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = gymPositions[selectedMachine][selectedGym]
            task.wait(0.5)
            pressE()
            while gymWorking do
                -- Si el personaje murio, reconectar
                local curChar = player.Character
                if not curChar or not curChar:FindFirstChild("HumanoidRootPart") then
                    player.CharacterAdded:Wait()
                    task.wait(1)
                    curChar = player.Character
                    local curHrp = curChar:WaitForChild("HumanoidRootPart")
                    curHrp.CFrame = gymPositions[selectedMachine][selectedGym]
                    task.wait(0.5)
                    pressE()
                end
                player.muscleEvent:FireServer("rep")
                task.wait(0.05)
            end
        end)
    end
    Notify("Auto Machine " .. (v and "ON" or "OFF"))
end)



CreateLabel(farmPanel, "Misc Farming")
CreateToggle(farmPanel, "Auto Size 2 (farming)", function(v)
    _G.AutoSize1Active = v
    task.spawn(function()
        while _G.AutoSize1Active do
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
            end
            task.wait(0.05)
        end
    end)
end)

local function activateProteinEgg()
    local tool = player.Character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    if tool then muscleEvent:FireServer("proteinEgg", tool) end
end
CreateToggle(farmPanel, "Auto Egg (30min)", function(v)
    _G.AutoEggActive = v
    if v then activateProteinEgg() end
end)
task.spawn(function()
    while true do
        if _G.AutoEggActive then activateProteinEgg() task.wait(1800) else task.wait(1) end
    end
end)

local function activateShake()
    local tool = player.Character:FindFirstChild("Tropical Shake") or player.Backpack:FindFirstChild("Tropical Shake")
    if tool then muscleEvent:FireServer("tropicalShake", tool) end
end
CreateToggle(farmPanel, "Auto Shake (15min)", function(v)
    _G.AutoShakeActive = v
    if v then activateShake() end
end)
task.spawn(function()
    while true do
        if _G.AutoShakeActive then activateShake() task.wait(900) else task.wait(1) end
    end
end)

CreateToggle(farmPanel, "Spin Fortune Wheel", function(v)
    _G.AutoSpinWheel = v
    if v then
        task.spawn(function()
            while _G.AutoSpinWheel do
                ReplicatedStorage.rEvents.openFortuneWheelRemote:InvokeServer(
                    "openFortuneWheel",
                    ReplicatedStorage.fortuneWheelChances["Fortune Wheel"]
                )
                task.wait(1)
            end
        end)
    end
end)

CreateToggle(farmPanel, "Auto King (teleport)", function(v)
    _G.AutoKingActive = v
    if v then
        local kingPos = CFrame.new(-8748, 123, -5865)
        task.spawn(function()
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp  = char:WaitForChild("HumanoidRootPart")
            while _G.AutoKingActive do
                if (hrp.Position - kingPos.Position).Magnitude > 5 then
                    hrp.CFrame = kingPos
                end
                task.wait(0.05)
            end
        end)
    end
end)

-- TAB: FAST REBIRTH
local fastrebPanel, fastrebTab = CreateTab("Fast Reb", nil)

-- Variables compartidas del panel
local rebirths = player.leaderstats:WaitForChild("Rebirths")
local _fastRebTarget = 0

CreateLabel(fastrebPanel, "Auto Rebirth")

-- TextBox + toggle para el target de rebirths
local _fastRebTargetEnabled = false
CreateTextBox(fastrebPanel, "Target de Rebirths", function(v)
    local n = tonumber(v)
    if n then
        _fastRebTarget = math.floor(n)
        Notify("Target rebirths -> " .. _fastRebTarget)
    end
end)
CreateToggle(fastrebPanel, "Activar Target Rebirths", function(v)
    _fastRebTargetEnabled = v
    if v then
        Notify("Target rebirths activado: " .. _fastRebTarget)
    else
        Notify("Target rebirths desactivado (sin limite)")
    end
end)

CreateToggle(fastrebPanel, "Auto Rebirth", function(v)
    _G.AutoRebirthActive = v
    if v then
        task.spawn(function()
            while _G.AutoRebirthActive do
                -- Chequeo de target (solo si el toggle estÃ¡ activado)
                if _fastRebTargetEnabled and _fastRebTarget > 0 and rebirths.Value >= _fastRebTarget then
                    _G.AutoRebirthActive = false
                    -- Desactivar el toggle visualmente
                    Notify("Auto Rebirth: target " .. _fastRebTarget .. " alcanzado!")
                    break
                end
                -- Esperar personaje vivo
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    player.CharacterAdded:Wait()
                    task.wait(0.5)
                end
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health <= 0 then
                    player.CharacterAdded:Wait()
                    task.wait(0.5)
                end
                -- Spam del evento de rebirth sin condicion de strength
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.05)
            end
        end)
        Notify("Auto Rebirth ON")
    else
        Notify("Auto Rebirth OFF")
    end
end)

CreateLabel(fastrebPanel, "Auto Rock (Pet Stat)")

-- Tracker para Fast Reb (instancias propias, independiente del de Farming)
local frTrackerGui = Instance.new("Frame")
frTrackerGui.Size = UDim2.new(0, 220, 0, 110)
frTrackerGui.Position = UDim2.new(1, -230, 0, 200)
frTrackerGui.BackgroundColor3 = C.BG_MID
frTrackerGui.BackgroundTransparency = 0.04
frTrackerGui.BorderSizePixel = 0
frTrackerGui.ZIndex = 100
frTrackerGui.Visible = false
frTrackerGui.Parent = gui
MakeCorner(frTrackerGui, 14)
MakeStroke(frTrackerGui, C.STROKE, 1.5, 0.2)

local function makeFRTrackerLabel(yOff, txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -12, 0, 18)
    l.Position = UDim2.new(0, 6, 0, yOff)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = C.TXT_M
    l.TextSize = 12
    l.Font = Enum.Font.GothamSemibold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 101
    l.Parent = frTrackerGui
    return l
end

local frTrackerTitle = Instance.new("TextLabel")
frTrackerTitle.Size = UDim2.new(1, 0, 0, 22)
frTrackerTitle.Position = UDim2.new(0, 0, 0, 6)
frTrackerTitle.BackgroundTransparency = 1
frTrackerTitle.Text = "Rock (Pet Stat) Tracker"
frTrackerTitle.TextColor3 = C.ACC_GLOW
frTrackerTitle.TextSize = 13
frTrackerTitle.Font = Enum.Font.GothamBold
frTrackerTitle.ZIndex = 101
frTrackerTitle.Parent = frTrackerGui

local frStatMinLbl   = makeFRTrackerLabel(30,  "Stat/min:  0")
local frStatTotalLbl = makeFRTrackerLabel(51,  "Stat total:  0")
local frTimeLbl      = makeFRTrackerLabel(72,  "Tiempo:  0s")
local frHitsLbl      = makeFRTrackerLabel(90,  "Golpes:  0")

-- Variables propias del tracker FR
local _frRockHits      = 0
local _frRockStart     = 0
local _frTrackerConn   = nil
local _frRockStatPerHit = 5
local _frPetStatTarget  = 0
local _frRockSelectedRock = nil

-- Dropdown de roca (copia del farming, mismos datos)
CreateDropdown(fastrebPanel, "Select Rock", rockNames, function(sel)
    _frRockSelectedRock = sel
end)

-- TextBox stat por golpe
CreateTextBox(fastrebPanel, "Stat por golpe (default 5)", function(v)
    local n = tonumber(v)
    if n and n > 0 then _frRockStatPerHit = n; Notify("Stat/golpe -> " .. n) end
end)

-- TextBox target de pet stat
CreateTextBox(fastrebPanel, "Target Pet Stat total (ej: 850000)", function(v)
    local n = tonumber(v)
    if n and n > 0 then
        _frPetStatTarget = n
        Notify("Target pet stat -> " .. formatNumber(n))
    end
end)

local function frStartTracker()
    _frRockHits = 0
    _frRockStart = tick()
    frTrackerGui.Visible = true
    if _frTrackerConn then _frTrackerConn:Disconnect() end
    local lastDura = player.Durability.Value
    _frTrackerConn = player.Durability.Changed:Connect(function(newVal)
        if not getgenv().FRRockRunning then return end
        if newVal > lastDura then
            _frRockHits = _frRockHits + 1
        end
        lastDura = newVal
    end)
    task.spawn(function()
        while getgenv().FRRockRunning or frTrackerGui.Visible do
            local elapsed = math.floor(tick() - _frRockStart)
            local totalStat = _frRockHits * _frRockStatPerHit
            local statPerMin = elapsed > 0 and math.floor((totalStat / elapsed) * 60) or 0
            frStatMinLbl.Text   = "Stat/min:  " .. formatNumber(statPerMin)
            frStatTotalLbl.Text = "Stat total:  " .. formatNumber(totalStat)
            frTimeLbl.Text      = "Tiempo:  " .. formatTime(elapsed)
            frHitsLbl.Text      = "Golpes:  " .. _frRockHits

            -- Chequeo del target de pet stat
            if getgenv().FRRockRunning and _frPetStatTarget > 0 and totalStat >= _frPetStatTarget then
                getgenv().FRRockRunning = false
                frTrackerGui.Visible = false
                if _frTrackerConn then _frTrackerConn:Disconnect(); _frTrackerConn = nil end
                Notify("Pet stat target alcanzado! Activando fase de rebirths...")
                task.wait(0.5)
                -- Activar Auto Rebirth, Auto Weight, Auto King, Auto Size
                _G.AutoRebirthActive = true
                task.spawn(function()
                    while _G.AutoRebirthActive do
                        if _fastRebTargetEnabled and _fastRebTarget > 0 and rebirths.Value >= _fastRebTarget then
                            _G.AutoRebirthActive = false
                            Notify("Auto Rebirth: target alcanzado!")
                            break
                        end
                        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                            player.CharacterAdded:Wait(); task.wait(0.5)
                        end
                        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health <= 0 then
                            player.CharacterAdded:Wait(); task.wait(0.5)
                        end
                        ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                        task.wait(0.05)
                    end
                end)
                _G.AutoWeightActive = true
                task.spawn(function()
                    while _G.AutoWeightActive do
                        local p = player
                        local c = p.Character
                        if not c then task.wait(0.01) continue end
                        local hum = c:FindFirstChildOfClass("Humanoid")
                        if not hum or hum.Health <= 0 then task.wait(0.01) continue end
                        local weightInChar = c:FindFirstChild("Weight")
                        if not weightInChar then
                            local wb = p.Backpack:FindFirstChild("Weight")
                            if wb and hum then
                                hum:EquipTool(wb)
                                task.wait(0.05)
                                if not c:FindFirstChild("Weight") then
                                    local attempts = 0
                                    while _G.AutoWeightActive and not c:FindFirstChild("Weight") do
                                        attempts = attempts + 1
                                        if hum and hum.Health > 0 then hum.Health = 0 end
                                        c = p.CharacterAdded:Wait()
                                        task.wait(0.8)
                                        hum = c:FindFirstChildOfClass("Humanoid")
                                        local wb2 = p.Backpack:FindFirstChild("Weight")
                                        if wb2 and hum then hum:EquipTool(wb2); task.wait(0.1) end
                                        if c:FindFirstChild("Weight") then
                                            Notify("Weight equipado tras " .. attempts .. " reintentos")
                                            break
                                        end
                                    end
                                end
                            end
                            task.wait(0.01) continue
                        end
                        p.muscleEvent:FireServer("rep")
                    end
                end)
                _G.AutoKingFRActive = true
                task.spawn(function()
                    local kingPos = CFrame.new(-8748, 123, -5865)
                    while _G.AutoKingFRActive do
                        local c = player.Character
                        local hrp = c and c:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = kingPos end
                        task.wait(0.01)
                    end
                end)
                _G.AutoSize1Active = true
                task.spawn(function()
                    while _G.AutoSize1Active do
                        local c = player.Character
                        if c and c:FindFirstChildOfClass("Humanoid") then
                            ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
                        end
                        task.wait(0.01)
                    end
                end)
                Notify("Auto Rebirth + Weight + King + Size 2 activados!")
                break
            end
            task.wait(0.5)
        end
    end)
end

CreateToggle(fastrebPanel, "Auto Rock (Pet Stat)", function(v)
    getgenv().FRRockRunning = v
    if v and _frRockSelectedRock then
        frStartTracker()
        task.spawn(function()
            local reqDura = rockData[_frRockSelectedRock]
            while getgenv().FRRockRunning do
                task.wait(0.25)
                if player.Durability.Value >= reqDura then
                    for _, obj in pairs(workspace.machinesFolder:GetDescendants()) do
                        if obj.Name == "neededDurability" and obj.Value == reqDura
                            and player.Character:FindFirstChild("LeftHand")
                            and player.Character:FindFirstChild("RightHand") then
                            local rock = obj.Parent:FindFirstChild("Rock")
                            if rock then
                                firetouchinterest(rock, player.Character.RightHand, 0)
                                firetouchinterest(rock, player.Character.RightHand, 1)
                                firetouchinterest(rock, player.Character.LeftHand, 0)
                                firetouchinterest(rock, player.Character.LeftHand, 1)
                                gettool()
                            end
                        end
                    end
                end
            end
        end)
    else
        frTrackerGui.Visible = false
        if _frTrackerConn then _frTrackerConn:Disconnect(); _frTrackerConn = nil end
    end
    Notify("Auto Rock (Pet Stat) " .. (v and "ON" or "OFF"))
end)

CreateLabel(fastrebPanel, "Auto Weight / King")

CreateToggle(fastrebPanel, "Auto Weight", function(v)
    _G.AutoWeightActive = v
    if v then
        task.spawn(function()
            while _G.AutoWeightActive do
                local p = player
                local char = p.Character
                if not char then task.wait(0.01) continue end

                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then task.wait(0.01) continue end

                -- Chequear si Weight estÃ¡ equipado en el char
                local weightInChar = char:FindFirstChild("Weight")
                if not weightInChar then
                    -- Intentar equipar desde backpack
                    local weightInBag = p.Backpack:FindFirstChild("Weight")
                    if weightInBag and hum then
                        hum:EquipTool(weightInBag)
                        -- Esperar un tick para ver si se equipÃ³
                        task.wait(0.05)
                        -- Re-chequear
                        if not char:FindFirstChild("Weight") then
                            -- No se equipÃ³: entrar en kill loop hasta que se equipe
                            local killAttempts = 0
                            while _G.AutoWeightActive and not char:FindFirstChild("Weight") do
                                killAttempts = killAttempts + 1
                                -- Matar al personaje
                                if hum and hum.Health > 0 then
                                    hum.Health = 0
                                end
                                -- Esperar respawn
                                char = p.CharacterAdded:Wait()
                                task.wait(0.8)
                                hum = char:FindFirstChildOfClass("Humanoid")
                                -- Intentar equipar de nuevo
                                local wb = p.Backpack:FindFirstChild("Weight")
                                if wb and hum then
                                    hum:EquipTool(wb)
                                    task.wait(0.1)
                                end
                                if char:FindFirstChild("Weight") then
                                    Notify("Weight equipado tras " .. killAttempts .. " reintentos")
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.01) continue
                end

                -- Weight equipado: spam rep sin pausa
                p.muscleEvent:FireServer("rep")
            end
        end)
    end
    Notify("Auto Weight " .. (v and "ON" or "OFF"))
end)

CreateToggle(fastrebPanel, "Auto King (teleport)", function(v)
    _G.AutoKingFRActive = v
    if v then
        local kingPos = CFrame.new(-8748, 123, -5865)
        task.spawn(function()
            while _G.AutoKingFRActive do
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = kingPos
                end
                task.wait(0.01)
            end
        end)
    end
    Notify("Auto King " .. (v and "ON" or "OFF"))
end)

CreateLabel(fastrebPanel, "Fast Rebirth Loop")
CreateToggle(fastrebPanel, "Fast Rebirth", function(v)
    _G.FastRebActive = v

    local function waitForRespawn()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            player.CharacterAdded:Wait()
            task.wait(1)
        end
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            player.CharacterAdded:Wait()
            task.wait(1)
        end
    end

    local function doRebirth()
        waitForRespawn()
        local rebirthCount = rebirths.Value
        local strengthTarget = 5000 + (rebirthCount * 2550)
        while _G.FastRebActive and player.leaderstats.Strength.Value < strengthTarget do
            waitForRespawn()
            local reps = player.MembershipType == Enum.MembershipType.Premium and 8 or 14
            for _ = 1, reps do muscleEvent:FireServer("rep") end
            task.wait(0.02)
        end
        if _G.FastRebActive and player.leaderstats.Strength.Value >= strengthTarget then
            task.wait(0.3)
            local before = rebirths.Value
            repeat
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.1)
            until rebirths.Value > before or not _G.FastRebActive
        end
    end

    if v then
        task.spawn(function()
            while _G.FastRebActive do
                doRebirth()
                task.wait(0.5)
            end
        end)
        Notify("Fast Rebirth ON")
    else
        Notify("Fast Rebirth OFF")
    end
end)

CreateToggle(fastrebPanel, "Auto Lift (Gamepass)", function(v)
    if v then
        local gamepassFolder = ReplicatedStorage.gamepassIds
        for _, gp in pairs(gamepassFolder:GetChildren()) do
            local val = Instance.new("IntValue")
            val.Name  = gp.Name
            val.Value = gp.Value
            val.Parent = player.ownedGamepasses
        end
        Notify("Auto Lift (Gamepass) ON")
    else
        local gamepassFolder = ReplicatedStorage.gamepassIds
        for _, gp in pairs(gamepassFolder:GetChildren()) do
            local owned = player.ownedGamepasses:FindFirstChild(gp.Name)
            if owned then owned:Destroy() end
        end
        Notify("Auto Lift (Gamepass) OFF")
    end
end)

CreateButton(fastrebPanel, "Jungle Lift", function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8642.396484375, 6.7980651855, 2086.1030273)
    task.wait(0.2); pressE()
end)

CreateButton(fastrebPanel, "Jungle Squat", function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-8371.43359375, 6.79806327, 2858.88525390)
    task.wait(0.2); pressE()
end)

CreateButton(fastrebPanel, "Anti Lag", function()
    local playerGui = player:WaitForChild("PlayerGui")
    local lighting  = game:GetService("Lighting")
    for _, g in pairs(playerGui:GetChildren()) do
        if g:IsA("ScreenGui") and g.Name ~= "RedHoodHub" then g:Destroy() end
    end
    for _, v in pairs(lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    local darkSky = Instance.new("Sky")
    darkSky.Name = "DarkSky"
    darkSky.SkyboxBk = "rbxassetid://0"; darkSky.SkyboxDn = "rbxassetid://0"
    darkSky.SkyboxFt = "rbxassetid://0"; darkSky.SkyboxLf = "rbxassetid://0"
    darkSky.SkyboxRt = "rbxassetid://0"; darkSky.SkyboxUp = "rbxassetid://0"
    darkSky.Parent = lighting
    lighting.Brightness = 0; lighting.ClockTime = 0
    lighting.OutdoorAmbient = Color3.new(0,0,0); lighting.Ambient = Color3.new(0,0,0)
    lighting.FogColor = Color3.new(0,0,0); lighting.FogEnd = 100
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj:Destroy()
        end
    end
    Notify("Anti Lag aplicado!")
end)

-- TAB: KILLING
local killPanel, killTab = CreateTab("Killing", nil)

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

local function isWhitelisted(p) for _, n in ipairs(_G.whitelistedPlayers) do if n:lower() == p.Name:lower() then return true end end return false end
local function isBlacklisted(p) for _, n in ipairs(_G.blacklistedPlayers) do if n:lower() == p.Name:lower() then return true end end return false end

local function killPlayer(target)
    if not isPlayerAlive(target) then return end
    local char = checkCharacter()
    if char and char:FindFirstChild("LeftHand") then
        pcall(function()
            firetouchinterest(target.Character.HumanoidRootPart, char.LeftHand, 0)
            firetouchinterest(target.Character.HumanoidRootPart, char.LeftHand, 1)
            for _, v in pairs(player.Backpack:GetChildren()) do
                if v.Name == "Punch" and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid:EquipTool(v)
                end
            end
            muscleEvent:FireServer("punch", "leftHand")
            task.wait(0.12)
            muscleEvent:FireServer("punch", "rightHand")
        end)
    end
end

CreateLabel(killPanel, "Kill Options")

local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then table.insert(playerNames, p.DisplayName .. " | " .. p.Name) end
end
Players.PlayerAdded:Connect(function(p)
    table.insert(playerNames, p.DisplayName .. " | " .. p.Name)
end)

CreateDropdown(killPanel, "Whitelist Player", playerNames, function(sel)
    local name = sel:match("| (.+)$")
    if name then
        name = name:gsub("^%s*(.-)%s*$","")
        for _, n in ipairs(_G.whitelistedPlayers) do if n:lower()==name:lower() then return end end
        table.insert(_G.whitelistedPlayers, name)
        Notify("Whitelisted: " .. name)
    end
end)

CreateDropdown(killPanel, "Killlist Player", playerNames, function(sel)
    local name = sel:match("| (.+)$")
    if name then
        name = name:gsub("^%s*(.-)%s*$","")
        for _, n in ipairs(_G.blacklistedPlayers) do if n:lower()==name:lower() then return end end
        table.insert(_G.blacklistedPlayers, name)
        Notify("Kill list: " .. name)
    end
end)

CreateToggle(killPanel, "Kill Everyone", function(v)
    _G.killAll = v
    if v then
        task.spawn(function()
            while _G.killAll do
                for _, p in ipairs(Players:GetPlayers()) do
                    if not _G.killAll then break end
                    if p ~= player and not isWhitelisted(p) then
                        killPlayer(p)
                    end
                end
                task.wait(0.15)
            end
        end)
    else
        if _G.killAllConn then _G.killAllConn:Disconnect(); _G.killAllConn = nil end
    end
    Notify("Kill Everyone " .. (v and "ON" or "OFF"))
end)

CreateToggle(killPanel, "Kill List Only", function(v)
    _G.killListOnly = v
    if v then
        task.spawn(function()
            while _G.killListOnly do
                for _, p in ipairs(Players:GetPlayers()) do
                    if not _G.killListOnly then break end
                    if p ~= player and isBlacklisted(p) then
                        killPlayer(p)
                    end
                end
                task.wait(0.15)
            end
        end)
    else
        if _G.killListConn then _G.killListConn:Disconnect(); _G.killListConn = nil end
    end
    Notify("Kill List Only " .. (v and "ON" or "OFF"))
end)

CreateToggle(killPanel, "Whitelist Friends", function(v)
    if v then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p:IsFriendsWith(player.UserId) then
                local already = false
                for _, n in ipairs(_G.whitelistedPlayers) do if n:lower()==p.Name:lower() then already=true; break end end
                if not already then table.insert(_G.whitelistedPlayers, p.Name) end
            end
        end
        Notify("Amigos whitelisted!")
    end
end)

CreateButton(killPanel, "Clear Whitelist", function()
    _G.whitelistedPlayers = {}; Notify("Whitelist limpiada")
end)
CreateButton(killPanel, "Clear Killlist", function()
    _G.blacklistedPlayers = {}; Notify("Killlist limpiada")
end)

CreateLabel(killPanel, "Kill Aura")
_G.deathRingRange = 20
CreateTextBox(killPanel, "Rango Aura (1-140)", function(v)
    local n = tonumber(v)
    if n then _G.deathRingRange = math.clamp(n, 1, 140); Notify("Rango -> " .. _G.deathRingRange) end
end)

local ringPart = nil
local function toggleRing(show)
    if show and not ringPart then
        ringPart = Instance.new("Part")
        ringPart.Shape = Enum.PartType.Cylinder
        ringPart.Material = Enum.Material.Neon
        ringPart.Color = Color3.fromRGB(50, 163, 255)
        ringPart.Transparency = 0.6
        ringPart.Anchored = true
        ringPart.CanCollide = false
        ringPart.CastShadow = false
        local d = (_G.deathRingRange or 20) * 2
        ringPart.Size = Vector3.new(0.2, d, d)
        ringPart.Parent = workspace
    elseif not show and ringPart then
        ringPart:Destroy(); ringPart = nil
    end
end

CreateToggle(killPanel, "Death Ring Aura", function(v)
    _G.deathRingEnabled = v
    if v then
        if not _G.deathRingConn then
            _G.deathRingConn = task.spawn(function()
                while _G.deathRingEnabled do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        if ringPart then
                            ringPart.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
                        end
                        local myPos = root.Position
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= player and not isWhitelisted(p) and isPlayerAlive(p) then
                                local dist = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
                                if dist <= (_G.deathRingRange or 20) then
                                    killPlayer(p)
                                end
                            end
                        end
                    end
                    task.wait(0.15)
                end
                _G.deathRingConn = nil
            end)
        end
    else
        _G.deathRingEnabled = false
        _G.deathRingConn = nil
    end
    Notify("Death Ring " .. (v and "ON" or "OFF"))
end)

CreateToggle(killPanel, "Show Ring Visual", function(v)
    toggleRing(v)
end)

CreateLabel(killPanel, "Combos / Misc")
CreateToggle(killPanel, "NaN Size Combo", function(v)
    _G.NaNComboActive = v
    if v then
        ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 0/0)
        task.spawn(function()
            while _G.NaNComboActive do
                local eggsInHand = 0
                if player.Character then
                    for _, item in ipairs(player.Character:GetChildren()) do
                        if item.Name == "Protein Egg" then
                            eggsInHand += 1
                            if eggsInHand > 1 then item.Parent = player.Backpack end
                        end
                    end
                    if eggsInHand == 0 then
                        local egg = player.Backpack:FindFirstChild("Protein Egg")
                        if egg then egg.Parent = player.Character end
                    end
                end
                task.wait(0.2)
            end
        end)
        Notify("NaN Combo ON")
    else
        Notify("NaN Combo OFF")
    end
end)

CreateToggle(killPanel, "Remove Attack Animations", function(v)
    local blockedAnims = {
        ["rbxassetid://3638729053"] = true,
        ["rbxassetid://3638767427"] = true,
    }
    if v then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                if track.Animation then
                    local id = track.Animation.AnimationId
                    local nm = track.Name:lower()
                    if blockedAnims[id] or nm:match("punch") or nm:match("attack") or nm:match("right") then
                        track:Stop()
                    end
                end
            end
            _G.AnimBlockConn = char.Humanoid.AnimationPlayed:Connect(function(track)
                if track.Animation then
                    local id = track.Animation.AnimationId
                    local nm = track.Name:lower()
                    if blockedAnims[id] or nm:match("punch") or nm:match("attack") or nm:match("right") then
                        track:Stop()
                    end
                end
            end)
        end
        Notify("Remove Animations ON")
    else
        if _G.AnimBlockConn then _G.AnimBlockConn:Disconnect(); _G.AnimBlockConn = nil end
        Notify("Remove Animations OFF")
    end
end)

-- TAB: PETS / SHOP
local petsPanel, petsTab = CreateTab("Pet Shop", nil)

CreateLabel(petsPanel, "Buy Pet")
local petList = {
    "Darkstar Hunter","Neon Guardian","Blue Birdie","Blue Bunny","Blue Firecaster",
    "Blue Pheonix","Crimson Falcon","Cybernetic Showdown Dragon","Dark Golem",
    "Dark Legends Manticore","Dark Vampy","Eternal Strike Leviathan",
    "Frostwave Legends Penguin","Gold Warrior","Golden Pheonix","Golden Viking",
    "Green Butterfly","Green Firecaster","Infernal Dragon","Lightning Strike Phantom",
    "Magic Butterfly","Muscle Sensei","Orange Hedgehog","Orange Pegasus",
    "Phantom Genesis Dragon","Purple Dragon","Purple Falcon","Red Dragon",
    "Red Firecaster","Red Kitty","Silver Dog","Ultimate Supernova Pegasus",
    "Ultra Birdie","White Pegasus","White Pheonix","Yellow Butterfly"
}
local selectedPet = ""
CreateDropdown(petsPanel, "Choose Pet", petList, function(sel) selectedPet = sel end)

CreateToggle(petsPanel, "Buy Pet", function(v)
    _G.AutoHatchPet = v
    if v then
        task.spawn(function()
            while _G.AutoHatchPet and selectedPet ~= "" do
                local petObj = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedPet)
                if petObj then ReplicatedStorage.cPetShopRemote:InvokeServer(petObj) end
                task.wait(0.1)
            end
        end)
    end
    Notify("Buy Pet " .. (v and "ON" or "OFF"))
end)

CreateLabel(petsPanel, "Buy Aura")
local auraList = {
    "Entropic Blast","Muscle King","Astral Electro","Azure Tundra","Blue Aura",
    "Dark Electro","Dark Lightning","Dark Storm","Electro","Enchanted Mirage",
    "Eternal Megastrike","Grand Supernova","Green Aura","Inferno","Lightning",
    "Power Lightning","Purple Aura","Purple Nova","Red Aura","Supernova",
    "Ultra Inferno","Ultra Mirage","Unstable Mirage","Yellow Aura"
}
local selectedAura = ""
CreateDropdown(petsPanel, "Choose Aura", auraList, function(sel) selectedAura = sel end)

CreateToggle(petsPanel, "Buy Aura", function(v)
    _G.AutoHatchAura = v
    if v then
        task.spawn(function()
            while _G.AutoHatchAura and selectedAura ~= "" do
                local auraObj = ReplicatedStorage.cPetShopFolder:FindFirstChild(selectedAura)
                if auraObj then ReplicatedStorage.cPetShopRemote:InvokeServer(auraObj) end
                task.wait(0.1)
            end
        end)
    end
    Notify("Buy Aura " .. (v and "ON" or "OFF"))
end)

CreateLabel(petsPanel, "Equip Pets")
CreateButton(petsPanel, "Equip Swift Samurai", function()
    for _, folder in pairs(player.petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.1)
    for _, pet in pairs(player.petsFolder.Unique:GetChildren()) do
        if pet.Name == "Swift Samurai" then
            ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
        end
    end
    Notify("Swift Samurai equipado!")
end)

-- TAB: TELEPORTS
local tpPanel, tpTab = CreateTab("Teleports", nil)

CreateLabel(tpPanel, "Islas")
local function tp(pos)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp  = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame  = pos
end
CreateButton(tpPanel, "Tiny Island",  function() tp(CFrame.new(-37.1, 9.2, 1919))   end)
CreateButton(tpPanel, "Main Island",  function() tp(CFrame.new(16.07, 9.08, 133.8)) end)
CreateButton(tpPanel, "Beach",        function() tp(CFrame.new(-8, 9, -169.2))       end)
CreateLabel(tpPanel, "Gyms")
CreateButton(tpPanel, "Muscle King Gym", function() tp(CFrame.new(-8665.4, 17.21, -5792.9)) end)
CreateButton(tpPanel, "Jungle Gym",      function() tp(CFrame.new(-8543, 6.8, 2400))        end)
CreateButton(tpPanel, "Legends Gym",     function() tp(CFrame.new(4516, 991.5, -3856))      end)
CreateButton(tpPanel, "Infernal Gym",    function() tp(CFrame.new(-6759, 7.36, -1284))      end)
CreateButton(tpPanel, "Mythical Gym",    function() tp(CFrame.new(2250, 7.37, 1073.2))      end)
CreateButton(tpPanel, "Frost Gym",       function() tp(CFrame.new(-2623, 7.36, -409))       end)

CreateLabel(tpPanel, "Jugadores")
local tpTargetName = nil
local tpPlayerList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then table.insert(tpPlayerList, p.DisplayName .. " | " .. p.Name) end
end
Players.PlayerAdded:Connect(function(p)
    table.insert(tpPlayerList, p.DisplayName .. " | " .. p.Name)
end)
CreateDropdown(tpPanel, "Select Player", tpPlayerList, function(sel)
    tpTargetName = sel:match("| (.+)$")
    if tpTargetName then tpTargetName = tpTargetName:gsub("^%s*(.-)%s*$", "") end
end)
CreateButton(tpPanel, "TP to Player", function()
    if not tpTargetName then Notify("Selecciona un jugador primero"); return end
    local target = Players:FindFirstChild(tpTargetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
        Notify("TP a " .. tpTargetName)
    else
        Notify("Jugador no disponible")
    end
end)
CreateButton(tpPanel, "Bring Player (a vos)", function()
    if not tpTargetName then Notify("Selecciona un jugador primero"); return end
    local target = Players:FindFirstChild(tpTargetName)
    local myChar = player.Character
    if target and target.Character and myChar and myChar:FindFirstChild("HumanoidRootPart") then
        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
        local myHrp = myChar.HumanoidRootPart
        if targetHrp then
            firetouchinterest(targetHrp, myHrp, 0)
            firetouchinterest(targetHrp, myHrp, 1)
            Notify("Bring -> " .. tpTargetName)
        end
    else
        Notify("Jugador no disponible")
    end
end)
-- Plataforma segura: se crea solo una vez, los siguientes clicks hacen TP a ella
local _safePlatform = nil
local _safePlatformPos = Vector3.new(7840, 300, 9345)

CreateButton(tpPanel, "TP + Plataforma Segura", function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Si ya existe, solo TP encima
    if _safePlatform and _safePlatform.Parent then
        hrp.CFrame = CFrame.new(_safePlatform.Position + Vector3.new(0, 7, 0))
        Notify("TP a plataforma existente")
        return
    end

    -- Primera vez: TP + crear
    local targetPos = _safePlatformPos
    local oldPos = hrp.Position
    hrp.CFrame = CFrame.new(targetPos)
    task.wait(0.5)
    if (hrp.Position - oldPos).Magnitude < 50 then
        targetPos = targetPos + Vector3.new(0, 100, 0)
        hrp.CFrame = CFrame.new(targetPos)
    end

    local base = hrp.Position - Vector3.new(0, 4, 0)

    -- Plataforma principal - negro oscuro
    local platform = Instance.new("Part")
    platform.Name = "RHH_Platform"
    platform.Size = Vector3.new(80, 3, 80)
    platform.CFrame = CFrame.new(base)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Color = Color3.fromRGB(8, 3, 3)
    platform.Material = Enum.Material.SmoothPlastic
    platform.Parent = workspace
    _safePlatform = platform

    local pc = Instance.new("UICorner")  -- no aplica a Part, usamos borde neon
    pc:Destroy()

    -- Borde neon rojo - 4 tiras en los bordes
    local function makeBorder(size, pos, rot)
        local b = Instance.new("Part")
        b.Name = "RHH_PlatBorder"
        b.Size = size
        b.CFrame = CFrame.new(base + pos) * rot
        b.Anchored = true
        b.CanCollide = false
        b.Color = Color3.fromRGB(200, 30, 30)
        b.Material = Enum.Material.Neon
        b.CastShadow = false
        b.Parent = workspace
        return b
    end

    local bLen = 80
    local bThk = 0.5
    local bH   = 3.2
    -- Frente / Fondo
    makeBorder(Vector3.new(bLen, bH, bThk), Vector3.new(0, 0,  40), CFrame.new())
    makeBorder(Vector3.new(bLen, bH, bThk), Vector3.new(0, 0, -40), CFrame.new())
    -- Lados
    makeBorder(Vector3.new(bThk, bH, bLen), Vector3.new( 40, 0, 0), CFrame.new())
    makeBorder(Vector3.new(bThk, bH, bLen), Vector3.new(-40, 0, 0), CFrame.new())

    -- LÃ­neas de grilla neon (sutiles) - cruce en X
    local function makeGrid(size, pos)
        local g = Instance.new("Part")
        g.Name = "RHH_PlatGrid"
        g.Size = size
        g.CFrame = CFrame.new(base + pos)
        g.Anchored = true
        g.CanCollide = false
        g.Color = Color3.fromRGB(60, 8, 8)
        g.Material = Enum.Material.Neon
        g.Transparency = 0.6
        g.CastShadow = false
        g.Parent = workspace
    end

    -- 4 lÃ­neas longitudinales + 4 transversales
    for i = -30, 30, 20 do
        makeGrid(Vector3.new(80, 0.12, 0.25), Vector3.new(0, 1.6,  i))
        makeGrid(Vector3.new(0.25, 0.12, 80), Vector3.new(i, 1.6, 0))
    end

    -- Logo en el centro (decal)
    local decal = Instance.new("Decal")
    decal.Texture = "rbxassetid://95596426520626"
    decal.Face = Enum.NormalId.Top
    decal.Transparency = 0.6
    decal.Parent = platform

    Notify("Plataforma creada  " .. math.floor(hrp.Position.X) .. ", " .. math.floor(hrp.Position.Y) .. ", " .. math.floor(hrp.Position.Z))
end)

CreateButton(tpPanel, "Eliminar Plataforma", function()
    if _safePlatform and _safePlatform.Parent then
        -- Eliminar plataforma + bordes + grilla
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "RHH_PlatBorder" or obj.Name == "RHH_PlatGrid" then
                obj:Destroy()
            end
        end
        _safePlatform:Destroy()
        _safePlatform = nil
        Notify("Plataforma eliminada")
    else
        Notify("No hay plataforma activa")
    end
end)

-- TAB: VISUAL
local visualPanel, visualTab = CreateTab("Visual", nil)

CreateToggle(visualPanel, "ESP Jugadores", function(v)
    Notify(v and "ESP activado" or "ESP desactivado")
end)

CreateToggle(visualPanel, "Fullbright", function(v)
    game:GetService("Lighting").Brightness = v and 10 or 1
    Notify(v and "Fullbright ON" or "Fullbright OFF")
end)

CreateDropdown(visualPanel, "Change Time", {"Night","Day","Midnight"}, function(sel)
    local lighting = game:GetService("Lighting")
    if sel == "Night" then lighting.ClockTime = 0
    elseif sel == "Day" then lighting.ClockTime = 12
    elseif sel == "Midnight" then lighting.ClockTime = 6 end
    Notify("Hora -> " .. sel)
end)

-- TAB: INVENTORY
local invPanel, invTab = CreateTab("Inventory", nil)

CreateLabel(invPanel, "Consumibles")
CreateToggle(invPanel, "Egg Devour (0.25s)", function(v)
    _G.EggDevourActive = v
    if v then activateProteinEgg() end
end)
task.spawn(function()
    while true do
        if _G.EggDevourActive then activateProteinEgg() end
        task.wait(0.25)
    end
end)

local itemList = {
    "Tropical Shake","Energy Shake","Protein Bar","TOUGH Bar",
    "Protein Shake","ULTRA Shake","Energy Bar"
}
local function formatEventName(name)
    local parts = {}
    for word in name:gmatch("%S+") do table.insert(parts, word:lower()) end
    for i = 2, #parts do parts[i] = parts[i]:sub(1,1):upper() .. parts[i]:sub(2) end
    return table.concat(parts)
end
local function eatAll()
    local shuffled = {table.unpack(itemList)}
    for i = #shuffled, 2, -1 do
        local j = math.random(i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    end
    for i = 1, math.min(4, #shuffled) do
        local tool = player.Character:FindFirstChild(shuffled[i]) or player.Backpack:FindFirstChild(shuffled[i])
        if tool then
            muscleEvent:FireServer(formatEventName(shuffled[i]), tool)
        end
    end
end
CreateToggle(invPanel, "Eat Everything", function(v)
    _G.EatAllActive = v
    if v then eatAll() end
end)
task.spawn(function()
    while true do
        if _G.EatAllActive then eatAll() end
        task.wait(0.5)
    end
end)

-- TAB: MISC
local miscPanel, miscTab = CreateTab("Misc", nil)

CreateLabel(miscPanel, "Servidor")
CreateButton(miscPanel, "Rejoin (mismo server)", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)
CreateButton(miscPanel, "Server Hop (server nuevo)", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

CreateLabel(miscPanel, "Auto Rejoin al kick")
CreateToggle(miscPanel, "Auto Rejoin", function(v)
    _G.AutoRejoinActive = v
    if v then
        _G.KickConn = game.Players.LocalPlayer.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.Failed then
                task.wait(3)
                game:GetService("TeleportService"):Teleport(game.PlaceId, player)
            end
        end)
        Notify("Auto Rejoin ON")
    else
        if _G.KickConn then _G.KickConn:Disconnect(); _G.KickConn = nil end
        Notify("Auto Rejoin OFF")
    end
end)

CreateLabel(miscPanel, "Utilidades")
CreateButton(miscPanel, "Copiar link del juego", function()
    local ok = pcall(setclipboard, "https://www.roblox.com/games/" .. game.PlaceId)
    Notify(ok and "Link copiado!" or "Error al copiar")
end)
CreateButton(miscPanel, "Screenshot (F12)", function()
    VIM:SendKeyEvent(true, "F12", false, game)
    task.wait(0.05)
    VIM:SendKeyEvent(false, "F12", false, game)
    Notify("Screenshot!")
end)
CreateButton(miscPanel, "Cerrar Hub", function()
    Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    task.spawn(function()
        task.wait(0.35)
        gui:Destroy()
    end)
end)

-- TAB: INFO
local infoPanel, infoTab = CreateTab("Info", nil)

CreateLabel(infoPanel, "RedHood Hub v4 - Full Edition")
CreateButton(infoPanel, "Copiar Discord", function()
    local ok = pcall(setclipboard, "https://discord.gg/")
    Notify(ok and "Discord copiado!" or "No soportado")
end)

--// ============================================
--// ACTIVAR PRIMER TAB
--// ============================================

SwitchTab(playerTab)

--// ============================================
--// BOTONES HEADER
--// ============================================

MinBtn.MouseEnter:Connect(function()
    Tween(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 160, 30)})
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)})
end)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(190, 30, 30)})
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)})
end)
CloseBtn.Activated:Connect(function()
    Tween(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    task.spawn(function()
        task.wait(0.4)
        gui:Destroy()
    end)
end)

--// ============================================
--// BURBUJA (minimizar)
--// ============================================

--// ============================================
--// BOTONES HEADER (eventos)
--// ============================================

MinBtn.MouseEnter:Connect(function()
    Tween(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 160, 20)})
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.BG_ELEM2})
end)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(190, 30, 50)})
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = C.BG_ELEM2})
end)
CloseBtn.Activated:Connect(function()
    Tween(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    task.spawn(function()
        task.wait(0.4)
        gui:Destroy()
    end)
end)

--// ============================================
--// BURBUJA (minimizar)
--// ============================================

local Bubble = Instance.new("Frame")
Bubble.Size = UDim2.new(0, 54, 0, 54)
Bubble.Position = UDim2.new(0, 22, 0.5, -27)
Bubble.BackgroundColor3 = C.BG_MID
Bubble.BackgroundTransparency = 0.05
Bubble.BorderSizePixel = 0
Bubble.Visible = false
Bubble.ZIndex = 50
Bubble.Parent = gui
MakeCorner(Bubble, 27)
local bubbleStroke = MakeStroke(Bubble, C.ACC_BR, 2, 0.1)
MakeGradient(Bubble, C.BG_SURF, C.BG_DEEP, 135)

-- Brillo de pulso externo
local bubbleGlow = Instance.new("Frame")
bubbleGlow.Size = UDim2.new(1, 16, 1, 16)
bubbleGlow.Position = UDim2.new(0, -8, 0, -8)
bubbleGlow.BackgroundColor3 = C.ACC
bubbleGlow.BackgroundTransparency = 0.85
bubbleGlow.BorderSizePixel = 0
bubbleGlow.ZIndex = 49
bubbleGlow.Parent = Bubble
MakeCorner(bubbleGlow, 33)

local BubbleLabel = Instance.new("ImageLabel")
BubbleLabel.Size = UDim2.new(1, -8, 1, -8)
BubbleLabel.Position = UDim2.new(0, 4, 0, 4)
BubbleLabel.BackgroundTransparency = 1
BubbleLabel.Image = "rbxassetid://95596426520626"
BubbleLabel.ScaleType = Enum.ScaleType.Crop
BubbleLabel.ZIndex = 51
BubbleLabel.Parent = Bubble
MakeCorner(BubbleLabel, 23)

-- Animacion pulso burbuja
task.spawn(function()
    local t = 0
    while gui.Parent do
        t = t + 0.04
        if Bubble.Visible then
            local pulse = math.abs(math.sin(t * 1.8))
            pcall(function()
                bubbleStroke.Transparency   = 0.05 + pulse * 0.6
                bubbleGlow.BackgroundTransparency = 0.78 + pulse * 0.18
            end)
        end
        task.wait(0.04)
    end
end)

local BubbleBtn = Instance.new("TextButton")
BubbleBtn.Size = UDim2.new(1, 0, 1, 0)
BubbleBtn.BackgroundTransparency = 1
BubbleBtn.Text = ""
BubbleBtn.ZIndex = 52
BubbleBtn.Parent = Bubble

local bubbleDragging, bubbleDragStart, bubbleStartPos, bubbleMoved
BubbleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        bubbleDragging = true
        bubbleMoved = false
        bubbleDragStart = input.Position
        bubbleStartPos = Bubble.Position
    end
end)
BubbleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        bubbleDragging = false
    end
end)
BubbleBtn.Activated:Connect(function()
    if bubbleMoved then return end
    Bubble.Visible = false
    Main.Visible = true
    Main.Size = UDim2.new(0, 54, 0, 54)
    Main.Position = UDim2.new(Bubble.Position.X.Scale, Bubble.Position.X.Offset, Bubble.Position.Y.Scale, Bubble.Position.Y.Offset)
    Tween(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 598, 0, 375),
        Position = UDim2.new(0.5, -299, 0.5, -187)
    })
end)

MinBtn.Activated:Connect(function()
    local savedPos = Bubble.Position
    Tween(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 54, 0, 54),
        Position = UDim2.new(savedPos.X.Scale, savedPos.X.Offset, savedPos.Y.Scale, savedPos.Y.Offset)
    })
    task.spawn(function()
        task.wait(0.28)
        Main.Visible = false
        Bubble.Size = UDim2.new(0, 10, 0, 10)
        Bubble.Position = UDim2.new(savedPos.X.Scale, savedPos.X.Offset + 22, savedPos.Y.Scale, savedPos.Y.Offset + 22)
        Bubble.BackgroundTransparency = 1
        BubbleLabel.ImageTransparency = 1
        Bubble.Visible = true
        Tween(Bubble, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 54, 0, 54),
            Position = savedPos,
            BackgroundTransparency = 0.05
        })
        Tween(BubbleLabel, TweenInfo.new(0.35), {ImageTransparency = 0})
    end)
end)

--// ============================================
--// DRAG MAIN
--// ============================================

local dragging, dragStart, startPos

local function isDragInput(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end
local function isMoveInput(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
end

Header.InputBegan:Connect(function(input)
    if isDragInput(input) then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
Header.InputEnded:Connect(function(input)
    if isDragInput(input) then dragging = false end
end)

UIS.InputChanged:Connect(function(input)
    if not isMoveInput(input) then return end
    if dragging then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
    if bubbleDragging then
        local d = input.Position - bubbleDragStart
        if d.Magnitude > 2 then bubbleMoved = true end
        Bubble.Position = UDim2.new(bubbleStartPos.X.Scale, bubbleStartPos.X.Offset + d.X, bubbleStartPos.Y.Scale, bubbleStartPos.Y.Offset + d.Y)
    end
end)

--// ============================================
--// LOADING SCREEN
--// ============================================

local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(0, 380, 0, 140)
LoadFrame.Position = UDim2.new(0.5, -190, 0.5, -70)
LoadFrame.BackgroundColor3 = C.BG_MID
LoadFrame.BackgroundTransparency = 0.0
LoadFrame.BorderSizePixel = 0
LoadFrame.ZIndex = 300
LoadFrame.Parent = gui
MakeCorner(LoadFrame, 22)
MakeStroke(LoadFrame, C.STROKE, 1.5, 0.1)
MakeGradient(LoadFrame, C.BG_SURF, C.BG_DEEP, 145)

-- Brillo esquina
local loadGlow = Instance.new("Frame")
loadGlow.Size = UDim2.new(0, 200, 0, 140)
loadGlow.Position = UDim2.new(0, -30, 0, -20)
loadGlow.BackgroundColor3 = C.ACC
loadGlow.BackgroundTransparency = 0.9
loadGlow.BorderSizePixel = 0
loadGlow.ZIndex = 299
loadGlow.Parent = LoadFrame
MakeCorner(loadGlow, 80)

-- Logo izquierdo
local LogoCircle = Instance.new("Frame")
LogoCircle.Size = UDim2.new(0, 88, 0, 88)
LogoCircle.Position = UDim2.new(0, 22, 0.5, -44)
LogoCircle.BackgroundColor3 = C.BG_DEEP
LogoCircle.BorderSizePixel = 0
LogoCircle.ZIndex = 301
LogoCircle.Parent = LoadFrame
MakeCorner(LogoCircle, 44)
MakeStroke(LogoCircle, C.ACC, 2, 0.0)

-- Anillo de spin exterior
local LogoRing = Instance.new("Frame")
LogoRing.Size = UDim2.new(1, 14, 1, 14)
LogoRing.Position = UDim2.new(0, -7, 0, -7)
LogoRing.BackgroundTransparency = 1
LogoRing.BorderSizePixel = 0
LogoRing.ZIndex = 300
LogoRing.Parent = LogoCircle
MakeCorner(LogoRing, 51)
local ringStroke = MakeStroke(LogoRing, C.ACC_GLOW, 2.5, 0.1)

local LogoText = Instance.new("ImageLabel")
LogoText.Size = UDim2.new(1, -6, 1, -6)
LogoText.Position = UDim2.new(0, 3, 0, 3)
LogoText.BackgroundTransparency = 1
LogoText.Image = "rbxassetid://95596426520626"
LogoText.ScaleType = Enum.ScaleType.Crop
LogoText.ZIndex = 302
LogoText.Parent = LogoCircle
MakeCorner(LogoText, 41)

-- Panel derecho
local LoadRight = Instance.new("Frame")
LoadRight.Size = UDim2.new(1, -132, 1, -24)
LoadRight.Position = UDim2.new(0, 124, 0, 12)
LoadRight.BackgroundTransparency = 1
LoadRight.ZIndex = 301
LoadRight.Parent = LoadFrame

local LoadHubName = Instance.new("TextLabel")
LoadHubName.Size = UDim2.new(1, 0, 0, 30)
LoadHubName.Position = UDim2.new(0, 0, 0, 10)
LoadHubName.BackgroundTransparency = 1
LoadHubName.Text = "RedHood Hub v4"
LoadHubName.TextColor3 = C.TXT_W
LoadHubName.TextSize = 22
LoadHubName.Font = Enum.Font.GothamBold
LoadHubName.TextXAlignment = Enum.TextXAlignment.Left
LoadHubName.ZIndex = 302
LoadHubName.Parent = LoadRight

local loadNameGrad = Instance.new("UIGradient")
loadNameGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.ACC_GLOW),
    ColorSequenceKeypoint.new(0.5, C.TXT_W),
    ColorSequenceKeypoint.new(1, C.TXT_M),
})
loadNameGrad.Rotation = 0
loadNameGrad.Parent = LoadHubName

-- Texto animado "Inicializando..."
local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(1, 0, 0, 20)
LoadingLabel.Position = UDim2.new(0, 0, 0, 44)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Inicializando..."
LoadingLabel.TextColor3 = C.TXT_D
LoadingLabel.TextSize = 12
LoadingLabel.Font = Enum.Font.Gotham
LoadingLabel.TextXAlignment = Enum.TextXAlignment.Left
LoadingLabel.ZIndex = 302
LoadingLabel.Parent = LoadRight

local LoadBy = Instance.new("TextLabel")
LoadBy.Size = UDim2.new(1, 0, 0, 16)
LoadBy.Position = UDim2.new(0, 0, 1, -36)
LoadBy.BackgroundTransparency = 1
LoadBy.Text = "by Shiina  .  Muscle Legends"
LoadBy.TextColor3 = C.TXT_D
LoadBy.TextSize = 10
LoadBy.Font = Enum.Font.Gotham
LoadBy.TextXAlignment = Enum.TextXAlignment.Left
LoadBy.ZIndex = 302
LoadBy.Parent = LoadRight

-- Barra de progreso
local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(1, 0, 0, 4)
ProgressBg.Position = UDim2.new(0, 0, 1, -18)
ProgressBg.BackgroundColor3 = C.BG_DEEP
ProgressBg.BackgroundTransparency = 0.0
ProgressBg.BorderSizePixel = 0
ProgressBg.ZIndex = 302
ProgressBg.Parent = LoadRight
MakeCorner(ProgressBg, 2)
MakeStroke(ProgressBg, C.STROKE_DIM, 1, 0.4)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = C.ACC_BR
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 303
ProgressFill.Parent = ProgressBg
MakeCorner(ProgressFill, 2)
MakeGradient(ProgressFill, C.ACC_GLOW, C.ACC, 0)

-- Porcentaje
local loadPct = Instance.new("TextLabel")
loadPct.Size = UDim2.new(0, 36, 0, 14)
loadPct.Position = UDim2.new(1, -36, 1, -34)
loadPct.BackgroundTransparency = 1
loadPct.Text = "0%"
loadPct.TextColor3 = C.ACC_BR
loadPct.TextSize = 10
loadPct.Font = Enum.Font.GothamBold
loadPct.TextXAlignment = Enum.TextXAlignment.Right
loadPct.ZIndex = 303
loadPct.Parent = LoadRight

-- Animar anillo y texto
local loadMsgs = {"Inicializando...", "Cargando modulos...", "Conectando eventos...", "Preparando UI...", "Casi listo..."}
task.spawn(function()
    local t = 0
    local msgIdx = 1
    local msgTimer = 0
    while LoadFrame and LoadFrame.Parent do
        t = t + 0.04
        msgTimer = msgTimer + 0.04
        if msgTimer > 0.4 and msgIdx < #loadMsgs then
            msgIdx = msgIdx + 1
            msgTimer = 0
            pcall(function() LoadingLabel.Text = loadMsgs[msgIdx] end)
        end
        pcall(function()
            ringStroke.Transparency = 0.05 + math.abs(math.sin(t * 3)) * 0.55
        end)
        task.wait(0.04)
    end
end)

local progressTween = TweenService:Create(
    ProgressFill,
    TweenInfo.new(2.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    {Size = UDim2.new(1, 0, 1, 0)}
)

-- Actualizar porcentaje
task.spawn(function()
    for i = 0, 100 do
        task.wait(0.022)
        pcall(function() loadPct.Text = i .. "%" end)
    end
end)

progressTween.Completed:Connect(function()
    task.wait(0.15)
    Tween(LoadFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundTransparency = 1, Size = UDim2.new(0, 380, 0, 4)})
    for _, child in ipairs(LoadFrame:GetDescendants()) do
        pcall(function()
            if child:IsA("TextLabel") or child:IsA("ImageLabel") then
                child.TextTransparency = 1
                child.ImageTransparency = 1
            elseif child:IsA("Frame") then
                child.BackgroundTransparency = 1
            elseif child:IsA("UIStroke") then
                child.Transparency = 1
            end
        end)
    end
    task.wait(0.45)
    LoadFrame:Destroy()

    Main.Visible = true
    Main.Size = UDim2.new(0, 60, 0, 60)
    Main.Position = UDim2.new(0.5, -30, 0.5, -30)
    Tween(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 598, 0, 375),
        Position = UDim2.new(0.5, -299, 0.5, -187)
    })
    task.wait(0.3)
    Notify("RedHood Hub v4  .  Listo!")
end)

progressTween:Play()

--// RECONEXION TRAS MUERTE
--// Reactiva features que dependen del personaje
--// ============================================

player.CharacterAdded:Connect(function(char)
    task.wait(0.4) -- minimo necesario para que el char cargue

    -- Infinite Jump
    if _G.IJConn then _G.IJConn:Disconnect() end
    if _G.IJActive then
        _G.IJConn = UIS.JumpRequest:Connect(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end

    -- No Clip
    if _G.NoClipConn then _G.NoClipConn:Disconnect() end
    if _G.NoClipActive then
        _G.NoClipConn = RunService.Stepped:Connect(function()
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end

    -- Speed Hack
    if _G.SpeedHackActive then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 50 end
    end

    -- Anti Fling
    if _G.AntiFlingActive then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(100000, 0, 100000)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.P = 1250
            bv.Parent = root
        end
    end

    -- NaN Combo
    if _G.NaNComboActive then
        ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 0/0)
    end

    -- Set Speed
    if _G.SpeedActive then
        task.spawn(function()
            while _G.SpeedActive do
                local c = player.Character
                if c and c:FindFirstChildOfClass("Humanoid") then
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSpeed", speedVal)
                end
                task.wait(0.15)
            end
        end)
    end

    -- Set Size
    if _G.SizeActive then
        task.spawn(function()
            while _G.SizeActive do
                local c = player.Character
                if c and c:FindFirstChildOfClass("Humanoid") then
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeVal)
                end
                task.wait(0.15)
            end
        end)
    end

    -- Auto King (Farming)
    if _G.AutoKingActive then
        local kingPos = CFrame.new(-8748, 123, -5865)
        task.spawn(function()
            while _G.AutoKingActive do
                local c = player.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = kingPos end
                task.wait(0.01)
            end
        end)
    end

    -- Auto King (Fast Reb)
    if _G.AutoKingFRActive then
        local kingPos = CFrame.new(-8748, 123, -5865)
        task.spawn(function()
            while _G.AutoKingFRActive do
                local c = player.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = kingPos end
                task.wait(0.01)
            end
        end)
    end

    -- Auto Weight (Fast Reb) â€” con kill loop si no se equipa
    if _G.AutoWeightActive then
        task.spawn(function()
            while _G.AutoWeightActive do
                local p = player
                local c = p.Character
                if not c then task.wait(0.01) continue end
                local hum = c:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then task.wait(0.01) continue end
                local weightInChar = c:FindFirstChild("Weight")
                if not weightInChar then
                    local wb = p.Backpack:FindFirstChild("Weight")
                    if wb and hum then
                        hum:EquipTool(wb)
                        task.wait(0.05)
                        if not c:FindFirstChild("Weight") then
                            local attempts = 0
                            while _G.AutoWeightActive and not c:FindFirstChild("Weight") do
                                attempts = attempts + 1
                                if hum and hum.Health > 0 then hum.Health = 0 end
                                c = p.CharacterAdded:Wait()
                                task.wait(0.8)
                                hum = c:FindFirstChildOfClass("Humanoid")
                                local wb2 = p.Backpack:FindFirstChild("Weight")
                                if wb2 and hum then hum:EquipTool(wb2); task.wait(0.1) end
                                if c:FindFirstChild("Weight") then
                                    Notify("Weight equipado tras " .. attempts .. " reintentos")
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.01) continue
                end
                p.muscleEvent:FireServer("rep")
            end
        end)
    end

    -- Auto Size (Fast Reb / Farming)
    if _G.AutoSize1Active then
        task.spawn(function()
            while _G.AutoSize1Active do
                local c = player.Character
                if c and c:FindFirstChildOfClass("Humanoid") then
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
                end
                task.wait(0.01)
            end
        end)
    end

    -- Auto Rebirth (Fast Reb)
    if _G.AutoRebirthActive then
        task.spawn(function()
            while _G.AutoRebirthActive do
                if _fastRebTargetEnabled and _fastRebTarget > 0 and rebirths.Value >= _fastRebTarget then
                    _G.AutoRebirthActive = false
                    Notify("Auto Rebirth: target alcanzado!")
                    break
                end
                local c = player.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                if not c or not c:FindFirstChild("HumanoidRootPart") or (hum and hum.Health <= 0) then
                    task.wait(0.1) continue
                end
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.05)
            end
        end)
    end

    -- Death Ring Aura
    if _G.deathRingEnabled then
        _G.deathRingConn = task.spawn(function()
            while _G.deathRingEnabled do
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    if ringPart then
                        ringPart.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
                    end
                    local myPos = root.Position
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and not isWhitelisted(p) and isPlayerAlive(p) then
                            if (myPos - p.Character.HumanoidRootPart.Position).Magnitude <= (_G.deathRingRange or 20) then
                                killPlayer(p)
                            end
                        end
                    end
                end
                task.wait(0.15)
            end
            _G.deathRingConn = nil
        end)
    end

    -- Kill Everyone
    if _G.killAll then
        task.spawn(function()
            while _G.killAll do
                for _, p in ipairs(Players:GetPlayers()) do
                    if not _G.killAll then break end
                    if p ~= player and not isWhitelisted(p) then killPlayer(p) end
                end
                task.wait(0.15)
            end
        end)
    end

    -- Kill List
    if _G.killListOnly then
        task.spawn(function()
            while _G.killListOnly do
                for _, p in ipairs(Players:GetPlayers()) do
                    if not _G.killListOnly then break end
                    if p ~= player and isBlacklisted(p) then killPlayer(p) end
                end
                task.wait(0.15)
            end
        end)
    end

    -- Fly Mode
    if _G.FlyActive then
        activateFly(char)
    end

    Notify("Respawn detectado - features ON")
end)
