local LP = game:GetService("Players").LocalPlayer
pcall(function()
    for _, v in pairs(LP:WaitForChild("PlayerGui"):GetChildren()) do
        if v.Name == "AboudEliteV90" then v:Destroy() end
    end
end)

local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VU = game:GetService("VirtualUser")
local ChatService = game:GetService("Chat")

-- ===== المتغيرات والدوال الأساسية (مضافة) =====
local saveFile = "BekaHub_Settings.json"
local ThemeColor = Color3.fromRGB(0, 170, 255)
local ThemedStrokes, ThemedTexts = {}, {}
local ActiveTabBtn
local TargetPlayer, LastTargetName, TargetStatusLabel

local function GetTr(text) return text end
local function AddTr(obj, text, prop) obj[prop or "Text"] = text end

local SafeFont = Enum.Font.SourceSansBold
local isBrookhaven = (game.PlaceId == 4924922222)

local SData = {}
local function SaveAll()
    pcall(function() if writefile then writefile(saveFile, HttpService:JSONEncode(SData)) end end)
end

local function GetS(key, def)
    if SData[key] ~= nil then return SData[key] else return def end
end

local isRainbowRP = GetS("RainbowRP", false)
local HighScore = GetS("MiniGameHighScore", 0)
local BangFrontSpeed = GetS("BangFrontSpeed", 16)

-- متغيراتنا الجديدة محفوظة في SData
local isTargetBang = GetS("TargetBang", false)
local isHeadSit = GetS("HeadSit", false)
local BangBackSpeed = GetS("BangBackSpeed", 30) -- السرعة 30 هنا

-- متغيرات تلوين الـ RP الجديدة
local rpThemes = {"Rainbow", "BlackRed", "BlueWhite", "PurplePink", "GoldBlack"}
local rpThemeNames = {
    Rainbow = "قوس قزح 🌈",
    BlackRed = "أسود وأحمر 🔴⚫",
    BlueWhite = "أزرق وأبيض 🔵⚪",
    PurplePink = "بنفسجي ووردي 🟣🌸",
    GoldBlack = "ذهبي وأسود 🟡⚫"
}
local currentThemeIdx = 1
local RPNameTheme = rpThemes[currentThemeIdx]

local rpSpeeds = {
    {Name = "سريع ⚡", Delay = 0.05},
    {Name = "وسط 🚶", Delay = 0.3},
    {Name = "بطيء 🐢", Delay = 0.8}
}
local currentSpeedIdx = 1
local RPNameSpeedDelay = rpSpeeds[currentSpeedIdx].Delay

local PlayerActivity = {}
for _, p in pairs(game.Players:GetPlayers()) do
    PlayerActivity[p.UserId] = {Joins = 1, Leaves = 0}
end

game.Players.PlayerAdded:Connect(function(p)
    if not PlayerActivity[p.UserId] then
        PlayerActivity[p.UserId] = {Joins = 1, Leaves = 0}
    else
        PlayerActivity[p.UserId].Joins = PlayerActivity[p.UserId].Joins + 1
    end
end)

game.Players.PlayerRemoving:Connect(function(p)
    if PlayerActivity[p.UserId] then
        PlayerActivity[p.UserId].Leaves = PlayerActivity[p.UserId].Leaves + 1
    end
end)

if isBrookhaven then
    task.spawn(function()
        pcall(function()
            local RE = game:GetService("ReplicatedStorage"):WaitForChild("RE", 5)
            if RE then
                local NameTextEvent = RE:WaitForChild("1RPNam1eTex1t", 5)
                local NameColorEvent = RE:WaitForChild("1RPNam1eColo1r", 5)
                
                NameTextEvent:FireServer("RolePlayName", "جاري تحميل سكربت")
                NameTextEvent:FireServer("RolePlayBio", "يرجى الانتظار...")
                
                local redColor = Color3.fromRGB(255, 0, 0)
                NameColorEvent:FireServer("PickingRPNameColor", redColor)
                NameColorEvent:FireServer("PickingRPBioColor", redColor)
            end
        end)
    end)
