--[[
    CORZ CLIENT — Universal Roblox Cheat
    Inspired by amber.lol
    Execute via Xeno executor
    Press Right Ctrl to toggle menu
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================================
-- THEME
-- ============================================================
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    TabBar = Color3.fromRGB(25, 25, 30),
    TabActive = Color3.fromRGB(255, 0, 100),
    TabInactive = Color3.fromRGB(140, 140, 150),
    SectionHeader = Color3.fromRGB(30, 30, 35),
    SectionHeaderText = Color3.fromRGB(255, 0, 100),
    LabelText = Color3.fromRGB(180, 180, 185),
    SliderFill = Color3.fromRGB(255, 0, 100),
    SliderBg = Color3.fromRGB(45, 45, 50),
    SliderKnob = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(255, 0, 100),
    ToggleOff = Color3.fromRGB(50, 50, 55),
    DropdownBg = Color3.fromRGB(35, 35, 40),
    DropdownText = Color3.fromRGB(180, 180, 185),
    DropdownArrow = Color3.fromRGB(255, 0, 100),
    Border = Color3.fromRGB(255, 0, 100),
}

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    Aimbot = {
        Aim = "None",
        StickyAim = false,
        ClosestPart = false,
        Type = "Camera",
        AimPart = "Head",
        AirPart = "Head",
        Smoothness = 5,
        SmoothnessX = 5,
        SmoothnessY = 5,
        PredictionX = 5,
        PredictionY = 5,
        SmoothingStyle = "None",
        TeamCheck = false,
        KnockedCheck = false,
        WallCheck = true,
        DistanceCheck = true,
    },
    Silent = {
        Enabled = false,
        AimPart = "Head",
    },
    Triggerbot = {
        Mode = "None",
        Delay = 0,
    },
    ESP = {
        Enabled = false,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
    },
    FOV = {
        UseFOV = false,
        FillFOV = false,
        SpinFOV = false,
        Radius = 50,
        Transparency = 1,
        FillTransparency = 1,
        SpinSpeed = 1,
        Shape = "Circle",
    },
    Movement = {
        SpeedEnabled = false,
        Speed = 16,
        JumpEnabled = false,
        JumpPower = 50,
        FlyEnabled = false,
        FlySpeed = 50,
    },
}

-- ============================================================
-- UI LIBRARY
-- ============================================================
local UI = {}
UI.__index = UI

function UI.new(title)
    local self = setmetatable({}, UI)
    self.Tabs = {}
    self.Pages = {}
    self.ActiveTab = nil

    local now = os.date("*t")
    local timeStr = string.format("%s %d, %d | %02d:%02d am",
        os.date("%b"), now.day, now.year, now.hour % 12, now.min)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CorzClient"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game:GetService("CoreGui")

    self.Main = Instance.new("Frame")
    self.Main.Size = UDim2.new(0, 480, 0, 360)
    self.Main.Position = UDim2.new(0.5, -240, 0.5, -180)
    self.Main.BackgroundColor3 = Theme.Background
    self.Main.BorderSizePixel = 0
    self.Main.Parent = self.ScreenGui

    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", self.Main)
    stroke.Color = Theme.Border
    stroke.Thickness = 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local titleBar = Instance.new("Frame", self.Main)
    titleBar.Size = UDim2.new(1, 0, 0, 28)
    titleBar.BackgroundColor3 = Theme.SectionHeader
    titleBar.BorderSizePixel = 0

    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 6)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = string.lower("Corz Client") .. " \xe2\x80\x94 " .. timeStr
    titleLabel.TextColor3 = Theme.TabActive
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local tabBar = Instance.new("Frame", self.Main)
    tabBar.Size = UDim2.new(1, 0, 0, 26)
    tabBar.Position = UDim2.new(0, 0, 0, 28)
    tabBar.BackgroundColor3 = Theme.TabBar
    tabBar.BorderSizePixel = 0

    self.TabBar = tabBar

    self.Content = Instance.new("Frame", self.Main)
    self.Content.Size = UDim2.new(1, -16, 1, -60)
    self.Content.Position = UDim2.new(0, 8, 0, 58)
    self.Content.BackgroundTransparency = 1

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            self.Main.Visible = not self.Main.Visible
        end
    end)

    return self
end

