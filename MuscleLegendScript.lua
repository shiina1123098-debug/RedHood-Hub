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

-- Paleta de colores centralizada (Red Hood / Black Souls)
local C = {
    BG_DEEP    = Color3.fromRGB(6,  2,  2),   -- fondo mÃ¡s profundo
    BG_MID     = Color3.fromRGB(12, 4,  4),   -- fondo medio
    BG_LIGHT   = Color3.fromRGB(20, 6,  6),   -- fondo claro
    BG_PANEL   = Color3.fromRGB(14, 4,  4),   -- paneles
    RED_DARK   = Color3.fromRGB(90,  10, 10), -- rojo oscuro
    RED_MID    = Color3.fromRGB(160, 25, 25), -- rojo medio
    RED_VIVID  = Color3.fromRGB(220, 40, 40), -- rojo vÃ­vido
    RED_BRIGHT = Color3.fromRGB(255, 70, 70), -- rojo brillante
    RED_GLOW   = Color3.fromRGB(255,100,100), -- rojo glow
    GOLD_DARK  = Color3.fromRGB(80,  55, 10), -- dorado oscuro (acento sutil)
    GOLD_MID   = Color3.fromRGB(180,130, 30), -- dorado medio
    TEXT_DIM   = Color3.fromRGB(140, 80, 80), -- texto apagado
    TEXT_MID   = Color3.fromRGB(210,155,155), -- texto medio
    TEXT_LIGHT = Color3.fromRGB(255,215,215), -- texto claro
    WHITE      = Color3.fromRGB(255,255,255),
}

local function MakeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function MakeStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.RED_DARK
    s.Thickness = thickness or 1.2
    s.Transparency = transparency or 0.4
    s.Parent = parent
    return s
end

local function MakeGradient(parent, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c0),
        ColorSequenceKeypoint.new(1, c1),
    })
    g.Rotation = rotation or 135
    g.Parent = parent
    return g
end

-- Sombra de profundidad (frame negro semitransparente detrÃ¡s)
local function MakeShadow(parent, offset, size, transparency)
    local s = Instance.new("Frame")
    s.Size = UDim2.new(1, size or 8, 1, size or 8)
    s.Position = UDim2.new(0, -(size or 8)/2 + (offset or 3), 0, -(size or 8)/2 + (offset or 3))
    s.BackgroundColor3 = Color3.fromRGB(0,0,0)
    s.BackgroundTransparency = transparency or 0.55
    s.BorderSizePixel = 0
    s.ZIndex = (parent.ZIndex or 1) - 1
    s.Parent = parent.Parent
    MakeCorner(s, 16)
    return s
end

local function Tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

--// ============================================
--// NOTIFICACION
--// ============================================

local notifStack = {}
local NOTIF_H = 50
local NOTIF_GAP = 8

local function Notify(text, duration)
    duration = duration or 3
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, NOTIF_H)
    notif.Position = UDim2.new(1, 10, 1, 10)
    notif.BackgroundColor3 = C.BG_MID
    notif.BackgroundTransparency = 0
    notif.BorderSizePixel = 0
    notif.ZIndex = 200
    notif.Parent = gui
    MakeCorner(notif, 14)
    MakeGradient(notif, Color3.fromRGB(22,6,6), C.BG_DEEP, 150)
    local stroke = MakeStroke(notif, C.RED_VIVID, 1.5, 0.2)

    -- Barra izquierda decorativa (dorada para diferenciar de UI)
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 0.7, 0)
    accentBar.Position = UDim2.new(0, 0, 0.15, 0)
    accentBar.BackgroundColor3 = C.RED_BRIGHT
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 202
    accentBar.Parent = notif
    MakeCorner(accentBar, 4)
    MakeGradient(accentBar, C.RED_GLOW, C.RED_DARK, 90)

    -- Punto decorativo top-right
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.Position = UDim2.new(1, -12, 0, 8)
    dot.BackgroundColor3 = C.RED_VIVID
    dot.BackgroundTransparency = 0.3
    dot.BorderSizePixel = 0
    dot.ZIndex = 202
    dot.Parent = notif
    MakeCorner(dot, 3)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -26, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.TEXT_LIGHT
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.ZIndex = 201
    label.Parent = notif

    -- Barra de progreso en fondo
    local progBg = Instance.new("Frame")
    progBg.Size = UDim2.new(1, -6, 0, 2)
    progBg.Position = UDim2.new(0, 3, 1, -3)
    progBg.BackgroundColor3 = Color3.fromRGB(30,8,8)
    progBg.BorderSizePixel = 0
    progBg.ZIndex = 201
    progBg.Parent = notif
    MakeCorner(progBg, 2)

    local progFill = Instance.new("Frame")
    progFill.Size = UDim2.new(1, 0, 1, 0)
    progFill.BackgroundColor3 = C.RED_MID
    progFill.BorderSizePixel = 0
    progFill.ZIndex = 202
    progFill.Parent = progBg
    MakeCorner(progFill, 2)

    -- Calcular posiciÃ³n Y en la pila
    table.insert(notifStack, notif)
    local idx = #notifStack
    local targetY = -(NOTIF_H + NOTIF_GAP) * idx

    Tween(notif, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -290, 1, targetY)
    })
    Tween(progFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    })

    task.spawn(function()
        task.wait(duration)
        Tween(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 1, targetY),
            BackgroundTransparency = 1
        })
        Tween(label, TweenInfo.new(0.3), {TextTransparency = 1})
        task.wait(0.35)
        -- Remover de la pila y reposicionar los restantes
        for i, n in ipairs(notifStack) do
            if n == notif then table.remove(notifStack, i); break end
        end
        if notif and notif.Parent then notif:Destroy() end
        -- Reposicionar los que quedan
        for i, n in ipairs(notifStack) do
            local ny = -(NOTIF_H + NOTIF_GAP) * i
            Tween(n, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
                Position = UDim2.new(1, -290, 1, ny)
            })
        end
    end)
end