end

task.spawn(function()
    local hue = 0
    local toggleColor = false
    while true do
        local currentDelay = RPNameSpeedDelay
        if isRainbowRP and isBrookhaven then
            pcall(function()
                local RE = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
                if RE then
                    local colorToApply
                    
                    if RPNameTheme == "Rainbow" then
                        colorToApply = Color3.fromHSV(hue, 1, 1)
                        hue = (hue + 0.05) % 1
                    elseif RPNameTheme == "BlackRed" then
                        colorToApply = toggleColor and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,0,0)
                    elseif RPNameTheme == "BlueWhite" then
                        colorToApply = toggleColor and Color3.fromRGB(0,0,255) or Color3.fromRGB(255,255,255)
                    elseif RPNameTheme == "PurplePink" then
                        colorToApply = toggleColor and Color3.fromRGB(150,0,255) or Color3.fromRGB(255,105,180)
                    elseif RPNameTheme == "GoldBlack" then
                        colorToApply = toggleColor and Color3.fromRGB(255,215,0) or Color3.fromRGB(0,0,0)
                    end
                    
                    if colorToApply then
                        RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPNameColor", colorToApply)
                        RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPBioColor", colorToApply)
                    end
                    toggleColor = not toggleColor
                end
            end)
        end
        task.wait(currentDelay)
    end
end)

-- ===== تحميل الإعدادات المحفوظة (مضاف) =====
pcall(function()
    if isfile and readfile and isfile(saveFile) then
        local data = HttpService:JSONDecode(readfile(saveFile))
        if type(data) == "table" then
            for k, v in pairs(data) do SData[k] = v end
        end
    end
end)

-- ===== حالة المميزات (مضاف) =====
local isSpeed = GetS("Speed", false)
local SpeedValue = GetS("SpeedValue", 50)
local isFly = GetS("Fly", false)
local FlySpeed = 50
local isNoclip = GetS("Noclip", false)
local isESP = GetS("ESP", false)
local isAntiSit = GetS("AntiSit", false)
local isWatch = false
local isTPStay = false
local isBangFront = false
local isBangBack = false
local isStrollerFling = false
local isAntiAFK = GetS("AntiAFK", false)
local isLowDetail = GetS("LowDetail", false)
local isEyeComfort = GetS("EyeComfort", false)

-- ===== الصوت والإشعارات (مضاف) =====
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://6895079853"
ClickSound.Volume = 0.5
ClickSound.Parent = workspace
local function PlayClickSound()
    pcall(function() ClickSound:Play() end)
end

local sg = Instance.new("ScreenGui")
sg.Name = "AboudEliteV90"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() sg.Parent = LP:WaitForChild("PlayerGui") end)

local function SendCustomNotification(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = text, Duration = duration or 4
        })
    end)
end

-- ===== ESP (مضاف) =====
local function UpdateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local hl = p.Character:FindFirstChild("BekaESP")
            if isESP then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "BekaESP"
                    hl.FillColor = ThemeColor
                    hl.Parent = p.Character
                end
            elseif hl then
                hl:Destroy()
            end
        end
    end
end
game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(1); UpdateESP() end)
end)

-- ===== جودة مريحة للعين (مضاف) =====
local CCEffect = Instance.new("ColorCorrectionEffect")
CCEffect.Brightness = 0.03
CCEffect.Contrast = 0.1
CCEffect.Saturation = 0.15
if isEyeComfort then CCEffect.Parent = game.Lighting end

-- ===== السرعة والطيران والجلوس (مضاف) =====
RS.Heartbeat:Connect(function()
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) then return end
        if isSpeed then hum.WalkSpeed = SpeedValue end
        if isAntiSit and hum.Sit then hum.Sit = false end
        if isFly then
            local cam = workspace.CurrentCamera
            hum.PlatformStand = false
            if hum.MoveDirection.Magnitude > 0 then
                hrp.AssemblyLinearVelocity = cam.CFrame.LookVector * FlySpeed
            else
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end)