function UI:CreateTab(name)
    local tabWidth = 80
    local idx = #self.Tabs + 1
    local tabBtn = Instance.new("TextButton", self.TabBar)
    tabBtn.Size = UDim2.new(0, tabWidth, 1, 0)
    tabBtn.Position = UDim2.new(0, (idx - 1) * tabWidth, 0, 0)
    tabBtn.BackgroundColor3 = Theme.TabBar
    tabBtn.Text = name
    tabBtn.TextColor3 = Theme.TabInactive
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.BorderSizePixel = 0

    local page = Instance.new("Frame", self.Content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false

    self.Tabs[idx] = {Btn = tabBtn, Page = page, Name = name}

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Theme.TabInactive
        end
        page.Visible = true
        tabBtn.TextColor3 = Theme.TabActive
        self.ActiveTab = name
    end)

    if idx == 1 then
        page.Visible = true
        tabBtn.TextColor3 = Theme.TabActive
        self.ActiveTab = name
    end

    local tabObj = setmetatable({Page = page, UI = self}, {
        __index = function(t, k)
            if rawget(t, k) ~= nil then return rawget(t, k) end
            return UI[k]
        end
    })
    return tabObj
end

function UI:CreateSection(parent, text)
    local header = Instance.new("Frame", parent)
    header.Size = UDim2.new(1, 0, 0, 22)
    header.BackgroundColor3 = Theme.SectionHeader
    header.BorderSizePixel = 0
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 4)
    local lbl = Instance.new("TextLabel", header)
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.SectionHeaderText
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return header
end

function UI:CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.LabelText
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("TextButton", frame)
    bg.Size = UDim2.new(0, 32, 0, 16)
    bg.Position = UDim2.new(1, -36, 0.5, -8)
    bg.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
    bg.Text = ""
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", bg)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = default
    bg.MouseButton1Click:Connect(function()
        state = not state
        bg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
        dot.Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        if callback then callback(state) end
    end)

    return {Get = function() return state end, Set = function(v)
        state = v
        bg.BackgroundColor3 = v and Theme.ToggleOn or Theme.ToggleOff
        dot.Position = v and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        if callback then callback(v) end
    end}
end

function UI:CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.55, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.LabelText
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local val = Instance.new("TextLabel", frame)
    val.Size = UDim2.new(0.4, 0, 0, 16)
    val.Position = UDim2.new(0.58, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.TextColor3 = Theme.SliderFill
    val.TextSize = 12
    val.Font = Enum.Font.GothamBold
    val.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, 0, 0, 5)
    bar.Position = UDim2.new(0, 0, 0, 20)
    bar.BackgroundColor3 = Theme.SliderBg
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.SliderFill
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    knob.BackgroundColor3 = Theme.SliderKnob
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local value = default
    local dragging = false

    local function update(input)
        local pct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pct + 0.5)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -5, 0.5, -5)
        val.Text = tostring(value)
        if callback then callback(value) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    return {Get = function() return value end, Set = function(v)
        value = v
        local pct = (v - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -5, 0.5, -5)
        val.Text = tostring(v)
        if callback then callback(v) end
    end}
end