--// ============================================
--// MAIN FRAME
--// ============================================

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 380)
Main.Position = UDim2.new(0.5, -300, 0.5, -190)
Main.BackgroundColor3 = C.BG_DEEP
Main.BackgroundTransparency = 0
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Visible = false
Main.Parent = gui
MakeCorner(Main, 18)
MakeStroke(Main, C.RED_MID, 1.8, 0.1)

-- Gradiente de fondo profundo
MakeGradient(Main, Color3.fromRGB(16,5,5), Color3.fromRGB(5,2,8), 145)

-- Brillo sutil en la esquina superior izquierda (efecto luz roja)
local mainGlow = Instance.new("Frame")
mainGlow.Size = UDim2.new(0.6, 0, 0.5, 0)
mainGlow.Position = UDim2.new(-0.1, 0, -0.2, 0)
mainGlow.BackgroundColor3 = Color3.fromRGB(100, 10, 10)
mainGlow.BackgroundTransparency = 0.92
mainGlow.BorderSizePixel = 0
mainGlow.ZIndex = 1
mainGlow.Parent = Main
MakeCorner(mainGlow, 120)

--// ============================================
--// HEADER
--// ============================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(10, 3, 3)
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0
Header.ZIndex = 5
Header.Parent = Main
MakeCorner(Header, 18)

MakeGradient(Header, Color3.fromRGB(24,6,6), Color3.fromRGB(10,3,3), 180)

-- LÃ­nea divisora con gradiente rojo-negro-rojo
local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = C.RED_VIVID
HeaderLine.BackgroundTransparency = 0
HeaderLine.BorderSizePixel = 0
HeaderLine.ZIndex = 6
HeaderLine.Parent = Header
local hlGrad = Instance.new("UIGradient")
hlGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(30,5,5)),
    ColorSequenceKeypoint.new(0.3, C.RED_VIVID),
    ColorSequenceKeypoint.new(0.7, C.RED_MID),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(30,5,5)),
})
hlGrad.Parent = HeaderLine

-- Logo circular premium
local LogoBorder = Instance.new("Frame")
LogoBorder.Size = UDim2.new(0, 36, 0, 36)
LogoBorder.Position = UDim2.new(0, 10, 0.5, -18)
LogoBorder.BackgroundColor3 = Color3.fromRGB(8, 2, 2)
LogoBorder.BorderSizePixel = 0
LogoBorder.ZIndex = 7
LogoBorder.Parent = Header
MakeCorner(LogoBorder, 18)
MakeStroke(LogoBorder, C.RED_BRIGHT, 2, 0.1)

local LogoImg = Instance.new("ImageLabel")
LogoImg.Size = UDim2.new(1, -4, 1, -4)
LogoImg.Position = UDim2.new(0, 2, 0, 2)
LogoImg.BackgroundTransparency = 1
LogoImg.Image = "rbxassetid://95596426520626"
LogoImg.ScaleType = Enum.ScaleType.Crop
LogoImg.ZIndex = 8
LogoImg.Parent = LogoBorder
MakeCorner(LogoImg, 16)

-- TÃ­tulo con letra mÃ¡s grande y espaciada
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 54, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "REDHOOD  HUB"
Title.TextColor3 = C.RED_BRIGHT
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6
Title.Parent = Header
-- Sombra de texto
local TitleShadow = Instance.new("TextLabel")
TitleShadow.Size = UDim2.new(1, 0, 1, 0)
TitleShadow.Position = UDim2.new(0, 1, 0, 1)
TitleShadow.BackgroundTransparency = 1
TitleShadow.Text = "REDHOOD  HUB"
TitleShadow.TextColor3 = Color3.fromRGB(80,10,10)
TitleShadow.TextSize = 15
TitleShadow.Font = Enum.Font.GothamBold
TitleShadow.TextXAlignment = Enum.TextXAlignment.Left
TitleShadow.ZIndex = 5
TitleShadow.Parent = Title

-- SubtÃ­tulo "v4 Â· by Shiina"
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -120, 0, 14)
SubTitle.Position = UDim2.new(0, 55, 0.62, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "v4  Â·  Full Edition"
SubTitle.TextColor3 = C.TEXT_DIM
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 6
SubTitle.Parent = Header

-- BotÃ³n Minimizar â€“ estilo flat con icono "_"
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinBtn.Text = "âˆ’"
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BackgroundColor3 = Color3.fromRGB(24, 7, 7)
MinBtn.BackgroundTransparency = 0
MinBtn.TextColor3 = C.TEXT_DIM
MinBtn.BorderSizePixel = 0
MinBtn.ZIndex = 7
MinBtn.Parent = Header
MakeCorner(MinBtn, 9)
MakeStroke(MinBtn, C.RED_DARK, 1, 0.4)

-- BotÃ³n Cerrar â€“ rojo mÃ¡s saturado
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -15)
CloseBtn.Text = "âœ•"
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BackgroundColor3 = Color3.fromRGB(24, 7, 7)
CloseBtn.BackgroundTransparency = 0
CloseBtn.TextColor3 = C.TEXT_DIM
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 7
CloseBtn.Parent = Header
MakeCorner(CloseBtn, 9)
MakeStroke(CloseBtn, C.RED_DARK, 1, 0.4)

--// ============================================
--// SIDEBAR
--// ============================================

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 122, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(9, 2, 2)
Sidebar.BackgroundTransparency = 0
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 4
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
Sidebar.Parent = Main
MakeCorner(Sidebar, 18)

MakeGradient(Sidebar, Color3.fromRGB(14,4,4), Color3.fromRGB(7,2,2), 180)

-- LÃ­nea divisora derecha del sidebar (mÃ¡s gruesa, con gradiente)
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, -50)
SidebarLine.Position = UDim2.new(0, 122, 0, 50)
SidebarLine.BackgroundColor3 = C.RED_DARK
SidebarLine.BackgroundTransparency = 0
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Parent = Main
MakeGradient(SidebarLine, Color3.fromRGB(8,2,2), C.RED_DARK, 90)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 12)
SidebarPad.PaddingBottom = UDim.new(0, 8)
SidebarPad.Parent = Sidebar