-- ===== مضاد الخمول (مضاف) =====
LP.Idled:Connect(function()
    if isAntiAFK then
        pcall(function()
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
        end)
    end
end)

-- ===== النافذة الرئيسية (مضاف) =====
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 460, 0, 300)
Main.Position = UDim2.new(0.5, -230, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BackgroundTransparency = 0.1
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.ZIndex = 2
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainBGImage = Instance.new("ImageLabel", Main)
MainBGImage.Size = UDim2.new(1, 100, 1, 100)
MainBGImage.Position = UDim2.new(0, -50, 0, -50)
MainBGImage.BackgroundTransparency = 1
MainBGImage.Image = ""
MainBGImage.ImageTransparency = 0.85
MainBGImage.ZIndex = 3

local SupportOverlay = Instance.new("Frame", sg)
SupportOverlay.Size = UDim2.new(0, 260, 0, 120)
SupportOverlay.Position = UDim2.new(0.5, -130, 0.5, -60)
SupportOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SupportOverlay.Visible = false
SupportOverlay.ZIndex = 1000
Instance.new("UICorner", SupportOverlay).CornerRadius = UDim.new(0, 10)

local SupportTxt = Instance.new("TextLabel", SupportOverlay)
SupportTxt.Size = UDim2.new(1, -20, 0.6, 0)
SupportTxt.Position = UDim2.new(0, 10, 0, 5)
SupportTxt.BackgroundTransparency = 1
SupportTxt.Text = "للدعم تواصل معنا عبر الديسكورد"
SupportTxt.TextColor3 = Color3.new(1, 1, 1)
SupportTxt.Font = SafeFont
SupportTxt.TextSize = 15
SupportTxt.TextWrapped = true
SupportTxt.ZIndex = 1001

local SupportClose = Instance.new("TextButton", SupportOverlay)
SupportClose.Size = UDim2.new(0.5, 0, 0, 30)
SupportClose.Position = UDim2.new(0.25, 0, 1, -40)
SupportClose.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
SupportClose.Text = "إغلاق"
SupportClose.TextColor3 = Color3.new(1, 1, 1)
SupportClose.Font = SafeFont
SupportClose.TextSize = 14
SupportClose.ZIndex = 1001
Instance.new("UICorner", SupportClose).CornerRadius = UDim.new(0, 6)
SupportClose.MouseButton1Click:Connect(function()
    SupportOverlay.Visible = false
end)

task.spawn(function()
    RS.RenderStepped:Connect(function()
        local t = tick()
        if Main.Visible then
            MainBGImage.Position = UDim2.new(0, -50 + math.sin(t * 0.2) * 20, 0, -50 + math.cos(t * 0.2) * 20)
        end
    end)
end)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = ThemeColor
MainStroke.Thickness = 2.5
table.insert(ThemedStrokes, MainStroke)

-- الشريط العلوي (Header)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BackgroundTransparency = 0.2
TopBar.ZIndex = 5

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BEKA HUB | الإصدار الخاص"
Title.TextColor3 = ThemeColor
Title.Font = SafeFont
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6
table.insert(ThemedTexts, Title)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = SafeFont
CloseBtn.TextSize = 16
CloseBtn.ZIndex = 6
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    PlayClickSound()
    Main.Visible = false
end)

-- القائمة الجانبية (Tabs Layout)
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BackgroundTransparency = 0.3
Sidebar.ScrollBarThickness = 2
Sidebar.ZIndex = 5

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -125, 1, -45)
Container.Position = UDim2.new(0, 122, 0, 42)
Container.BackgroundTransparency = 1
Container.ZIndex = 5

local ContentScroll = Instance.new("ScrollingFrame", Container)
ContentScroll.Size = UDim2.new(1, 0, 1, 0)
ContentScroll.BackgroundTransparency = 1
ContentScroll.ScrollBarThickness = 4
ContentScroll.ZIndex = 5

local ContentList = Instance.new("UIListLayout", ContentScroll)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, 8)