function UI:CreateDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.LabelText
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.42, 0, 0, 20)
    btn.Position = UDim2.new(0.56, 0, 0.5, -10)
    btn.BackgroundColor3 = Theme.DropdownBg
    btn.Text = default
    btn.TextColor3 = Theme.DropdownText
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)

    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 16, 1, 0)
    arrow.Position = UDim2.new(1, -16, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "+"
    arrow.TextColor3 = Theme.DropdownArrow
    arrow.TextSize = 14
    arrow.Font = Enum.Font.GothamBold

    local listFrame = Instance.new("Frame", frame)
    listFrame.Size = UDim2.new(0.42, 0, 0, #options * 22)
    listFrame.Position = UDim2.new(0.56, 0, 0, 24)
    listFrame.BackgroundColor3 = Theme.DropdownBg
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ZIndex = 20
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 3)

    local layout = Instance.new("UIListLayout", listFrame)
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    for i, opt in ipairs(options) do
        local item = Instance.new("TextButton", listFrame)
        item.Size = UDim2.new(1, 0, 0, 20)
        item.BackgroundColor3 = Theme.DropdownBg
        item.Text = opt
        item.TextColor3 = Theme.DropdownText
        item.TextSize = 11
        item.Font = Enum.Font.Gotham
        item.BorderSizePixel = 0
        item.ZIndex = 21
        item.MouseButton1Click:Connect(function()
            btn.Text = opt
            listFrame.Visible = false
            arrow.Text = "+"
            if callback then callback(opt) end
        end)
        item.MouseEnter:Connect(function() item.BackgroundColor3 = Theme.SliderFill end)
        item.MouseLeave:Connect(function() item.BackgroundColor3 = Theme.DropdownBg end)
    end

    local open = false
    btn.MouseButton1Click:Connect(function()
        open = not open
        listFrame.Visible = open
        arrow.Text = open and "-" or "+"
    end)

    local selected = default
    return {Get = function() return selected end, Set = function(v)
        selected = v
        btn.Text = v
        if callback then callback(v) end
    end}
end

-- ============================================================
-- UTILITY
-- ============================================================
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChild("Humanoid")
end
local function isAlive(plr)
    local c = plr.Character
    if not c then return false end
    local h = c:FindFirstChild("Humanoid")
    return h and c:FindFirstChild("HumanoidRootPart") and h.Health > 0
end
local function isKnocked(plr)
    local c = plr.Character
    if not c then return false end
    local fx = c:FindFirstChild("BodyEffects")
    if fx then
        local ko = fx:FindFirstChild("K.O")
        if ko and ko.Value then return true end
    end
    return false
end
local function isTeammate(plr)
    return plr.Team and plr.Team == LocalPlayer.Team
end
local function wallCheck(part)
    if not Config.Aimbot.WallCheck then return true end
    local hrp = getHRP()
    if not hrp then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local ray = workspace:Raycast(hrp.Position, (part.Position - hrp.Position).Unit * 1000, params)
    if ray and ray.Instance then
        local model = part.Parent
        while model and not model:FindFirstChild("Humanoid") do model = model.Parent end
        return ray.Instance:IsDescendantOf(model)
    end
    return true
end
local function getClosestPart(plr)
    local c = plr.Character
    if not c then return nil end
    local best, bestDist = nil, math.huge
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            local sp, vis = Camera:WorldToViewportPoint(p.Position)
            if vis then
                local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if d < bestDist then bestDist = d; best = p end
            end
        end
    end
    return best
end
local function getClosestPlayer()
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) then
            if not isTeammate(plr) and not (Config.Aimbot.KnockedCheck and isKnocked(plr)) then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local myHRP = getHRP()
                if hrp and myHRP then
                    local sp, vis = Camera:WorldToViewportPoint(hrp.Position)
                    if vis then
                        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if d < bestDist then bestDist = d; best = plr end
                    end
                end
            end
        end
    end
    return best
end

-- ============================================================
-- ESP
-- ============================================================
local ESPObjects = {}
local function createESP(plr)
    if plr == LocalPlayer then return end
    local box = Drawing.new("Quad"); box.Visible = false; box.Thickness = 1; box.Filled = false; box.Color = Theme.SliderFill
    local boxO = Drawing.new("Quad"); boxO.Visible = false; boxO.Thickness = 3; boxO.Filled = false; boxO.Color = Color3.new(0,0,0)
    local name = Drawing.new("Text"); name.Visible = false; name.Size = 14; name.Center = true; name.Outline = true; name.Color = Color3.new(1,1,1)
    local hp = Drawing.new("Line"); hp.Visible = false; hp.Thickness = 2; hp.Color = Color3.new(0,1,0)
    local hpT = Drawing.new("Text"); hpT.Visible = false; hpT.Size = 12; hpT.Center = true; hpT.Outline = true; hpT.Color = Color3.new(0,1,0)
    local dist = Drawing.new("Text"); dist.Visible = false; dist.Size = 12; dist.Center = true; dist.Outline = true; dist.Color = Color3.new(1,1,1)
    local tracer = Drawing.new("Line"); tracer.Visible = false; tracer.Thickness = 1; tracer.Color = Color3.new(1,1,1)
    ESPObjects[plr] = {Box=box, BoxO=boxO, Name=name, Hp=hp, HpT=hpT, Dist=dist, Tracer=tracer}
end
local function removeESP(plr)
    local e = ESPObjects[plr]
    if e then
        for _, v in pairs(e) do pcall(function() v:Remove() end) end
        ESPObjects[plr] = nil
    end