--// ============================================
--// CONTENT AREA
--// ============================================

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -132, 1, -60)
ContentArea.Position = UDim2.new(0, 128, 0, 55)
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
        Tween(currentTab.btn,       TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundTransparency = 1})
        Tween(currentTab.label,     TweenInfo.new(0.2), {TextColor3 = C.TEXT_DIM})
        Tween(currentTab.indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0.5, 0)})
    end
    currentTab = tabData
    tabData.panel.Visible = true
    Tween(tabData.btn,       TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.6})
    Tween(tabData.label,     TweenInfo.new(0.25), {TextColor3 = C.RED_BRIGHT})
    Tween(tabData.indicator, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 3, 0.65, 0)
    })
end

local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(22, 6, 6)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.Parent = Sidebar
    MakeCorner(btn, 10)

    -- Fondo activo tenue
    local btnBg = Instance.new("Frame")
    btnBg.Size = UDim2.new(1, 0, 1, 0)
    btnBg.BackgroundColor3 = Color3.fromRGB(30, 7, 7)
    btnBg.BackgroundTransparency = 1
    btnBg.BorderSizePixel = 0
    btnBg.ZIndex = 4
    btnBg.Parent = btn
    MakeCorner(btnBg, 10)
    MakeGradient(btnBg, Color3.fromRGB(35, 8, 8), Color3.fromRGB(18, 5, 5), 180)

    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, -18, 1, 0)
    btnLabel.Position = UDim2.new(0, 14, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = (icon and (icon .. "  ") or "") .. name
    btnLabel.TextColor3 = C.TEXT_DIM
    btnLabel.TextSize = 11
    btnLabel.Font = Enum.Font.GothamSemibold
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left
    btnLabel.ZIndex = 6
    btnLabel.Parent = btn

    -- Indicador lateral izquierdo
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0.5, 0)
    indicator.Position = UDim2.new(0, 1, 0.25, 0)
    indicator.BackgroundColor3 = C.RED_BRIGHT
    indicator.BorderSizePixel = 0
    indicator.BackgroundTransparency = 1
    indicator.ZIndex = 7
    indicator.Parent = btn
    MakeCorner(indicator, 3)
    MakeGradient(indicator, C.RED_GLOW, C.RED_MID, 90)

    local panel = Instance.new("ScrollingFrame")
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    panel.Visible = false
    panel.ZIndex = 4
    panel.ScrollBarThickness = 2
    panel.ScrollBarImageColor3 = C.RED_MID
    panel.CanvasSize = UDim2.new(0, 0, 0, 0)
    panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    panel.Parent = ContentArea

    local panelLayout = Instance.new("UIListLayout")
    panelLayout.Padding = UDim.new(0, 7)
    panelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    panelLayout.Parent = panel

    local panelPad = Instance.new("UIPadding")
    panelPad.PaddingTop = UDim.new(0, 6)
    panelPad.PaddingRight = UDim.new(0, 8)
    panelPad.PaddingBottom = UDim.new(0, 8)
    panelPad.Parent = panel

    local tabData = {btn = btn, panel = panel, label = btnLabel, indicator = indicator, bg = btnBg}

    btn.MouseEnter:Connect(function()
        if currentTab ~= tabData then
            Tween(btnBg, TweenInfo.new(0.15), {BackgroundTransparency = 0.5})
            Tween(btnLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(180, 70, 70)})
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= tabData then
            Tween(btnBg, TweenInfo.new(0.15), {BackgroundTransparency = 1})
            Tween(btnLabel, TweenInfo.new(0.15), {TextColor3 = C.TEXT_DIM})
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

-- LABEL de secciÃ³n â€” con lÃ­nea decorativa izquierda y dorado sutil
local function CreateLabel(parent, text)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 24)
    container.BackgroundTransparency = 1
    container.LayoutOrder = _nextOrder(parent)
    container.ZIndex = 5
    container.Parent = parent

    -- LÃ­nea izquierda de acento dorado
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 2, 0.7, 0)
    accent.Position = UDim2.new(0, 0, 0.15, 0)
    accent.BackgroundColor3 = C.GOLD_MID
    accent.BackgroundTransparency = 0.3
    accent.BorderSizePixel = 0
    accent.ZIndex = 6
    accent.Parent = container
    MakeCorner(accent, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(text)
    lbl.TextColor3 = C.GOLD_MID
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = container
    return container
end

-- TOGGLE â€” diseÃ±o mÃ¡s refinado con track curvado y dot con sombra
local function CreateToggle(parent, labelText, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = C.BG_PANEL
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    row.ZIndex = 5
    row.LayoutOrder = _nextOrder(parent)
    row.Parent = parent
    MakeCorner(row, 10)
    MakeStroke(row, Color3.fromRGB(40,10,10), 1, 0.3)
    MakeGradient(row, Color3.fromRGB(18,5,5), Color3.fromRGB(10,3,3), 180)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -58, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = C.TEXT_MID
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = row

    -- Track do toggle
    local togBg = Instance.new("Frame")
    togBg.Size = UDim2.new(0, 40, 0, 22)
    togBg.Position = UDim2.new(1, -52, 0.5, -11)
    togBg.BackgroundColor3 = Color3.fromRGB(30,8,8)
    togBg.BorderSizePixel = 0
    togBg.ZIndex = 6
    togBg.Parent = row
    MakeCorner(togBg, 11)
    MakeStroke(togBg, Color3.fromRGB(50,12,12), 1, 0.2)

    -- Knob do toggle
    local togDot = Instance.new("Frame")
    togDot.Size = UDim2.new(0, 16, 0, 16)
    togDot.Position = UDim2.new(0, 3, 0.5, -8)
    togDot.BackgroundColor3 = Color3.fromRGB(80,30,30)
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
            Tween(togBg,  TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(150,22,22)})
            Tween(togDot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 21, 0.5, -8),
                BackgroundColor3 = C.WHITE
            })
            Tween(lbl, TweenInfo.new(0.2), {TextColor3 = C.TEXT_LIGHT})
        else
            Tween(togBg,  TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(30,8,8)})
            Tween(togDot, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(80,30,30)
            })
            Tween(lbl, TweenInfo.new(0.2), {TextColor3 = C.TEXT_MID})
        end
        if callback then callback(state) end
    end

    -- Hover sutil
    togBtn.MouseEnter:Connect(function()
        Tween(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18,5,5)})
    end)
    togBtn.MouseLeave:Connect(function()
        Tween(row, TweenInfo.new(0.15), {BackgroundColor3 = C.BG_PANEL})
    end)

    togBtn.Activated:Connect(function() obj:Set(not state) end)
    return row, obj