-- زر القائمة الخارجية (Open/Close Toggle)
local ToggleBtn = Instance.new("TextButton", sg)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Text = "BEKA"
ToggleBtn.TextColor3 = ThemeColor
ToggleBtn.Font = SafeFont
ToggleBtn.TextSize = 14
ToggleBtn.ZIndex = 999999
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = ThemeColor
ToggleStroke.Thickness = 2
table.insert(ThemedStrokes, ToggleStroke)
table.insert(ThemedTexts, ToggleBtn)

ToggleBtn.MouseButton1Click:Connect(function()
    PlayClickSound()
    Main.Visible = not Main.Visible
end)

-- دالة إنشاء الأزرار للتبويبات
local Tabs = {}
local function CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton", Sidebar)
    tabBtn.Size = UDim2.new(1, -10, 0, 32)
    tabBtn.Position = UDim2.new(0, 5, 0, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.Text = (icon or "") .. " " .. GetTr(name)
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.Font = SafeFont
    tabBtn.TextSize = 13
    tabBtn.ZIndex = 6
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = Container
    
    Tabs[name] = {Btn = tabBtn, Frame = tabFrame}
    
    tabBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        for k, v in pairs(Tabs) do
            v.Frame.Visible = false
            v.Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            v.Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        tabFrame.Visible = true
        tabBtn.BackgroundColor3 = ThemeColor
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveTabBtn = tabBtn
    end)
    
    return tabFrame
end

-- إنشاء التبويبات الأساسية
local MainTab = CreateTab("🏠 قائمة رئيسية", "")
local FeaturesTab = CreateTab("🎡 المميزات", "")
local PlayersTab = CreateTab("👤 اللاعبين", "")
local ProtectionTab = CreateTab("🛡️ حمايه لكل المابات", "")
local ScriptsTab = CreateTab("📜 سكربتات", "")
local SettingsTab = CreateTab("⚙️ أخرى", "")

-- تفعيل التبويب الأول افتراضياً
if Tabs["🏠 قائمة رئيسية"] then
    Tabs["🏠 قائمة رئيسية"].Frame.Visible = true
    Tabs["🏠 قائمة رئيسية"].Btn.BackgroundColor3 = ThemeColor
    Tabs["🏠 قائمة رئيسية"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActiveTabBtn = Tabs["🏠 قائمة رئيسية"].Btn
end

-- ==========================================
-- || 🏠 محتويات القائمة الرئيسية (Main Tab) ||
-- ==========================================

local MainScroll = Instance.new("ScrollingFrame", MainTab)
MainScroll.Size = UDim2.new(1, 0, 1, 0)
MainScroll.BackgroundTransparency = 1
MainScroll.ScrollBarThickness = 3
MainScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
MainScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local MainLayout = Instance.new("UIListLayout", MainScroll)
MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
MainLayout.Padding = UDim.new(0, 8)

-- بطاقة المعلومات الشخصية
local ProfileCard = Instance.new("Frame", MainScroll)
ProfileCard.Size = UDim2.new(1, -10, 0, 80)
ProfileCard.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ProfileCard.BackgroundTransparency = 0.3
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 8)

local ProfileStroke = Instance.new("UIStroke", ProfileCard)
ProfileStroke.Color = ThemeColor
ProfileStroke.Thickness = 1.5
table.insert(ThemedStrokes, ProfileStroke)

local AvatarImg = Instance.new("ImageLabel", ProfileCard)
AvatarImg.Size = UDim2.new(0, 60, 0, 60)
AvatarImg.Position = UDim2.new(0, 10, 0.5, -30)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImg.Image = game:GetService("Players"):GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local WelcomeTxt = Instance.new("TextLabel", ProfileCard)
WelcomeTxt.Size = UDim2.new(1, -85, 0, 25)
WelcomeTxt.Position = UDim2.new(0, 80, 0, 10)
WelcomeTxt.BackgroundTransparency = 1
WelcomeTxt.Text = "أهلاً بك، " .. LP.DisplayName .. " (@" .. LP.Name .. ")"
WelcomeTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeTxt.Font = SafeFont
WelcomeTxt.TextSize = 15
WelcomeTxt.TextXAlignment = Enum.TextXAlignment.Left