end
local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) then
            if not ESPObjects[plr] then createESP(plr) end
            local e = ESPObjects[plr]
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hrp and hum and Config.ESP.Enabled then
                local myHRP = getHRP()
                local _, vis = Camera:WorldToViewportPoint(hrp.Position)
                if vis then
                    local root2D = Camera:WorldToViewportPoint(hrp.Position)
                    local head2D = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.5, 0))
                    local leg2D = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local h2, l2 = Vector2.new(head2D.X, head2D.Y), Vector2.new(leg2D.X, leg2D.Y)
                    local bH = (l2 - h2).Magnitude
                    local bW = bH * 0.6
                    local tl = Vector2.new(h2.X - bW/2, h2.Y)
                    local tr = Vector2.new(h2.X + bW/2, h2.Y)
                    local bl = Vector2.new(l2.X - bW/2, l2.Y)
                    local br = Vector2.new(l2.X + bW/2, l2.Y)
                    if Config.ESP.Boxes then
                        e.BoxO.PointA=tl; e.BoxO.PointB=tr; e.BoxO.PointC=br; e.BoxO.PointD=bl; e.BoxO.Visible=true
                        e.Box.PointA=tl; e.Box.PointB=tr; e.Box.PointC=br; e.Box.PointD=bl; e.Box.Visible=true
                    else e.Box.Visible=false; e.BoxO.Visible=false end
                    if Config.ESP.Names then
                        e.Name.Position=Vector2.new(h2.X, h2.Y-18); e.Name.Text=plr.DisplayName; e.Name.Visible=true
                    else e.Name.Visible=false end
                    if Config.ESP.Health then
                        local hp = hum.Health/hum.MaxHealth
                        local bH2 = bH*hp
                        e.Hp.From=Vector2.new(bl.X-6, bl.Y); e.Hp.To=Vector2.new(bl.X-6, bl.Y-bH2)
                        e.Hp.Color=Color3.fromRGB(255*(1-hp),255*hp,0); e.Hp.Visible=true
                        e.HpT.Position=Vector2.new(bl.X-6, bl.Y-bH2-14); e.HpT.Text=math.floor(hum.Health); e.HpT.Color=e.Hp.Color; e.HpT.Visible=true
                    else e.Hp.Visible=false; e.HpT.Visible=false end
                    if Config.ESP.Distance and myHRP then
                        local d=math.floor((myHRP.Position-hrp.Position).Magnitude)
                        e.Dist.Position=Vector2.new(h2.X, h2.Y+bH+4); e.Dist.Text=d.."m"; e.Dist.Visible=true
                    else e.Dist.Visible=false end
                    if Config.ESP.Tracers and myHRP then
                        local fp=Camera:WorldToViewportPoint(myHRP.Position-Vector3.new(0,3,0))
                        e.Tracer.From=Vector2.new(fp.X,fp.Y); e.Tracer.To=Vector2.new(root2D.X,root2D.Y); e.Tracer.Visible=true
                    else e.Tracer.Visible=false end
                else
                    for _,v in pairs(e) do pcall(function() v.Visible=false end) end
                end
            else
                for _,v in pairs(e) do pcall(function() v.Visible=false end) end
            end
        else removeESP(plr) end
    end
end

-- ============================================================
-- FOV
-- ============================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.NumSides = 64
FOVCircle.Color = Theme.SliderFill

local FOVCircleFill = Drawing.new("Circle")
FOVCircleFill.Thickness = 1
FOVCircleFill.Filled = true
FOVCircleFill.NumSides = 64
FOVCircleFill.Color = Theme.SliderFill
FOVCircleFill.Transparency = 0.3

local function updateFOV()
    local c = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = Config.FOV.Radius; FOVCircle.Position = c; FOVCircle.Visible = Config.FOV.UseFOV
    FOVCircleFill.Radius = Config.FOV.Radius; FOVCircleFill.Position = c; FOVCircleFill.Visible = Config.FOV.UseFOV and Config.FOV.FillFOV
    FOVCircleFill.Transparency = Config.FOV.FillTransparency
end