end

-- BOTÃƒO â€” com gradiente, stroke e animaÃ§Ã£o de click mais premium
local function CreateButton(parent, labelText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(100, 14, 14)
    btn.BackgroundTransparency = 0
    btn.Text = labelText
    btn.TextColor3 = C.TEXT_LIGHT
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.LayoutOrder = _nextOrder(parent)
    btn.Parent = parent
    MakeCorner(btn, 10)
    MakeStroke(btn, C.RED_MID, 1.2, 0.25)
    MakeGradient(btn, Color3.fromRGB(130,18,18), Color3.fromRGB(80,10,10), 180)

    -- Shimmer line en top
    local shimmer = Instance.new("Frame")
    shimmer.Size = UDim2.new(0.6, 0, 0, 1)
    shimmer.Position = UDim2.new(0.2, 0, 0, 0)
    shimmer.BackgroundColor3 = Color3.fromRGB(255,150,150)
    shimmer.BackgroundTransparency = 0.8
    shimmer.BorderSizePixel = 0
    shimmer.ZIndex = 6
    shimmer.Parent = btn
    MakeCorner(shimmer, 1)

    btn.MouseEnter:Connect(function()
        Tween(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(150, 22, 22)
        })
        Tween(shimmer, TweenInfo.new(0.15), {BackgroundTransparency = 0.5})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(100, 14, 14)
        })
        Tween(shimmer, TweenInfo.new(0.15), {BackgroundTransparency = 0.8})
    end)
    btn.Activated:Connect(function()
        Tween(btn, TweenInfo.new(0.07), {BackgroundColor3 = C.RED_VIVID})
        task.spawn(function()
            task.wait(0.12)
            Tween(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100,14,14)})
        end)
        if callback then callback() end
    end)
    return btn
end