local UserInfoTxt = Instance.new("TextLabel", ProfileCard)
UserInfoTxt.Size = UDim2.new(1, -85, 0, 35)
UserInfoTxt.Position = UDim2.new(0, 80, 0, 35)
UserInfoTxt.BackgroundTransparency = 1
UserInfoTxt.Text = GetTr("الأيدي") .. ": " .. LP.UserId .. " | " .. GetTr("عمر الحساب") .. ": " .. LP.AccountAge .. " " .. GetTr("يوم")
UserInfoTxt.TextColor3 = Color3.fromRGB(180, 180, 180)
UserInfoTxt.Font = SafeFont
UserInfoTxt.TextSize = 12
UserInfoTxt.TextXAlignment = Enum.TextXAlignment.Left
UserInfoTxt.TextWrapped = true

-- قسم أزرار الدعم والديسكورد
local DiscordBtn = Instance.new("TextButton", MainScroll)
DiscordBtn.Size = UDim2.new(1, -10, 0, 35)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Text = "🎉 " .. GetTr("انضم لسيرفر الديسكورد الآن!")
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.Font = SafeFont
DiscordBtn.TextSize = 14
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)

DiscordBtn.MouseButton1Click:Connect(function()
    PlayClickSound()
    if setclipboard then
        setclipboard("https://discord.gg/beka")
        SendCustomNotification("✅ " .. GetTr("تم النسخ"), GetTr("تم نسخ رابط الديسكورد! اذهب للمتصفح والصقه."), 4)
    end
end)

local SupportBtn = Instance.new("TextButton", MainScroll)
SupportBtn.Size = UDim2.new(1, -10, 0, 35)
SupportBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
SupportBtn.Text = "⛏️ " .. GetTr("تواصل مع الدعم")
SupportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SupportBtn.Font = SafeFont
SupportBtn.TextSize = 14
Instance.new("UICorner", SupportBtn).CornerRadius = UDim.new(0, 6)

SupportBtn.MouseButton1Click:Connect(function()
    PlayClickSound()
    SupportOverlay.Visible = true
end)

-- ==========================================
-- || 🎡 محتويات قسم المميزات (Features Tab) ||
-- ==========================================

local FeaturesScroll = Instance.new("ScrollingFrame", FeaturesTab)
FeaturesScroll.Size = UDim2.new(1, 0, 1, 0)
FeaturesScroll.BackgroundTransparency = 1
FeaturesScroll.ScrollBarThickness = 3
FeaturesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
FeaturesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local FeaturesLayout = Instance.new("UIListLayout", FeaturesScroll)
FeaturesLayout.SortOrder = Enum.SortOrder.LayoutOrder
FeaturesLayout.Padding = UDim.new(0, 8)

-- دالة إنشاء أزرار التفعيل والتعديل (Toggles)
local function CreateToggle(parent, titleText, defaultValue, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.4
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local txt = Instance.new("TextLabel", frame)
    txt.Size = UDim2.new(0.65, 0, 1, 0)
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = GetTr(titleText)
    txt.TextColor3 = Color3.fromRGB(240, 240, 240)
    txt.Font = SafeFont
    txt.TextSize = 13
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.28, 0, 0.7, 0)
    btn.Position = UDim2.new(0.7, 0, 0.15, 0)
    btn.BackgroundColor3 = defaultValue and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(160, 40, 40)
    btn.Text = defaultValue and GetTr("ON") or GetTr("OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = SafeFont
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local state = defaultValue
    btn.MouseButton1Click:Connect(function()
        PlayClickSound()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(160, 40, 40)
        btn.Text = state and GetTr("ON") or GetTr("OFF")
        callback(state)
    end)
    
    return frame
end

-- إضافة خيارات التحكم بالسرعة والطيران وغيرها
CreateToggle(FeaturesScroll, "⚡ تفعيل السرعة:", isSpeed, function(v)
    isSpeed = v; SData["Speed"] = v; SaveAll()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = v and SpeedValue or 16
    end
end)

CreateToggle(FeaturesScroll, "🦅 طيران (Fly):", isFly, function(v)
    isFly = v; SData["Fly"] = v; SaveAll()
    -- كود الطيران يتم استدعاؤه هنا
end)

CreateToggle(FeaturesScroll, "🧱 نكليب:", isNoclip, function(v)
    isNoclip = v; SData["Noclip"] = v; SaveAll()
end)

CreateToggle(FeaturesScroll, "🔴 ESP:", isESP, function(v)
    isESP = v; SData["ESP"] = v; SaveAll()
    UpdateESP()
end)

CreateToggle(FeaturesScroll, "🪑 مضاد الجلوس (قوي):", isAntiSit, function(v)
    isAntiSit = v; SData["AntiSit"] = v; SaveAll()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not v)
        if v then LP.Character.Humanoid.Sit = false end
    end
end)