-- ============================================================
-- AIMBOT
-- ============================================================
local function getAimPart(plr)
    local c = plr.Character
    if not c then return nil end
    if Config.Aimbot.ClosestPart then return getClosestPart(plr) end
    return c:FindFirstChild(Config.Aimbot.AimPart) or c:FindFirstChild("HumanoidRootPart")
end

local function doAimbot()
    if Config.Aimbot.Aim == "None" then return end
    local target = getClosestPlayer()
    if not target then return end
    local aimPart = getAimPart(target)
    if not aimPart or not wallCheck(aimPart) then return end
    local predictedPos = aimPart.Position
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local vel = hrp.Velocity
        predictedPos = predictedPos + Vector3.new(vel.X * Config.Aimbot.PredictionX * 0.01, 0, vel.Z * Config.Aimbot.PredictionY * 0.01)
    end
    local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
    if not onScreen then return end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
    if Config.FOV.UseFOV and dist > Config.FOV.Radius then return end
    if Config.Aimbot.Type == "Camera" then
        local dir = (predictedPos - Camera.CFrame.Position).Unit
        local yaw = math.atan2(dir.X, dir.Z)
        local pitch = math.asin(math.clamp(dir.Y, -1, 1))
        local targetCF = Camera.CFrame * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
        local smooth = Config.Aimbot.Smoothness
        if smooth > 0 then
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1/smooth)
        else
            Camera.CFrame = targetCF
        end
    end
end

-- ============================================================
-- TRIGGERBOT
-- ============================================================
local triggerConn = nil
local function doTriggerbot()
    if Config.Triggerbot.Mode == "None" then
        if triggerConn then triggerConn:Disconnect(); triggerConn = nil end
        return
    end
    if triggerConn then return end
    triggerConn = RunService.Heartbeat:Connect(function()
        if Config.Triggerbot.Mode == "None" then
            triggerConn:Disconnect(); triggerConn = nil; return
        end
        local target = getClosestPlayer()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local sp, vis = Camera:WorldToViewportPoint(head.Position)
                if vis then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if d <= 30 then
                        if Config.Triggerbot.Delay > 0 then wait(Config.Triggerbot.Delay) end
                        mouse1press(); wait(0.05); mouse1release()
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- BUILD UI
-- ============================================================
local App = UI.new("Corz Client")

-- ==================== AIMBOT TAB ====================
local AimTab = App:CreateTab("Aimbot")

-- Left column container
local AimLeft = Instance.new("Frame", AimTab.Page)
AimLeft.Size = UDim2.new(0.48, 0, 1, 0)
AimLeft.Position = UDim2.new(0, 0, 0, 0)
AimLeft.BackgroundTransparency = 1
AimLeft.ClipsDescendants = true

local aimL = Instance.new("UIListLayout", AimLeft)
aimL.Padding = UDim.new(0, 3)
aimL.SortOrder = Enum.SortOrder.LayoutOrder

UI:CreateSection(AimLeft, "Aimbot")
AimTab:CreateDropdown(AimLeft, "Aim", {"None", "Closest", "FOV", "Health"}, "None", function(v) Config.Aimbot.Aim = v end)
AimTab:CreateToggle(AimLeft, "Sticky Aim", false, function(v) Config.Aimbot.StickyAim = v end)
AimTab:CreateToggle(AimLeft, "Closest Part", false, function(v) Config.Aimbot.ClosestPart = v end)
AimTab:CreateDropdown(AimLeft, "Type", {"Camera", "Mouse"}, "Camera", function(v) Config.Aimbot.Type = v end)
AimTab:CreateDropdown(AimLeft, "Aim Part", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}, "Head", function(v) Config.Aimbot.AimPart = v end)
AimTab:CreateDropdown(AimLeft, "Air Part", {"Head", "HumanoidRootPart"}, "Head", function(v) Config.Aimbot.AirPart = v end)

UI:CreateSection(AimLeft, "FOV")
AimTab:CreateToggle(AimLeft, "Use FOV", false, function(v) Config.FOV.UseFOV = v end)
AimTab:CreateToggle(AimLeft, "Fill FOV", false, function(v) Config.FOV.FillFOV = v end)
AimTab:CreateToggle(AimLeft, "Spin FOV", false, function(v) Config.FOV.SpinFOV = v end)
AimTab:CreateSlider(AimLeft, "FOV Radius", 10, 500, 50, function(v) Config.FOV.Radius = v end)
AimTab:CreateSlider(AimLeft, "FOV Transparency", 0, 10, 10, function(v) Config.FOV.Transparency = v/10 end)
AimTab:CreateSlider(AimLeft, "Fill Transparency", 0, 10, 10, function(v) Config.FOV.FillTransparency = v/10 end)
AimTab:CreateSlider(AimLeft, "Spin Speed", 1, 20, 1, function(v) Config.FOV.SpinSpeed = v end)
AimTab:CreateDropdown(AimLeft, "Shape", {"Circle", "Square"}, "Circle", function(v) Config.FOV.Shape = v end)