-- DROPDOWN â€” mais polido com Ã­cone de seta
local function CreateDropdown(parent, labelText, options, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 36)
    container.BackgroundColor3 = C.BG_PANEL
    container.BackgroundTransparency = 0
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.ZIndex = 5
    container.LayoutOrder = _nextOrder(parent)
    container.Parent = parent
    MakeCorner(container, 10)
    MakeStroke(container, Color3.fromRGB(50,12,12), 1, 0.3)
    MakeGradient(container, Color3.fromRGB(18,5,5), Color3.fromRGB(10,3,3), 180)

    local layout = Instance.new("UIListLayout")
    layout.Parent = container

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1
    header.Text = ""
    header.ZIndex = 6
    header.Parent = container

    -- Label do header
    local headerLbl = Instance.new("TextLabel")
    headerLbl.Size = UDim2.new(1, -40, 1, 0)
    headerLbl.Position = UDim2.new(0, 10, 0, 0)
    headerLbl.BackgroundTransparency = 1
    headerLbl.Text = labelText .. ":  â€”"
    headerLbl.TextColor3 = C.TEXT_MID
    headerLbl.TextSize = 11
    headerLbl.Font = Enum.Font.GothamSemibold
    headerLbl.TextXAlignment = Enum.TextXAlignment.Left
    headerLbl.ZIndex = 7
    headerLbl.Parent = header

    -- Ãcone de seta
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "â–¾"
    arrow.TextColor3 = C.RED_MID
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 7
    arrow.Parent = header

    local open = false
    local selected = nil
    local optBtns = {}

    for _, opt in ipairs(options) do
        local ob = Instance.new("TextButton")
        ob.Size = UDim2.new(1, 0, 0, 28)
        ob.BackgroundColor3 = Color3.fromRGB(15,4,4)
        ob.BackgroundTransparency = 0.1
        ob.Text = "  " .. opt
        ob.TextColor3 = C.TEXT_MID
        ob.TextSize = 11
        ob.Font = Enum.Font.Gotham
        ob.TextXAlignment = Enum.TextXAlignment.Left
        ob.ZIndex = 7
        ob.Visible = false
        ob.Parent = container

        ob.MouseEnter:Connect(function()
            Tween(ob, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30,8,8), BackgroundTransparency = 0})
        end)
        ob.MouseLeave:Connect(function()
            Tween(ob, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(15,4,4), BackgroundTransparency = 0.1})
        end)

        table.insert(optBtns, ob)
        ob.Activated:Connect(function()
            selected = opt
            headerLbl.Text = labelText .. ":  " .. opt
            open = false
            Tween(arrow, TweenInfo.new(0.15), {Rotation = 0})
            container.Size = UDim2.new(1, 0, 0, 36)
            for _, b in ipairs(optBtns) do b.Visible = false end
            if callback then callback(opt) end
        end)
    end

    header.Activated:Connect(function()
        open = not open
        if open then
            for _, b in ipairs(optBtns) do b.Visible = true end
            container.Size = UDim2.new(1, 0, 0, 36 + #optBtns * 28)
            Tween(arrow, TweenInfo.new(0.15), {Rotation = 180})
        else
            for _, b in ipairs(optBtns) do b.Visible = false end
            container.Size = UDim2.new(1, 0, 0, 36)
            Tween(arrow, TweenInfo.new(0.15), {Rotation = 0})
        end
    end)

    local obj = {}
    function obj:GetSelected() return selected end
    return container, obj
end

-- TEXTBOX â€” con placeholder rojo sutil y borde que se ilumina al foco
local function CreateTextBox(parent, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = C.BG_PANEL
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.ZIndex = 5
    frame.LayoutOrder = _nextOrder(parent)
    frame.Parent = parent
    MakeCorner(frame, 10)
    local tbStroke = MakeStroke(frame, Color3.fromRGB(50,12,12), 1, 0.3)
    MakeGradient(frame, Color3.fromRGB(18,5,5), Color3.fromRGB(10,3,3), 180)

    -- Ãcone de lÃ¡pis
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 24, 1, 0)
    icon.Position = UDim2.new(0, 4, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "âœŽ"
    icon.TextColor3 = C.RED_DARK
    icon.TextSize = 13
    icon.Font = Enum.Font.GothamBold
    icon.ZIndex = 6
    icon.Parent = frame

    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, -30, 1, 0)
    tb.Position = UDim2.new(0, 26, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text = ""
    tb.PlaceholderText = placeholder
    tb.PlaceholderColor3 = Color3.fromRGB(100,45,45)
    tb.TextColor3 = C.TEXT_LIGHT
    tb.TextSize = 11
    tb.Font = Enum.Font.Gotham
    tb.TextXAlignment = Enum.TextXAlignment.Left
    tb.ZIndex = 6
    tb.Parent = frame

    tb.Focused:Connect(function()
        Tween(tbStroke, TweenInfo.new(0.2), {
            Color = C.RED_MID,
            Transparency = 0
        })
    end)
    tb.FocusLost:Connect(function(enter)
        Tween(tbStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(50,12,12),
            Transparency = 0.3
        })
        if enter and callback then callback(tb.Text) end
    end)
    return frame
end

--// ============================================
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
    -- genera suelo invisible gigante
    if v and not _G.WaterParts then
        _G.WaterParts = {}
        local partSize = 2048
        local totalDist = 50000
        local startPos = Vector3.new(-2, -9.5, -2)
        local n = math.ceil(totalDist / partSize)
        for x = 0, n-1 do
            for z = 0, n-1 do
                local function mkPart(pos)
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(partSize, 1, partSize)
                    p.Position = pos
                    p.Anchored = true
                    p.Transparency = 1
                    p.CanCollide = true
                    p.Parent = workspace
                    table.insert(_G.WaterParts, p)
                end
                mkPart(startPos + Vector3.new( x*partSize, 0,  z*partSize))
                mkPart(startPos + Vector3.new(-x*partSize, 0,  z*partSize))
                mkPart(startPos + Vector3.new(-x*partSize, 0, -z*partSize))
                mkPart(startPos + Vector3.new( x*partSize, 0, -z*partSize))
            end
        end
        Notify("Walk on Water ON")
    elseif not v and _G.WaterParts then
        for _, p in ipairs(_G.WaterParts) do
            if p and p.Parent then p:Destroy() end
        end
        _G.WaterParts = nil
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
                    if p.Character:FindFirstChild("Stomp") then p.Character.Stomp:Activate() end
                elseif selectedTool == "Ground Slam" then
                    local gs = p.Backpack:FindFirstChild("Ground Slam")
                    if gs then gs.Parent = p.Character end
                    p.muscleEvent:FireServer("slam")
                    if p.Character:FindFirstChild("Ground Slam") then p.Character["Ground Slam"]:Activate() end
                end
                task.wait()
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

local trackerGui = Instance.new("Frame")
trackerGui.Size = UDim2.new(0, 230, 0, 118)
trackerGui.Position = UDim2.new(1, -242, 0, 76)
trackerGui.BackgroundColor3 = C.BG_DEEP
trackerGui.BackgroundTransparency = 0
trackerGui.BorderSizePixel = 0
trackerGui.ZIndex = 100
trackerGui.Visible = false
trackerGui.Parent = gui
MakeCorner(trackerGui, 14)
MakeStroke(trackerGui, C.RED_MID, 1.5, 0.2)
MakeGradient(trackerGui, Color3.fromRGB(16,4,4), C.BG_DEEP, 160)

-- Barra topo do tracker
local trackerHeader = Instance.new("Frame")
trackerHeader.Size = UDim2.new(1, 0, 0, 28)
trackerHeader.BackgroundColor3 = Color3.fromRGB(18,4,4)
trackerHeader.BackgroundTransparency = 0
trackerHeader.BorderSizePixel = 0
trackerHeader.ZIndex = 101
trackerHeader.Parent = trackerGui
MakeCorner(trackerHeader, 14)
MakeGradient(trackerHeader, Color3.fromRGB(24,6,6), Color3.fromRGB(12,3,3), 180)

local trackerHeaderLine = Instance.new("Frame")
trackerHeaderLine.Size = UDim2.new(1, 0, 0, 1)
trackerHeaderLine.Position = UDim2.new(0, 0, 1, -1)
trackerHeaderLine.BackgroundColor3 = C.RED_DARK
trackerHeaderLine.BackgroundTransparency = 0.2
trackerHeaderLine.BorderSizePixel = 0
trackerHeaderLine.ZIndex = 102
trackerHeaderLine.Parent = trackerHeader

local trackerTitle = Instance.new("TextLabel")
trackerTitle.Size = UDim2.new(1, -10, 1, 0)
trackerTitle.Position = UDim2.new(0, 10, 0, 0)
trackerTitle.BackgroundTransparency = 1
trackerTitle.Text = "â—ˆ  PET BUG TRACKER"
trackerTitle.TextColor3 = C.RED_BRIGHT
trackerTitle.TextSize = 11
trackerTitle.Font = Enum.Font.GothamBold
trackerTitle.TextXAlignment = Enum.TextXAlignment.Left
trackerTitle.ZIndex = 102
trackerTitle.Parent = trackerHeader

-- Stats del tracker
local function MakeTrackerRow(yOff, icon, color)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -16, 0, 18)
    row.Position = UDim2.new(0, 8, 0, yOff)
    row.BackgroundTransparency = 1
    row.ZIndex = 101
    row.Parent = trackerGui

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 14, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = color or C.RED_MID
    iconLbl.TextSize = 10
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.ZIndex = 102
    iconLbl.Parent = row

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(1, -16, 1, 0)
    valLbl.Position = UDim2.new(0, 16, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = "â€”"
    valLbl.TextColor3 = C.TEXT_MID
    valLbl.TextSize = 11
    valLbl.Font = Enum.Font.GothamSemibold
    valLbl.TextXAlignment = Enum.TextXAlignment.Left
    valLbl.ZIndex = 102
    valLbl.Parent = row

    return valLbl
end

local trackerStatMin   = MakeTrackerRow(32,  "âš¡", C.RED_BRIGHT)
local trackerStatTotal = MakeTrackerRow(52,  "â—†", C.GOLD_MID)
local trackerTime      = MakeTrackerRow(72,  "â—·", C.TEXT_DIM)
local trackerHits      = MakeTrackerRow(92,  "âœ¦", C.TEXT_DIM)

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
        if newVal > lastDura then  -- Durabilidad subiÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ = golpe aceptado
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
            trackerStatMin.Text   = "Stat/min  " .. formatNumber(statPerMin)
            trackerStatTotal.Text = "Total  " .. formatNumber(totalStat)
            trackerTime.Text      = "Tiempo  " .. formatTime(elapsed)
            trackerHits.Text      = "Golpes  " .. _rockHits
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

CreateLabel(farmPanel, "Rebirth")
local targetRebirths = 0
local rebirths = player.leaderstats:WaitForChild("Rebirths")
CreateTextBox(farmPanel, "Target de Rebirths", function(v)
    local n = tonumber(v)
    if n then targetRebirths = n; Notify("Target -> " .. n) end
end)
CreateToggle(farmPanel, "Auto Rebirth", function(v)
    _G.AutoRebirthActive = v
    if v then
        task.spawn(function()
            while _G.AutoRebirthActive and rebirths.Value < targetRebirths do
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.3)
            end
            _G.AutoRebirthActive = false
            Notify("Auto Rebirth: target alcanzado!")
        end)
    end
end)