-- ==========================================
-- || 👤 محتويات قسم اللاعبين (Players Tab) ||
-- ==========================================

local PlayersScroll = Instance.new("ScrollingFrame", PlayersTab)
PlayersScroll.Size = UDim2.new(1, 0, 1, 0)
PlayersScroll.BackgroundTransparency = 1
PlayersScroll.ScrollBarThickness = 3
PlayersScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayersScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local PlayersLayout = Instance.new("UIListLayout", PlayersScroll)
PlayersLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayersLayout.Padding = UDim.new(0, 8)

-- مربع البحث واختيار اللاعب
local TargetInput = Instance.new("TextBox", PlayersScroll)
TargetInput.Size = UDim2.new(1, -10, 0, 35)
TargetInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.Font = SafeFont
TargetInput.TextSize = 13
TargetInput.Text = ""
Instance.new("UICorner", TargetInput).CornerRadius = UDim.new(0, 6)
AddTr(TargetInput, "🔎 ابحث..", "PlaceholderText")

TargetStatusLabel = Instance.new("TextLabel", PlayersScroll)
TargetStatusLabel.Size = UDim2.new(1, -10, 0, 20)
TargetStatusLabel.BackgroundTransparency = 1
TargetStatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TargetStatusLabel.Font = SafeFont
TargetStatusLabel.TextSize = 12
TargetStatusLabel.Text = GetTr("يرجى البحث عن لاعب")