-- Right column container
local AimRight = Instance.new("Frame", AimTab.Page)
AimRight.Size = UDim2.new(0.48, 0, 1, 0)
AimRight.Position = UDim2.new(0.52, 0, 0, 0)
AimRight.BackgroundTransparency = 1
AimRight.ClipsDescendants = true

local aimR = Instance.new("UIListLayout", AimRight)
aimR.Padding = UDim.new(0, 3)
aimR.SortOrder = Enum.SortOrder.LayoutOrder

UI:CreateSection(AimRight, "Controls")
AimTab:CreateSlider(AimRight, "Smoothness", 1, 20, 5, function(v) Config.Aimbot.Smoothness = v end)
AimTab:CreateSlider(AimRight, "Smoothness X", 1, 20, 5, function(v) Config.Aimbot.SmoothnessX = v end)
AimTab:CreateSlider(AimRight, "Smoothness Y", 1, 20, 5, function(v) Config.Aimbot.SmoothnessY = v end)

UI:CreateSection(AimRight, "Predictions")
AimTab:CreateSlider(AimRight, "Prediction X", 0, 20, 5, function(v) Config.Aimbot.PredictionX = v end)
AimTab:CreateSlider(AimRight, "Prediction Y", 0, 20, 5, function(v) Config.Aimbot.PredictionY = v end)

AimTab:CreateDropdown(AimRight, "Smoothing Style", {"None", "Linear", "Quadratic", "Exponential"}, "None", function(v) Config.Aimbot.SmoothingStyle = v end)

AimTab:CreateToggle(AimRight, "Team Check", false, function(v) Config.Aimbot.TeamCheck = v end)
AimTab:CreateToggle(AimRight, "Knocked Check", false, function(v) Config.Aimbot.KnockedCheck = v end)
AimTab:CreateToggle(AimRight, "Wallcheck", true, function(v) Config.Aimbot.WallCheck = v end)
AimTab:CreateToggle(AimRight, "Distance Check", true, function(v) Config.Aimbot.DistanceCheck = v end)

AimTab:CreateDropdown(AimRight, "Trigger Bot", {"None", "Auto", "On Key"}, "None", function(v) Config.Triggerbot.Mode = v; doTriggerbot() end)

-- ==================== SILENT TAB ====================
local SilTab = App:CreateTab("Silent")

local SilLeft = Instance.new("Frame", SilTab.Page)
SilLeft.Size = UDim2.new(0.48, 0, 1, 0)
SilLeft.BackgroundTransparency = 1
Instance.new("UIListLayout", SilLeft).Padding = UDim.new(0, 3)

UI:CreateSection(SilLeft, "Silent Aim")
SilTab:CreateToggle(SilLeft, "Enabled", false, function(v) Config.Silent.Enabled = v end)
SilTab:CreateDropdown(SilLeft, "Aim Part", {"Head", "HumanoidRootPart", "UpperTorso"}, "Head", function(v) Config.Silent.AimPart = v end)

local SilRight = Instance.new("Frame", SilTab.Page)
SilRight.Size = UDim2.new(0.48, 0, 1, 0)
SilRight.Position = UDim2.new(0.52, 0, 0, 0)
SilRight.BackgroundTransparency = 1
Instance.new("UIListLayout", SilRight).Padding = UDim.new(0, 3)

UI:CreateSection(SilRight, "Projectile")
SilTab:CreateSlider(SilRight, "Bullet Speed", 0, 2000, 1000, function(v) end)
SilTab:CreateDropdown(SilRight, "Bullet Type", {"Hitscan", "Projectile", "Raycast"}, "Hitscan", function(v) end)

-- ==================== VISUAL TAB ====================
local VisTab = App:CreateTab("Visual")