CreateLabel(farmPanel, "Misc Farming")
CreateToggle(farmPanel, "Auto Size 1 (farming)", function(v)
    _G.AutoSize1Active = v
    task.spawn(function()
        while _G.AutoSize1Active do
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 1)
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
        local kingPos = CFrame.new(-8665.4, 17.21, -5792.9)
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

CreateLabel(tpPanel, "Safe Platform")
-- Plataforma segura: se crea solo una vez, los siguientes clicks hacen TP a ella
local _safePlatform = nil
local _safePlatformPos = Vector3.new(7840, 300, 9345)

CreateButton(tpPanel, "TP + Plataforma Segura", function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Si ya existe la plataforma, solo hacer TP encima
    if _safePlatform and _safePlatform.Parent then
        hrp.CFrame = CFrame.new(_safePlatform.Position + Vector3.new(0, 8, 0))
        Notify("TP a plataforma existente")
        return
    end

    -- Primera vez: TP + crear plataforma
    local targetPos = _safePlatformPos
    local oldPos = hrp.Position
    hrp.CFrame = CFrame.new(targetPos)
    task.wait(0.5)

    -- Anti-return: si volvio al origen, subir mas
    if (hrp.Position - oldPos).Magnitude < 50 then
        targetPos = targetPos + Vector3.new(0, 100, 0)
        hrp.CFrame = CFrame.new(targetPos)
    end

    -- Crear plataforma debajo
    local platform = Instance.new("Part")
    platform.Name = "SafeGrayPlatform"
    platform.Size = Vector3.new(80, 8, 80)
    platform.Position = hrp.Position - Vector3.new(0, 4, 0)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0
    platform.BrickColor = BrickColor.new("Medium stone grey")
    platform.Material = Enum.Material.Concrete
    platform.Parent = workspace
    _safePlatform = platform

    Notify("Plataforma creada en " .. tostring(math.floor(hrp.Position.X)) .. ", " .. tostring(math.floor(hrp.Position.Y)) .. ", " .. tostring(math.floor(hrp.Position.Z)))
end)

CreateButton(tpPanel, "Eliminar Plataforma", function()
    if _safePlatform and _safePlatform.Parent then
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

CreateButton(miscPanel, "Copiar link del juego", function()
    local ok = pcall(setclipboard, "https://www.roblox.com/games/" .. game.PlaceId)
    Notify(ok and "Link copiado OK" or "Error al copiar")
end)

CreateButton(miscPanel, "Rejoin", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
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

CreateToggle(miscPanel, "Infinite Jump", function(v)
    if v then
        _G.IJConn = UIS.JumpRequest:Connect(function()
            if player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    else
        if _G.IJConn then _G.IJConn:Disconnect(); _G.IJConn = nil end
    end
    Notify("Infinite Jump " .. (v and "ON" or "OFF"))
end)

CreateToggle(miscPanel, "No Clip", function(v)
    if v then
        _G.NoClipConn = RunService.Stepped:Connect(function()
            if player.Character then
                for _, p in ipairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    else
        if _G.NoClipConn then _G.NoClipConn:Disconnect(); _G.NoClipConn = nil end
    end
    Notify("NoClip " .. (v and "ON" or "OFF"))
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
    Tween(MinBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(180,130,25),
        TextColor3 = C.WHITE
    })
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(24,7,7),
        TextColor3 = C.TEXT_DIM
    })
end)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(170,25,25),
        TextColor3 = C.WHITE
    })
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(24,7,7),
        TextColor3 = C.TEXT_DIM
    })
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
Bubble.Size = UDim2.new(0, 58, 0, 58)
Bubble.Position = UDim2.new(0, 24, 0.5, -29)
Bubble.BackgroundColor3 = C.BG_DEEP
Bubble.BackgroundTransparency = 0
Bubble.BorderSizePixel = 0
Bubble.Visible = false
Bubble.ZIndex = 50
Bubble.Parent = gui
MakeCorner(Bubble, 29)
MakeGradient(Bubble, Color3.fromRGB(28,6,6), C.BG_DEEP, 135)
local bubbleStroke = MakeStroke(Bubble, C.RED_BRIGHT, 2, 0.15)