TargetInput:GetPropertyChangedSignal("Text"):Connect(function()
    local name = TargetInput.Text
    if name ~= "" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if string.sub(string.lower(p.Name), 1, string.len(name)) == string.lower(name) or string.sub(string.lower(p.DisplayName), 1, string.len(name)) == string.lower(name) then
                TargetPlayer = p
                LastTargetName = p.Name
                TargetStatusLabel.Text = GetTr("✅ متصل الآن") .. ": " .. p.DisplayName
                TargetStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
                return
            end
        end
        TargetStatusLabel.Text = GetTr("اللاعب غير موجود!")
        TargetStatusLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- أزرار التفاعل مع اللاعب المستهدف
CreateToggle(PlayersScroll, "👀 مراقبة:", isWatch, function(v)
    isWatch = v; SData["Watch"] = v; SaveAll()
    if v and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Humanoid") then
        workspace.CurrentCamera.CameraSubject = TargetPlayer.Character.Humanoid
    else
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = LP.Character.Humanoid
        end
    end
end)

CreateToggle(PlayersScroll, "🚀 تنقل (Stay):", isTPStay, function(v)
    isTPStay = v; SData["TPStay"] = v; SaveAll()
end)

CreateToggle(PlayersScroll, "🔥 بانج فنج أمامي:", isBangFront, function(v)
    isBangFront = v; SData["BangFront"] = v; SaveAll()
end)

CreateToggle(PlayersScroll, "🍑 بانج فنج خلفي:", isBangBack, function(v)
    isBangBack = v; SData["BangBack"] = v; SaveAll()
end)

CreateToggle(PlayersScroll, "🛋️ قتل بالكنبة (Fling):", isStrollerFling, function(v)
    isStrollerFling = v; SData["Stroller"] = v; SaveAll()
end)

-- ==========================================
-- || 🛡️ محتويات قسم الحماية (Protection Tab) ||
-- ==========================================

local ProtectionScroll = Instance.new("ScrollingFrame", ProtectionTab)
ProtectionScroll.Size = UDim2.new(1, 0, 1, 0)
ProtectionScroll.BackgroundTransparency = 1
ProtectionScroll.ScrollBarThickness = 3
ProtectionScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ProtectionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ProtectionLayout = Instance.new("UIListLayout", ProtectionScroll)
ProtectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
ProtectionLayout.Padding = UDim.new(0, 8)

CreateToggle(ProtectionScroll, "صملة: تشغيل", isAntiAFK, function(v)
    isAntiAFK = v; SData["AntiAFK"] = v; SaveAll()
end)

CreateToggle(ProtectionScroll, "📉 وضع تقليل اللاق (Low Detail):", isLowDetail, function(v)
    isLowDetail = v; SData["LowDetail"] = v; SaveAll()
    if v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
                obj.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end)

CreateToggle(ProtectionScroll, "🌄 جودة مريحة للعين:", isEyeComfort, function(v)
    isEyeComfort = v; SData["EyeComfort"] = v; SaveAll()
    if v then
        CCEffect.Parent = game.Lighting
    else
        CCEffect.Parent = nil
    end
end)

-- ==========================================
-- || 📜 محتويات قسم السكربتات (Scripts Tab) ||
-- ==========================================

local ScriptsScroll = Instance.new("ScrollingFrame", ScriptsTab)
ScriptsScroll.Size = UDim2.new(1, 0, 1, 0)
ScriptsScroll.BackgroundTransparency = 1
ScriptsScroll.ScrollBarThickness = 3
ScriptsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ScriptsLayout = Instance.new("UIListLayout", ScriptsScroll)
ScriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScriptsLayout.Padding = UDim.new(0, 8)

local function CreateScriptBtn(parent, name, loadCode)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = GetTr(name)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = SafeFont
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = ThemeColor
    stroke.Thickness = 1
    table.insert(ThemedStrokes, stroke)

    btn.MouseButton1Click:Connect(function()
        PlayClickSound()
        pcall(loadCode)
    end)
end

CreateScriptBtn(ScriptsScroll, "🕺 سكربت الرقصات", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerScripter/Emotes/main/Script"))()
end)

CreateScriptBtn(ScriptsScroll, "🏎️ سكربت تفحيط سيارات", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerScripter/Drift/main/Script"))()
end)

-- ==========================================
-- || ⚙️ محتويات قسم الخيارات الأخرى (Settings Tab) ||
-- ==========================================

local SettingsScroll = Instance.new("ScrollingFrame", SettingsTab)
SettingsScroll.Size = UDim2.new(1, 0, 1, 0)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.ScrollBarThickness = 3
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SettingsLayout = Instance.new("UIListLayout", SettingsScroll)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0, 8)

-- أزرار التنقل بين السيرفرات
local function CreateServerBtn(text, func)
    local btn = Instance.new("TextButton", SettingsScroll)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = GetTr(text)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = SafeFont
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        PlayClickSound()
        func()
    end)
end

CreateServerBtn("🔄 إعادة دخول السيرفر", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end)

CreateServerBtn("🚀 دخول سيرفر آخر", function()
    TeleportService:Teleport(game.PlaceId, LP)
end)

-- ==========================================
-- || 🔄 الحلقة الرئيسية للتحديث والتنفيذ (Main Loop) ||
-- ==========================================

RS.RenderStepped:Connect(function()
    pcall(function()
        if isTPStay and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
        
        if isBangFront and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1.2)
        end
        
        if isBangBack and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
        end

        if isNoclip and LP.Character then
            for _, v in pairs(LP.Character:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

SendCustomNotification("BEKA HUB", GetTr("تم تحميل سكربت beka بنجاح!"), 5)