local VisLeft = Instance.new("Frame", VisTab.Page)
VisLeft.Size = UDim2.new(0.48, 0, 1, 0)
VisLeft.BackgroundTransparency = 1
Instance.new("UIListLayout", VisLeft).Padding = UDim.new(0, 3)

UI:CreateSection(VisLeft, "ESP")
VisTab:CreateToggle(VisLeft, "Enabled", false, function(v) Config.ESP.Enabled = v end)
VisTab:CreateToggle(VisLeft, "Boxes", true, function(v) Config.ESP.Boxes = v end)
VisTab:CreateToggle(VisLeft, "Names", true, function(v) Config.ESP.Names = v end)
VisTab:CreateToggle(VisLeft, "Health", true, function(v) Config.ESP.Health = v end)
VisTab:CreateToggle(VisLeft, "Distance", true, function(v) Config.ESP.Distance = v end)
VisTab:CreateToggle(VisLeft, "Tracers", false, function(v) Config.ESP.Tracers = v end)

local VisRight = Instance.new("Frame", VisTab.Page)
VisRight.Size = UDim2.new(0.48, 0, 1, 0)
VisRight.Position = UDim2.new(0.52, 0, 0, 0)
VisRight.BackgroundTransparency = 1
Instance.new("UIListLayout", VisRight).Padding = UDim.new(0, 3)

UI:CreateSection(VisRight, "Chams")
VisTab:CreateToggle(VisRight, "Team Color", false, function(v) end)
VisTab:CreateToggle(VisRight, "X-Ray", false, function(v) end)

-- ==================== MOVEMENT TAB ====================
local MovTab = App:CreateTab("Movement")

local MovLeft = Instance.new("Frame", MovTab.Page)
MovLeft.Size = UDim2.new(0.48, 0, 1, 0)
MovLeft.BackgroundTransparency = 1
Instance.new("UIListLayout", MovLeft).Padding = UDim.new(0, 3)

UI:CreateSection(MovLeft, "Speed")
MovTab:CreateToggle(MovLeft, "Speed Hack", false, function(v)
    Config.Movement.SpeedEnabled = v
    local h = getHum()
    if h then h.WalkSpeed = v and Config.Movement.Speed or 16 end
end)
MovTab:CreateSlider(MovLeft, "Speed", 16, 200, 16, function(v)
    Config.Movement.Speed = v
    if Config.Movement.SpeedEnabled then local h = getHum(); if h then h.WalkSpeed = v end end
end)

UI:CreateSection(MovLeft, "Jump")
MovTab:CreateToggle(MovLeft, "Jump Power", false, function(v)
    Config.Movement.JumpEnabled = v
    local h = getHum()
    if h then h.JumpPower = v and Config.Movement.JumpPower or 50 end
end)
MovTab:CreateSlider(MovLeft, "Jump Power", 50, 300, 50, function(v)
    Config.Movement.JumpPower = v
    if Config.Movement.JumpEnabled then local h = getHum(); if h then h.JumpPower = v end end
end)

local MovRight = Instance.new("Frame", MovTab.Page)
MovRight.Size = UDim2.new(0.48, 0, 1, 0)
MovRight.Position = UDim2.new(0.52, 0, 0, 0)
MovRight.BackgroundTransparency = 1
Instance.new("UIListLayout", MovRight).Padding = UDim.new(0, 3)

UI:CreateSection(MovRight, "Fly")
local flyVel, flyGyro = nil, nil
MovTab:CreateToggle(MovRight, "Fly", false, function(v)
    Config.Movement.FlyEnabled = v
    local hrp = getHRP()
    if v and hrp then
        flyVel = Instance.new("BodyVelocity"); flyVel.MaxForce = Vector3.new(1e9,1e9,1e9); flyVel.Velocity = Vector3.new(); flyVel.Parent = hrp
        flyGyro = Instance.new("BodyGyro"); flyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9); flyGyro.P = 1e4; flyGyro.D = 500; flyGyro.Parent = hrp
    else
        if flyVel then flyVel:Destroy(); flyVel = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    end
end)
MovTab:CreateSlider(MovRight, "Fly Speed", 10, 200, 50, function(v) Config.Movement.FlySpeed = v end)