-- Anillo exterior animado (glow)
local BubbleRingOuter = Instance.new("Frame")
BubbleRingOuter.Size = UDim2.new(1, 12, 1, 12)
BubbleRingOuter.Position = UDim2.new(0, -6, 0, -6)
BubbleRingOuter.BackgroundTransparency = 1
BubbleRingOuter.BorderSizePixel = 0
BubbleRingOuter.ZIndex = 49
BubbleRingOuter.Parent = Bubble
MakeCorner(BubbleRingOuter, 35)
local bubbleRingStroke = MakeStroke(BubbleRingOuter, C.RED_DARK, 1.5, 0.5)

local BubbleLabel = Instance.new("ImageLabel")
BubbleLabel.Size = UDim2.new(1, -6, 1, -6)
BubbleLabel.Position = UDim2.new(0, 3, 0, 3)
BubbleLabel.BackgroundTransparency = 1
BubbleLabel.Image = "rbxassetid://95596426520626"
BubbleLabel.ScaleType = Enum.ScaleType.Crop
BubbleLabel.ZIndex = 51
BubbleLabel.Parent = Bubble
MakeCorner(BubbleLabel, 26)

-- AnimaciÃ³n latido (dos anillos pulsando alternados)
task.spawn(function()
    local t = 0
    while gui.Parent do
        t = t + 0.035
        if Bubble.Visible then
            -- Pulso principal
            local pulse = math.abs(math.sin(t * 1.8))
            bubbleStroke.Transparency = 0.05 + pulse * 0.5
            -- Anillo exterior respira inverso
            bubbleRingStroke.Transparency = 0.3 + (1 - pulse) * 0.5
        end
        task.wait(0.03)
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
    Main.Size = UDim2.new(0, 58, 0, 58)
    Main.Position = UDim2.new(Bubble.Position.X.Scale, Bubble.Position.X.Offset, Bubble.Position.Y.Scale, Bubble.Position.Y.Offset)
    Tween(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 380),
        Position = UDim2.new(0.5, -300, 0.5, -190)
    })
end)

MinBtn.Activated:Connect(function()
    local savedPos = Bubble.Position
    Tween(Main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 58, 0, 58),
        Position = UDim2.new(savedPos.X.Scale, savedPos.X.Offset, savedPos.Y.Scale, savedPos.Y.Offset)
    })
    task.spawn(function()
        task.wait(0.28)
        Main.Visible = false
        Bubble.Size = UDim2.new(0, 10, 0, 10)
        Bubble.Position = UDim2.new(savedPos.X.Scale, savedPos.X.Offset + 24, savedPos.Y.Scale, savedPos.Y.Offset + 24)
        Bubble.BackgroundTransparency = 1
        BubbleLabel.ImageTransparency = 1
        Bubble.Visible = true
        Tween(Bubble, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 58, 0, 58),
            Position = savedPos,
            BackgroundTransparency = 0
        })
        Tween(BubbleLabel, TweenInfo.new(0.3), {ImageTransparency = 0})
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
LoadFrame.Size = UDim2.new(0, 320, 0, 120)
LoadFrame.Position = UDim2.new(0.5, -160, 0.5, -60)
LoadFrame.BackgroundColor3 = C.BG_DEEP
LoadFrame.BackgroundTransparency = 0
LoadFrame.BorderSizePixel = 0
LoadFrame.ZIndex = 300
LoadFrame.Parent = gui
MakeCorner(LoadFrame, 18)
MakeStroke(LoadFrame, C.RED_VIVID, 1.8, 0.1)
MakeGradient(LoadFrame, Color3.fromRGB(18,5,5), C.BG_DEEP, 140)

-- Linha decorativa no topo
local loadTopLine = Instance.new("Frame")
loadTopLine.Size = UDim2.new(0, 0, 0, 2)
loadTopLine.Position = UDim2.new(0, 0, 0, 0)
loadTopLine.BackgroundColor3 = C.RED_BRIGHT
loadTopLine.BorderSizePixel = 0
loadTopLine.ZIndex = 302
loadTopLine.Parent = LoadFrame
MakeCorner(loadTopLine, 2)
MakeGradient(loadTopLine, C.RED_GLOW, C.RED_DARK, 0)
-- Animar linha de entrada
Tween(loadTopLine, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 2)})

local LogoCircle = Instance.new("Frame")
LogoCircle.Size = UDim2.new(0, 76, 0, 76)
LogoCircle.Position = UDim2.new(0, 18, 0.5, -38)
LogoCircle.BackgroundColor3 = Color3.fromRGB(8,2,2)
LogoCircle.BorderSizePixel = 0
LogoCircle.ZIndex = 301
LogoCircle.Parent = LoadFrame
MakeCorner(LogoCircle, 38)
MakeStroke(LogoCircle, C.RED_BRIGHT, 2, 0.1)

local LogoRing = Instance.new("Frame")
LogoRing.Size = UDim2.new(1, 14, 1, 14)
LogoRing.Position = UDim2.new(0, -7, 0, -7)
LogoRing.BackgroundTransparency = 1
LogoRing.BorderSizePixel = 0
LogoRing.ZIndex = 300
LogoRing.Parent = LogoCircle
MakeCorner(LogoRing, 44)
local ringStroke = MakeStroke(LogoRing, C.RED_VIVID, 2.5, 0.1)

local LogoText = Instance.new("ImageLabel")
LogoText.Size = UDim2.new(1, -4, 1, -4)
LogoText.Position = UDim2.new(0, 2, 0, 2)
LogoText.BackgroundTransparency = 1
LogoText.Image = "rbxassetid://95596426520626"
LogoText.ScaleType = Enum.ScaleType.Crop
LogoText.ZIndex = 302
LogoText.Parent = LogoCircle
MakeCorner(LogoText, 36)

local LoadRight = Instance.new("Frame")
LoadRight.Size = UDim2.new(1, -112, 1, 0)
LoadRight.Position = UDim2.new(0, 106, 0, 0)
LoadRight.BackgroundTransparency = 1
LoadRight.ZIndex = 301
LoadRight.Parent = LoadFrame

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(1, 0, 0, 22)
LoadingLabel.Position = UDim2.new(0, 0, 0, 16)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Inicializando..."
LoadingLabel.TextColor3 = C.TEXT_DIM
LoadingLabel.TextSize = 11
LoadingLabel.Font = Enum.Font.Gotham
LoadingLabel.TextXAlignment = Enum.TextXAlignment.Left
LoadingLabel.ZIndex = 302
LoadingLabel.Parent = LoadRight

local LoadHubName = Instance.new("TextLabel")
LoadHubName.Size = UDim2.new(1, 0, 0, 26)
LoadHubName.Position = UDim2.new(0, 0, 0, 36)
LoadHubName.BackgroundTransparency = 1
LoadHubName.Text = "REDHOOD  HUB"
LoadHubName.TextColor3 = C.RED_BRIGHT
LoadHubName.TextSize = 17
LoadHubName.Font = Enum.Font.GothamBold
LoadHubName.TextXAlignment = Enum.TextXAlignment.Left
LoadHubName.ZIndex = 302
LoadHubName.Parent = LoadRight

local LoadBy = Instance.new("TextLabel")
LoadBy.Size = UDim2.new(1, -4, 0, 14)
LoadBy.Position = UDim2.new(0, 0, 1, -22)
LoadBy.BackgroundTransparency = 1
LoadBy.Text = "by Shiina  Â·  v4"
LoadBy.TextColor3 = C.RED_DARK
LoadBy.TextSize = 10
LoadBy.Font = Enum.Font.Gotham
LoadBy.TextXAlignment = Enum.TextXAlignment.Right
LoadBy.ZIndex = 302
LoadBy.Parent = LoadRight

local ProgressBg = Instance.new("Frame")
ProgressBg.Size = UDim2.new(1, -4, 0, 4)
ProgressBg.Position = UDim2.new(0, 0, 1, -9)
ProgressBg.BackgroundColor3 = Color3.fromRGB(18,5,5)
ProgressBg.BorderSizePixel = 0
ProgressBg.ZIndex = 302
ProgressBg.Parent = LoadRight
MakeCorner(ProgressBg, 3)
MakeStroke(ProgressBg, Color3.fromRGB(40,10,10), 1, 0.2)

local ProgressFill = Instance.new("Frame")
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = C.RED_BRIGHT
ProgressFill.BorderSizePixel = 0
ProgressFill.ZIndex = 303
ProgressFill.Parent = ProgressBg
MakeCorner(ProgressFill, 3)
MakeGradient(ProgressFill, C.RED_GLOW, C.RED_MID, 0)

task.spawn(function()
    local t = 0
    while LoadFrame and LoadFrame.Parent do
        t = t + 0.05
        pcall(function()
            ringStroke.Transparency = 0.1 + math.abs(math.sin(t * 2.5)) * 0.5
        end)
        task.wait(0.05)
    end
end)

local progressTween = TweenService:Create(
    ProgressFill,
    TweenInfo.new(2, Enum.EasingStyle.Linear),
    {Size = UDim2.new(1, 0, 1, 0)}
)

progressTween.Completed:Connect(function()
    Tween(LoadFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    for _, child in ipairs(LoadFrame:GetDescendants()) do
        pcall(function()
            if child:IsA("TextLabel") then child.TextTransparency = 1
            elseif child:IsA("Frame") then child.BackgroundTransparency = 1
            elseif child:IsA("UIStroke") then child.Transparency = 1 end
        end)
    end
    task.wait(0.3)
    LoadFrame:Destroy()

    Main.Visible = true
    Main.Size = UDim2.new(0, 60, 0, 60)
    Main.Position = UDim2.new(0.5, -30, 0.5, -30)
    Tween(Main, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 380),
        Position = UDim2.new(0.5, -300, 0.5, -190)
    })

    Notify("RedHood Hub v4 â€” Full Edition cargado!")
end)

progressTween:Play()

--// ============================================
--// RECONEXION TRAS MUERTE
--// Reactiva features que dependen del personaje
--// ============================================

player.CharacterAdded:Connect(function(char)
    task.wait(1) -- esperar a que el personaje cargue

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
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
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
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeVal)
                end
                task.wait(0.15)
            end
        end)
    end

    -- Auto King
    if _G.AutoKingActive then
        local kingPos = CFrame.new(-8665.4, 17.21, -5792.9)
        task.spawn(function()
            local hrp = char:WaitForChild("HumanoidRootPart")
            while _G.AutoKingActive do
                if (hrp.Position - kingPos.Position).Magnitude > 5 then
                    hrp.CFrame = kingPos
                end
                task.wait(0.05)
            end
        end)
    end

    -- Death Ring Aura
    if _G.deathRingEnabled and not _G.deathRingConn then
        _G.deathRingConn = RunService.Heartbeat:Connect(function()
            if ringPart then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then ringPart.CFrame = root.CFrame * CFrame.Angles(0,0,math.rad(90)) end
            end
            local myPos = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
            if not myPos then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and not isWhitelisted(p) and isPlayerAlive(p) then
                    local dist = (myPos - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= (_G.deathRingRange or 20) then killPlayer(p) end
                end
            end
        end)
    end

    -- Kill Everyone
    if _G.killAll and not _G.killAllConn then
        _G.killAllConn = RunService.Heartbeat:Connect(function()
            if _G.killAll then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and not isWhitelisted(p) then killPlayer(p) end
                end
            end
        end)
    end

    -- Kill List
    if _G.killListOnly and not _G.killListConn then
        _G.killListConn = RunService.Heartbeat:Connect(function()
            if _G.killListOnly then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and isBlacklisted(p) then killPlayer(p) end
                end
            end
        end)
    end

    Notify("Personaje respawneado - features reactivados")
end)