UI:CreateSection(MovRight, "NoClip")
MovTab:CreateToggle(MovRight, "NoClip", false, function(v)
    if v then
        RunService.Stepped:Connect(function()
            if not Config.Movement.NoClip then return end
            local c = getChar()
            if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end)
    end
    Config.Movement.NoClip = v
end)

-- ==================== PLAYERS TAB ====================
local PlrTab = App:CreateTab("Players")

local PlrLeft = Instance.new("Frame", PlrTab.Page)
PlrLeft.Size = UDim2.new(0.48, 0, 1, 0)
PlrLeft.BackgroundTransparency = 1
Instance.new("UIListLayout", PlrLeft).Padding = UDim.new(0, 3)

UI:CreateSection(PlrLeft, "Player List")
PlrTab:CreateButton(PlrLeft, "Teleport to Closest", function()
    local t = getClosestPlayer()
    if t and t.Character then
        local hrp = t.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = getHRP()
        if hrp and myHRP then myHRP.CFrame = hrp.CFrame end
    end
end)
PlrTab:CreateButton(PlrLeft, "Spectate Closest", function()
    local t = getClosestPlayer()
    if t then Camera.CameraSubject = t.Character:FindFirstChild("Humanoid") end
end)
PlrTab:CreateButton(PlrLeft, "Reset Camera", function()
    Camera.CameraSubject = getHum()
end)

local PlrRight = Instance.new("Frame", PlrTab.Page)
PlrRight.Size = UDim2.new(0.48, 0, 1, 0)
PlrRight.Position = UDim2.new(0.52, 0, 0, 0)
PlrRight.BackgroundTransparency = 1
Instance.new("UIListLayout", PlrRight).Padding = UDim.new(0, 3)

UI:CreateSection(PlrRight, "Target")
PlrTab:CreateButton(PlrRight, "View Target", function()
    local t = getClosestPlayer()
    if t and t.Character then
        local head = t.Character:FindFirstChild("Head")
        if head then Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position) end
    end
end)

-- ==================== SETTINGS TAB ====================
local SetTab = App:CreateTab("Settings")

local SetLeft = Instance.new("Frame", SetTab.Page)
SetLeft.Size = UDim2.new(0.48, 0, 1, 0)
SetLeft.BackgroundTransparency = 1
Instance.new("UIListLayout", SetLeft).Padding = UDim.new(0, 3)

UI:CreateSection(SetLeft, "Keybinds")
SetTab:CreateButton(SetLeft, "Right Ctrl = Toggle Menu", function() end)

local SetRight = Instance.new("Frame", SetTab.Page)
SetRight.Size = UDim2.new(0.48, 0, 1, 0)
SetRight.Position = UDim2.new(0.52, 0, 0, 0)
SetRight.BackgroundTransparency = 1
Instance.new("UIListLayout", SetRight).Padding = UDim.new(0, 3)

UI:CreateSection(SetRight, "Misc")
SetTab:CreateButton(SetRight, "Unload All", function()
    Config.Aimbot.Aim = "None"
    Config.Silent.Enabled = false
    Config.Triggerbot.Mode = "None"
    Config.ESP.Enabled = false
    Config.FOV.UseFOV = false
    for _, e in pairs(ESPObjects) do for _,v in pairs(e) do pcall(function() v:Remove() end) end end
    ESPObjects = {}
    FOVCircle.Visible = false; FOVCircleFill.Visible = false
    if triggerConn then triggerConn:Disconnect(); triggerConn = nil end
    if flyVel then flyVel:Destroy(); flyVel = nil end
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
end)

-- ============================================================
-- MAIN LOOP
-- ============================================================
RunService.RenderStepped:Connect(function()
    updateESP()
    updateFOV()
    doAimbot()
    if flyEnabled and flyVel and flyGyro then
        local hrp = getHRP()
        if hrp then
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
            flyVel.Velocity = dir.Magnitude > 0 and dir.Unit * Config.Movement.FlySpeed or Vector3.new()
            flyGyro.CFrame = Camera.CFrame
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if Config.Movement.SpeedEnabled then local h = getHum(); if h then h.WalkSpeed = Config.Movement.Speed end end
    if Config.Movement.JumpEnabled then local h = getHum(); if h then h.JumpPower = Config.Movement.JumpPower end end
end)

Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)

print("[CORZ CLIENT] Loaded! Press Right Ctrl to toggle.")
