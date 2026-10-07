local LP = game:GetService("Players").LocalPlayer
pcall(function()
    for _, v in pairs(LP:WaitForChild("PlayerGui"):GetChildren()) do
        if v.Name == "YousifHubV1" then v:Destroy() end
    end
end)

local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VU = game:GetService("VirtualUser")
local ChatService = game:GetService("Chat")

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
-- ==========================================
-- || 🏷️ نظام الرتب فوق الرأس لـ ABD HUB (مربوط بـ WebSocket) ||
-- ==========================================

-- تم إزالة المتغيرات المكررة (Players, HttpService, LP) لأنها موجودة مسبقاً في سكربتك
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- 🌐 إعدادات سيرفر WebSocket
local WEBSOCKET_URL = "wss://abd-server-9vf6.onrender.com"
local WSSocket = nil
local Developers = {
    ["yousif1479"] = true,
}

local RankAdmins = {
    ["yousif1479"] = true,
}

local RankMods = {
    ["yousif1479"] = true,
}

local RankVIPs = {
    ["yousif1479"] = true,
}

local SECRET_BIO_MEMBER = "ABD HUB PPR" 
local SECRET_BIO_SAMILLL = "ABD HUB SAMILLL" 
local ActiveUsers = {} 
local tagConnections = {} -- تم تغيير الاسم لتفادي التعارض
local tagsVisible = true 

-- 🛡️ إنشاء واجهة محمية (ScreenGui) داخل مسار منفصل لمنع توقف السكربت (Yielding)
local tagGui = nil
task.spawn(function()
    pcall(function() tagGui = CoreGui:FindFirstChild("ABD_Tags_GUI") end)
    if not tagGui then
        tagGui = Instance.new("ScreenGui")
        tagGui.Name = "ABD_Tags_GUI"
        tagGui.ResetOnSpawn = false 
        tagGui.IgnoreGuiInset = true
        
        local success = pcall(function() tagGui.Parent = (gethui and gethui()) or CoreGui end)
        if not success or not tagGui.Parent then
            -- استخدام FindFirstChild بدلاً من WaitForChild لمنع توقف السكربت
            local pGui = LP:FindFirstChild("PlayerGui")
            if pGui then tagGui.Parent = pGui end
        end
    end
end)

-- جلب حالة رتبة صميللل للاعبك
local function CheckLocalSamilll()
    local saveFileName = "ABD_Hub_Missions_" .. LP.UserId .. ".json"
    
    local success, fileData = pcall(function()
        if isfile and isfile(saveFileName) then
            return HttpService:JSONDecode(readfile(saveFileName))
        end
    end)

    if success and fileData and type(fileData) == "table" then
        if fileData.OwnsSamilllRank == true then return true end
    end

    if type(GetS) == "function" then
        return GetS("OwnsSamilllRank", false)
    end
    
    return false
end

-- 2️⃣ دالة التحقق
local function isScriptUser(player)
    if Developers[player.Name] then return true end
    if RankAdmins[player.Name] then return true end
    if RankMods[player.Name] then return true end
    if RankVIPs[player.Name] then return true end
    if player == LP then return true end 
    if ActiveUsers[player.UserId] then return true end
    return false
end

-- 3️⃣ دالة حذف التاج القديم
local function removeTag(player)
    if tagGui then
        local oldTag = tagGui:FindFirstChild(player.Name .. "_Tag")
        if oldTag then oldTag:Destroy() end
    end
end

-- 4️⃣ دالة تصميم وإنشاء التاج الفخم
local function createTag(player)
    if not isScriptUser(player) then return end

    local character = player.Character
    if not character then return end

    local head = character:WaitForChild("Head", 5)
    if not head or not tagGui then return end

    removeTag(player)

    local hasSamilll = false
    if player == LP and CheckLocalSamilll() then
        hasSamilll = true
    elseif ActiveUsers[player.UserId] == "Samilll" then
        hasSamilll = true
    end

    local roleText = "عضو"
    if Developers[player.Name] then
        roleText = hasSamilll and "🔥 مطور صميللل 🔥" or "مطور"
    elseif RankAdmins[player.Name] then
        roleText = hasSamilll and "🔥 اداري صميللل 🔥" or "اداري"
    elseif RankMods[player.Name] then
        roleText = hasSamilll and "🔥 ادمن صميللل 🔥" or "ادمن"
    elseif RankVIPs[player.Name] then
        roleText = hasSamilll and "🔥 VIP صميللل 🔥" or "VIP"
    else
        roleText = hasSamilll and "🔥 صميللل 🔥" or "عضو"
    end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = player.Name .. "_Tag"
    billboardGui.Adornee = head
    billboardGui.Size = UDim2.new(3.5, 0, 1.2, 0)
    billboardGui.StudsOffset = Vector3.new(0, 3.2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Active = false
    billboardGui.ClipsDescendants = false
    billboardGui.Enabled = tagsVisible 
    billboardGui.Parent = tagGui

    local frame = Instance.new("Frame", billboardGui)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.2 
    frame.BorderSizePixel = 0
    frame.Active = false
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 6) 

    local gradient = Instance.new("UIGradient", frame)
    gradient.Rotation = 90

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2 

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.Text = roleText
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Active = false 
    
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(30, 0, 10)

    if roleText:match("مطور") then
        gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 0, 25)), ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 50))}
        stroke.Color = Color3.fromRGB(255, 50, 80)
        
    elseif roleText:match("VIP") then
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }
        task.spawn(function()
            local rot = 0
            while frame.Parent do
                rot = (rot + 3) % 360
                gradient.Rotation = rot
                stroke.Color = Color3.fromHSV((tick() % 3) / 3, 1, 1)
                task.wait(0.03)
            end
        end)
        
    elseif roleText == "🔥 صميللل 🔥" then
        gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 40, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 0))}
        stroke.Color = Color3.fromRGB(255, 140, 0)
        
    else
        gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 15)), ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 10, 30))}
        stroke.Color = Color3.fromRGB(160, 15, 35)
    end
end
-- ==========================================
-- 🌐 نظام الإرسال والاستقبال المباشر (WebSocket)
-- ==========================================
local function BroadcastMyRank()
    if not WSSocket then return end
    local myRank = CheckLocalSamilll() and "Samilll" or "Member"
    
    local dataToSync = {
        Type = "SyncRank",
        UserId = LP.UserId,
        Rank = myRank
    }
    pcall(function() WSSocket:Send(HttpService:JSONEncode(dataToSync)) end)
end

local function ConnectToWebSocket()
    pcall(function()
        if WebSocket and WebSocket.connect then
            WSSocket = WebSocket.connect(WEBSOCKET_URL)
            
            WSSocket.OnMessage:Connect(function(msg)
                pcall(function()
                    local data = HttpService:JSONDecode(msg)
                    if data and data.Type == "SyncRank" and data.UserId and data.Rank then
                        local senderId = tonumber(data.UserId)
                        if senderId and senderId ~= LP.UserId then
                            ActiveUsers[senderId] = data.Rank
                            local player = game:GetService("Players"):GetPlayerByUserId(senderId)
                            if player and player.Character then
                                createTag(player)
                            end
                        end
                    end
                end)
            end)

            WSSocket.OnClose:Connect(function()
                WSSocket = nil
                task.wait(5)
                ConnectToWebSocket()
            end)

            BroadcastMyRank()
        end
    end)
end

-- تشغيل الـ WebSocket
task.spawn(function()
    ConnectToWebSocket()
end)

-- 5️⃣ 🛠️ الفحص الإجباري والمستمر (كل ثانيتين) للسيرفر وللاعبين
task.spawn(function()
    while task.wait(2) do 
        -- 🌐 1. فحص السيرفر: نرسل الرتبة كل ثانيتين عشان اللي يدخل جديد توصله فوراً وما تتأخر
        pcall(function()
            BroadcastMyRank()
        end)

        -- 🛡️ 2. فحص اللاعبين: نراقب التيجان محلياً ونركبها للي ناقصه
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if isScriptUser(p) or p == LP then
                if p.Character and p.Character:FindFirstChild("Head") then
                    local currentHead = p.Character.Head
                    local existingTag = tagGui and tagGui:FindFirstChild(p.Name .. "_Tag")
                    
                    if not existingTag or existingTag.Adornee ~= currentHead or existingTag.Parent ~= tagGui then
                        createTag(p)
                    end
                end
            elseif p ~= LP and not ActiveUsers[p.UserId] then
                local bag = p:FindFirstChild("PlayersBag")
                if bag then
                    local bio = bag:FindFirstChild("RPBio")
                    if bio then
                        if bio.Value == SECRET_BIO_MEMBER then
                            ActiveUsers[p.UserId] = "Member"
                            if p.Character then createTag(p) end
                        elseif bio.Value == SECRET_BIO_SAMILLL then
                            ActiveUsers[p.UserId] = "Samilll"
                            if p.Character then createTag(p) end
                        end
                    end
                end
            end
        end
    end
end)

-- 🌟 كود التحديث الفوري لإخفاء التاج
task.spawn(function()
    while task.wait(1) do
        if tagGui then
            local myTag = tagGui:FindFirstChild(LP.Name .. "_Tag")
            if myTag then
                if _G.HideMyTagLocally then
                    myTag.Enabled = false
                else
                    myTag.Enabled = tagsVisible
                end
            end
        end
    end
end)

-- 🛠️ إرسال البايو السري لبروكهافن
task.spawn(function()
    local re = ReplicatedStorage:WaitForChild("RE", 10)
    if re then
        local remoteText = re:WaitForChild("1RPNam1eTex1t", 10)
        if remoteText then
            for i = 1, 3 do
                local bioToSend = CheckLocalSamilll() and SECRET_BIO_SAMILLL or SECRET_BIO_MEMBER
                remoteText:FireServer("RolePlayBio", bioToSend)
                task.wait(1.5)
            end
        end
    end
end)

_G.UpdateMyRankToSamilll = function()
    createTag(LP) 
    BroadcastMyRank() 
    
    local re = ReplicatedStorage:FindFirstChild("RE")
    if re then
        local remoteText = re:FindFirstChild("1RPNam1eTex1t")
        if remoteText then
            remoteText:FireServer("RolePlayBio", SECRET_BIO_SAMILLL)
        end
    end
end

-- 6️⃣ تشغيل النظام الأساسي وضمان بقاء التاج بعد الترسبن
local function setupPlayer(player)
    if player.Character then task.spawn(createTag, player) end
    
    table.insert(tagConnections, player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Head", 10) 
        createTag(player)
    end))
end

for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
    setupPlayer(p)
end
table.insert(tagConnections, game:GetService("Players").PlayerAdded:Connect(setupPlayer))
table.insert(tagConnections, game:GetService("Players").PlayerRemoving:Connect(function(p)
    ActiveUsers[p.UserId] = nil
    removeTag(p)
end))

local VIPSupporters = RankVIPs



local Admins = {
    ["yousif1479"] = true,
} 
local LastAdminCommand = "" 

local currentLang = GetS("ScriptLanguage", "AR")
local ActiveTabBtn = nil
local ActiveTabFunc = nil

local T = {
    ["🆕 ما الجديد"] = {EN="🆕 What's New", RU="🆕 Что нового"},
    ["🏠 قائمة رئيسية"] = {EN="🏠 Main Menu", RU="🏠 Главное меню"},
    ["🛡️ الحقوق"] = {EN="🛡️ Credits", RU="🛡️ Авторы"},
    ["👤 اللاعبين"] = {EN="👤 Players", RU="👤 Игроки"},
    ["🎡 المميزات"] = {EN="🎡 Features", RU="🎡 Функции"},
    ["⚙️ أخرى"] = {EN="⚙️ Others", RU="⚙️ Другое"},
    ["🌐 سيرفر"] = {EN="🌐 Server", RU="🌐 Сервер"},
    ["📜 سكربتات"] = {EN="📜 Scripts", RU="📜 Скрипты"},
    ["👕 سكنات"] = {EN="👕 Skins", RU="👕 Скины"},
    ["🎵 الأغاني"] = {EN="🎵 Music", RU="🎵 Музыка"},
    ["الأيدي"] = {EN="ID", RU="ID"},
    ["عمر الحساب"] = {EN="Account Age", RU="Возраст акк."},
    ["يوم"] = {EN="Days", RU="Дней"},
    ["الاشتراك"] = {EN="Subscription", RU="Подписка"},
    ["فعال"] = {EN="Active", RU="Активен"},
    ["غير فعال"] = {EN="Inactive", RU="Неактивен"},
    ["الصحة"] = {EN="Health", RU="Здоровье"},
    ["السرعة"] = {EN="Speed", RU="Скорость"},
    ["التشغيل"] = {EN="Uptime", RU="Время работы"},
    ["👑 رؤية رسائل الدعم (السجل الكامل) 👑"] = {EN="👑 View Support Logs 👑", RU="👑 Журнал поддержки 👑"},
    ["🗑️ مسح سجل رسائل الدعم"] = {EN="🗑️ Clear Support Logs", RU="🗑️ Очистить журнал"},
    ["👑 عبود المطور 👑"] = {EN="👑 Aboud Developer 👑", RU="👑 Разработчик Aboud 👑"},
    ["الوقت الحالي: "] = {EN="Current Time: ", RU="Текущее время: "},
    ["تاريخ الحساب: "] = {EN="Account Date: ", RU="Дата создания: "},
    ["✅ متصل الآن"] = {EN="✅ Online Now", RU="✅ В сети"},
    ["⚠️ اللاعب غادر السيرفر"] = {EN="⚠️ Player Left", RU="⚠️ Игрок вышел"},
    ["🔎 ابحث.."] = {EN="🔎 Search..", RU="🔎 Поиск.."},
    ["صملة: تشغيل"] = {EN="Anti-AFK: ON", RU="Анти-АФК: ВКЛ"},
    ["صملة: إيقاف"] = {EN="Anti-AFK: OFF", RU="Анти-AFK: ВЫКЛ"},
    ["👀 مراقبة:"] = {EN="👀 Spectate:", RU="👀 Наблюдать:"},
    ["🚀 تنقل (Stay):"] = {EN="🚀 TP (Stay):", RU="🚀 ТП (Следовать):"},
    ["🔥 بانج فنج أمامي:"] = {EN="🔥 Bang Front:", RU="🔥 Анимация спереди:"},
    ["🍑 بانج فنج خلفي:"] = {EN="🍑 Bang Back:", RU="🍑 Анимация сзади:"},
    ["👙 شلح اللاعب (حذف الملابس):"] = {EN="👙 Strip Player:", RU="👙 Раздеть игрока:"},
    ["🎨 تغيير لون السكربت: "] = {EN="🎨 Theme Color: ", RU="🎨 Цвет темы: "},
    ["🖼️ ستايل السكربت الشامل: "] = {EN="🖼️ UI Preset: ", RU="🖼️ Стиль UI: "},
    ["🪑 مضاد الجلوس (قوي):"] = {EN="🪑 Anti Sit (Strong):", RU="🪑 Анти Сидение:"},
    ["🌈 تفعيل تلوين اسم RP:"] = {EN="🌈 Enable RP Name Color:", RU="🌈 Включить цвет RP:"},
    ["⚡ تفعيل السرعة:"] = {EN="⚡ Enable Speed:", RU="⚡ Включить скорость:"},
    ["سرعة"] = {EN="Speed", RU="Скорость"},
    ["🦅 طيران (Fly):"] = {EN="🦅 Fly:", RU="🦅 Полет (Fly):"},
    ["طيران"] = {EN="Fly", RU="Полет"},
    ["🌀 دوران:"] = {EN="🌀 Spin:", RU="🌀 Вращение:"},
    ["🧱 نكليب:"] = {EN="🧱 Noclip:", RU="🧱 Прохождение сквозь стены:"},
    ["🔴 ESP:"] = {EN="🔴 ESP:", RU="🔴 ESP (ВХ):"},
    ["📉 وضع تقليل اللاق (Low Detail):"] = {EN="📉 Low Detail Mode:", RU="📉 Режим низкой детализации:"},
    ["🌄 جودة مريحة للعين:"] = {EN="🌄 Eye Comfort Mode:", RU="🌄 Защита глаз:"},
    ["📍 البدايه"] = {EN="📍 Spawn", RU="📍 Спавн"},
    ["📍 مقر سري 1"] = {EN="📍 Secret Base 1", RU="📍 Секретная база 1"},
    ["📍 مقر سري ثاني"] = {EN="📍 Secret Base 2", RU="📍 Секретная база 2"},
    ["📍 مركز شرطه"] = {EN="📍 Police Station", RU="📍 Полицейский участок"},
    ["⚠️ الانتقالات الخاصة ببروكهافن معطلة في هذا الماب."] = {EN="⚠️ Brookhaven TPs disabled here.", RU="⚠️ ТП Брукхейвена отключены."},
    ["✅ حفظ تشيك بوينت"] = {EN="✅ Save Checkpoint", RU="✅ Сохранить точку"},
    ["🚀 تنقل للتشيك بوينت"] = {EN="🚀 TP to Checkpoint", RU="🚀 ТП к точке"},
    ["🗑️ إزالة التشيك بوينت"] = {EN="🗑️ Remove Checkpoint", RU="🗑️ Удалить точку"},
    ["🔄 إعادة دخول السيرفر"] = {EN="🔄 Rejoin Server", RU="🔄 Перезайти на сервер"},
    ["🚀 دخول سيرفر آخر"] = {EN="🚀 Server Hop", RU="🚀 Другой сервер"},
    ["🌌 دخول سيرفر فاضي"] = {EN="🌌 Empty Server Hop", RU="🌌 Пустой сервер"},
    ["🕺 سكربت الرقصات"] = {EN="🕺 Emotes Script", RU="🕺 Скрипт эмоций"},
    ["🎵 سكربت الأغاني"] = {EN="🎵 Music Script", RU="🎵 Скрипт музыки"},
    ["💬 سكربت عبود شات"] = {EN="💬 Aboud Chat Script", RU="💬 Скрипт чата Aboud"},
    ["🏎️ سكربت تفحيط سيارات"] = {EN="🏎️ Car Drift Script", RU="🏎️ Скрипт дрифта"},
    ["اكتب اسم اللاعب للنسخ.."] = {EN="Target Name to copy..", RU="Имя цели.."},
    ["نسخ سكن اللاعب المحدد"] = {EN="Copy Target Skin", RU="Скопировать скин цели"},
    ["نسخ سكن أقرب لاعب"] = {EN="Copy Closest Skin", RU="Скопировать ближ. скин"},
    ["نسخ سكن عشوائي"] = {EN="Copy Random Skin", RU="Скопировать случайный скин"},
    ["اللاعب غير موجود!"] = {EN="Player not found!", RU="Игрок не найден!"},
    ["يرجى البحث عن لاعب"] = {EN="Please search for a player", RU="Пожалуйста, найдите игрока"},
    ["هذه الميزة تعمل في ماب بروكهافن فقط!"] = {EN="This works in Brookhaven only!", RU="Только для Brookhaven!"},
    ["جاري نسخ سكن: "] = {EN="Copying skin: ", RU="Копирование скина: "},
    ["ابحث عن لاعب أولاً!"] = {EN="Search for a player first!", RU="Сначала найдите игрока!"},
    ["لا يوجد لاعب قريب!"] = {EN="No close players!", RU="Нет игроков поблизости!"},
    ["لا يوجد لاعبين!"] = {EN="No players found!", RU="Игроки не найдены!"},
    ["تم نسخ السكن بنجاح!"] = {EN="Skin copied successfully!", RU="Скин успешно скопирован!"},
    ["اكتب مشكلتك أو اقتراحك للمطور هنا:"] = {EN="Write your issue/suggestion here:", RU="Напишите проблему/предложение здесь:"},
    ["اكتب مشكلتك هنا..."] = {EN="Type your issue here...", RU="Введите проблему здесь..."},
    ["ارسال"] = {EN="Send", RU="Отправить"},
    ["الغاء"] = {EN="Cancel", RU="Отмена"},
    ["إغلاق"] = {EN="Close", RU="Закрыть"},
    ["أدخل كود الأغنية هنا..."] = {EN="Enter Song ID here...", RU="Введите ID песни здесь..."},
    ["▶️ تشغيل الأغنية"] = {EN="▶️ Play Song", RU="▶️ Включить песню"},
    ["جديد"] = {EN="NEW", RU="НОВОЕ"},
    ["ON"] = {EN="ON", RU="ВКЛ"},
    ["OFF"] = {EN="OFF", RU="ВЫКЛ"},
    ["🔒 إيقاف"] = {EN="🔒 OFF", RU="🔒 ВЫКЛ"},
    ["تم حفظ مكانك بنجاح!"] = {EN="Checkpoint saved successfully!", RU="Точка сохранения успешно сохранена!"},
    ["تم مسح مكان الحفظ!"] = {EN="Checkpoint cleared!", RU="Точка сохранения удалена!"},
    ["🚀 جاري البحث"] = {EN="🚀 Searching", RU="🚀 Поиск"},
    ["جاري البحث عن سيرفر مليان باللاعبين (احتمالية تواجد عرب أكبر)..."] = {EN="Searching for an active server...", RU="Поиск активного сервера..."},
    ["اللاعب المستهدف دخل السيرفر: "] = {EN="Target player joined: ", RU="Целевой игрок зашел: "},
    ["⚠️ تنبيه"] = {EN="⚠️ Warning", RU="⚠️ Внимание"},
    ["اللاعب المستهدف غادر السيرفر: "] = {EN="Target player left: ", RU="Целевой игрок вышел: "},
    ["✅ تم النسخ"] = {EN="✅ Copied", RU="✅ Скопировано"},
    ["✔️ تم الإرسال"] = {EN="✔️ Sent", RU="✔️ Отправлено"},
    ["تم إرسال رسالتك للمطور عبود، شكراً لك!"] = {EN="Message sent to Dev Aboud, thank you!", RU="Сообщение отправлено разработчику Aboud, спасибо!"},
    ["🚫 تنبيه"] = {EN="🚫 Alert", RU="🚫 Тревога"},
    ["يرجى الانتظار "] = {EN="Please wait ", RU="Пожалуйста, подождите "},
    [" ثانية."] = {EN=" seconds.", RU=" секунд."},
    ["🚫 وصول مرفوض"] = {EN="🚫 Access Denied", RU="🚫 Доступ запрещен"},
    ["أنت مبند!"] = {EN="You are banned!", RU="Вы забанены!"},
    ["✅ فك الحظر"] = {EN="✅ Unbanned", RU="✅ Разбанен"},
    ["تم فك الباند عنك من قبل المطور! يمكنك استخدام السكربت الآن."] = {EN="You have been unbanned by the Dev! You can use the script now.", RU="Разработчик снял с вас бан! Теперь вы можете использовать скрипт."},
    ["تم تحميل سكربت عبود"] = {EN="Aboud Script Loaded", RU="Скрипт Aboud загружен"},
    ["🚫 تنبيه من المطور 🚫\nتم تبنيدك من استخدام السكربت\nجميع الصلاحيات والمميزات تم إغلاقها."] = {EN="🚫 Dev Alert 🚫\nYou have been banned from the script.\nAll features disabled.", RU="🚫 Внимание от разраба 🚫\nВы забанены.\nВсе функции отключены."},
    ["السكربت شغال مسبقاً!"] = {EN="Script is already running!", RU="Скрипт уже запущен!"},
    ["⚠️ جاري النقل"] = {EN="⚠️ Teleporting", RU="⚠️ Телепортация"},
    ["جاري إعادة الدخول لنفس السيرفر..."] = {EN="Rejoining the same server...", RU="Переподключение к серверу..."},
    ["جاري البحث عن سيرفر فاضي..."] = {EN="Searching for an empty server...", RU="Поиск пустого сервера..."},
    ["✅ سكربت مدعوم"] = {EN="✅ Supported Script", RU="✅ Поддерживаемый скрипт"},
    ["هذا السكربت مدعوم بالكامل في بروكهافن!"] = {EN="This script is fully supported in Brookhaven!", RU="Этот скрипт полностью поддерживается в Brookhaven!"},
    ["⚠️ سكربت غير مدعوم"] = {EN="⚠️ Unsupported Script", RU="⚠️ Неподдерживаемый скрипт"},
    ["هذا السكربت غير مدعوم في هذا الماب، قد تواجه بعض المشاكل."] = {EN="Unsupported map, you may face some issues.", RU="Неподдерживаемая карта, возможны проблемы."},
    ["⛏️ تواصل مع الدعم"] = {EN="⛏️ Contact Support", RU="⛏️ Поддержка"},
    ["يمكنكم التواصل مع الدعم بشكل سريع وتقديم اقتراحات ومشاكل عند القائمة الرئيسية."] = {EN="Contact support quickly and submit suggestions/issues in the Main Menu.", RU="Быстро свяжитесь с поддержкой в главном меню."},
    ["🛋️ قتل بالكنبة (Fling):"] = {EN="🛋️ Couch Fling (Kill):", RU="🛋️ Убить диваном (Fling):"},
    ["🔥 فلنق"] = {EN="🔥 Fling", RU="🔥 Fling"},
    ["بدأ الفلنق على: "] = {EN="Started Fling on: ", RU="Запущен Fling на: "},
    ["تم ايقاف الفلنق!"] = {EN="Fling stopped!", RU="Fling остановлен!"},
    ["🎉 هدايا الديسكورد 🎉"] = {EN="🎉 Discord Gifts 🎉", RU="🎉 Подарки Discord 🎉"},
    ["انضم لسيرفر الديسكورد الآن! توزيع رتب واشتراكات VIP مجانية بانتظارك."] = {EN="Join our Discord now! Free VIP subscriptions and ranks waiting for you.", RU="Присоединяйтесь к Discord! Вас ждут бесплатные VIP подписки и ранги."},
    ["تم نسخ رابط الديسكورد! اذهب للمتصفح والصقه."] = {EN="Discord link copied! Paste it in your browser.", RU="Ссылка скопирована! Вставьте в браузер."},
    ["⚡ سرعة بانج أمامي:"] = {EN="⚡ Bang Front Speed:", RU="⚡ Скорость анимации спереди:"},
    ["⚡ سرعة بانج خلفي:"] = {EN="⚡ Bang Back Speed:", RU="⚡ Скорость анимации сзади:"},
    ["🎮 العب X O (ضد بوت)"] = {EN="🎮 Play Tic-Tac-Toe (Vs Bot)", RU="🎮 Играть в Крестики-нолики"},
    ["🐍 العب الأفعى"] = {EN="🐍 Play Snake", RU="🐍 Играть в Змейку"}
}

local function GetTr(key)
    if currentLang == "AR" then return key end
    if T[key] and T[key][currentLang] then return T[key][currentLang] end
    return key
end

local TranslatableUI = {}
local function AddTr(obj, key, prop)
    prop = prop or "Text"
    table.insert(TranslatableUI, {Obj = obj, Key = key, Prop = prop})
    pcall(function() obj[prop] = GetTr(key) end)
end

local savedColor = GetS("ThemeColor", nil)
local ThemeColor = savedColor and Color3.new(savedColor[1], savedColor[2], savedColor[3]) or Color3.fromRGB(128, 0, 32)
local ThemedStrokes, ThemedTexts, ThemedBGs, ThemedMenus, ThemedGradients, GlowEffects, OrbEffects, WelcomeElements = {}, {}, {}, {}, {}, {}, {}, {}

local function SetTheme(col)
    ThemeColor = col
    SData["ThemeColor"] = {col.R, col.G, col.B}; SaveAll()
    for _, s in pairs(ThemedStrokes) do pcall(function() s.Color = col end) end
    for _, t in pairs(ThemedTexts) do pcall(function() t.TextColor3 = col end) end
    for _, b in pairs(ThemedBGs) do pcall(function() b.BackgroundColor3 = col end) end
    for _, g in pairs(GlowEffects) do pcall(function() g.ImageColor3 = col end) end
    for _, orb in pairs(OrbEffects) do pcall(function() orb.ImageColor3 = col end) end
    for _, we in pairs(WelcomeElements) do pcall(function() we.TextColor3 = col end) end
    for _, m in pairs(ThemedMenus) do pcall(function() m.BackgroundColor3 = Color3.new(col.R * 0.12, col.G * 0.12, col.B * 0.12) end) end
    for _, grad in pairs(ThemedGradients) do pcall(function() grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(0.5, col), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))}) end) end
    if ActiveTabBtn then ActiveTabBtn.BackgroundColor3 = Color3.new(col.R*0.6, col.G*0.6, col.B*0.6) end
end

local function AddNewBadge(parentObj, offset)
    local badge = Instance.new("TextLabel", parentObj)
    badge.Size = UDim2.new(0, 30, 0, 14)
    badge.Position = offset or UDim2.new(1, -25, 0, -5)
    badge.BackgroundTransparency = 1
    AddTr(badge, "جديد", "Text")
    badge.TextColor3 = Color3.fromRGB(255, 50, 50)
    badge.Font = Enum.Font.GothamBlack
    badge.TextSize = 10
    badge.ZIndex = 15
end

local isBanned = false
local banFileName = "AboudBanSave_" .. LP.UserId .. ".txt"
pcall(function() if isfile and isfile(banFileName) then if readfile(banFileName) == "BANNED" then isBanned = true end end end)

local sg = Instance.new("ScreenGui")
sg.Parent = LP:WaitForChild("PlayerGui")
sg.Name = "YousifHubV1"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true

local RankBadge = Instance.new("Frame", sg)
RankBadge.Size = UDim2.new(0, 100, 0, 30)
RankBadge.Position = UDim2.new(0.5, -50, 0, 20)
RankBadge.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
RankBadge.ZIndex = 9999
RankBadge.Visible = false
Instance.new("UICorner", RankBadge).CornerRadius = UDim.new(0, 8)
local RankStroke = Instance.new("UIStroke", RankBadge)
RankStroke.Color = Color3.new(1,1,1)
RankStroke.Thickness = 2
local RankTxt = Instance.new("TextLabel", RankBadge)
RankTxt.Size = UDim2.new(1, 0, 1, 0)
RankTxt.BackgroundTransparency = 1
RankTxt.Font = SafeFont
RankTxt.TextSize = 16
RankTxt.ZIndex = 10000



local function PlaySound(id, vol) pcall(function() local s = Instance.new("Sound", sg); s.SoundId = id; s.Volume = vol or 1; s:Play(); game:GetService("Debris"):AddItem(s, 4) end) end
local function PlayClickSound() PlaySound("rbxassetid://6895079853", 0.7) end

local fpsLabel = Instance.new("TextLabel", sg)
fpsLabel.Size = UDim2.new(0, 90, 0, 25)
fpsLabel.Position = UDim2.new(1, -100, 0, 10)
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fpsLabel.TextColor3 = ThemeColor
fpsLabel.Font = SafeFont
fpsLabel.TextSize = 15
fpsLabel.Text = "FPS: ..."
fpsLabel.ZIndex = 99999
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 6)
table.insert(ThemedTexts, fpsLabel)

task.spawn(function() 
    local sec = tick(); local frames = 0; 
    RS.RenderStepped:Connect(function() 
        frames = frames + 1; 
        if tick() - sec >= 1 then 
            pcall(function() fpsLabel.Text = "FPS: " .. frames end); 
            frames = 0; sec = tick() 
        end 
    end) 
end)
local NotifContainer = Instance.new("Frame", sg)
NotifContainer.Name = "AboudNotifs"
NotifContainer.Size = UDim2.new(0, 260, 0.8, 0); NotifContainer.Position = UDim2.new(1, -270, 0.1, 0); NotifContainer.BackgroundTransparency = 1; NotifContainer.ZIndex = 999999
local NotifList = Instance.new("UIListLayout", NotifContainer); NotifList.SortOrder = Enum.SortOrder.LayoutOrder; NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom; NotifList.Padding = UDim.new(0, 12)

local function SendCustomNotification(title, text, duration, icon)
    pcall(function()
        local f = Instance.new("Frame"); f.Size = UDim2.new(1, 30, 0, 75); f.BackgroundTransparency = 0.15; f.BackgroundColor3 = Color3.fromRGB(20, 20, 20); f.BorderSizePixel = 0; f.ClipsDescendants = false; Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local notifGlow = Instance.new("ImageLabel", f); notifGlow.BackgroundTransparency = 1; notifGlow.Position = UDim2.new(0, -15, 0, -15); notifGlow.Size = UDim2.new(1, 30, 1, 30); notifGlow.ZIndex = -1; notifGlow.Image = "rbxassetid://5028857478"; notifGlow.ImageColor3 = ThemeColor; notifGlow.ScaleType = Enum.ScaleType.Slice; notifGlow.SliceCenter = Rect.new(24, 24, 276, 276); table.insert(GlowEffects, notifGlow)
        local stroke = Instance.new("UIStroke", f); stroke.Color = ThemeColor; stroke.Thickness = 2; table.insert(ThemedStrokes, stroke)
        
        local textOffset = 10
        if icon then
            local img = Instance.new("ImageLabel", f)
            img.Size = UDim2.new(0, 35, 0, 35)
            img.Position = UDim2.new(0, 10, 0.5, -17.5)
            img.BackgroundTransparency = 1
            img.Image = icon
            img.ScaleType = Enum.ScaleType.Fit
            textOffset = 55
        end

        local tTitle = Instance.new("TextLabel", f); tTitle.Size = UDim2.new(1, -textOffset, 0, 22); tTitle.Position = UDim2.new(0, textOffset, 0, 5); tTitle.BackgroundTransparency = 1; tTitle.Text = title; tTitle.TextColor3 = ThemeColor; tTitle.Font = SafeFont; tTitle.TextSize = 19; tTitle.TextXAlignment = Enum.TextXAlignment.Left; table.insert(ThemedTexts, tTitle)
        local tText = Instance.new("TextLabel", f); tText.Size = UDim2.new(1, -textOffset - 10, 0, 42); tText.Position = UDim2.new(0, textOffset, 0, 27); tText.BackgroundTransparency = 1; tText.Text = text; tText.TextColor3 = Color3.new(0.95, 0.95, 0.95); tText.Font = SafeFont; tText.TextSize = 13; tText.TextWrapped = true; tText.TextXAlignment = Enum.TextXAlignment.Left
        
        f.Parent = NotifContainer
        TS:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 75)}):Play()
        PlaySound("rbxassetid://452267918", 1)
        task.spawn(function() task.wait(duration or 3); local slideOut = TS:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 75)}); slideOut:Play(); slideOut.Completed:Wait(); f:Destroy() end)
    end)
end

-- (Discord promo removed)
local function ShowBannedScreen()
    isBanned = true
    pcall(function() if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16; LP.Character.Humanoid.PlatformStand = false end end)
    local banGui = Instance.new("ScreenGui"); banGui.Parent = LP:WaitForChild("PlayerGui"); banGui.ResetOnSpawn = false
    local bg = Instance.new("Frame", banGui); bg.Size = UDim2.new(0, 0, 0, 0); bg.Position = UDim2.new(0.5, 0, 0.5, 0); bg.AnchorPoint = Vector2.new(0.5, 0.5); bg.BackgroundColor3 = Color3.fromRGB(180, 0, 0); bg.ClipsDescendants = true; bg.ZIndex = 99999; Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 15)
    local stroke = Instance.new("UIStroke", bg); stroke.Color = Color3.fromRGB(255, 255, 255); stroke.Thickness = 5
    local txt = Instance.new("TextLabel", bg); txt.Size = UDim2.new(1, -40, 1, -40); txt.Position = UDim2.new(0, 20, 0, 20); txt.BackgroundTransparency = 1; txt.Text = GetTr("🚫 تنبيه من المطور 🚫\nتم تبنيدك من استخدام السكربت\nجميع الصلاحيات والمميزات تم إغلاقها."); txt.TextColor3 = Color3.fromRGB(255, 255, 255); txt.Font = SafeFont; txt.TextSize = 40; txt.ZIndex = 99999; txt.TextWrapped = true
    TS:Create(bg, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -40, 1, -40)}):Play()
    pcall(function() local s = Instance.new("Sound", sg); s.SoundId = "rbxassetid://147758746"; s.Volume = 3; s:Play(); game:GetService("Debris"):AddItem(s, 6) end)
    task.delay(5, function() TS:Create(bg, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play(); task.wait(0.5); banGui:Destroy() end)
end
if isBanned then task.spawn(ShowBannedScreen) end

local SupportMessages = {}
local supportLogFile = "AboudSupportLogs_" .. LP.UserId .. ".json"
local lastSupportSend = 0 
pcall(function() if isfile and readfile and isfile(supportLogFile) then local decoded = HttpService:JSONDecode(readfile(supportLogFile)); if type(decoded) == "table" then SupportMessages = decoded end end end)
local function SaveSupportMessages() pcall(function() if writefile then writefile(supportLogFile, HttpService:JSONEncode(SupportMessages)) end end) end

local SupportOverlay = Instance.new("Frame", sg)
SupportOverlay.Size = UDim2.new(0, 320, 0, 240); SupportOverlay.Position = UDim2.new(0.5, -160, 0.5, -120); SupportOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 20); SupportOverlay.Visible = false; SupportOverlay.ZIndex = 1000; SupportOverlay.Active = true; Instance.new("UICorner", SupportOverlay)
local supStroke = Instance.new("UIStroke", SupportOverlay); supStroke.Color = ThemeColor; supStroke.Thickness = 2; table.insert(ThemedStrokes, supStroke)

local supImg = Instance.new("ImageLabel", SupportOverlay); supImg.Size = UDim2.new(0, 60, 0, 60); supImg.Position = UDim2.new(0.5, -30, 0, 10); supImg.BackgroundTransparency = 1; supImg.Image = "rbxassetid://7733674079"; supImg.ImageColor3 = ThemeColor; supImg.ZIndex = 1001; table.insert(GlowEffects, supImg)
local supTxt = Instance.new("TextLabel", SupportOverlay); supTxt.Size = UDim2.new(1, -20, 0, 30); supTxt.Position = UDim2.new(0, 10, 0, 75); supTxt.BackgroundTransparency = 1; supTxt.TextColor3 = Color3.new(1,1,1); supTxt.Font = SafeFont; supTxt.TextSize = 15; supTxt.TextWrapped = true; supTxt.ZIndex = 1001
AddTr(supTxt, "اكتب مشكلتك أو اقتراحك للمطور هنا:", "Text")

local supInput = Instance.new("TextBox", SupportOverlay); supInput.Size = UDim2.new(1, -20, 0, 60); supInput.Position = UDim2.new(0, 10, 0, 115); supInput.BackgroundColor3 = Color3.fromRGB(10, 10, 10); supInput.TextColor3 = Color3.new(1,1,1); supInput.Font = SafeFont; supInput.TextSize = 14; supInput.Text = ""; supInput.TextWrapped = true; supInput.ClearTextOnFocus = false; supInput.Active = true; supInput.ZIndex = 1001; Instance.new("UICorner", supInput)
AddTr(supInput, "اكتب مشكلتك هنا...", "PlaceholderText")

local sendBtn = Instance.new("TextButton", SupportOverlay); sendBtn.Size = UDim2.new(0.45, 0, 0, 35); sendBtn.Position = UDim2.new(0, 10, 0, 190); sendBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); sendBtn.TextColor3 = Color3.new(1,1,1); sendBtn.Font = SafeFont; sendBtn.TextSize = 18; sendBtn.ZIndex = 1001; Instance.new("UICorner", sendBtn)
AddTr(sendBtn, "ارسال", "Text")

local cancelBtn = Instance.new("TextButton", SupportOverlay); cancelBtn.Size = UDim2.new(0.45, 0, 0, 35); cancelBtn.Position = UDim2.new(0.55, -10, 0, 190); cancelBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); cancelBtn.TextColor3 = Color3.new(1,1,1); cancelBtn.Font = SafeFont; cancelBtn.TextSize = 18; cancelBtn.ZIndex = 1001; Instance.new("UICorner", cancelBtn)
AddTr(cancelBtn, "الغاء", "Text")

cancelBtn.MouseButton1Click:Connect(function() PlayClickSound(); SupportOverlay.Visible = false end)
sendBtn.MouseButton1Click:Connect(function()
    PlayClickSound()
    local currentTime = tick()
    if currentTime - lastSupportSend < 60 and lastSupportSend ~= 0 then 
        local remaining = math.ceil(60 - (currentTime - lastSupportSend))
        SendCustomNotification(GetTr("🚫 تنبيه"), GetTr("يرجى الانتظار ") .. remaining .. GetTr(" ثانية."), 3)
        return
    end
    local txt = supInput.Text
    if txt ~= "" and txt:match("%S") then
        lastSupportSend = currentTime; SupportOverlay.Visible = false; supInput.Text = ""
        SendCustomNotification(GetTr("✔️ تم الإرسال"), GetTr("تم إرسال رسالتك للمطور عبود، شكراً لك!"), 5)
        task.spawn(function()
            pcall(function()
  
            end)
        end)
    end
end)

local ViewOverlay = Instance.new("Frame", sg); ViewOverlay.Size = UDim2.new(0, 350, 0, 250); ViewOverlay.Position = UDim2.new(0.5, -175, 0.5, -125); ViewOverlay.BackgroundColor3 = Color3.fromRGB(20, 20, 20); ViewOverlay.Visible = false; ViewOverlay.ZIndex = 1000; ViewOverlay.Active = true; Instance.new("UICorner", ViewOverlay)
local vStroke = Instance.new("UIStroke", ViewOverlay); vStroke.Color = ThemeColor; vStroke.Thickness = 2; table.insert(ThemedStrokes, vStroke)

local closeViewBtn = Instance.new("TextButton", ViewOverlay); closeViewBtn.Size = UDim2.new(1, 0, 0, 30); closeViewBtn.Position = UDim2.new(0, 0, 1, -30); closeViewBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); closeViewBtn.TextColor3 = Color3.new(1,1,1); closeViewBtn.Font = SafeFont; closeViewBtn.ZIndex = 1001; Instance.new("UICorner", closeViewBtn)
AddTr(closeViewBtn, "إغلاق", "Text")
local msgsList = Instance.new("ScrollingFrame", ViewOverlay); msgsList.Size = UDim2.new(1, -10, 1, -40); msgsList.Position = UDim2.new(0, 5, 0, 5); msgsList.BackgroundTransparency = 1; msgsList.AutomaticCanvasSize = Enum.AutomaticSize.Y; msgsList.ScrollBarThickness = 4; msgsList.ZIndex = 1001; Instance.new("UIListLayout", msgsList).Padding = UDim.new(0, 5)
closeViewBtn.MouseButton1Click:Connect(function() PlayClickSound(); ViewOverlay.Visible = false end)
local function RefreshMessages()
    for _, v in pairs(msgsList:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
    for _, m in pairs(SupportMessages) do
        local t = Instance.new("TextLabel", msgsList); t.Size = UDim2.new(1, -10, 0, 40); t.BackgroundTransparency = 0.5; t.BackgroundColor3 = Color3.fromRGB(10, 10, 10); t.TextColor3 = Color3.new(1,1,1); t.Font = SafeFont; t.TextSize = 13; t.TextWrapped = true; t.TextXAlignment = Enum.TextXAlignment.Left; t.Text = "👤 [" .. m.Player .. "]:\n💬 " .. m.Msg; t.ZIndex = 1001
    end
end

local VerifiedUsers = {}
VerifiedUsers[LP.Name] = true 
local function HookChat(p)
    p.Chatted:Connect(function(msg)
        local lowerMsg = string.lower(msg); local myName = string.lower(LP.Name)
        if lowerMsg == "/e giveban " .. myName or lowerMsg == "giveban " .. myName then pcall(function() if writefile then writefile(banFileName, "BANNED") end end); ShowBannedScreen()
        elseif lowerMsg == "/e unban " .. myName or lowerMsg == "unban " .. myName then isBanned = false; pcall(function() if writefile then writefile(banFileName, "UNBANNED") end end); SendCustomNotification(GetTr("✅ فك الحظر"), GetTr("تم فك الباند عنك من قبل المطور! يمكنك استخدام السكربت الآن."), 6) end
    end)
end
for _, p in pairs(game.Players:GetPlayers()) do HookChat(p) end; game.Players.PlayerAdded:Connect(HookChat)

local savedCheckpoint = nil 
local function SetupCharacter(char)
    if not char:FindFirstChild("AboudUserTag") then local tag = Instance.new("StringValue", char); tag.Name = "AboudUserTag" end
    if savedCheckpoint then task.spawn(function() local hrp = char:WaitForChild("HumanoidRootPart", 5); if hrp then task.wait(0.5); hrp.CFrame = savedCheckpoint end end) end
    if isAntiSit then pcall(function() local hum = char:WaitForChild("Humanoid", 5); if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false); hum.Sit = false end end) end
end
if LP.Character then SetupCharacter(LP.Character) end; LP.CharacterAdded:Connect(SetupCharacter)

local isNoclip = GetS("Noclip", false); local isWatch = GetS("Watch", false); local isSpeed = GetS("Speed", false); local isTPStay = GetS("TPStay", false)
local isAntiSit = GetS("AntiSit", false); local isESP = GetS("ESP", false); local isSpin = GetS("Spin", false); local isBangFront = GetS("BangFront", false)
local isBangBack = GetS("BangBack", false); local isStrip = GetS("Strip", false); local isAntiAFK = GetS("AntiAFK", false)
local isFly = GetS("Fly", false); local isStrollerFling = GetS("Stroller", false)
local isLowDetail = GetS("LowDetail", false); local isEyeComfort = GetS("EyeComfort", false)
local StrippedClothes = {}

local CCEffect = Instance.new("ColorCorrectionEffect")
CCEffect.Name = "AboudEyeComfort"; CCEffect.Brightness = 0.02; CCEffect.Contrast = 0.05; CCEffect.Saturation = 0.1; CCEffect.TintColor = Color3.fromRGB(255, 245, 235)
if isEyeComfort then CCEffect.Parent = game.Lighting end

local SpeedValue = GetS("SpeedValue", 100); local SpinSpeed = GetS("SpinSpeed", 50); local FlySpeed = GetS("FlySpeed", 200)
local afkTime = 0; local TargetPlayer, OrbitTarget, LastTargetName, LastOrbitName = nil, nil, nil, nil
local SkinTarget = nil
local AdminTarget = nil

local function GetCurrentTime() return os.date("%I:%M:%S %p") end

game.Players.PlayerAdded:Connect(function(player)
    if LastTargetName and player.Name == LastTargetName then 
        task.wait(3); TargetPlayer = player; PlaySound("rbxassetid://452267918", 3); 
        if TargetStatusLabel then TargetStatusLabel.Text = GetTr("✅ متصل الآن"); TargetStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 0) end 
        SendCustomNotification(GetTr("✅ متصل الآن"), GetTr("اللاعب المستهدف دخل السيرفر: ") .. player.Name, 4)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    if TargetPlayer == player then 
        PlaySound("rbxassetid://147758746", 2); 
        if TargetStatusLabel then TargetStatusLabel.Text = GetTr("⚠️ اللاعب غادر السيرفر"); TargetStatusLabel.TextColor3 = Color3.fromRGB(200, 0, 0) end 
        SendCustomNotification(GetTr("⚠️ تنبيه"), GetTr("اللاعب المستهدف غادر السيرفر: ") .. player.Name, 4)
    end
end)

LP.Idled:Connect(function() if isAntiAFK then VU:CaptureController(); VU:ClickButton2(Vector2.new()) end end)
task.spawn(function() while task.wait(1) do if isAntiAFK then afkTime += 1 else afkTime = 0 end end end)

local function UpdateESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = v.Character:FindFirstChild("AboudESP"); local nameTag = v.Character:FindFirstChild("AboudNameTag")
            if isESP then
                if not highlight then highlight = Instance.new("Highlight", v.Character); highlight.Name = "AboudESP"; highlight.FillColor = ThemeColor; highlight.FillTransparency = 0.5 end
                if not nameTag then nameTag = Instance.new("BillboardGui", v.Character); nameTag.Name = "AboudNameTag"; nameTag.Adornee = v.Character:FindFirstChild("Head"); nameTag.Size = UDim2.new(0, 100, 0, 50); nameTag.StudsOffset = Vector3.new(0, 3, 0); nameTag.AlwaysOnTop = true; local label = Instance.new("TextLabel", nameTag); label.BackgroundTransparency = 1; label.Size = UDim2.new(1, 0, 1, 0); label.Text = v.DisplayName; label.TextColor3 = Color3.new(1,1,1); label.Font = SafeFont; label.TextSize = 14 end
            else if highlight then highlight:Destroy() end if nameTag then nameTag:Destroy() end end
        end
    end
end

local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 440, 0, 340); Main.Position = UDim2.new(0.5, -220, 0.5, -170); Main.BackgroundColor3 = Color3.fromRGB(15, 0, 0); Main.Visible = false; Main.Active = true; Main.ClipsDescendants = true; Main.BackgroundTransparency = 0.15; Instance.new("UICorner", Main); table.insert(ThemedMenus, Main)

local mDragging, mDragInput, mDragStart, mStartPos
Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then mDragging = true; mDragStart = input.Position; mStartPos = Main.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then mDragging = false end end) end end)
Main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then mDragInput = input end end)
local ParticlesContainer = Instance.new("Frame", Main)
ParticlesContainer.Size = UDim2.new(1, 0, 1, 0)
ParticlesContainer.BackgroundTransparency = 1
ParticlesContainer.ZIndex = 2 
ParticlesContainer.ClipsDescendants = true

            task.spawn(function()
    while task.wait(1.5) do 
        if Main.Visible then 
            local particle = Instance.new("Frame", ParticlesContainer)
            local size = math.random(4, 9) 
            particle.Size = UDim2.new(0, size, 0, size)
            local startX = math.random() 
            particle.Position = UDim2.new(startX, 0, 1, 10) 
            particle.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
            particle.BackgroundTransparency = 0.4 
            particle.BorderSizePixel = 0
            particle.ZIndex = 2 
            Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0) 
            
            local endX = startX + (math.random(-15, 15) / 100) 
            local duration = math.random(5, 9) 
            
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local tween = TS:Create(particle, tweenInfo, {
                Position = UDim2.new(endX, 0, -0.1, 0), 
                BackgroundTransparency = 1 
            })
            tween:Play()
            
            task.delay(duration, function()
                if particle then particle:Destroy() end
            end)
        end
    end
end)
local GlowOrb1 = Instance.new("ImageLabel", Main); GlowOrb1.Size = UDim2.new(0, 250, 0, 250); GlowOrb1.Position = UDim2.new(0, -50, 0, -50); GlowOrb1.BackgroundTransparency = 1; GlowOrb1.Image = "rbxassetid://11552717538"; GlowOrb1.ImageColor3 = ThemeColor; GlowOrb1.ImageTransparency = 0.6; GlowOrb1.ZIndex = 0; table.insert(OrbEffects, GlowOrb1)
local GlowOrb2 = Instance.new("ImageLabel", Main); GlowOrb2.Size = UDim2.new(0, 200, 0, 200); GlowOrb2.Position = UDim2.new(1, -150, 1, -150); GlowOrb2.BackgroundTransparency = 1; GlowOrb2.Image = "rbxassetid://11552717538"; GlowOrb2.ImageColor3 = ThemeColor; GlowOrb2.ImageTransparency = 0.7; GlowOrb2.ZIndex = 0; table.insert(OrbEffects, GlowOrb2)

local MainBGImage = Instance.new("ImageLabel", Main); MainBGImage.Size = UDim2.new(2, 0, 2, 0); MainBGImage.BackgroundTransparency = 1; MainBGImage.ImageTransparency = 0.85; MainBGImage.Image = "rbxassetid://2151950106"; MainBGImage.ScaleType = Enum.ScaleType.Tile; MainBGImage.TileSize = UDim2.new(0, 150, 0, 150); MainBGImage.ZIndex = 1; Instance.new("UICorner", MainBGImage)

task.spawn(function()
    local t = 0
    RS.RenderStepped:Connect(function(dt)
        if Main.Visible and not isBanned then
            t = t + dt
            GlowOrb1.Position = UDim2.new(0, -50 + math.sin(t) * 40, 0, -50 + math.cos(t * 0.8) * 30)
            GlowOrb2.Position = UDim2.new(1, -150 + math.cos(t * 1.2) * 40, 1, -150 + math.sin(t * 0.9) * 30)
            MainBGImage.Position = UDim2.new(0, -50 + math.sin(t/5) * 50, 0, -50 + math.cos(t/5) * 50)
        end
    end)
end)

local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = ThemeColor; MainStroke.Thickness = 2; table.insert(ThemedStrokes, MainStroke)
local MainStrokeGrad = Instance.new("UIGradient", MainStroke); table.insert(ThemedGradients, MainStrokeGrad); MainStrokeGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0), NumberSequenceKeypoint.new(0.7, 0), NumberSequenceKeypoint.new(1, 1)})

local InnerClip = Instance.new("Frame", Main); InnerClip.Size = UDim2.new(1, 0, 1, 0); InnerClip.BackgroundTransparency = 1; InnerClip.ClipsDescendants = false; InnerClip.ZIndex = 2; Instance.new("UICorner", InnerClip)
local TitleLabel = Instance.new("TextLabel", InnerClip); TitleLabel.Size = UDim2.new(1, 0, 0, 40); TitleLabel.BackgroundTransparency = 1; TitleLabel.Text = "YOUSIF HUB"; TitleLabel.TextColor3 = ThemeColor; TitleLabel.Font = SafeFont; TitleLabel.TextSize = 22; TitleLabel.ZIndex = 3; table.insert(ThemedTexts, TitleLabel)
local Side = Instance.new("ScrollingFrame", InnerClip); Side.Size = UDim2.new(0, 120, 1, -40); Side.Position = UDim2.new(0, 0, 0, 40); Side.BackgroundColor3 = Color3.fromRGB(25, 0, 0); Side.BackgroundTransparency = 0.6; Side.ScrollBarThickness = 0; Side.ZIndex = 3; Side.AutomaticCanvasSize = Enum.AutomaticSize.Y; Side.CanvasSize = UDim2.new(0,0,0,0); Instance.new("UICorner", Side); table.insert(ThemedMenus, Side)
local SideLayout = Instance.new("UIListLayout", Side); SideLayout.Padding = UDim.new(0, 5); SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
local Content = Instance.new("ScrollingFrame", InnerClip); Content.Size = UDim2.new(1, -130, 1, -50); Content.Position = UDim2.new(0, 125, 0, 45); Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 2; Content.ZIndex = 3; Content.AutomaticCanvasSize = Enum.AutomaticSize.Y; Content.CanvasSize = UDim2.new(0, 0, 0, 0); Instance.new("UIListLayout", Content).Padding = UDim.new(0, 8)
local TabButtons = {}
local function LoadTabContent(b, func)
    ActiveTabBtn = b
    ActiveTabFunc = func
    
    -- إرجاع كل التابات لحالتها العادية بحركة ناعمة
    for _, btn in pairs(TabButtons) do 
        TS:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 35),
            BackgroundTransparency = 0.6
        }):Play()
        
        local indicator = btn:FindFirstChild("ActiveIndicator")
        if indicator then
            TS:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1, 
                Size = UDim2.new(0, 4, 0, 0) 
            }):Play()
        end
    end
    
    -- تفعيل التاب المختار بشكل ناعم
    TS:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = ThemeColor,
        BackgroundTransparency = 0.3
    }):Play()
    
    local activeIndicator = b:FindFirstChild("ActiveIndicator")
    if activeIndicator then
        TS:Create(activeIndicator, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 4, 0.6, 0) 
        }):Play()
    end

    for _,v in pairs(Content:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
    func()
end

function Tab(nameKey, order, func)
    local b = Instance.new("TextButton", Side)
    b.Size = UDim2.new(1, -12, 0, 38)
    b.LayoutOrder = order
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.BackgroundTransparency = 0.6
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = SafeFont
    b.TextSize = 13
    b.ZIndex = 4
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    -- 🪄 الخط الجانبي السحري (مخفي في البداية)
    local indicator = Instance.new("Frame", b)
    indicator.Name = "ActiveIndicator"
    indicator.Size = UDim2.new(0, 4, 0, 0)
    indicator.Position = UDim2.new(0, 2, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = Color3.new(1, 1, 1)
    indicator.BackgroundTransparency = 1
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 5
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    AddTr(b, nameKey, "Text")
    table.insert(TabButtons, b)
    
    b.MouseButton1Click:Connect(function() 
        PlayClickSound()
        LoadTabContent(b, func)
    end)
    return b, func
end
function AddOnOffBtn(parent, textKey, initial_state, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundTransparency = 1; f.ZIndex = 4
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(0.7, 0, 1, 0); t.Text = GetTr(textKey); t.TextColor3 = Color3.new(1, 1, 1); t.Font = SafeFont; t.TextSize = 13; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"; t.ZIndex = 4
    
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 24, 0, 24); b.Position = UDim2.new(1, -40, 0.5, -12); b.Text = ""; b.ZIndex = 4; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local bStroke = Instance.new("UIStroke", b); bStroke.Color = Color3.new(1,1,1); bStroke.Thickness = 1.5; bStroke.Transparency = 0.5
    local checkMark = Instance.new("TextLabel", b); checkMark.Size = UDim2.new(1, 0, 1, 0); checkMark.BackgroundTransparency = 1; checkMark.Text = "✓"; checkMark.TextColor3 = Color3.new(1,1,1); checkMark.Font = Enum.Font.GothamBold; checkMark.TextSize = 16; checkMark.ZIndex = 5

    local state = initial_state or false
    local function UpdateButtonVisuals()
        if isBanned then 
            b.BackgroundColor3 = Color3.fromRGB(120, 0, 0); checkMark.Text = "🔒"; checkMark.Visible = true;
            if state then state = false; pcall(callback, false) end
        else 
            checkMark.Text = "✓"
            checkMark.Visible = state
            b.BackgroundColor3 = state and ThemeColor or Color3.fromRGB(40, 40, 40)
        end
    end
    UpdateButtonVisuals()
    b.MouseButton1Click:Connect(function() PlayClickSound(); if isBanned then SendCustomNotification(GetTr("🚫 وصول مرفوض"), GetTr("أنت مبند!"), 4) else state = not state; UpdateButtonVisuals(); pcall(callback, state) end end)
    task.spawn(function() local wasBanned = isBanned; while task.wait(1) do if isBanned ~= wasBanned then wasBanned = isBanned; UpdateButtonVisuals() end end end)
    return f
end

function AddToggleWithTextBox(parent, textKey, initial_state, initial_val, placeholderKey, tbColor, callbackToggle, callbackText)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundTransparency = 1; f.ZIndex = 4
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(0.48, 0, 1, 0); t.Text = GetTr(textKey); t.TextColor3 = Color3.new(1, 1, 1); t.Font = SafeFont; t.TextSize = 13; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"; t.ZIndex = 4
    
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 24, 0, 24); b.Position = UDim2.new(1, -40, 0.5, -12); b.Text = ""; b.ZIndex = 4; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local bStroke = Instance.new("UIStroke", b); bStroke.Color = Color3.new(1,1,1); bStroke.Thickness = 1.5; bStroke.Transparency = 0.5
    local checkMark = Instance.new("TextLabel", b); checkMark.Size = UDim2.new(1, 0, 1, 0); checkMark.BackgroundTransparency = 1; checkMark.Text = "✓"; checkMark.TextColor3 = Color3.new(1,1,1); checkMark.Font = Enum.Font.GothamBold; checkMark.TextSize = 16; checkMark.ZIndex = 5

    local tb = Instance.new("TextBox", f); tb.Size = UDim2.new(0, 50, 0, 25); tb.Position = UDim2.new(1, -100, 0.5, -12.5); tb.PlaceholderText = GetTr(placeholderKey); tb.Text = tostring(initial_val); tb.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12); tb.TextColor3 = tbColor; tb.Font = SafeFont; tb.TextSize = 12; tb.ZIndex = 4; Instance.new("UICorner", tb); table.insert(ThemedMenus, tb)
    tb.FocusLost:Connect(function() local val = tonumber(tb.Text) or initial_val; tb.Text = tostring(val); pcall(callbackText, val) end)

    local state = initial_state or false
    local function UpdateButtonVisuals()
        if isBanned then 
            b.BackgroundColor3 = Color3.fromRGB(120, 0, 0); checkMark.Text = "🔒"; checkMark.Visible = true;
            if state then state = false; pcall(callbackToggle, false) end
        else 
            checkMark.Text = "✓"
            checkMark.Visible = state
            b.BackgroundColor3 = state and ThemeColor or Color3.fromRGB(40, 40, 40)
        end
    end
    UpdateButtonVisuals()
    b.MouseButton1Click:Connect(function() PlayClickSound(); if isBanned then SendCustomNotification(GetTr("🚫 وصول مرفوض"), GetTr("أنت مبند!"), 4) else state = not state; UpdateButtonVisuals(); pcall(callbackToggle, state) end end)
    task.spawn(function() local wasBanned = isBanned; while task.wait(1) do if isBanned ~= wasBanned then wasBanned = isBanned; UpdateButtonVisuals() end end end)
    return f
end

local function PlayCinematic()
    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Scriptable
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local startCFrame = hrp.CFrame * CFrame.new(0, 15, -20) * CFrame.Angles(math.rad(-25), math.rad(180), 0)
        local endCFrame = hrp.CFrame * CFrame.new(0, 6, 15)
        cam.CFrame = startCFrame
        local tween = TS:Create(cam, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = endCFrame})
        tween:Play()
        tween.Completed:Wait()
    end
    cam.CameraType = Enum.CameraType.Custom
    cam.CameraSubject = LP.Character and LP.Character:FindFirstChild("Humanoid")
end

task.spawn(function() 
    if isBanned then return end
    
    local LoadFrame = Instance.new("Frame", sg); LoadFrame.Size = UDim2.new(1, 0, 1, 0); LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 10); LoadFrame.BackgroundTransparency = 0.1; LoadFrame.ZIndex = 100
    
    local LoadLabel = Instance.new("TextLabel", LoadFrame); LoadLabel.Size = UDim2.new(1, 0, 0, 50); LoadLabel.Position = UDim2.new(0, 0, 0.5, -60); LoadLabel.Text = GetTr("جاري تحميل السكربت..."); LoadLabel.TextColor3 = ThemeColor; LoadLabel.Font = SafeFont; LoadLabel.TextSize = 38; LoadLabel.BackgroundTransparency = 1; LoadLabel.ZIndex = 101; table.insert(ThemedTexts, LoadLabel)
    
    local BarBG = Instance.new("Frame", LoadFrame); BarBG.Size = UDim2.new(0, 300, 0, 12); BarBG.Position = UDim2.new(0.5, -150, 0.5, 0); BarBG.BackgroundColor3 = Color3.fromRGB(25, 15, 15); BarBG.BorderSizePixel = 0; BarBG.ZIndex = 101; Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)
    local BarGlow = Instance.new("ImageLabel", BarBG); BarGlow.BackgroundTransparency = 1; BarGlow.Position = UDim2.new(0, -15, 0, -15); BarGlow.Size = UDim2.new(1, 30, 1, 30); BarGlow.ZIndex = 100; BarGlow.Image = "rbxassetid://5028857478"; BarGlow.ImageColor3 = ThemeColor; BarGlow.ImageTransparency = 0.4; BarGlow.ScaleType = Enum.ScaleType.Slice; BarGlow.SliceCenter = Rect.new(24, 24, 276, 276); table.insert(GlowEffects, BarGlow)
    local Bar = Instance.new("Frame", BarBG); Bar.Size = UDim2.new(0, 0, 1, 0); Bar.BackgroundColor3 = ThemeColor; Bar.BorderSizePixel = 0; Bar.ZIndex = 102; Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0); table.insert(ThemedBGs, Bar)
    local BarInnerGlow = Instance.new("ImageLabel", Bar); BarInnerGlow.BackgroundTransparency = 1; BarInnerGlow.Position = UDim2.new(0, -8, 0, -8); BarInnerGlow.Size = UDim2.new(1, 16, 1, 16); BarInnerGlow.ZIndex = 101; BarInnerGlow.Image = "rbxassetid://5028857478"; BarInnerGlow.ImageColor3 = Color3.fromRGB(255, 255, 255); BarInnerGlow.ImageTransparency = 0.6; BarInnerGlow.ScaleType = Enum.ScaleType.Slice; BarInnerGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    
    TS:Create(Bar, TweenInfo.new(5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(5)
    LoadLabel.Text = GetTr("تم تحميل السكربت")
    task.wait(0.5)
    
    TS:Create(BarBG, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(Bar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TS:Create(BarGlow, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TS:Create(BarInnerGlow, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TS:Create(LoadLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()

    task.spawn(PlayCinematic)
    task.wait(0.5)

    local WelcomeBox = Instance.new("Frame", LoadFrame); WelcomeBox.Size = UDim2.new(0, 0, 0, 0); WelcomeBox.Position = UDim2.new(0.5, 0, 0.5, 0); WelcomeBox.AnchorPoint = Vector2.new(0.5, 0.5); WelcomeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); WelcomeBox.BackgroundTransparency = 0.15; WelcomeBox.ZIndex = 105; Instance.new("UICorner", WelcomeBox).CornerRadius = UDim.new(0, 15); WelcomeBox.ClipsDescendants = true
    local WStroke = Instance.new("UIStroke", WelcomeBox); WStroke.Color = ThemeColor; WStroke.Thickness = 2; table.insert(ThemedStrokes, WStroke)
    
    local wParticle = Instance.new("ImageLabel", WelcomeBox); wParticle.Size = UDim2.new(2, 0, 2, 0); wParticle.Position = UDim2.new(-0.5, 0, -0.5, 0); wParticle.BackgroundTransparency = 1; wParticle.Image = "rbxassetid://2151950106"; wParticle.ImageTransparency = 0.8; wParticle.ZIndex = 104; wParticle.ScaleType = Enum.ScaleType.Tile; wParticle.TileSize = UDim2.new(0, 100, 0, 100)
    task.spawn(function()
        local t = 0
        while task.wait() do
            if not wParticle.Parent then break end
            t = t + 0.01
            wParticle.Position = UDim2.new(-0.5 + math.sin(t)*0.1, 0, -0.5 + math.cos(t)*0.1, 0)
        end
    end)

    local TimeLabel = Instance.new("TextLabel", WelcomeBox); TimeLabel.Size = UDim2.new(1, 0, 0, 30); TimeLabel.Position = UDim2.new(0, 0, 0, 15); TimeLabel.BackgroundTransparency = 1; TimeLabel.TextColor3 = ThemeColor; TimeLabel.Font = SafeFont; TimeLabel.TextSize = 24; TimeLabel.ZIndex = 106; table.insert(WelcomeElements, TimeLabel)
    task.spawn(function() while task.wait(1) do if not TimeLabel.Parent then break end; TimeLabel.Text = os.date("%I:%M:%S %p") end end)

    local wPlayerImg = Instance.new("ImageLabel", WelcomeBox); wPlayerImg.Size = UDim2.new(0, 80, 0, 80); wPlayerImg.Position = UDim2.new(0.5, -40, 0.5, -60); wPlayerImg.BackgroundTransparency = 1; wPlayerImg.ZIndex = 106; Instance.new("UICorner", wPlayerImg).CornerRadius = UDim.new(1, 0); wPlayerImg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
    local pStroke = Instance.new("UIStroke", wPlayerImg); pStroke.Color = ThemeColor; pStroke.Thickness = 2; table.insert(ThemedStrokes, pStroke)

    local WelcomeText = Instance.new("TextLabel", WelcomeBox); WelcomeText.Size = UDim2.new(1, 0, 0, 30); WelcomeText.Position = UDim2.new(0, 0, 0.5, 30); WelcomeText.BackgroundTransparency = 1; WelcomeText.Text = "مرحباً بك من جديد، " .. LP.DisplayName; WelcomeText.TextColor3 = Color3.new(1,1,1); WelcomeText.Font = SafeFont; WelcomeText.TextSize = 18; WelcomeText.ZIndex = 106

    local EnterBtn = Instance.new("TextButton", WelcomeBox); EnterBtn.Size = UDim2.new(0.6, 0, 0, 45); EnterBtn.Position = UDim2.new(0.2, 0, 1, -60); EnterBtn.BackgroundColor3 = ThemeColor; EnterBtn.TextColor3 = Color3.new(1,1,1); EnterBtn.Font = SafeFont; EnterBtn.TextSize = 18; EnterBtn.Text = "اضغط على زر مره وحدا"; EnterBtn.ZIndex = 106; Instance.new("UICorner", EnterBtn).CornerRadius = UDim.new(0, 8); table.insert(ThemedBGs, EnterBtn)
    
    TS:Create(WelcomeBox, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 320)}):Play()
    PlaySound("rbxassetid://452267918", 2.5)

    EnterBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        EnterBtn.Text = "تم تحميل السكربت"
        
        if isBrookhaven then
            task.spawn(function()
                pcall(function()
                    local RE = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
                    if RE then
                        if Admins[LP.Name] then
                            RE:FindFirstChild("1RPNam1eTex1t"):FireServer("RolePlayName", "👑 المالك 👑")
                            RE:FindFirstChild("1RPNam1eTex1t"):FireServer("RolePlayBio", "مطور السكربت")
                            local redColor = Color3.fromRGB(255, 50, 50)
                            RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPNameColor", redColor)
                            RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPBioColor", redColor)
                        elseif VIPSupporters[LP.Name] then
                            RE:FindFirstChild("1RPNam1eTex1t"):FireServer("RolePlayName", "💎 VIP 💎")
                            RE:FindFirstChild("1RPNam1eTex1t"):FireServer("RolePlayBio", "داعم أسطوري")
                            local goldColor = Color3.fromRGB(255, 215, 0)
                            RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPNameColor", goldColor)
                            RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPBioColor", goldColor)
                        else
                            RE:FindFirstChild("1RPNam1eTex1t"):FireServer("RolePlayName", "تم تحميل السكربت")
                            RE:FindFirstChild("1RPNam1eTex1t"):FireServer("RolePlayBio", "سكربت ABD HUB تحديث 1.2V")
                            local redColor = Color3.fromRGB(128, 0, 32)
                            RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPNameColor", redColor)
                            RE:FindFirstChild("1RPNam1eColo1r"):FireServer("PickingRPBioColor", redColor)
                        end
                    end
                end)
            end)
        end
        
        task.wait(0.5)
        TS:Create(WelcomeBox, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TS:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        LoadFrame:Destroy()

        if VIPSupporters[LP.Name] then
            task.delay(5, function()
                SendCustomNotification("💎 VIP 💎", "مرحبا بك يا " .. LP.DisplayName .. " تم تفعيلك لل VIP سوف نضيف اضافات مستقبلا لك", 8)
            end)
        end

        Main.Size = UDim2.new(0, 0, 0, 0); Main.Visible = true; 
        TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 440, 0, 340)}):Play()
        SetTheme(ThemeColor)

        task.delay(1, function()
            if isBrookhaven then
                SendCustomNotification(GetTr("✅ سكربت مدعوم"), GetTr("هذا السكربت مدعوم بالكامل في بروكهافن!"), 4)
            else
                SendCustomNotification(GetTr("⚠️ سكربت غير مدعوم"), GetTr("هذا السكربت غير مدعوم في هذا الماب، قد تواجه بعض المشاكل."), 4)
            end
            -- (Discord invite notification removed)
            task.wait(5)
            SendCustomNotification(GetTr("⛏️ تواصل مع الدعم"), GetTr("يمكنكم التواصل مع الدعم بشكل سريع وتقديم اقتراحات ومشاكل عند القائمة الرئيسية."), 6)
            task.wait(6)
            SendCustomNotification("🛡️ حقوق السكربت", "© 2026 ABOUD HUB PRIVATE\nهذا السكربت محمي بالكامل ويمنع التعديل عليه أو سرقته.", 8)
        end)
                local whatIsNewBtn, whatIsNewFunc = Tab("ما الجديد", 1, function()
            local updateBox = Instance.new("Frame", Content); updateBox.Size = UDim2.new(1, 0, 0, 270); updateBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20); updateBox.BackgroundTransparency = 0.2; updateBox.ZIndex = 4; Instance.new("UICorner", updateBox)
            local uStroke = Instance.new("UIStroke", updateBox); uStroke.Color = ThemeColor; uStroke.Thickness = 2; table.insert(ThemedStrokes, uStroke)
            
            local uTitle = Instance.new("TextLabel", updateBox); uTitle.Size = UDim2.new(1, 0, 0, 35); uTitle.Text = "🚀 آخر تحديثات السكربت (1.2V)"; uTitle.TextColor3 = ThemeColor; uTitle.Font = Enum.Font.GothamBold; uTitle.TextSize = 17; uTitle.BackgroundTransparency = 1; uTitle.ZIndex = 5; table.insert(ThemedTexts, uTitle)
            
            local div = Instance.new("Frame", updateBox); div.Size = UDim2.new(0.9, 0, 0, 1); div.Position = UDim2.new(0.05, 0, 0, 35); div.BackgroundColor3 = ThemeColor; div.BorderSizePixel = 0; div.ZIndex = 5; table.insert(ThemedBGs, div)
            
            local t = Instance.new("TextLabel", updateBox); t.Size = UDim2.new(1, -20, 1, -45); t.Position = UDim2.new(0, 10, 0, 40); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(0.95,0.95,0.95); t.Font = SafeFont; t.TextSize = 14; t.TextWrapped = true; t.TextXAlignment = Enum.TextXAlignment.Left; t.TextYAlignment = Enum.TextYAlignment.Top; t.ZIndex = 5
            
            local texts = {
                AR = [[
🚀 تحديثات ABD HUB الجديدة
تم تحديث تاب لحقوق

 
]],
EN = [[
Tab Rights Updated
]]
            }
            t.Text = texts[currentLang] or texts["AR"]
        end)
        
        LoadTabContent(whatIsNewBtn, whatIsNewFunc)
        AddNewBadge(whatIsNewBtn) -- إضافة علامة "جديد" للقائمة

    end)
end)

                
Tab(" قائمة رئيسية", 2, function()
    local welcomeTxt = Instance.new("TextLabel", Content); welcomeTxt.Size = UDim2.new(1, 0, 0, 30); welcomeTxt.BackgroundTransparency = 1; welcomeTxt.Text = "أهلاً بك، " .. LP.DisplayName .. " 👑"; welcomeTxt.TextColor3 = Color3.new(1,1,1); welcomeTxt.Font = SafeFont; welcomeTxt.TextSize = 18; welcomeTxt.TextXAlignment = Enum.TextXAlignment.Left; welcomeTxt.ZIndex = 4
    
    local headerBG = Instance.new("Frame", Content); headerBG.Size = UDim2.new(1, 0, 0, 90); headerBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20); headerBG.BackgroundTransparency = 0.5; headerBG.ZIndex = 4; Instance.new("UICorner", headerBG).CornerRadius = UDim.new(0, 10); table.insert(ThemedMenus, headerBG)
    local hdStroke = Instance.new("UIStroke", headerBG); hdStroke.Color = ThemeColor; hdStroke.Thickness = 1.5; table.insert(ThemedStrokes, hdStroke)

    local pimg = Instance.new("ImageLabel", headerBG); pimg.Size = UDim2.new(0, 65, 0, 65); pimg.Position = UDim2.new(0, 15, 0.5, -32.5); pimg.ZIndex = 5; Instance.new("UICorner", pimg).CornerRadius = UDim.new(1, 0); pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
    local imgStroke = Instance.new("UIStroke", pimg); imgStroke.Color = ThemeColor; imgStroke.Thickness = 2; table.insert(ThemedStrokes, imgStroke)

    local isVIP = VIPSupporters[LP.Name]
    local badge = Instance.new("TextLabel", pimg); badge.Size = UDim2.new(0, 22, 0, 22); badge.Position = UDim2.new(1, -15, 1, -15); badge.BackgroundColor3 = isVIP and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 150, 255); badge.Text = isVIP and "👑" or "✔"; badge.TextColor3 = Color3.new(1,1,1); badge.Font = SafeFont; badge.TextSize = 12; badge.ZIndex = 6; Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0); local badgeStroke = Instance.new("UIStroke", badge); badgeStroke.Color = Color3.new(1,1,1); badgeStroke.Thickness = 1

    local nameL = Instance.new("TextLabel", headerBG); nameL.Size = UDim2.new(1, -100, 0, 25); nameL.Position = UDim2.new(0, 95, 0, 20); nameL.BackgroundTransparency = 1; nameL.Text = LP.DisplayName; nameL.TextColor3 = ThemeColor; nameL.Font = SafeFont; nameL.TextSize = 20; nameL.TextXAlignment = Enum.TextXAlignment.Left; nameL.ZIndex = 5; table.insert(ThemedTexts, nameL)
    local userL = Instance.new("TextLabel", headerBG); userL.Size = UDim2.new(1, -100, 0, 20); userL.Position = UDim2.new(0, 95, 0, 45); userL.BackgroundTransparency = 1; userL.Text = "@" .. LP.Name; userL.TextColor3 = Color3.new(0.7, 0.7, 0.7); userL.Font = SafeFont; userL.TextSize = 13; userL.TextXAlignment = Enum.TextXAlignment.Left; userL.ZIndex = 5

    local supBtn = Instance.new("ImageButton", headerBG); supBtn.Size = UDim2.new(0, 25, 0, 25); supBtn.Position = UDim2.new(1, -35, 0, 15); supBtn.BackgroundTransparency = 1; supBtn.Image = "rbxassetid://7733674079"; supBtn.ImageColor3 = ThemeColor; supBtn.ZIndex = 6; table.insert(GlowEffects, supBtn)
    supBtn.MouseButton1Click:Connect(function() PlayClickSound(); SupportOverlay.Visible = true end)

    local langBtn = Instance.new("TextButton", headerBG); langBtn.Size = UDim2.new(0, 20, 0, 20); langBtn.Position = UDim2.new(1, -65, 0, 18); langBtn.BackgroundTransparency = 1; langBtn.Text = "🌐"; langBtn.TextSize = 18; langBtn.ZIndex = 6
    local discordSmallBtn = Instance.new("ImageButton", headerBG); discordSmallBtn.Size = UDim2.new(0, 25, 0, 25); discordSmallBtn.Position = UDim2.new(1, -67, 0, 45); discordSmallBtn.BackgroundTransparency = 1; discordSmallBtn.Image = "rbxassetid://115465566081051"; discordSmallBtn.ScaleType = Enum.ScaleType.Fit; discordSmallBtn.ZIndex = 6    
    discordSmallBtn.MouseButton1Click:Connect(function() 
        PlayClickSound(); 
        pcall(function() setclipboard("https://discord.gg/7rSynUpQx") end); 
        SendCustomNotification("✅", GetTr("تم نسخ رابط الديسكورد! اذهب للمتصفح والصقه."), 6) 
    end)
    local langMenu = Instance.new("Frame", headerBG); langMenu.Size = UDim2.new(0, 100, 0, 105); langMenu.Position = UDim2.new(1, -110, 0, 45); langMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25); langMenu.Visible = false; langMenu.ZIndex = 100; Instance.new("UICorner", langMenu).CornerRadius = UDim.new(0, 8)
    local lmStroke = Instance.new("UIStroke", langMenu); lmStroke.Color = ThemeColor; lmStroke.Thickness = 1.5; table.insert(ThemedStrokes, lmStroke); table.insert(ThemedMenus, langMenu)

    local function CreateLangOption(langName, code, yPos)
        local b = Instance.new("TextButton", langMenu); b.Size = UDim2.new(1, -10, 0, 25); b.Position = UDim2.new(0, 5, 0, yPos); b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.new(1, 1, 1); b.Font = SafeFont; b.TextSize = 13; b.Text = langName; b.ZIndex = 101; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() PlayClickSound(); langMenu.Visible = false; currentLang = code; SData["ScriptLanguage"] = currentLang; SaveAll(); for _, item in pairs(TranslatableUI) do if item.Obj and item.Obj.Parent then pcall(function() item.Obj[item.Prop] = GetTr(item.Key) end) end end; if ActiveTabBtn and ActiveTabFunc then for _,v in pairs(Content:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end; ActiveTabFunc() end end)
    end
    CreateLangOption("العربية", "AR", 10); CreateLangOption("English", "EN", 40); CreateLangOption("Русский", "RU", 70)
    langBtn.MouseButton1Click:Connect(function() PlayClickSound(); langMenu.Visible = not langMenu.Visible end)

    local infoContainer = Instance.new("Frame", Content); infoContainer.Size = UDim2.new(1, 0, 0, 140); infoContainer.BackgroundTransparency = 1; infoContainer.ZIndex = 5
    local infoLayout = Instance.new("UIGridLayout", infoContainer); infoLayout.CellSize = UDim2.new(0.31, 0, 0, 65); infoLayout.CellPadding = UDim2.new(0.035, 0, 0, 10); infoLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function AddStatCard(icon, titleKey, valFunc, order)
        local card = Instance.new("Frame", infoContainer); card.BackgroundColor3 = Color3.fromRGB(30, 30, 30); card.BackgroundTransparency = 0.4; card.LayoutOrder = order; Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8); table.insert(ThemedMenus, card)
        local cardStr = Instance.new("UIStroke", card); cardStr.Color = ThemeColor; cardStr.Thickness = 1; cardStr.Transparency = 0.5; table.insert(ThemedStrokes, cardStr)
        
        local iconL = Instance.new("TextLabel", card); iconL.Size = UDim2.new(1, 0, 0, 20); iconL.Position = UDim2.new(0, 0, 0, 5); iconL.BackgroundTransparency = 1; iconL.Text = icon; iconL.TextSize = 16; iconL.ZIndex = 6
        local titleL = Instance.new("TextLabel", card); titleL.Size = UDim2.new(1, 0, 0, 15); titleL.Position = UDim2.new(0, 0, 0, 25); titleL.BackgroundTransparency = 1; titleL.Text = GetTr(titleKey); titleL.TextColor3 = Color3.new(0.8,0.8,0.8); titleL.Font = SafeFont; titleL.TextSize = 11; titleL.ZIndex = 6
        local valL = Instance.new("TextLabel", card); valL.Size = UDim2.new(1, 0, 0, 20); valL.Position = UDim2.new(0, 0, 0, 42); valL.BackgroundTransparency = 1; valL.TextColor3 = Color3.new(1,1,1); valL.Font = SafeFont; valL.TextSize = 13; valL.RichText = true; valL.ZIndex = 6
        
        task.spawn(function()
            while task.wait(0.5) do
                if not card.Parent then break end
                pcall(function() valL.Text = "<b>" .. tostring(valFunc()) .. "</b>" end)
            end
        end)
    end

    AddStatCard("🆔", "الأيدي", function() return LP.UserId end, 1)
    AddStatCard("📅", "عمر الحساب", function() return LP.AccountAge .. " " .. GetTr("يوم") end, 2)
    AddStatCard("💎", "الاشتراك", function() return isVIP and "<font color='rgb(0,255,0)'>"..GetTr("فعال").."</font>" or "<font color='rgb(255,50,50)'>"..GetTr("غير فعال").."</font>" end, 3)
    AddStatCard("❤️", "الصحة", function() return LP.Character and LP.Character:FindFirstChild("Humanoid") and math.floor(LP.Character.Humanoid.Health) or "0" end, 4)
    AddStatCard("⚡", "السرعة", function() return LP.Character and LP.Character:FindFirstChild("Humanoid") and math.floor(LP.Character.Humanoid.WalkSpeed) or "16" end, 5)
    
    if not _G.AboudHub_SessionStartTime then _G.AboudHub_SessionStartTime = tick() end
    local function GetLiveSessionTime()
        local diff = tick() - _G.AboudHub_SessionStartTime; local h = math.floor(diff / 3600); local m = math.floor((diff % 3600) / 60); local s = math.floor(diff % 60)
        if h > 0 then return string.format("%02d:%02d:%02d", h, m, s) else return string.format("%02d:%02d", m, s) end
    end
    AddStatCard("⏳", "التشغيل", GetLiveSessionTime, 6)

    if Admins[LP.Name] then
        local devViewBtn = Instance.new("TextButton", Content); devViewBtn.Size = UDim2.new(1, 0, 0, 40); devViewBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); devViewBtn.TextColor3 = Color3.new(1, 1, 1); devViewBtn.Font = SafeFont; devViewBtn.TextSize = 14; devViewBtn.Text = GetTr("👑 رؤية رسائل الدعم (السجل الكامل) 👑"); devViewBtn.ZIndex = 4; Instance.new("UICorner", devViewBtn)
        devViewBtn.MouseButton1Click:Connect(function() PlayClickSound(); ViewOverlay.Visible = true; pcall(RefreshMessages) end)

        local devClearBtn = Instance.new("TextButton", Content); devClearBtn.Size = UDim2.new(1, 0, 0, 30); devClearBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0); devClearBtn.TextColor3 = Color3.new(1, 1, 1); devClearBtn.Font = SafeFont; devClearBtn.TextSize = 13; devClearBtn.Text = GetTr("🗑️ مسح سجل رسائل الدعم"); devClearBtn.ZIndex = 4; Instance.new("UICorner", devClearBtn)
        devClearBtn.MouseButton1Click:Connect(function() PlayClickSound(); SupportMessages = {}; SaveSupportMessages(); pcall(RefreshMessages) end)
    end
end)
Tab("الحقوق", 3, function() 
    for _, v in pairs(Content:GetChildren()) do
        if v.Name == "1_AboudProfile" or v.Name == "2_AboudDiscord" or v.Name == "3_AboudLB" or v.Name == "4_AboudFooter" then
            v:Destroy()
        end
    end


    _G.AboudLeaderboard = _G.AboudLeaderboard or {}

    if not _G.Global_Aboud_LB_Started then
        _G.Global_Aboud_LB_Started = true
        _G.AboudSavedTime = 0
        pcall(function() 
            if isfile and isfile("AboudHub_Score.txt") then
                local content = readfile("AboudHub_Score.txt")
                if content and content ~= "" then
                    _G.AboudSavedTime = tonumber(content) or 0
                end
            end
        end)
        _G.AboudSessionStart = tick()
        
        local wsUrl = "wss://abd-server-9vf6.onrender.com"

        local function ConnectSocket()
            pcall(function()
                _G.TimeSocket = WebSocket.connect(wsUrl)
                if _G.TimeSocket then
                    _G.TimeSocket.OnMessage:Connect(function(msg)
                        if msg == "ping" or string.match(msg, "^%s*{") then return end
                        
                        local cmd, pname, pid, ptimeStr = string.match(msg, "^(!timesync)%s+(%S+)%s+(%d+)%s+(%d+%.?%d*)")
                        if cmd == "!timesync" and pname and pid and ptimeStr then
                            local ptimeNum = tonumber(ptimeStr)
                            if not _G.AboudLeaderboard[pname] or ptimeNum > (_G.AboudLeaderboard[pname].Time or 0) then
                                _G.AboudLeaderboard[pname] = {UserId = tonumber(pid), Time = ptimeNum}
                            end
                        end
                    end)
                    
                    _G.TimeSocket.OnClose:Connect(function()
                        _G.TimeSocket = nil
                        task.wait(5)
                        ConnectSocket()
                    end)
                end
            end)
        end
        task.spawn(ConnectSocket)

        task.spawn(function()
            while task.wait(120) do
                if _G.TimeSocket then pcall(function() _G.TimeSocket:Send("ping") end) end
            end
        end)

        task.spawn(function()
            while task.wait(5) do
                local currentTotal = _G.AboudSavedTime + (tick() - _G.AboudSessionStart)
                pcall(function() if writefile then writefile("AboudHub_Score.txt", tostring(math.floor(currentTotal))) end end)
                
                _G.AboudLeaderboard[LP.Name] = {UserId = LP.UserId, Time = currentTotal}
                
                if _G.TimeSocket then
                    pcall(function() 
                        _G.TimeSocket:Send("!timesync " .. string.gsub(LP.Name, "%s+", "_") .. " " .. tostring(LP.UserId) .. " " .. tostring(math.floor(currentTotal))) 
                    end)
                end
            end
        end)
    end

    local lbContainer = Instance.new("Frame", Content)
    lbContainer.Name = "3_AboudLB"
    lbContainer.LayoutOrder = 3
    lbContainer.Size = UDim2.new(1, 0, 0, 240)
    lbContainer.BackgroundColor3 = Color3.new(ThemeColor.R*0.05, ThemeColor.G*0.05, ThemeColor.B*0.05)
    lbContainer.BackgroundTransparency = 0.2
    lbContainer.ZIndex = 4
    Instance.new("UICorner", lbContainer).CornerRadius = UDim.new(0, 10)
    
    local lbStroke = Instance.new("UIStroke", lbContainer)
    lbStroke.Color = ThemeColor
    lbStroke.Thickness = 1.5
    table.insert(ThemedStrokes, lbStroke)

    local lbHeader = Instance.new("Frame", lbContainer)
    lbHeader.Size = UDim2.new(1, 0, 0, 35)
    lbHeader.BackgroundColor3 = Color3.new(0, 0, 0)
    lbHeader.BackgroundTransparency = 0.5
    lbHeader.BorderSizePixel = 0
    Instance.new("UICorner", lbHeader).CornerRadius = UDim.new(0, 10)
    
    local lbTitle = Instance.new("TextLabel", lbHeader)
    lbTitle.Size = UDim2.new(1, 0, 1, 0)
    lbTitle.BackgroundTransparency = 1
    lbTitle.Text = "🏆 Top 20 - أساطير الصملة"
    lbTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    lbTitle.Font = Enum.Font.GothamBlack
    lbTitle.TextSize = 15
    lbTitle.ZIndex = 5

    local lbScroll = Instance.new("ScrollingFrame", lbContainer)
    lbScroll.Size = UDim2.new(1, -10, 1, -45)
    lbScroll.Position = UDim2.new(0, 5, 0, 40)
    lbScroll.BackgroundTransparency = 1
    lbScroll.ScrollBarThickness = 3
    lbScroll.ClipsDescendants = true
    lbScroll.ScrollBarImageColor3 = ThemeColor
    lbScroll.ZIndex = 5
    
    local lbLayout = Instance.new("UIListLayout", lbScroll)
    lbLayout.Padding = UDim.new(0, 6)
    lbLayout.SortOrder = Enum.SortOrder.LayoutOrder

    lbLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        lbScroll.CanvasSize = UDim2.new(0, 0, 0, lbLayout.AbsoluteContentSize.Y + 5)
    end)

    local UI_Slots = {}
    for i = 1, 20 do
        local slot = Instance.new("Frame", lbScroll)
        slot.Size = UDim2.new(1, 0, 0, 45)
        slot.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        slot.BackgroundTransparency = 0.4
        slot.ZIndex = 6
        slot.Visible = false
        Instance.new("UICorner", slot).CornerRadius = UDim.new(0, 6)
        
        local rankLbl = Instance.new("TextLabel", slot)
        rankLbl.Size = UDim2.new(0, 35, 1, 0)
        rankLbl.Position = UDim2.new(0, 5, 0, 0)
        rankLbl.BackgroundTransparency = 1
        rankLbl.Font = Enum.Font.GothamBlack
        rankLbl.TextSize = 16
        rankLbl.ZIndex = 7

        local img = Instance.new("ImageLabel", slot)
        img.Size = UDim2.new(0, 35, 0, 35)
        img.Position = UDim2.new(0, 45, 0, 5)
        img.BackgroundTransparency = 1
        img.ZIndex = 7
        Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)

        local nameLbl = Instance.new("TextLabel", slot)
        nameLbl.Size = UDim2.new(1, -160, 0, 20)
        nameLbl.Position = UDim2.new(0, 90, 0, 5)
        nameLbl.BackgroundTransparency = 1
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 13
        nameLbl.ZIndex = 7

        local timeLbl = Instance.new("TextLabel", slot)
        timeLbl.Size = UDim2.new(1, -160, 0, 15)
        timeLbl.Position = UDim2.new(0, 90, 0, 25)
        timeLbl.BackgroundTransparency = 1
        timeLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        timeLbl.TextXAlignment = Enum.TextXAlignment.Left
        timeLbl.Font = SafeFont
        timeLbl.TextSize = 11
        timeLbl.ZIndex = 7
        
        UI_Slots[i] = {Frame = slot, Rank = rankLbl, Img = img, Name = nameLbl, Time = timeLbl}
    end

    local isThisTabActive = true
    local function RefreshLeaderboard()
        if not lbContainer.Parent or not isThisTabActive then return end
        
        local sortedPlayers = {}
        for name, data in pairs(_G.AboudLeaderboard) do
            if type(data) == "table" and data.UserId and data.Time then
                table.insert(sortedPlayers, {Name = name, UserId = data.UserId, Time = data.Time})
            end
        end
        table.sort(sortedPlayers, function(a, b) return a.Time > b.Time end)

        if #sortedPlayers == 0 then
            UI_Slots[1].Frame.Visible = true
            UI_Slots[1].Rank.Text = "#1"
            UI_Slots[1].Rank.TextColor3 = Color3.fromRGB(150, 150, 150)
            if UI_Slots[1].Name.Text ~= "جاري تحميل الأساطير..." then
                UI_Slots[1].Name.Text = "جاري تحميل الأساطير..."
            end
            UI_Slots[1].Name.TextColor3 = Color3.new(1,1,1)
            UI_Slots[1].Time.Text = "00:00:00"
            if UI_Slots[1].Img.Image ~= "rbxassetid://10111280387" then
                UI_Slots[1].Img.Image = "rbxassetid://10111280387" 
            end
            for i = 2, 20 do UI_Slots[i].Frame.Visible = false end
        else
            for i = 1, 20 do
                if sortedPlayers[i] then
                    local p = sortedPlayers[i]
                    UI_Slots[i].Frame.Visible = true
                    
                    if UI_Slots[i].Rank.Text ~= "#" .. i then
                        UI_Slots[i].Rank.Text = "#" .. i
                    end
                    
                    if UI_Slots[i].Name.Text ~= p.Name then
                        UI_Slots[i].Name.Text = p.Name
                    end
                    
                    local h = math.floor(p.Time / 3600)
                    local m = math.floor((p.Time % 3600) / 60)
                    local s = math.floor(p.Time % 60)
                    local newTimeFormat = string.format("⏳ %02d:%02d:%02d", h, m, s)
                    if UI_Slots[i].Time.Text ~= newTimeFormat then
                        UI_Slots[i].Time.Text = newTimeFormat
                    end
                    
                    local newThumb = "rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150"
                    if UI_Slots[i].Img.Image ~= newThumb then
                        UI_Slots[i].Img.Image = newThumb
                    end
                    
                    if i == 1 then
                        UI_Slots[i].Rank.TextColor3 = Color3.fromRGB(255, 215, 0)
                        UI_Slots[i].Name.TextColor3 = Color3.fromRGB(255, 215, 0)
                        UI_Slots[i].Frame.BackgroundColor3 = Color3.fromRGB(60, 50, 10)
                    elseif i == 2 then
                        UI_Slots[i].Rank.TextColor3 = Color3.fromRGB(192, 192, 192)
                        UI_Slots[i].Name.TextColor3 = Color3.fromRGB(192, 192, 192)
                        UI_Slots[i].Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                    elseif i == 3 then
                        UI_Slots[i].Rank.TextColor3 = Color3.fromRGB(205, 127, 50)
                        UI_Slots[i].Name.TextColor3 = Color3.fromRGB(205, 127, 50)
                        UI_Slots[i].Frame.BackgroundColor3 = Color3.fromRGB(45, 30, 20)
                    else
                        UI_Slots[i].Rank.TextColor3 = Color3.new(1, 1, 1)
                        UI_Slots[i].Name.TextColor3 = Color3.new(1, 1, 1)
                        UI_Slots[i].Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                    end
                else
                    UI_Slots[i].Frame.Visible = false
                end
            end
        end
    end

    task.spawn(function()
        while task.wait(1) do
            if not lbContainer.Parent then
                isThisTabActive = false
                break 
            end
            RefreshLeaderboard()
        end
    end)
    RefreshLeaderboard()

    local footerBox = Instance.new("Frame", Content)
    footerBox.Name = "4_AboudFooter"
    footerBox.LayoutOrder = 4
    footerBox.Size = UDim2.new(1, 0, 0, 110)
    footerBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    footerBox.BackgroundTransparency = 0.2
    footerBox.ZIndex = 4
    Instance.new("UICorner", footerBox).CornerRadius = UDim.new(0, 8)
    
    local footerStr = Instance.new("UIStroke", footerBox)
    footerStr.Color = ThemeColor
    footerStr.Thickness = 1.5
    table.insert(ThemedStrokes, footerStr)

    local crTxt = Instance.new("TextLabel", footerBox)
    crTxt.Size = UDim2.new(1, -10, 0, 35)
    crTxt.Position = UDim2.new(0, 5, 0, 5)
    crTxt.BackgroundTransparency = 1
    crTxt.Text = "© 2026 HUB BETA"
    crTxt.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    crTxt.Font = SafeFont
    crTxt.TextSize = 12
    crTxt.TextWrapped = true
    crTxt.ZIndex = 5

    local animTxt = Instance.new("TextLabel", footerBox)
    animTxt.Size = UDim2.new(1, -10, 0, 25)
    animTxt.Position = UDim2.new(0, 5, 0, 40)
    animTxt.BackgroundTransparency = 1
    animTxt.TextColor3 = Color3.new(1, 1, 1)
    animTxt.Font = Enum.Font.GothamBlack
    animTxt.TextSize = 16
    animTxt.ZIndex = 5

    local txtGrad = Instance.new("UIGradient", animTxt)
    txtGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })

    local phrases = {
        "HUB ON TOP",
        "الافضل",
        "متكامل",
        "الاقوه",
        "MY HUB", 
        "الافضل",
        "yousif1479 hub"
    }    

    task.spawn(function()
        local rot = 0
        while task.wait(0.02) do
            if not animTxt.Parent then break end
            rot = (rot + 5) % 360
            txtGrad.Rotation = rot
        end
    end)

    task.spawn(function()
        local idx = 1
        while task.wait() do
            if not animTxt.Parent then break end
            
            local fadeOut = TS:Create(animTxt, TweenInfo.new(0.5), {TextTransparency = 1})
            fadeOut:Play()
            fadeOut.Completed:Wait()
            
            animTxt.Text = "✨ " .. phrases[idx] .. " ✨"
            
            local fadeIn = TS:Create(animTxt, TweenInfo.new(0.5), {TextTransparency = 0})
            fadeIn:Play()
            fadeIn.Completed:Wait()
            
            task.wait(1.5)
            
            idx = idx + 1
            if idx > #phrases then idx = 1 end
        end
    end)

    local timeLine = Instance.new("Frame", footerBox)
    timeLine.Size = UDim2.new(0.8, 0, 0, 1)
    timeLine.Position = UDim2.new(0.1, 0, 0, 75)
    timeLine.BackgroundColor3 = ThemeColor
    timeLine.BackgroundTransparency = 0.5
    timeLine.BorderSizePixel = 0
    table.insert(ThemedBGs, timeLine)

    local tL = Instance.new("TextLabel", footerBox)
    tL.Size = UDim2.new(1, 0, 0, 25)
    tL.Position = UDim2.new(0, 0, 0, 80)
    tL.BackgroundTransparency = 1
    tL.TextColor3 = ThemeColor
    tL.Font = Enum.Font.GothamBold
    tL.TextSize = 14
    tL.ZIndex = 5
    table.insert(ThemedTexts, tL)

    task.spawn(function() 
        while task.wait(1) do 
            if not tL.Parent then break end 
            pcall(function() tL.Text = "⏱️ " .. GetTr("الوقت الحالي: ") .. GetCurrentTime() end) 
        end 
    end)
end)
AddNewBadge(rightsTabBtn)


-- ==========================================
-- || وظائف الحركة (الجلوس والبانج) بدون مساس ||
-- ==========================================
local AboudActionLoop = nil
local AboudBangAnim = nil
local lastHum = nil 

local function GetStabilizer(root)
    if root and not root:FindFirstChild("AboudStabilizer") then
        local vel = Instance.new("BodyAngularVelocity")
        vel.Name = "AboudStabilizer"
        vel.AngularVelocity = Vector3.new(0, 0, 0)
        vel.MaxTorque = Vector3.new(50000, 50000, 50000)
        vel.P = 1250
        vel.Parent = root
    end
end

local function RemoveStabilizer(root)
    if root and root:FindFirstChild("AboudStabilizer") then
        root.AboudStabilizer:Destroy()
    end
end

local function ToggleHeadSit(state, TargetPlayer, LP, RS)
    if AboudActionLoop then AboudActionLoop:Disconnect(); AboudActionLoop = nil end
    
    if state then
        AboudActionLoop = RS.Heartbeat:Connect(function()
            pcall(function()
                local myChar = LP.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar and myChar:FindFirstChild("Humanoid")
                
                local tChar = TargetPlayer and TargetPlayer.Character
                local tHum = tChar and tChar:FindFirstChild("Humanoid")
                local tHead = tChar and tChar:FindFirstChild("Head")
                
                if not tChar or not tHum or tHum.Health <= 0 then 
                    if myHum then myHum.Sit = false end
                    return 
                end
                
                if myRoot and myHum then
                    myHum.BreakJointsOnDeath = false 
                    GetStabilizer(myRoot)
                    
                    if myHum.Health > 0 then
                        myHum.Sit = true 
                    end
                    
                    if tHead then
                        myRoot.CFrame = tHead.CFrame * CFrame.new(0, 2, 0)
                        _G.AboudLastTargetHead = tHead.CFrame
                    elseif _G.AboudLastTargetHead then
                        myRoot.CFrame = _G.AboudLastTargetHead * CFrame.new(0, 2, 0)
                    end
                    myRoot.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end)
    else
        pcall(function()
            local myChar = LP.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            if myHum then 
                myHum.Sit = false 
                myHum.BreakJointsOnDeath = true 
            end
            if myRoot then RemoveStabilizer(myRoot) end
        end)
    end
end

local function ToggleBangTarget(state, TargetPlayer, LP, RS)
    if AboudActionLoop then AboudActionLoop:Disconnect(); AboudActionLoop = nil end
    if AboudBangAnim then pcall(function() AboudBangAnim:Stop() end); AboudBangAnim = nil end
    lastHum = nil
    
    if state then
        AboudActionLoop = RS.Heartbeat:Connect(function()
            pcall(function()
                local myChar = LP.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar and myChar:FindFirstChild("Humanoid")
                
                local tChar = TargetPlayer and TargetPlayer.Character
                local tHum = tChar and tChar:FindFirstChild("Humanoid")
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                
                if not tChar or not tHum or tHum.Health <= 0 then return end
                
                if myRoot and myHum then
                    myHum.BreakJointsOnDeath = false 
                    GetStabilizer(myRoot)
                    
                    if myHum ~= lastHum and myHum.Health > 0 then
                        lastHum = myHum
                        if AboudBangAnim then pcall(function() AboudBangAnim:Stop() end) end
                        
                        local animator = myHum:FindFirstChildOfClass("Animator")
                        if not animator then
                            animator = Instance.new("Animator")
                            animator.Parent = myHum
                        end
                        
                        local Anim = Instance.new("Animation")
                        Anim.AnimationId = "rbxassetid://5918726674"
                        AboudBangAnim = animator:LoadAnimation(Anim)
                        AboudBangAnim:Play(0.1, 1, BangBackSpeed / 10)
                    end
                    
                    if myHum.Health > 0 and AboudBangAnim then
                        if not AboudBangAnim.IsPlaying then
                            pcall(function() AboudBangAnim:Play(0.1, 1, BangBackSpeed / 10) end)
                        else
                            pcall(function() AboudBangAnim:AdjustSpeed(BangBackSpeed / 10) end)
                        end
                    end
                    
                    local offset = math.sin(tick() * BangBackSpeed) * 0.5 
                    
                    if tRoot then
                        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.1 + offset)
                        _G.AboudLastTargetCFrame = tRoot.CFrame
                    elseif _G.AboudLastTargetCFrame then
                        myRoot.CFrame = _G.AboudLastTargetCFrame * CFrame.new(0, 0, 1.1 + offset)
                    end
                    myRoot.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end)
    else
        pcall(function()
            local myChar = LP.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar and myChar:FindFirstChild("Humanoid")
            if myHum then myHum.BreakJointsOnDeath = true end
            if myRoot then RemoveStabilizer(myRoot) end
            if AboudBangAnim then pcall(function() AboudBangAnim:Stop() end); AboudBangAnim = nil end
        end)
    end

end
local playersTabBtn, playersTabFunc = Tab(" اللاعبين", 4, function()
    local pprof = Instance.new("Frame", Content); pprof.Size = UDim2.new(1, 0, 0, 140); pprof.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12); pprof.BackgroundTransparency = 0.35; pprof.ZIndex = 4; Instance.new("UICorner", pprof); table.insert(ThemedMenus, pprof)
    
    -- رجعنا الصورة الأصلية الفخمة زي ما طلبت
    local pimg = Instance.new("ImageLabel", pprof)
    pimg.Size = UDim2.new(0, 70, 0, 70)
    pimg.Position = UDim2.new(0, 10, 0, 10)
    pimg.BackgroundTransparency = 1 -- عشان ما يطلع مربع أبيض وراها
    pimg.ZIndex = 4
    Instance.new("UICorner", pimg).CornerRadius = UDim.new(1,0)
    
    local ptxt = Instance.new("TextLabel", pprof); ptxt.Size = UDim2.new(1, -220, 0, 25); ptxt.Position = UDim2.new(0, 90, 0, 10); ptxt.BackgroundTransparency = 1; ptxt.TextColor3 = Color3.new(1, 1, 1); ptxt.Font = SafeFont; ptxt.TextSize = 14; ptxt.TextXAlignment = Enum.TextXAlignment.Left; ptxt.ZIndex = 4
    
    local dateL = Instance.new("TextLabel", pprof); dateL.Size = UDim2.new(1, -220, 0, 15); dateL.Position = UDim2.new(0, 90, 0, 30); dateL.BackgroundTransparency = 1; dateL.TextColor3 = Color3.new(0.7, 0.7, 0.7); dateL.Font = SafeFont; dateL.TextSize = 12; dateL.TextXAlignment = Enum.TextXAlignment.Left; dateL.Text = "تاريخ الحساب: ----/--/--"; dateL.ZIndex = 4
    TargetStatusLabel = Instance.new("TextLabel", pprof); TargetStatusLabel.Size = UDim2.new(1, -220, 0, 15); TargetStatusLabel.Position = UDim2.new(0, 90, 0, 48); TargetStatusLabel.BackgroundTransparency = 1; TargetStatusLabel.Font = SafeFont; TargetStatusLabel.TextSize = 12; TargetStatusLabel.TextXAlignment = Enum.TextXAlignment.Left; TargetStatusLabel.Text = ""; TargetStatusLabel.ZIndex = 4
    
    local joinsL = Instance.new("TextLabel", pprof); joinsL.Size = UDim2.new(1, -220, 0, 15); joinsL.Position = UDim2.new(0, 90, 0, 68); joinsL.BackgroundTransparency = 1; joinsL.TextColor3 = Color3.fromRGB(100, 200, 100); joinsL.Font = SafeFont; joinsL.TextSize = 12; joinsL.TextXAlignment = Enum.TextXAlignment.Left; joinsL.Text = "مرات الدخول: 0"; joinsL.ZIndex = 4
    
    -- ✅ تم إصلاح خط الخروج هنا (كان joinsL.TextSize وصار leavesL.TextSize)
    local leavesL = Instance.new("TextLabel", pprof); leavesL.Size = UDim2.new(1, -220, 0, 15); leavesL.Position = UDim2.new(0, 90, 0, 88); leavesL.BackgroundTransparency = 1; leavesL.TextColor3 = Color3.fromRGB(200, 100, 100); leavesL.Font = SafeFont; leavesL.TextSize = 12; leavesL.TextXAlignment = Enum.TextXAlignment.Left; leavesL.Text = "مرات الخروج: 0"; leavesL.ZIndex = 4

    local pBox = Instance.new("TextBox", pprof); pBox.Size = UDim2.new(0, 110, 0, 25); pBox.Position = UDim2.new(1, -120, 0, 10); pBox.PlaceholderText = "ابحث عن لاعب"; pBox.Text = ""; pBox.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12); pBox.TextColor3 = Color3.new(1, 1, 1); pBox.Font = SafeFont; pBox.TextSize = 12; pBox.ZIndex = 4; Instance.new("UICorner", pBox); table.insert(ThemedMenus, pBox)
    local pBoxStroke = Instance.new("UIStroke", pBox); pBoxStroke.Color = Color3.fromRGB(255, 255, 255); pBoxStroke.Thickness = 1.5; pBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local targetTimerLbl = Instance.new("TextLabel", pprof)
    targetTimerLbl.Size = UDim2.new(0, 80, 0, 20)
    targetTimerLbl.Position = UDim2.new(0, 10, 0, 110)
    targetTimerLbl.BackgroundTransparency = 1
    targetTimerLbl.TextColor3 = ThemeColor
    targetTimerLbl.Font = Enum.Font.GothamBold
    targetTimerLbl.TextSize = 15
    targetTimerLbl.Text = "00:00:00"
    targetTimerLbl.ZIndex = 4
    table.insert(ThemedTexts, targetTimerLbl)
    _G.AboudServerLogs = _G.AboudServerLogs or {}
    
    if _G.TargetUserId and _G.AboudServerLogs[_G.TargetUserId] then
        -- استرجاع بيانات اللاعب المبحوث عنه حتى لو غيرت التاب
        local savedData = _G.AboudServerLogs[_G.TargetUserId]
        pBox.Text = savedData.Name
        pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(savedData.UserId).."&w=150&h=150"
        ptxt.Text = savedData.DisplayName
        if savedData.AccountAge then
            pcall(function() dateL.Text = GetTr("تاريخ الحساب: ") .. os.date("%Y/%m/%d", os.time() - (savedData.AccountAge * 86400)) end)
        end
        joinsL.Text = "مرات الدخول: " .. savedData.Joins
        leavesL.Text = "مرات الخروج: " .. savedData.Leaves
        
        local isConnected = game.Players:GetPlayerByUserId(_G.TargetUserId) ~= nil
        if isConnected then
            TargetStatusLabel.Text = "✅ متصل الآن"
            TargetStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
        else
            TargetStatusLabel.Text = "⚠️ غادر السيرفر"
            TargetStatusLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
        end
    else
        -- لو ما كنت باحث عن أحد، يحط صورتك
        pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(LP.UserId).."&w=150&h=150"
        ptxt.Text = LP.DisplayName
        dateL.Text = "تاريخ الحساب: ----/--/--"
        TargetStatusLabel.Text = ""
        joinsL.Text = "مرات الدخول: 0"
        leavesL.Text = "مرات الخروج: 0"
    end
    -- ==========================================

    -- 🟢 تم استبدال زر المهملات بزر النسخ (صورة) 🟢
    local copyMainBtn = Instance.new("ImageButton", pprof)
    copyMainBtn.Size = UDim2.new(0, 25, 0, 25)
    copyMainBtn.Position = UDim2.new(1, -150, 0, 10)
    copyMainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    copyMainBtn.Image = "rbxassetid://6031094678" -- أيقونة النسخ
    copyMainBtn.ZIndex = 5
    Instance.new("UICorner", copyMainBtn).CornerRadius = UDim.new(0, 4)
    local copyMainStroke = Instance.new("UIStroke", copyMainBtn); copyMainStroke.Color = ThemeColor; copyMainStroke.Thickness = 1.5; table.insert(ThemedStrokes, copyMainStroke)

    local openLogBtn = Instance.new("ImageButton", pprof)
    openLogBtn.Size = UDim2.new(0, 30, 0, 30)
    openLogBtn.Position = UDim2.new(1, -40, 0, 40)
    openLogBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    openLogBtn.Image = "rbxassetid://3926305904"
    openLogBtn.ImageRectOffset = Vector2.new(964, 324)
    openLogBtn.ImageRectSize = Vector2.new(36, 36)
    openLogBtn.ZIndex = 5
    Instance.new("UICorner", openLogBtn).CornerRadius = UDim.new(0, 4)
    local logBtnStroke = Instance.new("UIStroke", openLogBtn); logBtnStroke.Color = ThemeColor; logBtnStroke.Thickness = 1.5; table.insert(ThemedStrokes, logBtnStroke)

    local LogModal = Instance.new("Frame", sg)
    LogModal.Size = UDim2.new(0, 360, 0, 330)
    LogModal.Position = UDim2.new(0.5, -180, 0.5, -165)
    LogModal.BackgroundColor3 = Color3.fromRGB(20, 15, 15)
    LogModal.Visible = false
    LogModal.ZIndex = 1000
    Instance.new("UICorner", LogModal).CornerRadius = UDim.new(0, 10)
    local LMStroke = Instance.new("UIStroke", LogModal); LMStroke.Color = ThemeColor; LMStroke.Thickness = 2; table.insert(ThemedStrokes, LMStroke)

    local LMTitle = Instance.new("TextLabel", LogModal); LMTitle.Size = UDim2.new(1, 0, 0, 40); LMTitle.Text = "لوق دخول وخروج لاعبين"; LMTitle.TextColor3 = ThemeColor; LMTitle.Font = Enum.Font.GothamBold; LMTitle.TextSize = 18; LMTitle.BackgroundTransparency = 1; LMTitle.ZIndex = 1001; table.insert(ThemedTexts, LMTitle)
    
    local LMClose = Instance.new("TextButton", LogModal)
    LMClose.Size = UDim2.new(0, 30, 0, 30)
    LMClose.Position = UDim2.new(0, 10, 1, -40)
    LMClose.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    LMClose.TextColor3 = Color3.new(1,1,1)
    LMClose.Font = Enum.Font.GothamBold
    LMClose.TextSize = 14
    LMClose.Text = "X"
    LMClose.ZIndex = 1005 
    Instance.new("UICorner", LMClose).CornerRadius = UDim.new(0, 6)

    local LMSearch = Instance.new("TextBox", LogModal); LMSearch.Size = UDim2.new(0.9, 0, 0, 35); LMSearch.Position = UDim2.new(0.05, 0, 0, 45); LMSearch.PlaceholderText = "🔍 اكتب 3 حروف لإضافة لاعب..."; LMSearch.Text = ""; LMSearch.BackgroundColor3 = Color3.fromRGB(30, 30, 30); LMSearch.TextColor3 = Color3.new(1,1,1); LMSearch.Font = SafeFont; LMSearch.TextSize = 14; LMSearch.ZIndex = 1001; Instance.new("UICorner", LMSearch)
    
    local LMScroll = Instance.new("ScrollingFrame", LogModal); LMScroll.Size = UDim2.new(0.95, 0, 1, -95); LMScroll.Position = UDim2.new(0.025, 0, 0, 85); LMScroll.BackgroundTransparency = 1; LMScroll.ScrollBarThickness = 3; LMScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; LMScroll.ZIndex = 1001
    local LMLayout = Instance.new("UIListLayout", LMScroll); LMLayout.Padding = UDim.new(0, 5)

    _G.PinnedLogUsers = _G.PinnedLogUsers or {}
    _G.TargetUserId = _G.TargetUserId or nil
    LastTargetName = _G.LastTargetName or nil
    
    local function formatTime(seconds)
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        if h > 0 then return string.format("%02d:%02d:%02d", h, m, s) else return string.format("%02d:%02d", m, s) end
    end

    local function CreatePlayerCard(data)
        if LMScroll:FindFirstChild(data.Name:lower()) then return end
        
        local card = Instance.new("Frame", LMScroll)
        card.Name = data.Name:lower()
        card.Size = UDim2.new(1, -10, 0, 85)
        card.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        card.ZIndex = 1002
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local cardStr = Instance.new("UIStroke", card); cardStr.Color = ThemeColor; cardStr.Thickness = 1; cardStr.Transparency = 0.5; table.insert(ThemedStrokes, cardStr)
        
        local pfp = Instance.new("ImageLabel", card); pfp.Size = UDim2.new(0, 50, 0, 50); pfp.Position = UDim2.new(0, 10, 0, 10); pfp.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(data.UserId).."&w=150&h=150"; pfp.BackgroundTransparency = 1; pfp.ZIndex = 1003; Instance.new("UICorner", pfp).CornerRadius = UDim.new(1,0)
        local nameLbl = Instance.new("TextLabel", card); nameLbl.Size = UDim2.new(1, -140, 0, 20); nameLbl.Position = UDim2.new(0, 70, 0, 5); nameLbl.Text = data.DisplayName .. " (@"..data.Name..")"; nameLbl.TextColor3 = Color3.new(1,1,1); nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 13; nameLbl.TextXAlignment = Enum.TextXAlignment.Left; nameLbl.BackgroundTransparency = 1; nameLbl.ZIndex = 1003
        
        local inLbl = Instance.new("TextLabel", card); inLbl.Size = UDim2.new(0, 90, 0, 15); inLbl.Position = UDim2.new(0, 70, 0, 25); inLbl.TextColor3 = Color3.fromRGB(0, 200, 0); inLbl.Font = SafeFont; inLbl.TextSize = 11; inLbl.TextXAlignment = Enum.TextXAlignment.Left; inLbl.BackgroundTransparency = 1; inLbl.ZIndex = 1003
        local outLbl = Instance.new("TextLabel", card); outLbl.Size = UDim2.new(0, 90, 0, 15); outLbl.Position = UDim2.new(0, 70, 0, 40); outLbl.Font = SafeFont; outLbl.TextSize = 11; outLbl.TextXAlignment = Enum.TextXAlignment.Left; outLbl.BackgroundTransparency = 1; outLbl.ZIndex = 1003

        local jCountLbl = Instance.new("TextLabel", card); jCountLbl.Size = UDim2.new(0, 80, 0, 15); jCountLbl.Position = UDim2.new(0, 170, 0, 25); jCountLbl.TextColor3 = Color3.fromRGB(150, 255, 150); jCountLbl.Font = SafeFont; jCountLbl.TextSize = 11; jCountLbl.TextXAlignment = Enum.TextXAlignment.Left; jCountLbl.BackgroundTransparency = 1; jCountLbl.ZIndex = 1003
        local lCountLbl = Instance.new("TextLabel", card); lCountLbl.Size = UDim2.new(0, 80, 0, 15); lCountLbl.Position = UDim2.new(0, 170, 0, 40); lCountLbl.TextColor3 = Color3.fromRGB(255, 150, 150); lCountLbl.Font = SafeFont; lCountLbl.TextSize = 11; lCountLbl.TextXAlignment = Enum.TextXAlignment.Left; lCountLbl.BackgroundTransparency = 1; lCountLbl.ZIndex = 1003

        local timerLbl = Instance.new("TextLabel", card); timerLbl.Size = UDim2.new(0, 60, 0, 20); timerLbl.Position = UDim2.new(1, -70, 0, 5); timerLbl.Text = "00:00"; timerLbl.TextColor3 = ThemeColor; timerLbl.Font = Enum.Font.GothamBold; timerLbl.TextSize = 14; timerLbl.BackgroundTransparency = 1; timerLbl.ZIndex = 1003; table.insert(ThemedTexts, timerLbl)
        
        local delBtn = Instance.new("TextButton", card); delBtn.Size = UDim2.new(0, 25, 0, 25); delBtn.Position = UDim2.new(1, -35, 0, 30); delBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); delBtn.TextColor3 = Color3.new(1,1,1); delBtn.Font = Enum.Font.Gotham; delBtn.TextSize = 12; delBtn.Text = "🗑️"; delBtn.ZIndex = 1003; Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        local rstBtn = Instance.new("TextButton", card); rstBtn.Size = UDim2.new(0, 25, 0, 25); rstBtn.Position = UDim2.new(1, -65, 0, 30); rstBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 180); rstBtn.TextColor3 = Color3.new(1,1,1); rstBtn.Font = Enum.Font.Gotham; rstBtn.TextSize = 12; rstBtn.Text = "🔄"; rstBtn.ZIndex = 1003; Instance.new("UICorner", rstBtn).CornerRadius = UDim.new(0, 6)
        local copyLogBtn = Instance.new("ImageButton", card)
        copyLogBtn.Size = UDim2.new(0, 25, 0, 25)
        copyLogBtn.Position = UDim2.new(1, -95, 0, 30)
        copyLogBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        copyLogBtn.Image = "rbxassetid://6031094678" -- أيقونة النسخ
        copyLogBtn.ZIndex = 1003
        Instance.new("UICorner", copyLogBtn).CornerRadius = UDim.new(0, 6)
        local copyLogStroke = Instance.new("UIStroke", copyLogBtn); copyLogStroke.Color = ThemeColor; copyLogStroke.Thickness = 1.5; table.insert(ThemedStrokes, copyLogStroke)

        delBtn.MouseButton1Click:Connect(function()
            PlayClickSound()
            _G.PinnedLogUsers[data.UserId] = nil
            card:Destroy()
        end)

        rstBtn.MouseButton1Click:Connect(function()
            PlayClickSound()
            local logData = _G.AboudServerLogs[data.UserId]
            if logData then
                logData.Joins = 0; logData.Leaves = 0; logData.JoinTick = os.time(); logData.LeaveTimeStr = nil; logData.Duration = 0
            end
        end)

        copyLogBtn.MouseButton1Click:Connect(function()
            PlayClickSound()
            local logData = _G.AboudServerLogs[data.UserId]
            if logData then
                local timeSpent = timerLbl.Text
                local copyStrText = string.format("👤 اسم اللاعب: %s (@%s)\n⏳ مدة البقاء: %s\n🟢 عدد الدخول: %d\n🔴 عدد الخروج: %d",
                    logData.DisplayName, logData.Name, timeSpent, logData.Joins, logData.Leaves)
                pcall(function() setclipboard(copyStrText) end)
                SendCustomNotification("✅ تم النسخ", "تم نسخ بيانات " .. logData.DisplayName .. " بنجاح!", 4)
            end
        end)

        task.spawn(function()
            while card.Parent do
                local logData = _G.AboudServerLogs[data.UserId]
                if logData then
                    inLbl.Text = "دخل: " .. logData.JoinTimeStr
                    outLbl.Text = logData.LeaveTimeStr and ("خرج: " .. logData.LeaveTimeStr) or "حالة: متصل 🟢"
                    outLbl.TextColor3 = logData.LeaveTimeStr and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
                    jCountLbl.Text = "الدخول: " .. logData.Joins
                    lCountLbl.Text = "الخروج: " .. logData.Leaves
                    
                    if not logData.LeaveTimeStr then
                        timerLbl.Text = formatTime((logData.Duration or 0) + (os.time() - logData.JoinTick))
                    else
                        timerLbl.Text = formatTime(logData.Duration or 0)
                    end
                end
                task.wait(1)
            end
        end)
    end

    for uid, isPinned in pairs(_G.PinnedLogUsers) do
        if isPinned and _G.AboudServerLogs[uid] then
            CreatePlayerCard(_G.AboudServerLogs[uid])
        end
    end

    LMSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local txt = LMSearch.Text:lower()
        if #txt >= 3 then
            for _, data in pairs(_G.AboudServerLogs) do
                if data.Name:lower():find(txt) or data.DisplayName:lower():find(txt) then
                    if not _G.PinnedLogUsers[data.UserId] then
                        _G.PinnedLogUsers[data.UserId] = true
                        CreatePlayerCard(data)
                    end
                end
            end
        end
    end)

    for _, p in ipairs(game.Players:GetPlayers()) do
        if not _G.AboudServerLogs[p.UserId] then
            _G.AboudServerLogs[p.UserId] = { Name = p.Name, DisplayName = p.DisplayName, UserId = p.UserId, AccountAge = p.AccountAge, JoinTimeStr = os.date("%H:%M"), JoinTick = os.time(), LeaveTimeStr = nil, Joins = 1, Leaves = 0, Duration = 0 }
        end
    end

    if not _G.AboudEventsConnected then
        _G.AboudEventsConnected = true
        
        game.Players.PlayerAdded:Connect(function(p)
            if not _G.AboudServerLogs[p.UserId] then
                _G.AboudServerLogs[p.UserId] = { Name = p.Name, DisplayName = p.DisplayName, UserId = p.UserId, AccountAge = p.AccountAge, JoinTimeStr = os.date("%H:%M"), JoinTick = os.time(), LeaveTimeStr = nil, Joins = 1, Leaves = 0, Duration = 0 }
            else
                if _G.AboudServerLogs[p.UserId].LeaveTimeStr ~= nil then 
                    _G.AboudServerLogs[p.UserId].Joins = _G.AboudServerLogs[p.UserId].Joins + 1
                end
                _G.AboudServerLogs[p.UserId].JoinTimeStr = os.date("%H:%M")
                _G.AboudServerLogs[p.UserId].JoinTick = os.time()
                _G.AboudServerLogs[p.UserId].LeaveTimeStr = nil
            end

            -- 🔄 التفعيل التلقائي (Auto Resume) للميزات عند رجوع اللاعب المستهدف
            if LastTargetName and p.Name == LastTargetName then
                task.spawn(function()
                    task.wait(2.5) -- انتظار حتى ترسبن شخصيته بالكامل
                    TargetPlayer = p
                    
                    if _G.TargetUserId == p.UserId then
                        TargetStatusLabel.Text = "✅ متصل الآن"
                        TargetStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
                    end

                    -- إعادة تشغيل المص
                    if _G.isSuck and ToggleSuck then
                        ToggleSuck(false)
                        task.wait(0.2)
                        ToggleSuck(true)
                    end
                    -- إعادة تشغيل البانق الخلفي
                    if isTargetBang and ToggleBangTarget then
                        ToggleBangTarget(false, nil, LP, RS)
                        task.wait(0.2)
                        ToggleBangTarget(true, p, LP, RS)
                    end
                    -- إعادة تشغيل الجلوس على الرأس
                    if isHeadSit and ToggleHeadSit then
                        ToggleHeadSit(false, nil, LP, RS)
                        task.wait(0.2)
                        ToggleHeadSit(true, p, LP, RS)
                    end
                end)
            end
        end)

        game.Players.PlayerRemoving:Connect(function(p)
            local logData = _G.AboudServerLogs[p.UserId]
            if logData and logData.LeaveTimeStr == nil then
                logData.Leaves = logData.Leaves + 1
                logData.Duration = (logData.Duration or 0) + (os.time() - logData.JoinTick)
                logData.LeaveTimeStr = os.date("%H:%M")
            end
            
            if _G.TargetUserId and p.UserId == _G.TargetUserId then
                SendCustomNotification("⚠️ غادر السيرفر", p.DisplayName .. " (@" .. p.Name .. ") طلع من الماب!", 5)
                TargetStatusLabel.Text = "⚠️ غادر السيرفر"
                TargetStatusLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
                TargetPlayer = nil -- نخليه مسحوب لحين عودته
            end
        end)
    end

    openLogBtn.MouseButton1Click:Connect(function() PlayClickSound(); LogModal.Visible = true end)
    LMClose.MouseButton1Click:Connect(function() PlayClickSound(); LogModal.Visible = false end)

    -- 🟢 تفعيل زر النسخ الأساسي (الصورة)
    copyMainBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        if _G.TargetUserId and _G.AboudServerLogs[_G.TargetUserId] then
            local data = _G.AboudServerLogs[_G.TargetUserId]
            local timeSpent = targetTimerLbl.Text
            
            local copyStr = string.format("👤 اسم اللاعب: %s (@%s)\n⏳ مدة البقاء: %s\n🟢 %s\n🔴 %s",
                data.DisplayName, data.Name, timeSpent, joinsL.Text, leavesL.Text)
                
            pcall(function() setclipboard(copyStr) end)
            SendCustomNotification("✅ تم النسخ", "تم نسخ بيانات اللاعب بنجاح!", 4)
        else
            SendCustomNotification("🚫 تنبيه", "يرجى البحث عن لاعب أولاً لنسخ بياناته!", 3)
        end
    end)

    pBox:GetPropertyChangedSignal("Text"):Connect(function() 
        local txt = pBox.Text:lower()
        if txt == "" then return end
        
        local foundData = nil
        -- البحث داخل سجل السيرفر (عشان يجيب اللي طلعوا واللي موجودين)
        for uid, data in pairs(_G.AboudServerLogs) do
            if data.Name:lower():find(txt) or data.DisplayName:lower():find(txt) then
                foundData = data
                break
            end
        end

        if foundData then
            if VIPSupporters and VIPSupporters[foundData.Name] and not VIPSupporters[LP.Name] and not Admins[LP.Name] then 
                TargetPlayer = nil; _G.TargetUserId = nil; pBox.Text = ""; return 
            end
            
            _G.TargetUserId = foundData.UserId
            LastTargetName = foundData.Name
            _G.LastTargetName = foundData.Name
            TargetPlayer = game.Players:GetPlayerByUserId(foundData.UserId)
            
            pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(foundData.UserId).."&w=150&h=150"
            ptxt.Text = foundData.DisplayName
            
            if foundData.AccountAge then
                pcall(function() dateL.Text = GetTr("تاريخ الحساب: ") .. os.date("%Y/%m/%d", os.time() - (foundData.AccountAge * 86400)) end)
            end
            
            joinsL.Text = "مرات الدخول: " .. foundData.Joins
            leavesL.Text = "مرات الخروج: " .. foundData.Leaves 
            
            if TargetPlayer then
                TargetStatusLabel.Text = "✅ متصل الآن"
                TargetStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
            else
                TargetStatusLabel.Text = "⚠️ غادر السيرفر"
                TargetStatusLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
            end
        else
            TargetPlayer = nil
            _G.TargetUserId = nil
            LastTargetName = nil
            pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(LP.UserId).."&w=150&h=150"
            ptxt.Text = "اللاعب غير موجود"
            TargetStatusLabel.Text = "اللاعب غير موجود"
            TargetStatusLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
            dateL.Text = "تاريخ الحساب: ----/--/--"
            joinsL.Text = "مرات الدخول: 0"
            leavesL.Text = "مرات الخروج: 0"
            targetTimerLbl.Text = "00:00:00"
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            if not targetTimerLbl or not targetTimerLbl.Parent then break end
            if _G.TargetUserId then
                local logData = _G.AboudServerLogs[_G.TargetUserId]
                local isConnected = game.Players:GetPlayerByUserId(_G.TargetUserId) ~= nil
                
                if logData then
                    joinsL.Text = "مرات الدخول: " .. logData.Joins
                    leavesL.Text = "مرات الخروج: " .. logData.Leaves
                    
                    if logData.AccountAge then
                        pcall(function() dateL.Text = GetTr("تاريخ الحساب: ") .. os.date("%Y/%m/%d", os.time() - (logData.AccountAge * 86400)) end)
                    end

                    if isConnected then
                        -- الوقت يستمر
                        local currentDur = (logData.Duration or 0) + (os.time() - logData.JoinTick)
                        targetTimerLbl.Text = formatTime(currentDur)
                        TargetStatusLabel.Text = "✅ متصل الآن"
                        TargetStatusLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
                    else
                        -- تجميد الوقت
                        targetTimerLbl.Text = formatTime(logData.Duration or 0)
                        TargetStatusLabel.Text = "⚠️ غادر السيرفر"
                        TargetStatusLabel.TextColor3 = Color3.fromRGB(200, 0, 0)
                    end
                end
            end
        end
    end)

    AddOnOffBtn(Content, "مراقبة:", isWatch, function(state) isWatch = state; SData["Watch"] = state; SaveAll() end)
    AddOnOffBtn(Content, " تنقل (Stay):", isTPStay, function(state) isTPStay = state; SData["TPStay"]=state; SaveAll() end)
    
    local BangAnim = Instance.new("Animation"); BangAnim.AnimationId = "rbxassetid://148843379"; local BangTrack = nil
    local function PlayBangAnim() pcall(function() if LP.Character and LP.Character:FindFirstChild("Humanoid") then local animator = LP.Character.Humanoid:FindFirstChildOfClass("Animator") or LP.Character.Humanoid; if not BangTrack then BangTrack = animator:LoadAnimation(BangAnim) end; BangTrack:Play(0.1, 1, 3) end end) end
    local function StopBangAnim() pcall(function() if BangTrack then BangTrack:Stop() end end) end
    AddOnOffBtn(Content, "بانج فنج أمامي:", isBangFront, function(state) isBangFront = state; SData["BangFront"]=state; SaveAll(); if state then PlayBangAnim() else StopBangAnim() end end)
    
    AddOnOffBtn(Content, "بانج فنج خلفي:", isTargetBang, function(state) 
        isTargetBang = state; SData["TargetBang"] = state; SaveAll()
        if state and not TargetPlayer then SendCustomNotification("🚫 تنبيه", "ابحث عن لاعب أولاً!", 3); return end
        ToggleBangTarget(state, TargetPlayer, LP, RS) 
    end)

    local function ToggleSuck(state)
        if _G.AboudSuckLoop then _G.AboudSuckLoop:Disconnect(); _G.AboudSuckLoop = nil end
        _G.isSuck = state
        if state then
            local currentSpeed = SuckSpeed or 10 
            _G.AboudSuckLoop = RS.Heartbeat:Connect(function()
                if not _G.isSuck or not TargetPlayer then return end
                local myChar = LP.Character
                local myHum = myChar and myChar:FindFirstChild("Humanoid")
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local tChar = TargetPlayer.Character
                local tHum = tChar and tChar:FindFirstChild("Humanoid")
                local tHead = tChar and tChar:FindFirstChild("Head")
                
                if not myChar or not myHum or myHum.Health <= 0 then return end
                if not tChar or not tHum or tHum.Health <= 0 or not tHead then return end
                
                pcall(function()
                    myHum.Sit = true
                    local move = math.sin(tick() * currentSpeed) * 1.5 
                    myRoot.CFrame = tHead.CFrame * CFrame.new(0, 0.2, -0.5 + move) * CFrame.Angles(0, math.rad(180), 0)
                    myRoot.Velocity = Vector3.new(0, 0, 0)
                end)
            end)
        else
            pcall(function()
                local myChar = LP.Character
                local myHum = myChar and myChar:FindFirstChild("Humanoid")
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHum then myHum.Sit = false; myHum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end
                if myRoot then myRoot.Velocity = Vector3.new(0,0,0); myRoot.RotVelocity = Vector3.new(0,0,0) end
            end)
        end
    end

    _G.isSuck = SData["isSuck"] or false
    AddOnOffBtn(Content, " مص:", _G.isSuck, function(state) 
        SData["isSuck"] = state; SaveAll()               
        if state and not TargetPlayer then SendCustomNotification("🚫 تنبيه", "ابحث عن لاعب أولاً من فوق!", 3); return end
        ToggleSuck(state) 
    end)
    
    AddOnOffBtn(Content, "جلوس على رأس اللاعب:", isHeadSit, function(state) 
        isHeadSit = state; SData["HeadSit"] = state; SaveAll()
        if state and not TargetPlayer then SendCustomNotification("🚫 تنبيه", "ابحث عن لاعب أولاً!", 3); return end
        ToggleHeadSit(state, TargetPlayer, LP, RS) 
    end)

    AddOnOffBtn(Content, "شلح اللاعب (حذف الملابس):", isStrip, function(state) 
        isStrip = state; SData["Strip"]=state; SaveAll() 
        if not state then for _, item in pairs(StrippedClothes) do pcall(function() if item.Obj and item.Prnt then item.Obj.Parent = item.Prnt end end) end; StrippedClothes = {} end 
    end)
    
    local isCouchFling = SData["isCouchFling"] or false 
    AddOnOffBtn(Content, "قتل بالكنبة (Fling):", isCouchFling, function(state)
        isCouchFling = state; SData["isCouchFling"] = state; SaveAll()
        if state then
            if not TargetPlayer then SendCustomNotification("🚫 تنبيه", "ابحث عن لاعب أولاً!", 3); return end
            _G.aboud_flingloop = true
            SendCustomNotification("فلنق", "بدأ الفلنق على: " .. TargetPlayer.Name, 3)
            
            task.spawn(function()
                local LocalPlayer = LP; local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local function ClearAllTools() pcall(function() ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools") end) end
                local function GetAndEquipCouch()
                    for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name == "Couch" then v.Grip = CFrame.new(0, 2, -2.5); v.Parent = LocalPlayer.Character; return true end
                    end
                    pcall(function() ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch") end)
                    local startTime = tick()
                    while tick() - startTime < 0.5 do
                        for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v.Name == "Couch" then v.Grip = CFrame.new(0, 2, -2.5); v.Parent = LocalPlayer.Character; return true end
                        end
                        task.wait(0.1)
                    end
                    return false
                end
                local function UnequipCouch()
                    if LocalPlayer.Character then
                        for _, v in ipairs(LocalPlayer.Character:GetChildren()) do if v:IsA("Tool") and v.Name == "Couch" then v.Parent = LocalPlayer.Backpack; return true end end
                    end
                    return false
                end
                local function SkidFling(target, originalPosition)
                    local Character = LocalPlayer.Character; local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid"); local RootPart = Humanoid and Humanoid.RootPart
                    local TCharacter = target.Character; local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid"); local TRootPart = THumanoid and THumanoid.RootPart; local THead = TCharacter and TCharacter:FindFirstChild("Head")
                    if not (Character and Humanoid and RootPart and TCharacter and THumanoid and TRootPart) then return end
                    if THead then workspace.CurrentCamera.CameraSubject = THead elseif THumanoid then workspace.CurrentCamera.CameraSubject = THumanoid end
                    local FPos = function(BasePart, Pos, Ang) RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang; Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang); RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7); RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8) end
                    local SFBasePart = function(BasePart)
                        local TimeToWait = 5; local Time = tick(); local Angle = 0
                        repeat
                            if RootPart and THumanoid then
                                if BasePart.Velocity.Magnitude < 50 then
                                    Angle = Angle + 100
                                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                                else
                                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0,0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0,0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90),0,0)); task.wait()
                                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0)); task.wait()
                                end
                            else break end
                        until BasePart.Velocity.Magnitude > 500 or not BasePart.Parent or not target.Character or Humanoid.Health <= 0 or tick() > Time + TimeToWait or not _G.aboud_flingloop or not isCouchFling
                    end
                    local BV = Instance.new("BodyVelocity"); BV.Parent = RootPart; BV.Velocity = Vector3.new(9e8, 9e8, 9e8); BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    if TRootPart and THead then if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then SFBasePart(THead) else SFBasePart(TRootPart) end elseif TRootPart then SFBasePart(TRootPart) elseif THead then SFBasePart(THead) end
                    BV:Destroy(); Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true); workspace.CurrentCamera.CameraSubject = Humanoid
                    task.wait(0.5); UnequipCouch()
                    if originalPosition and RootPart then RootPart.CFrame = originalPosition; RootPart.Velocity = Vector3.new(0, 0, 0); RootPart.RotVelocity = Vector3.new(0, 0, 0) end
                    task.wait(0.3); ClearAllTools(); workspace.FallenPartsDestroyHeight = -500
                end
                while _G.aboud_flingloop and isCouchFling do
                    pcall(function()
                        local target = TargetPlayer; if not target or not target.Character then return end
                        local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); if not RootPart then return end
                        if RootPart.Velocity.Magnitude < 50 then _G.aboud_OldPos = RootPart.CFrame end
                        workspace.FallenPartsDestroyHeight = 0/0
                        if not GetAndEquipCouch() then SendCustomNotification("خطأ", "لم يتم العثور على الكنبة", 3); workspace.FallenPartsDestroyHeight = -500; isCouchFling = false; _G.aboud_flingloop = false; return end
                        SkidFling(target, _G.aboud_OldPos)
                    end)
                    task.wait(0.1)
                end
            end)
        else
            _G.aboud_flingloop = false
            pcall(function()
                local char = LP.Character; local humanoid = char and char:FindFirstChildOfClass("Humanoid"); local rootPart = humanoid and humanoid.RootPart
                if char then for _, v in ipairs(char:GetChildren()) do if v:IsA("Tool") and v.Name == "Couch" then v.Parent = LP.Backpack end end end
                if rootPart then local bv = rootPart:FindFirstChildOfClass("BodyVelocity"); if bv then bv:Destroy() end; rootPart.Velocity = Vector3.new(0, 0, 0); rootPart.RotVelocity = Vector3.new(0, 0, 0) end
                if humanoid then humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true); workspace.CurrentCamera.CameraSubject = humanoid end
                if _G.aboud_OldPos and rootPart then rootPart.CFrame = _G.aboud_OldPos * CFrame.new(0, 0.5, 0); if char then char:SetPrimaryPartCFrame(_G.aboud_OldPos * CFrame.new(0, 0.5, 0)) end end
                workspace.FallenPartsDestroyHeight = -500
            end)
            SendCustomNotification("🔥 فلنق", "تم ايقاف الفلنق!", 3)
        end
    end)

    local isBoatFling = SData["isBoatFling"] or false
    AddOnOffBtn(Content, "فلنق بالسفينة (مميت):", isBoatFling, function(state)
        isBoatFling = state; SData["isBoatFling"] = state; SaveAll()
        if state then
            if not TargetPlayer then SendCustomNotification("🚫 تنبيه", "ابحث عن لاعب أولاً!", 3); return end
            _G.aboud_boatloop = true
            task.spawn(function()
                local player = LP; local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid"); if not hrp or not hum then return end
                _G.aboud_OldPosBoat = hrp.CFrame; hrp.CFrame = CFrame.new(634.18, -4.00, 1839.65); task.wait(0.5)
                pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree") end)
                local startTime = tick(); local seated = false
                while tick() - startTime < 10 and isBoatFling do
                    local vehicle = workspace.Vehicles:FindFirstChild(player.Name .. "Car")
                    if vehicle then
                        local vehicleSeat = vehicle:FindFirstChild("VehicleSeat") or (vehicle:FindFirstChild("Body") and vehicle.Body:FindFirstChild("VehicleSeat"))
                        if vehicleSeat then
                            hrp.CFrame = vehicleSeat.CFrame * CFrame.new(0, 2, 0); task.wait(0.2)
                            if firetouchinterest then firetouchinterest(hrp, vehicleSeat, 0); firetouchinterest(hrp, vehicleSeat, 1) end
                            task.wait(0.5)
                            if hum.SeatPart == vehicleSeat then seated = true; break end
                        end
                    end
                    task.wait(0.5)
                end
                if not seated then SendCustomNotification("خطأ", "ما قدرت اركب السفينة!", 3); isBoatFling = false; return end
                while _G.aboud_boatloop and isBoatFling do
                    local target = TargetPlayer
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = target.Character.HumanoidRootPart.Position; local vehicle = workspace.Vehicles:FindFirstChild(player.Name .. "Car")
                        if vehicle then local offset = Vector3.new(math.random(-2, 2), -3.5, math.random(-2, 2)); vehicle:SetPrimaryPartCFrame(CFrame.new(targetPos + offset)); hrp.Velocity = Vector3.new(0, 8000, 0); hrp.RotVelocity = Vector3.new(5000, 5000, 5000) end
                    end
                    task.wait(0.05)
                end
            end)
            SendCustomNotification("🛳️", "بدأ الفلنق المميت بالسفينة على: " .. TargetPlayer.Name, 3)
        else
            _G.aboud_boatloop = false
            pcall(function()
                local vehicle = workspace.Vehicles:FindFirstChild(LP.Name .. "Car"); local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); local hum = char and char:FindFirstChild("Humanoid")
                if vehicle then local destination = Vector3.new(-86.00, -224.27, 34.57); vehicle:SetPrimaryPartCFrame(CFrame.new(destination)); if hrp then hrp.CFrame = CFrame.new(destination + Vector3.new(0, 5, 0)) end; task.wait(0.5); vehicle:Destroy() end
                if _G.aboud_OldPosBoat and hrp then hrp.Velocity = Vector3.new(0,0,0); hrp.RotVelocity = Vector3.new(0,0,0); hrp.CFrame = _G.aboud_OldPosBoat end
                if hum then hum.Sit = false; hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end
            end)
            SendCustomNotification("🛳️", "تم ايقاف الفلنق بالسفينة ورجعت لمكانك!", 3)
        end
    end)

    _G.ExpAngle = 0

    -- 🟢 السر اللي جبناه من سكربت Gaze لاستخراج الآيدي الحقيقي للأنيميشن 🟢
    local function GetRealAnimId(catalogId)
        local success, objects = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(catalogId)) end)
        if success and objects and #objects > 0 then
            local obj = objects[1]
            if obj:IsA("Animation") and obj.AnimationId ~= "" then
                return obj.AnimationId
            elseif obj:FindFirstChildOfClass("Animation") then
                return obj:FindFirstChildOfClass("Animation").AnimationId
            end
        end
        return "rbxassetid://" .. tostring(catalogId)
    end

    -- 🟢 إعداد أنيميشن الحضن 🟢
    local HugAnim = Instance.new("Animation")
    HugAnim.AnimationId = GetRealAnimId(102303622774230) -- ✅ تم وضع الآيدي الخاص بك مع دالة التخطي

    local function StopAllExpMoves()
        if _G.ExpLoop then _G.ExpLoop:Disconnect(); _G.ExpLoop = nil end
        pcall(function()
            -- إيقاف أنيميشن الحضن إذا كان شغال
            if _G.HugAnimTrack then _G.HugAnimTrack:Stop(); _G.HugAnimTrack = nil end 
            
            local myHum = LP.Character and LP.Character:FindFirstChild("Humanoid")
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myHum then 
                myHum.Sit = false
                -- ✅ تم التعديل هنا: إرجاع الشخصية لحالتها الطبيعية بدلاً من إلغاء الفيزياء
                myHum:ChangeState(Enum.HumanoidStateType.GettingUp) 
            end
            if myHRP then myHRP.Velocity = Vector3.new(0,0,0); myHRP.RotVelocity = Vector3.new(0,0,0) end
        end)
    end

    local function ToggleTornado(state)
        _G.isTornadoActive = state
        if state then _G.isFootInFaceActive = false; _G.isBouncing = false; _G.isBackpacking = false; _G.isGlitching = false end
        StopAllExpMoves()
        if state then
            if not TargetPlayer then SendCustomNotification("🚫 تنبيه", "يرجى البحث عن ضحية أولاً!", 3); return end
            _G.ExpLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.isTornadoActive or not TargetPlayer then return end
                local myChar = LP.Character; local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart"); local myHum = myChar and myChar:FindFirstChild("Humanoid")
                local tChar = TargetPlayer.Character; local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
                if myHRP and tHRP and myHum then
                    myHum.Sit = true; _G.ExpAngle = _G.ExpAngle + math.rad(30)
                    local radius = 3.5; local offsetX = math.sin(_G.ExpAngle) * radius; local offsetY = math.sin(_G.ExpAngle * 2) * 2; local offsetZ = math.cos(_G.ExpAngle) * radius
                    myHRP.CFrame = tHRP.CFrame * CFrame.new(offsetX, offsetY, offsetZ) * CFrame.Angles(math.rad(_G.ExpAngle*10), math.rad(_G.ExpAngle*20), 0)
                    myHRP.Velocity = Vector3.new(0,0,0)
                end
            end)
        end
    end

    local function ToggleFootInFace(state)
        _G.isFootInFaceActive = state
        if state then _G.isTornadoActive = false; _G.isBouncing = false; _G.isBackpacking = false; _G.isGlitching = false end
        StopAllExpMoves()
        if state then
            if not TargetPlayer then SendCustomNotification("🚫 تنبيه", "يرجى البحث عن ضحية أولاً!", 3); return end
            
            -- 🟢 تشغيل أنيميشن الحضن 🟢
            pcall(function()
                local myHum = LP.Character and LP.Character:FindFirstChild("Humanoid")
                if myHum then
                    local animator = myHum:FindFirstChildOfClass("Animator") or myHum
                    if not _G.HugAnimTrack then
                        _G.HugAnimTrack = animator:LoadAnimation(HugAnim)
                    end
                    _G.HugAnimTrack.Looped = true
                    _G.HugAnimTrack:Play()
                end
            end)

            _G.ExpLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.isFootInFaceActive or not TargetPlayer then return end
                local myChar = LP.Character; local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart"); local myHum = myChar and myChar:FindFirstChild("Humanoid")
                local tChar = TargetPlayer.Character; local tHead = tChar and tChar:FindFirstChild("Head")
                if myHRP and tHead and myHum then
                    -- ✅ تم استخدام الإحداثيات المنخفضة لضمان ضبط مستوى الحضن
                    myHum.Sit = true; myHRP.CFrame = tHead.CFrame * CFrame.new(0, -1.2, -1.8) * CFrame.Angles(0, math.rad(180), 0); myHRP.Velocity = Vector3.new(0,0,0)
                end
            end)
        end
    end

    local function ToggleBounce(state)
        _G.isBouncing = state
        if state then _G.isTornadoActive = false; _G.isFootInFaceActive = false; _G.isBackpacking = false; _G.isGlitching = false end
        StopAllExpMoves()
        if state then
            if not TargetPlayer then SendCustomNotification("🚫 تنبيه", "يرجى البحث عن ضحية أولاً!", 3); return end
            _G.ExpLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.isBouncing or not TargetPlayer or not TargetPlayer.Character then return end
                local tHead = TargetPlayer.Character:FindFirstChild("Head"); local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); local myHum = LP.Character and LP.Character:FindFirstChild("Humanoid")
                if tHead and myRoot and myHum then
                    myHum.Sit = true; local jumpHeight = 3 + math.abs(math.sin(tick() * 8)) * 6
                    myRoot.CFrame = tHead.CFrame * CFrame.new(0, jumpHeight, 0); myRoot.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end

    local function ToggleBackpack(state)
        _G.isBackpacking = state
        if state then _G.isTornadoActive = false; _G.isFootInFaceActive = false; _G.isBouncing = false; _G.isGlitching = false end
        StopAllExpMoves()
        if state then
            if not TargetPlayer then SendCustomNotification("🚫 تنبيه", "يرجى البحث عن ضحية أولاً!", 3); return end
            
            -- 🟢 تشغيل أنيميشن الحضن 🟢
            pcall(function()
                local myHum = LP.Character and LP.Character:FindFirstChild("Humanoid")
                if myHum then
                    local animator = myHum:FindFirstChildOfClass("Animator") or myHum
                    if not _G.HugAnimTrack then
                        _G.HugAnimTrack = animator:LoadAnimation(HugAnim)
                    end
                    _G.HugAnimTrack.Looped = true
                    _G.HugAnimTrack:Play()
                end
            end)

            _G.ExpLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.isBackpacking or not TargetPlayer or not TargetPlayer.Character then return end
                local tRoot = TargetPlayer.Character:FindFirstChild("HumanoidRootPart"); local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if tRoot and myRoot then myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0.5, 1.5); myRoot.Velocity = Vector3.new(0, 0, 0) end
            end)
        end
    end

    local function ToggleGlitch(state)
        _G.isGlitching = state
        if state then _G.isTornadoActive = false; _G.isFootInFaceActive = false; _G.isBouncing = false; _G.isBackpacking = false end
        StopAllExpMoves()
        if state then
            if not TargetPlayer then SendCustomNotification("?? تنبيه", "يرجى البحث عن ضحية أولاً!", 3); return end
            _G.ExpLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if not _G.isGlitching or not TargetPlayer or not TargetPlayer.Character then return end
                local tRoot = TargetPlayer.Character:FindFirstChild("HumanoidRootPart"); local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if tRoot and myRoot then
                    local rx = math.random(-360, 360); local ry = math.random(-360, 360); local rz = math.random(-360, 360)
                    myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 2, 0) * CFrame.Angles(math.rad(rx), math.rad(ry), math.rad(rz)); myRoot.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end

    AddOnOffBtn(Content, "الإعصار المدمر:", _G.isTornadoActive, function(state) _G.isTornadoActive = state; SData["isTornadoActive"] = state; SaveAll(); ToggleTornado(state) end)
    AddOnOffBtn(Content, "حضن امامي:", _G.isFootInFaceActive, function(state) _G.isFootInFaceActive = state; SData["isFootInFaceActive"] = state; SaveAll(); ToggleFootInFace(state) end)
    AddOnOffBtn(Content, "تنطيط على رأس اللاعب:", _G.isBouncing, function(state) _G.isBouncing = state; SData["isBouncing"] = state; SaveAll(); ToggleBounce(state) end)
    AddOnOffBtn(Content, "حضن خلفي:", _G.isBackpacking, function(state) _G.isBackpacking = state; SData["isBackpacking"] = state; SaveAll(); ToggleBackpack(state) end)
    AddOnOffBtn(Content, "جليتش مرعب فوق اللاعب:", _G.isGlitching, function(state) _G.isGlitching = state; SData["isGlitching"] = state; SaveAll(); ToggleGlitch(state) end)

end)
AddNewBadge(playersTabBtn)
local isAimbotEnabled = GetS("AimbotEnabled", false)
local isAimbotEnabled = GetS("AimbotEnabled", false)

local FOVCircle
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.fromRGB(255, 50, 50)
    FOVCircle.Thickness = 1.5
    FOVCircle.Transparency = 1
    FOVCircle.NumSides = 64
    FOVCircle.Radius = 150
    FOVCircle.Filled = false
end)

local AimbotLoop = nil

local function IsPlayerVisible(targetHead, originPos)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    local rayResult = workspace:Raycast(originPos, (targetHead.Position - originPos), rayParams)
    if rayResult and rayResult.Instance then
        return rayResult.Instance:IsDescendantOf(targetHead.Parent)
    end
    return true
end

local function ToggleAimbot(state)
    isAimbotEnabled = state
    pcall(function() SData["AimbotEnabled"] = state; SaveAll() end)
    
    if FOVCircle then FOVCircle.Visible = state end
    
    if state then
        if not AimbotLoop then
            local UIS = game:GetService("UserInputService")
            local Camera = workspace.CurrentCamera
            local Players = game:GetService("Players")
            local LP = Players.LocalPlayer

            AimbotLoop = game:GetService("RunService").RenderStepped:Connect(function()
                if not isAimbotEnabled then return end
                
                local mousePos = UIS:GetMouseLocation()
                if FOVCircle then 
                    FOVCircle.Position = FOVCircle.Position:Lerp(mousePos, 0.6)
                end
                
                local closestPlayer = nil
                local shortestDistance = FOVCircle and FOVCircle.Radius or 150
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                        
                        local isEnemy = true
                        if player.Team ~= nil and LP.Team ~= nil and player.Team == LP.Team then
                            isEnemy = false
                        elseif player.TeamColor ~= nil and LP.TeamColor ~= nil and player.TeamColor == LP.TeamColor then
                            isEnemy = false
                        end
                        
                        if isEnemy then
                            local head = player.Character.Head
                            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                            
                            if onScreen then
                                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                                if distance < shortestDistance then
                                    if IsPlayerVisible(head, Camera.CFrame.Position) then
                                        closestPlayer = player
                                        shortestDistance = distance
                                    end
                                end
                            end
                        end
                    end
                end
                
                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
                end
            end)
        end
    else
        if AimbotLoop then
            AimbotLoop:Disconnect()
            AimbotLoop = nil
        end
    end
end
local featuresTabBtn = Tab("المميزات", 5, function()
    AddToggleWithTextBox(Content, " تفعيل السرعة:", isSpeed, SpeedValue, "سرعة", Color3.new(0, 1, 0), 
        function(state) isSpeed = state; SData["Speed"]=state; SaveAll(); if not state and LP.Character then LP.Character.Humanoid.WalkSpeed = 16 end end,
        function(val) SpeedValue = val; SData["SpeedValue"] = val; SaveAll() end
    )
    
    if not isBrookhaven then
        AddOnOffBtn(Content, "ايم بوت + FOV:", isAimbotEnabled, function(state)
            ToggleAimbot(state)
        end)
        if isAimbotEnabled then ToggleAimbot(true) end
    end

    AddToggleWithTextBox(Content, "طيران (Fly):", isFly, FlySpeed, "طيران", Color3.new(0, 1, 1), 
        function(state) isFly = state; SData["Fly"]=state; SaveAll() end,
        function(val) FlySpeed = val; SData["FlySpeed"] = val; SaveAll() end
    )
    
    AddOnOffBtn(Content, "دوران:", isSpin, function(state) isSpin = state; SData["Spin"]=state; SaveAll() end) 
    AddOnOffBtn(Content, "نكليب:", isNoclip, function(state) isNoclip = state; SData["Noclip"]=state; SaveAll() end) 
    AddOnOffBtn(Content, " ESP:", isESP, function(state) isESP = state; SData["ESP"]=state; SaveAll() end)

    local isFPSBoost = GetS("FPSBoost", false)
    AddOnOffBtn(Content, "وضع تقليل لاق V2 (إزالة التكسرات):", isFPSBoost, function(state)
        isFPSBoost = state; SData["FPSBoost"] = state; SaveAll()
        if state then
            game.Lighting.GlobalShadows = false
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                end
            end
        else
            game.Lighting.GlobalShadows = true
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.Plastic
                    v.CastShadow = true
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 0
                end
            end
        end
    end)

    AddOnOffBtn(Content, "وضع تقليل لاق V1 (إخفاء التفاصيل):", isLowDetail, function(state)
        isLowDetail = state; SData["LowDetail"] = state; SaveAll()
        if state then
            game.Lighting.GlobalShadows = false
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then 
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                end
            end
        else
            game.Lighting.GlobalShadows = true
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then 
                    v.Material = Enum.Material.Plastic
                    v.CastShadow = true
                end
            end
        end
    end)

    AddOnOffBtn(Content, "جودة مريحة للعين:", isEyeComfort, function(state) isEyeComfort = state; SData["EyeComfort"] = state; SaveAll(); if state then CCEffect.Parent = game.Lighting else CCEffect.Parent = nil end end)
    
    local SavedLighting = {
        Brightness = game.Lighting.Brightness,
        ClockTime = game.Lighting.ClockTime,
        GlobalShadows = game.Lighting.GlobalShadows,
        Ambient = game.Lighting.Ambient
    }

    local function ClearShaders()
        for _, v in pairs(game.Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BlurEffect") then
                if v.Name == "AboudShader" then v:Destroy() end
            end
        end
    end

    local function AddShader(class, props)
        local eff = Instance.new(class)
        eff.Name = "AboudShader"
        for k, v in pairs(props) do eff[k] = v end
        eff.Parent = game.Lighting
    end

    local RTXModes = {
        {Name = "الافتراضي", Action = function()
            ClearShaders()
            game.Lighting.Brightness = SavedLighting.Brightness
            game.Lighting.ClockTime = SavedLighting.ClockTime
            game.Lighting.GlobalShadows = SavedLighting.GlobalShadows
            game.Lighting.Ambient = SavedLighting.Ambient
        end},
        {Name = "RTX سينمائي", Action = function()
            ClearShaders()
            game.Lighting.ClockTime = 17
            game.Lighting.Brightness = 2.25
            game.Lighting.GlobalShadows = true
            AddShader("BloomEffect", {Intensity = 0.3, Size = 10, Threshold = 0.8})
            AddShader("ColorCorrectionEffect", {Brightness = 0.1, Contrast = 0.5, Saturation = -0.3, TintColor = Color3.fromRGB(255, 235, 203)})
            AddShader("SunRaysEffect", {Intensity = 0.075, Spread = 0.727})
            AddShader("BlurEffect", {Size = 5})
            AddShader("Atmosphere", {Density = 0.364, Offset = 0.556, Color = Color3.fromRGB(199, 175, 166), Decay = Color3.fromRGB(44, 39, 33), Glare = 0.36, Haze = 1.72})
        end},
        {Name = "طور الحيوي", Action = function()
            ClearShaders()
            AddShader("BloomEffect", {Intensity = 2, Size = 24, Threshold = 0.8})
            AddShader("ColorCorrectionEffect", {Brightness = 0.1, Contrast = 1.2, Saturation = 1})
            AddShader("SunRaysEffect", {Intensity = 0.15, Spread = 1})
        end},
        {Name = "الكئيب", Action = function()
            ClearShaders()
            AddShader("BloomEffect", {Intensity = 1.2, Size = 20, Threshold = 0.9})
            AddShader("ColorCorrectionEffect", {Brightness = -0.1, Contrast = 1.3, Saturation = 0.6, TintColor = Color3.fromRGB(255, 240, 220)})
            AddShader("DepthOfFieldEffect", {FocusDistance = 25, InFocusRadius = 15, NearIntensity = 0.7, FarIntensity = 0.7})
        end},
        {Name = "الواقعي", Action = function()
            ClearShaders()
            AddShader("BloomEffect", {Intensity = 0.8, Size = 16, Threshold = 0.95})
            AddShader("ColorCorrectionEffect", {Brightness = 0.05, Contrast = 1.1, Saturation = 0.7})
            AddShader("SunRaysEffect", {Intensity = 0.08, Spread = 0.8})
        end},
        {Name = "شادر الأجهزة الضعيفة", Action = function()
            ClearShaders()
            AddShader("ColorCorrectionEffect", {Brightness = 0.05, Contrast = 1.1, Saturation = 0.8})
        end}
    }

    local currentRTXIdx = GetS("RTXModeIdx", 1)
    local rtxBtn = Instance.new("TextButton", Content)
    rtxBtn.Size = UDim2.new(1, -10, 0, 35)
    rtxBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    rtxBtn.TextColor3 = Color3.new(1, 1, 1)
    rtxBtn.Font = SafeFont
    rtxBtn.TextSize = 14
    rtxBtn.Text = "تحديد جودة الإضاءة: " .. RTXModes[currentRTXIdx].Name
    rtxBtn.ZIndex = 4
    Instance.new("UICorner", rtxBtn).CornerRadius = UDim.new(0, 6)
    local rtxStroke = Instance.new("UIStroke", rtxBtn)
    rtxStroke.Color = ThemeColor
    rtxStroke.Thickness = 1.5
    table.insert(ThemedStrokes, rtxStroke)

    pcall(function() RTXModes[currentRTXIdx].Action() end)

    rtxBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        currentRTXIdx = currentRTXIdx + 1
        if currentRTXIdx > #RTXModes then currentRTXIdx = 1 end
        rtxBtn.Text = "تحديد جودة الإضاءة: " .. RTXModes[currentRTXIdx].Name
        SData["RTXModeIdx"] = currentRTXIdx
        SaveAll()
        pcall(function() RTXModes[currentRTXIdx].Action() end)
    end)

    local divTheme = Instance.new("Frame", Content)
    divTheme.Size = UDim2.new(1, -10, 0, 2)
    divTheme.BackgroundColor3 = ThemeColor
    divTheme.BorderSizePixel = 0
    divTheme.ZIndex = 4
    table.insert(ThemedBGs, divTheme)

    local Colors = {
        {Name = "أحمر ", Col = Color3.fromRGB(200, 0, 0)}, {Name = "أخضر 🟢", Col = Color3.fromRGB(0, 200, 0)},
        {Name = "أزرق ", Col = Color3.fromRGB(0, 100, 255)}, {Name = "بنفسجي 🟣", Col = Color3.fromRGB(150, 0, 200)},
        {Name = "ذهبي ", Col = Color3.fromRGB(255, 215, 0)}, {Name = "أبيض ⚪", Col = Color3.fromRGB(255, 255, 255)}
    }
    local currentColorIdx = 1
    local colorBtn = Instance.new("TextButton", Content)
    colorBtn.Size = UDim2.new(1, 0, 0, 35)
    colorBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    colorBtn.TextColor3 = Color3.new(1, 1, 1)
    colorBtn.Font = SafeFont
    colorBtn.TextSize = 14
    colorBtn.Text = GetTr("تغيير لون السكربت: ") .. Colors[currentColorIdx].Name
    colorBtn.ZIndex = 4
    Instance.new("UICorner", colorBtn)
    
    colorBtn.MouseButton1Click:Connect(function() 
        PlayClickSound()
        currentColorIdx = currentColorIdx + 1
        if currentColorIdx > #Colors then currentColorIdx = 1 end
        colorBtn.Text = GetTr("تغيير لون السكربت: ") .. Colors[currentColorIdx].Name
        SetTheme(Colors[currentColorIdx].Col) 
    end)
    
    local SkinsPresets = {
        {Name = "الافتراضي", BG = "rbxassetid://2151950106", Color = Color3.fromRGB(128, 0, 32), Font = Enum.Font.SourceSansBold, IsVIP = false},
        {Name = "هاكر", BG = "", Color = Color3.fromRGB(0, 255, 0), Font = Enum.Font.Code, IsVIP = false},
        {Name = "باتمان", BG = "rbxassetid://11416301389", Color = Color3.fromRGB(255, 215, 0), Font = Enum.Font.GothamBold, IsVIP = false},
        {Name = "الثيم الملكي (VIP)", BG = "rbxassetid://6071575925", Color = Color3.fromRGB(255, 215, 0), Font = Enum.Font.GothamBlack, IsVIP = true},
        {Name = "ثيم الفضاء (VIP)", BG = "rbxassetid://7072714488", Color = Color3.fromRGB(150, 0, 255), Font = Enum.Font.GothamBold, IsVIP = true},
        {Name = "قاتل الشياطين (VIP)", BG = "rbxassetid://7403233296", Color = Color3.fromRGB(220, 20, 60), Font = Enum.Font.GothamBold, IsVIP = true}, 
        {Name = "جوجوتسو كايسن (VIP)", BG = "rbxassetid://8413813893", Color = Color3.fromRGB(0, 191, 255), Font = Enum.Font.GothamBold, IsVIP = true}, 
        {Name = "دراغون بول (VIP)", BG = "rbxassetid://6139198305", Color = Color3.fromRGB(255, 140, 0), Font = Enum.Font.GothamBlack, IsVIP = true}, 
        {Name = "شارينغان (VIP)", BG = "rbxassetid://5041865913", Color = Color3.fromRGB(139, 0, 0), Font = Enum.Font.GothamBlack, IsVIP = true}, 
        {Name = "ون بيس (VIP)", BG = "rbxassetid://6341270258", Color = Color3.fromRGB(255, 0, 0), Font = Enum.Font.GothamBold, IsVIP = true}, 
        {Name = "هجوم العمالقة (VIP)", BG = "rbxassetid://5814554336", Color = Color3.fromRGB(34, 139, 34), Font = Enum.Font.GothamBold, IsVIP = true}, 
        {Name = "هنتر x هنتر (VIP)", BG = "rbxassetid://6522851944", Color = Color3.fromRGB(0, 200, 100), Font = Enum.Font.GothamBold, IsVIP = true}, 
        {Name = "ديث نوت (VIP)", BG = "rbxassetid://5386047242", Color = Color3.fromRGB(50, 50, 50), Font = Enum.Font.Code, IsVIP = true},
        {Name = "طوكيو غول (VIP)", BG = "rbxassetid://5256249117", Color = Color3.fromRGB(255, 20, 20), Font = Enum.Font.GothamBlack, IsVIP = true},
        {Name = "مغامرات جوجو (VIP)", BG = "rbxassetid://6814041797", Color = Color3.fromRGB(255, 0, 255), Font = Enum.Font.GothamBold, IsVIP = true}, 
        {Name = "بليتش (VIP)", BG = "rbxassetid://5908003666", Color = Color3.fromRGB(255, 100, 0), Font = Enum.Font.GothamBold, IsVIP = true},
        {Name = "بلاك كلوفر (VIP)", BG = "rbxassetid://6683803874", Color = Color3.fromRGB(100, 0, 0), Font = Enum.Font.GothamBlack, IsVIP = true},
        {Name = "سايبر بانك (VIP)", BG = "rbxassetid://6553813954", Color = Color3.fromRGB(255, 20, 147), Font = Enum.Font.Code, IsVIP = true}, 
        {Name = "ألماس جليدي (VIP)", BG = "rbxassetid://5212563852", Color = Color3.fromRGB(0, 255, 255), Font = Enum.Font.GothamBold, IsVIP = true}, 
        {Name = "فينوم المرعب (VIP)", BG = "rbxassetid://7335607316", Color = Color3.fromRGB(100, 100, 100), Font = Enum.Font.GothamBlack, IsVIP = true},
        {Name = "بركان الغضب (VIP)", BG = "rbxassetid://5681347053", Color = Color3.fromRGB(255, 69, 0), Font = Enum.Font.GothamBold, IsVIP = true},
        {Name = "عاصفة الرعد (VIP)", BG = "rbxassetid://6022802094", Color = Color3.fromRGB(255, 255, 0), Font = Enum.Font.GothamBlack, IsVIP = true},
        {Name = "قمر الدم (VIP)", BG = "rbxassetid://6139198310", Color = Color3.fromRGB(150, 0, 0), Font = Enum.Font.GothamBlack, IsVIP = true},
        {Name = "ظلام حالك (VIP)", BG = "", Color = Color3.fromRGB(200, 200, 200), Font = Enum.Font.GothamBold, IsVIP = true},
        {Name = "نيون مشع (VIP)", BG = "", Color = Color3.fromRGB(0, 255, 150), Font = Enum.Font.GothamBlack, IsVIP = true}
    }

    local currentSkinIdx = GetS("SavedSkinIdx", 1)
    if SkinsPresets[currentSkinIdx] and SkinsPresets[currentSkinIdx].IsVIP and not VIPSupporters[LP.Name] and not Admins[LP.Name] then
        currentSkinIdx = 1
    end

    local skinBtn = Instance.new("TextButton", Content)
    skinBtn.Size = UDim2.new(1, 0, 0, 35)
    skinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    skinBtn.TextColor3 = Color3.new(1, 1, 1)
    skinBtn.Font = SafeFont
    skinBtn.TextSize = 14
    skinBtn.Text = GetTr("🖼️ ستايل السكربت الشامل: ") .. SkinsPresets[currentSkinIdx].Name
    skinBtn.ZIndex = 4
    Instance.new("UICorner", skinBtn)

    skinBtn.MouseButton1Click:Connect(function()
        pcall(function() PlayClickSound() end)
        
        local nextIdx = currentSkinIdx + 1
        if nextIdx > #SkinsPresets then nextIdx = 1 end
        
        local s = SkinsPresets[nextIdx]
        
        if s.IsVIP and not VIPSupporters[LP.Name] and not Admins[LP.Name] then
            SendCustomNotification("🚫 عذراً", "هذا الثيم حصري لداعمين ABD HUB (الـ VIP) فقط!", 4)
            return 
        end
        
        currentSkinIdx = nextIdx
        skinBtn.Text = GetTr("ستايل السكربت الشامل: ") .. s.Name
        
        SData["SavedSkinIdx"] = currentSkinIdx
        if SaveAll then SaveAll() end
        
        if s.BG == "" then 
            MainBGImage.ImageTransparency = 1 
        else 
            MainBGImage.Image = s.BG
            MainBGImage.ImageTransparency = 0.7 
        end
        
        SetTheme(s.Color)
        SafeFont = s.Font
        
        for _, child in pairs(sg:GetDescendants()) do 
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then 
                pcall(function() child.Font = SafeFont end) 
            end 
        end
    end)

    if isBrookhaven then 
        local div = Instance.new("Frame", Content)
        div.Size = UDim2.new(1, -10, 0, 2)
        div.BackgroundColor3 = ThemeColor
        div.BorderSizePixel = 0
        div.ZIndex = 4
        table.insert(ThemedBGs, div)

        local RPLabel = Instance.new("TextLabel", Content)
        RPLabel.Size = UDim2.new(1, 0, 0, 25)
        RPLabel.BackgroundTransparency = 1
        RPLabel.Text = "ABD HUB IS BACK"
        RPLabel.TextColor3 = Color3.new(1, 1, 1)
        RPLabel.Font = SafeFont
        RPLabel.TextSize = 15
        RPLabel.ZIndex = 5

        local RPSpeedValue = GetS("RPSpeedValue", 2)
        local timeAccumulator = 0
        local rpButtonsList = {} 
        
        local ActiveRPMode = GetS("ActiveRPMode", "None")
        local ActiveRPHex = GetS("ActiveRPHex", "None")
        
        local function StopRPColor()
            if _G.RPColorLoop_Aboud then 
                _G.RPColorLoop_Aboud:Disconnect()
                _G.RPColorLoop_Aboud = nil 
            end
        end

        local function StartRPColor(mode, baseColorHex)
            StopRPColor()
            local RE = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
            local RemoteColor = RE and RE:FindFirstChild("1RPNam1eColo1r")
            if not RemoteColor then return end

            local baseColor = baseColorHex and Color3.fromHex(baseColorHex) or Color3.new(1,1,1)

            _G.RPColorLoop_Aboud = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
                timeAccumulator = timeAccumulator + deltaTime
                
                if mode == "Rainbow" then
                    local r = (math.sin(timeAccumulator * RPSpeedValue) * 0.5) + 0.5
                    local g = (math.sin((timeAccumulator * RPSpeedValue) + 2) * 0.5) + 0.5
                    local b = (math.sin((timeAccumulator * RPSpeedValue) + 4) * 0.5) + 0.5
                    pcall(function()
                        RemoteColor:FireServer("PickingRPNameColor", Color3.new(r, g, b))
                        RemoteColor:FireServer("PickingRPBioColor", Color3.new(r, g, b))
                    end)
                elseif mode == "Pulse" then
                    local intensity = (math.sin(timeAccumulator * RPSpeedValue) * 0.5) + 0.5
                    local finalColor = Color3.new(baseColor.R * intensity, baseColor.G * intensity, baseColor.B * intensity)
                    pcall(function()
                        RemoteColor:FireServer("PickingRPNameColor", finalColor)
                        RemoteColor:FireServer("PickingRPBioColor", finalColor)
                    end)
                end
            end)
        end

        local speedFrame = Instance.new("Frame", Content)
        speedFrame.Size = UDim2.new(1, 0, 0, 35)
        speedFrame.BackgroundTransparency = 1
        speedFrame.ZIndex = 4
        
        local speedLbl = Instance.new("TextLabel", speedFrame)
        speedLbl.Size = UDim2.new(0.6, 0, 1, 0)
        speedLbl.Text = "سرعت تلوين لاسم"
        speedLbl.TextColor3 = Color3.new(1, 1, 1)
        speedLbl.Font = SafeFont
        speedLbl.TextSize = 13
        speedLbl.BackgroundTransparency = 1
        speedLbl.TextXAlignment = "Left"
        speedLbl.ZIndex = 4

        local speedBox = Instance.new("TextBox", speedFrame)
        speedBox.Size = UDim2.new(0, 60, 0, 25)
        speedBox.Position = UDim2.new(1, -70, 0.5, -12.5)
        speedBox.PlaceholderText = "السرعة"
        speedBox.Text = tostring(RPSpeedValue)
        speedBox.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
        speedBox.TextColor3 = Color3.new(1,1,1)
        speedBox.Font = SafeFont
        speedBox.TextSize = 12
        speedBox.ZIndex = 4
        Instance.new("UICorner", speedBox)
        table.insert(ThemedMenus, speedBox)
        
        speedBox.FocusLost:Connect(function()
            local val = tonumber(speedBox.Text) or RPSpeedValue
            speedBox.Text = tostring(val)
            RPSpeedValue = val
            SData["RPSpeedValue"] = val
            if SaveAll then SaveAll() end
        end)

        local function AddRPRadioBtn(nameText, mode, colorHex)
            local f = Instance.new("Frame", Content)
            f.Size = UDim2.new(1, 0, 0, 35)
            f.BackgroundTransparency = 1
            f.ZIndex = 4

            local t = Instance.new("TextLabel", f)
            t.Size = UDim2.new(0.7, 0, 1, 0)
            t.Text = nameText
            t.TextColor3 = Color3.new(1, 1, 1)
            t.Font = SafeFont
            t.TextSize = 13
            t.BackgroundTransparency = 1
            t.TextXAlignment = "Left"
            t.ZIndex = 4

            local b = Instance.new("TextButton", f)
            b.Size = UDim2.new(0, 24, 0, 24)
            b.Position = UDim2.new(1, -40, 0.5, -12)
            b.Text = ""
            b.ZIndex = 4
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

            local bStroke = Instance.new("UIStroke", b)
            bStroke.Color = Color3.new(1,1,1)
            bStroke.Thickness = 1.5
            bStroke.Transparency = 0.5

            local checkMark = Instance.new("TextLabel", b)
            checkMark.Size = UDim2.new(1, 0, 1, 0)
            checkMark.BackgroundTransparency = 1
            checkMark.Text = "✓"
            checkMark.TextColor3 = Color3.new(1,1,1)
            checkMark.Font = Enum.Font.GothamBold
            checkMark.TextSize = 16
            checkMark.ZIndex = 5
            checkMark.Visible = false
            
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

            local isThisButtonActive = (ActiveRPMode == mode and (mode == "Rainbow" or ActiveRPHex == colorHex))
            
            if isThisButtonActive then
                checkMark.Visible = true
                b.BackgroundColor3 = ThemeColor
                if not _G.RPColorLoop_Aboud then 
                    StartRPColor(mode, colorHex) 
                end
            end

            table.insert(rpButtonsList, {Btn = b, Check = checkMark, Mode = mode, Hex = colorHex})

            b.MouseButton1Click:Connect(function()
                if PlayClickSound then PlayClickSound() end
                
                local wasActive = checkMark.Visible
                
                for _, data in ipairs(rpButtonsList) do
                    data.Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    data.Check.Visible = false
                end
                
                if wasActive then
                    StopRPColor()
                    ActiveRPMode = "None"
                    ActiveRPHex = "None"
                else
                    b.BackgroundColor3 = ThemeColor
                    checkMark.Visible = true
                    StartRPColor(mode, colorHex)
                    ActiveRPMode = mode
                    ActiveRPHex = colorHex or "None"
                end
                
                SData["ActiveRPMode"] = ActiveRPMode
                SData["ActiveRPHex"] = ActiveRPHex
                if SaveAll then SaveAll() end
            end)
        end

        task.spawn(function()
            while task.wait(0.5) do
                if not Content.Parent then break end 
                for _, data in ipairs(rpButtonsList) do
                    if data.Btn and data.Btn.Parent then
                        data.Btn.BackgroundColor3 = data.Check.Visible and ThemeColor or Color3.fromRGB(40, 40, 40)
                    end
                end
            end
        end)

        AddRPRadioBtn(" تلوين الاسم قوس قزح", "Rainbow", nil)
        AddRPRadioBtn("[._.] ابيض اسود", "Pulse", "#FFFFFF")
        AddRPRadioBtn("[._.] احمر اسود", "Pulse", "#FF0000")
        AddRPRadioBtn("[._.] ازرق اسود", "Pulse", "#0000FF")
        AddRPRadioBtn("[._.] اخضر اسود", "Pulse", "#00FF00")
        AddRPRadioBtn("[._.] اصفر اسود", "Pulse", "#FFFF00")
        AddRPRadioBtn("[._.] ازرق بارد اسود", "Pulse", "#00FFFF")
        AddRPRadioBtn("[._.] وردي اسود", "Pulse", "#FF00FF")
        AddRPRadioBtn("[._.] رمادي اسود", "Pulse", "#808080")
        AddRPRadioBtn("[._.] برتقالي اسود", "Pulse", "#FF8C00")
        AddRPRadioBtn("[._.] بنفسجي اسود", "Pulse", "#800080")
        AddRPRadioBtn("[._.] ليموني اسود", "Pulse", "#32CD32")
        AddRPRadioBtn("[._.] بني اسود", "Pulse", "#8B4513")
        AddRPRadioBtn("[._.] ذهبي اسود", "Pulse", "#FFD700")
        AddRPRadioBtn("[._.] فضي اسود", "Pulse", "#C0C0C0")
        AddRPRadioBtn("[._.] نعناعي اسود", "Pulse", "#98FF98")
        AddRPRadioBtn("[._.] سماوي اسود", "Pulse", "#87CEEB")
        AddRPRadioBtn("[._.] قرمزي اسود", "Pulse", "#DC143C")
        AddRPRadioBtn("[._.] كحلي اسود", "Pulse", "#000080")
        AddRPRadioBtn("[._.] بيج اسود", "Pulse", "#F5F5DC")
        AddRPRadioBtn("[._.] بنفسجي فاتح اسود", "Pulse", "#EE82EE")
    end
end)
AddNewBadge(featuresTabBtn)
local function CreateSpeedClickerGame(parent)
    if parent:FindFirstChild("AboudMiniGame") then return end    
    local GameFrame = Instance.new("Frame", parent)
    GameFrame.Name = "AboudMiniGame"
    GameFrame.Size = UDim2.new(0, 300, 0, 350)
    GameFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    GameFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    GameFrame.ZIndex = 9000
    Instance.new("UICorner", GameFrame).CornerRadius = UDim.new(0, 10)  
    local title = Instance.new("TextLabel", GameFrame); title.Size = UDim2.new(1, 0, 0, 40); title.Text = "تحدي سرعة النقرات ⚡"; title.TextColor3 = ThemeColor; title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 22; title.ZIndex = 9001 
    local close = Instance.new("TextButton", GameFrame); close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -30, 0, 0); close.Text = "X"; close.TextColor3 = Color3.new(1,1,1); close.BackgroundColor3 = Color3.fromRGB(200, 0, 0); close.ZIndex = 9001; Instance.new("UICorner", close)    
    local timeLabel = Instance.new("TextLabel", GameFrame); timeLabel.Size = UDim2.new(1, 0, 0, 30); timeLabel.Position = UDim2.new(0, 0, 0, 50); timeLabel.Text = "الوقت: 10 ثواني"; timeLabel.TextColor3 = Color3.new(1,1,1); timeLabel.BackgroundTransparency = 1; timeLabel.Font = SafeFont; timeLabel.TextSize = 18; timeLabel.ZIndex = 9001
    
    local scoreLabel = Instance.new("TextLabel", GameFrame); scoreLabel.Size = UDim2.new(1, 0, 0, 40); scoreLabel.Position = UDim2.new(0, 0, 0, 80); scoreLabel.Text = "0"; scoreLabel.TextColor3 = Color3.fromRGB(255, 215, 0); scoreLabel.BackgroundTransparency = 1; scoreLabel.Font = Enum.Font.GothamBlack; scoreLabel.TextSize = 40; scoreLabel.ZIndex = 9001   
    local clickBtn = Instance.new("TextButton", GameFrame); clickBtn.Size = UDim2.new(0, 150, 0, 150); clickBtn.Position = UDim2.new(0.5, -75, 0, 150); clickBtn.Text = "ابدأ!"; clickBtn.BackgroundColor3 = ThemeColor; clickBtn.TextColor3 = Color3.new(1,1,1); clickBtn.Font = Enum.Font.GothamBold; clickBtn.TextSize = 25; clickBtn.ZIndex = 9001; Instance.new("UICorner", clickBtn).CornerRadius = UDim.new(1, 0)
    
    local score = 0
    local timeLeft = 10
    local playing = false
    
    clickBtn.MouseButton1Click:Connect(function()
        if not playing then
            playing = true
            score = 0
            timeLeft = 10
            clickBtn.Text = "اضغط!"
            
            task.spawn(function()
                while timeLeft > 0 and GameFrame.Parent do
                    task.wait(1)
                    timeLeft = timeLeft - 1
                    timeLabel.Text = "الوقت: " .. timeLeft .. " ثواني"
                end
                if not GameFrame.Parent then return end
                playing = false
                clickBtn.Text = "إعادة"
                timeLabel.Text = "انتهى الوقت!"


if score > HighScore then
                    HighScore = score
                    SData["MiniGameHighScore"] = HighScore
                    SaveAll()
                    SendCustomNotification("🏆 رقم قياسي جديد!", "حققت أعلى سكور في اللعبة: " .. HighScore, 5)
                end
            end)
        end
        if playing then
            score = score + 1
            scoreLabel.Text = tostring(score)
            
            clickBtn.Size = UDim2.new(0, 140, 0, 140)
            clickBtn.Position = UDim2.new(0.5, -70, 0, 155)
            task.wait(0.05)
            clickBtn.Size = UDim2.new(0, 150, 0, 150)
            clickBtn.Position = UDim2.new(0.5, -75, 0, 150)
        end
    end)
    close.MouseButton1Click:Connect(function() GameFrame:Destroy() end)
end

local function CreateXOGame(parent)
    if parent:FindFirstChild("AboudXOGame") then return end
    
    local GameFrame = Instance.new("Frame", parent)
    GameFrame.Name = "AboudXOGame"
    GameFrame.Size = UDim2.new(0, 300, 0, 390)
    GameFrame.Position = UDim2.new(0.5, -150, 0.5, -195)
    GameFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    GameFrame.ZIndex = 9000
    Instance.new("UICorner", GameFrame).CornerRadius = UDim.new(0, 10)
    
    local title = Instance.new("TextLabel", GameFrame); title.Size = UDim2.new(1, 0, 0, 40); title.Text = "لعبة X O ضد بوت 🎮"; title.TextColor3 = ThemeColor; title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 22; title.ZIndex = 9001
    local close = Instance.new("TextButton", GameFrame); close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -30, 0, 0); close.Text = "X"; close.TextColor3 = Color3.new(1,1,1); close.BackgroundColor3 = Color3.fromRGB(200, 0, 0); close.ZIndex = 9001; Instance.new("UICorner", close)
    local status = Instance.new("TextLabel", GameFrame); status.Size = UDim2.new(1, 0, 0, 30); status.Position = UDim2.new(0, 0, 0, 40); status.Text = "دورك (X)"; status.TextColor3 = Color3.new(1,1,1); status.BackgroundTransparency = 1; status.Font = SafeFont; status.TextSize = 18; status.ZIndex = 9001
    
    local scores = Instance.new("TextLabel", GameFrame); scores.Size = UDim2.new(1, 0, 0, 20); scores.Position = UDim2.new(0, 0, 0, 65); scores.Text = "أنت: 0 | البوت: 0"; scores.TextColor3 = Color3.new(1,1,0); scores.BackgroundTransparency = 1; scores.Font = SafeFont; scores.TextSize = 16; scores.ZIndex = 9001
    
    local Grid = Instance.new("Frame", GameFrame)
    Grid.Size = UDim2.new(0, 240, 0, 240); Grid.Position = UDim2.new(0.5, -120, 0, 100); Grid.BackgroundTransparency = 1; Grid.ZIndex = 9001
    local UIGrid = Instance.new("UIGridLayout", Grid); UIGrid.CellSize = UDim2.new(0, 75, 0, 75); UIGrid.CellPadding = UDim2.new(0, 5, 0, 5)
    
    local buttons = {}
    local gameOver = false
    local pScore, bScore = 0, 0

    local function CheckWin()
        local winLines = {
            {1,2,3}, {4,5,6}, {7,8,9},
            {1,4,7}, {2,5,8}, {3,6,9},
            {1,5,9}, {3,5,7}
        }
        for _, line in ipairs(winLines) do
            if buttons[line[1]].Text ~= "" and buttons[line[1]].Text == buttons[line[2]].Text and buttons[line[2]].Text == buttons[line[3]].Text then
                return buttons[line[1]].Text
            end
        end
        local tie = true
        for i=1,9 do if buttons[i].Text == "" then tie = false end end
        if tie then return "Tie" end
        return nil
    end

    local function BotTurn()
        if gameOver then return end
        local empty = {}
        for i=1,9 do if buttons[i].Text == "" then table.insert(empty, i) end end
        if #empty > 0 then
            local pick = nil
            local winLines = {{1,2,3},{4,5,6},{7,8,9},{1,4,7},{2,5,8},{3,6,9},{1,5,9},{3,5,7}}
            
            local function findBestMove(mark)
                for _, line in ipairs(winLines) do
                    local count, eSpot = 0, nil
                    for _, idx in ipairs(line) do
                        if buttons[idx].Text == mark then count = count + 1
                        elseif buttons[idx].Text == "" then eSpot = idx end
                    end
                    if count == 2 and eSpot then return eSpot end
                end
                return nil
            end

            pick = findBestMove("O")
            if not pick then pick = findBestMove("X") end
            if not pick and buttons[5].Text == "" then pick = 5 end
            if not pick then
                local corners = {1,3,7,9}
                local availableCorners = {}
                for _, c in ipairs(corners) do if buttons[c].Text == "" then table.insert(availableCorners, c) end end
                if #availableCorners > 0 then pick = availableCorners[math.random(1, #availableCorners)] end
            end
            if not pick then pick = empty[math.random(1, #empty)] end

            buttons[pick].Text = "O"
            buttons[pick].TextColor3 = Color3.fromRGB(50, 50, 255)
            local winner = CheckWin()
            if winner then
                gameOver = true
                if winner == "Tie" then status.Text = "تعادل!" else status.Text = "فاز البوت!"; bScore = bScore + 1; scores.Text = "أنت: "..pScore.." | البوت: "..bScore end
                task.delay(1.5, function()
                    for j=1,9 do buttons[j].Text = "" end
                    gameOver = false; status.Text = "دورك (X)"
                end)
            else
                status.Text = "دورك (X)"
            end
        end
    end

    for i = 1, 9 do
        local btn = Instance.new("TextButton", Grid)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.Text = ""; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBlack; btn.TextSize = 35; btn.ZIndex = 9002; Instance.new("UICorner", btn)
        buttons[i] = btn
        
        btn.MouseButton1Click:Connect(function()
            if gameOver or btn.Text ~= "" or status.Text ~= "دورك (X)" then return end
            PlayClickSound()
            btn.Text = "X"
            btn.TextColor3 = Color3.fromRGB(255, 50, 50)
            
            local winner = CheckWin()
            if winner then
                gameOver = true
                if winner == "Tie" then status.Text = "تعادل!" else status.Text = "أنت فزت!"; pScore = pScore + 1; scores.Text = "أنت: "..pScore.." | البوت: "..bScore end
                task.delay(1.5, function()
                    for j=1,9 do buttons[j].Text = "" end
                    gameOver = false; status.Text = "دورك (X)"
                end)
            else
                status.Text = "دور البوت..."
                task.delay(0.5, BotTurn)
            end
        end)
    end
    close.MouseButton1Click:Connect(function() GameFrame:Destroy() end)
end

local function CreateSnakeGame(parent)
    if parent:FindFirstChild("AboudSnakeGame") then return end
    
    local GameFrame = Instance.new("Frame", parent)
    GameFrame.Name = "AboudSnakeGame"
    GameFrame.Size = UDim2.new(0, 260, 0, 360)
    GameFrame.Position = UDim2.new(0.5, -130, 0.5, -180)
    GameFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    GameFrame.ZIndex = 9000
    Instance.new("UICorner", GameFrame).CornerRadius = UDim.new(0, 10)
    
    local title = Instance.new("TextLabel", GameFrame); title.Size = UDim2.new(1, 0, 0, 40); title.Text = "لعبة الأفعى 🐍"; title.TextColor3 = ThemeColor; title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 22; title.ZIndex = 9001
    local close = Instance.new("TextButton", GameFrame); close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -30, 0, 0); close.Text = "X"; close.TextColor3 = Color3.new(1,1,1); close.BackgroundColor3 = Color3.fromRGB(200, 0, 0); close.ZIndex = 9001; Instance.new("UICorner", close)
    local scoreLabel = Instance.new("TextLabel", GameFrame); scoreLabel.Size = UDim2.new(1, 0, 0, 30); scoreLabel.Position = UDim2.new(0, 0, 0, 40); scoreLabel.Text = "السكور: 0"; scoreLabel.TextColor3 = Color3.new(1,1,1); scoreLabel.BackgroundTransparency = 1; scoreLabel.Font = SafeFont; scoreLabel.TextSize = 18; scoreLabel.ZIndex = 9001
    
    local GridBG = Instance.new("Frame", GameFrame)
    GridBG.Size = UDim2.new(0, 200, 0, 200); GridBG.Position = UDim2.new(0.5, -100, 0, 80); GridBG.BackgroundColor3 = Color3.fromRGB(10, 10, 10); GridBG.ZIndex = 9001; Instance.new("UICorner", GridBG)

    local Controls = Instance.new("Frame", GameFrame)
    Controls.Size = UDim2.new(1, 0, 0, 100); Controls.Position = UDim2.new(0, 0, 1, -85); Controls.BackgroundTransparency = 1; Controls.ZIndex = 9001

    local loseMsg = Instance.new("TextLabel", GameFrame)
    loseMsg.Size = UDim2.new(1, 0, 1, 0)
    loseMsg.Position = UDim2.new(0, 0, 0, 0)
    loseMsg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loseMsg.BackgroundTransparency = 0.2
    loseMsg.Text = "لقد خسرت با الافعى XO"
    loseMsg.TextColor3 = Color3.fromRGB(255, 50, 50)
    loseMsg.Font = Enum.Font.GothamBold
    loseMsg.TextSize = 22
    loseMsg.ZIndex = 9010
    loseMsg.Visible = false
    Instance.new("UICorner", loseMsg).CornerRadius = UDim.new(0, 10)

    local snake = {{x=5,y=5}}
    local dir = {x=1,y=0}
    local food = {x=10,y=10}
    local playing = true
    local score = 0
    local cellSize = 13.33

    local function spawnFood()
        food.x = math.random(1, 15)
        food.y = math.random(1, 15)
    end

    local function UpdateGrid()
        for _, v in pairs(GridBG:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        
        local fx = Instance.new("Frame", GridBG); fx.Size = UDim2.new(0, 13, 0, 13); fx.Position = UDim2.new(0, (food.x-1)*cellSize, 0, (food.y-1)*cellSize); fx.BackgroundColor3 = Color3.fromRGB(255, 0, 0); fx.ZIndex = 9002; Instance.new("UICorner", fx).CornerRadius = UDim.new(1,0)
        
        for i, s in ipairs(snake) do
            local p = Instance.new("Frame", GridBG); p.Size = UDim2.new(0, 13, 0, 13); p.Position = UDim2.new(0, (s.x-1)*cellSize, 0, (s.y-1)*cellSize); p.BackgroundColor3 = i==1 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 200, 0); p.ZIndex = 9002; Instance.new("UICorner", p)
        end
    end

    local function MakeBtn(txt, pos, cb)
        local b = Instance.new("TextButton", Controls)
        b.Size = UDim2.new(0, 45, 0, 45); b.Position = pos; b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(50, 50, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 20; b.ZIndex = 9002; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(cb)
    end

    MakeBtn("▲", UDim2.new(0.5, -22.5, 0, 0), function() if dir.y == 0 then dir = {x=0,y=-1} end end)
    MakeBtn("▼", UDim2.new(0.5, -22.5, 0, 50), function() if dir.y == 0 then dir = {x=0,y=1} end end)
    MakeBtn("◀", UDim2.new(0.5, -72.5, 0, 50), function() if dir.x == 0 then dir = {x=-1,y=0} end end)
    MakeBtn("▶", UDim2.new(0.5, 27.5, 0, 50), function() if dir.x == 0 then dir = {x=1,y=0} end end)

    close.MouseButton1Click:Connect(function() playing = false; GameFrame:Destroy() end)

    task.spawn(function()
        while playing and GameFrame.Parent do
            task.wait(0.15)
            local h = snake[1]
            local nx = h.x + dir.x
            local ny = h.y + dir.y

            if nx < 1 or nx > 15 or ny < 1 or ny > 15 then 
                playing = false; scoreLabel.Text = "خسرت! السكور: "..score; loseMsg.Visible = true; 
                task.delay(2, function() if GameFrame and GameFrame.Parent then GameFrame:Destroy() end end)
                break 
            end
            local collides = false
            for _, s in ipairs(snake) do if s.x == nx and s.y == ny then collides = true; break end end
            if collides then 
                playing = false; scoreLabel.Text = "خسرت! السكور: "..score; loseMsg.Visible = true; 
                task.delay(2, function() if GameFrame and GameFrame.Parent then GameFrame:Destroy() end end)
                break 
            end

            table.insert(snake, 1, {x=nx, y=ny})
            if nx == food.x and ny == food.y then
                score = score + 1
                scoreLabel.Text = "السكور: " .. score
                spawnFood()
            else
                table.remove(snake)
            end
            UpdateGrid()
        end
    end)
end

local othersTabBtn = Tab("أخرى", 6, function()
    local function AddInputControl(titleTxt, currentVal, callback)
        local f = Instance.new("Frame", Content); f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundTransparency = 1; f.ZIndex = 4
        local t = Instance.new("TextLabel", f); t.Size = UDim2.new(0.6, 0, 1, 0); t.Text = GetTr(titleTxt); t.TextColor3 = Color3.new(1, 1, 1); t.Font = SafeFont; t.TextSize = 13; t.BackgroundTransparency = 1; t.TextXAlignment = "Left"; t.ZIndex = 4

        local tb = Instance.new("TextBox", f); tb.Size = UDim2.new(0, 60, 0, 25); tb.Position = UDim2.new(1, -70, 0.5, -12.5); tb.PlaceholderText = GetTr("سرعة"); tb.Text = tostring(currentVal); tb.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12); tb.TextColor3 = Color3.new(1,1,1); tb.Font = SafeFont; tb.TextSize = 12; tb.ZIndex = 4; Instance.new("UICorner", tb); table.insert(ThemedMenus, tb)
        tb.FocusLost:Connect(function() local val = tonumber(tb.Text) or currentVal; tb.Text = tostring(val); pcall(callback, val) end)
    end

    AddInputControl("سرعتbang1", BangFrontSpeed, function(val) BangFrontSpeed = val; SData["BangFrontSpeed"] = val; SaveAll() end)
    AddInputControl("سرعت bang", BangBackSpeed, function(val) BangBackSpeed = val; SData["BangBackSpeed"] = val; SaveAll() end)
    AddInputControl("سرعت m:", SuckSpeed or 150, function(val) SuckSpeed = val; SData["SuckSpeed"] = val; SaveAll() end)

    local divMain1 = Instance.new("Frame", Content); divMain1.Size = UDim2.new(1, -10, 0, 2); divMain1.BackgroundColor3 = ThemeColor; divMain1.BorderSizePixel = 0; divMain1.ZIndex = 4

    if isBrookhaven then
        local function AddTPBtn(nameKey, targetPosition)
            local btn = Instance.new("TextButton", Content); btn.Size = UDim2.new(1, -10, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = SafeFont; btn.TextSize = 14; btn.Text = GetTr(nameKey); btn.ZIndex = 4; Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(function() PlayClickSound(); if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition) end end)
        end
        AddTPBtn("📍 البدايه", Vector3.new(-24.42, 6.78, -19.33)); AddTPBtn("📍 مقر سري 1", Vector3.new(182.10, 6.81, -406.99)); AddTPBtn("📍 مقر سري ثاني", Vector3.new(-703.93, 4.30, 1063.55)); AddTPBtn("📍 مركز شرطه", Vector3.new(-118.90, 4.60, -10.99))
        local div = Instance.new("Frame", Content); div.Size = UDim2.new(1, -10, 0, 2); div.BackgroundColor3 = Color3.fromRGB(80, 80, 80); div.BorderSizePixel = 0; div.ZIndex = 4
    else
        local lbl = Instance.new("TextLabel", Content); lbl.Size = UDim2.new(1, 0, 0, 30); lbl.BackgroundTransparency = 1; lbl.Text = GetTr("⚠️ الانتقالات الخاصة ببروكهافن معطلة في هذا الماب."); lbl.TextColor3 = Color3.new(1,0.3,0.3); lbl.Font = SafeFont; lbl.TextSize = 14
    end

    -- 🌟 الزر الجديد: إخفاء/إظهار التاج الخاص بك من شاشتك (مع حفظ الحالة)
    if _G.HideMyTagLocally == nil then _G.HideMyTagLocally = false end
    
    local toggleTagBtn = Instance.new("TextButton", Content)
    toggleTagBtn.Size = UDim2.new(1, -10, 0, 35)
    toggleTagBtn.BackgroundColor3 = _G.HideMyTagLocally and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(130, 0, 150)
    toggleTagBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleTagBtn.Font = SafeFont
    toggleTagBtn.TextSize = 14
    toggleTagBtn.Text = _G.HideMyTagLocally and GetTr("إظهار رتبتك") or GetTr("إخفاء رتبتك")
    toggleTagBtn.ZIndex = 4
    Instance.new("UICorner", toggleTagBtn)

    toggleTagBtn.MouseButton1Click:Connect(function() 
        PlayClickSound() 
        _G.HideMyTagLocally = not _G.HideMyTagLocally
        if _G.HideMyTagLocally then
            toggleTagBtn.Text = GetTr("إظهار رتبتك")
            toggleTagBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        else
            toggleTagBtn.Text = GetTr("إخفاء رتبتك")
            toggleTagBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 150)
        end
    end)

    local divMain3 = Instance.new("Frame", Content); divMain3.Size = UDim2.new(1, -10, 0, 2); divMain3.BackgroundColor3 = ThemeColor; divMain3.BorderSizePixel = 0; divMain3.ZIndex = 4

    local saveBtn = Instance.new("TextButton", Content); saveBtn.Size = UDim2.new(1, -10, 0, 35); saveBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0); saveBtn.TextColor3 = Color3.new(1, 1, 1); saveBtn.Font = SafeFont; saveBtn.TextSize = 14; saveBtn.Text = GetTr("✅ حفظ تشيك بوينت"); saveBtn.ZIndex = 4; Instance.new("UICorner", saveBtn)
    saveBtn.MouseButton1Click:Connect(function() PlayClickSound(); if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then savedCheckpoint = LP.Character.HumanoidRootPart.CFrame; SendCustomNotification(GetTr("✅ حفظ تشيك بوينت"), GetTr("تم حفظ مكانك بنجاح!"), 3) end end)

    local tpBtn = Instance.new("TextButton", Content); tpBtn.Size = UDim2.new(1, -10, 0, 35); tpBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 150); tpBtn.TextColor3 = Color3.new(1, 1, 1); tpBtn.Font = SafeFont; tpBtn.TextSize = 14; tpBtn.Text = GetTr("🚀 تنقل للتشيك بوينت"); tpBtn.ZIndex = 4; Instance.new("UICorner", tpBtn)
    tpBtn.MouseButton1Click:Connect(function() PlayClickSound(); if savedCheckpoint and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then LP.Character.HumanoidRootPart.CFrame = savedCheckpoint end end)

    local delBtn = Instance.new("TextButton", Content); delBtn.Size = UDim2.new(1, -10, 0, 35); delBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); delBtn.TextColor3 = Color3.new(1, 1, 1); delBtn.Font = SafeFont; delBtn.TextSize = 14; delBtn.Text = GetTr("🗑️ إزالة التشيك بوينت"); delBtn.ZIndex = 4; Instance.new("UICorner", delBtn)
    delBtn.MouseButton1Click:Connect(function() PlayClickSound(); savedCheckpoint = nil; SendCustomNotification(GetTr("🗑️ إزالة التشيك بوينت"), GetTr("تم مسح مكان الحفظ!"), 3) end)
end)
local serverTabBtn, serverTabFunc = Tab(" سيرفر", 7, function()
    -- دالة عشان نوحد تصميم الأزرار وتكون فخمة وتناسب هوية السكربت
    local function createServerBtn(text, textColor)
        local btn = Instance.new("TextButton", Content)
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = textColor or Color3.new(1, 1, 1)
        btn.Font = SafeFont
        btn.TextSize = 14
        btn.Text = text
        btn.ZIndex = 4
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local str = Instance.new("UIStroke", btn)
        str.Color = ThemeColor
        str.Thickness = 1.5
        str.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(ThemedStrokes, str)
        
        return btn
    end

    local rj = createServerBtn("إعادة دخول السيرفر", Color3.fromRGB(255, 100, 100))
    rj.MouseButton1Click:Connect(function() 
        PlayClickSound()
        SendCustomNotification(GetTr("⚠️ جاري النقل"), GetTr("جاري إعادة الدخول لنفس السيرفر..."), 4)
        task.delay(0.5, function()
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP) 
            end)
        end)
    end)    
    local sh = createServerBtn("🚀دخول سيرفر آخر (فيه ناس)", Color3.fromRGB(100, 255, 100))
    sh.MouseButton1Click:Connect(function() 
        PlayClickSound()
        SendCustomNotification(GetTr("🚀 جاري البحث"), "جاري البحث عن سيرفر مناسب وغير ممتلئ...", 4)
        task.spawn(function()
            pcall(function()
                local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
                local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
                if success and result and result.data then
                    local validServers = {}
                    for _, s in pairs(result.data) do 
                        if type(s) == "table" and s.playing and s.maxPlayers then
                            if s.playing >= 5 and s.playing <= (s.maxPlayers - 3) and s.id ~= game.JobId then 
                                table.insert(validServers, s.id)
                            end
                        end
                    end
                    if #validServers > 0 then
                        local randomServerId = validServers[math.random(1, #validServers)]
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServerId, LP)
                    else
                        SendCustomNotification("🚫 عذراً", "لم يتم العثور على سيرفر مناسب حالياً، حاول مرة أخرى.", 3)
                    end
                end
            end)
        end)
    end)
    
    local emptyHop = createServerBtn("دخول سيرفر فاضي", Color3.fromRGB(100, 150, 255))
    emptyHop.MouseButton1Click:Connect(function() 
        PlayClickSound()
        SendCustomNotification(GetTr("⚠️ جاري النقل"), GetTr("جاري البحث عن سيرفر فاضي..."), 4)
        task.spawn(function() 
            local success, result = pcall(function() return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) end)
            if success and result and result.data then
                for _, s in pairs(result.data) do 
                    if type(s) == "table" and s.playing and s.playing > 0 and s.playing <= 3 and s.id ~= game.JobId then 
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                        break 
                    end 
                end 
            end
        end) 
    end)
    local copyIdBtn = createServerBtn("نسخ معرف السيرفر (JobId)", Color3.fromRGB(255, 215, 0))
    copyIdBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        pcall(function() setclipboard(game.JobId) end)
        SendCustomNotification("✅ تم النسخ", "تم نسخ معرف السيرفر بنجاح!", 3)
    end)
    local joinSpecificFrame = Instance.new("Frame", Content)
    joinSpecificFrame.Size = UDim2.new(1, -10, 0, 45)
    joinSpecificFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    joinSpecificFrame.ZIndex = 4
    Instance.new("UICorner", joinSpecificFrame).CornerRadius = UDim.new(0, 6)
    local jsStr = Instance.new("UIStroke", joinSpecificFrame)
    jsStr.Color = ThemeColor
    jsStr.Thickness = 1.5
    table.insert(ThemedStrokes, jsStr)

    local jobIdBox = Instance.new("TextBox", joinSpecificFrame)
    jobIdBox.Size = UDim2.new(0.65, 0, 1, -10)
    jobIdBox.Position = UDim2.new(0, 5, 0, 5)
    jobIdBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    jobIdBox.TextColor3 = Color3.new(1, 1, 1)
    jobIdBox.Font = SafeFont
    jobIdBox.TextSize = 12
    jobIdBox.PlaceholderText = "أدخل معرف السيرفر هنا..."
    jobIdBox.Text = ""
    jobIdBox.ClearTextOnFocus = false
    jobIdBox.ZIndex = 5
    Instance.new("UICorner", jobIdBox).CornerRadius = UDim.new(0, 4)

    local joinSpecificBtn = Instance.new("TextButton", joinSpecificFrame)
    joinSpecificBtn.Size = UDim2.new(0.3, 0, 1, -10)
    joinSpecificBtn.Position = UDim2.new(0.68, 0, 0, 5)
    joinSpecificBtn.BackgroundColor3 = ThemeColor
    joinSpecificBtn.TextColor3 = Color3.new(1, 1, 1)
    joinSpecificBtn.Font = SafeFont
    joinSpecificBtn.TextSize = 13
    joinSpecificBtn.Text = "دخول 🚀"
    joinSpecificBtn.ZIndex = 5
    Instance.new("UICorner", joinSpecificBtn).CornerRadius = UDim.new(0, 4)
    table.insert(ThemedBGs, joinSpecificBtn)

    joinSpecificBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        local idToJoin = string.gsub(jobIdBox.Text, "^%s*(.-)%s*$", "%1") -- يمسح المسافات لو اللاعب نسخها بالغلط
        if idToJoin ~= "" then
            SendCustomNotification("⚠️ جاري النقل", "جاري محاولة الدخول للسيرفر المطلوب...", 3)
            task.delay(0.5, function()
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, idToJoin, LP)
                end)
            end)
        else
            SendCustomNotification("🚫 تنبيه", "يرجى كتابة معرف السيرفر أولاً!", 3)
        end
    end)
end)
Tab("سكربتات", 8, function()
    local sBox = Instance.new("TextBox", Content)
    sBox.Size = UDim2.new(1, -10, 0, 35)
    sBox.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12)
    sBox.TextColor3 = Color3.new(1, 1, 1)
    sBox.Font = SafeFont
    sBox.TextSize = 13
    sBox.PlaceholderText = " 🔍 ابحث عن أي دسكربت..."    
    sBox.Text = ""
    sBox.ZIndex = 4
    sBox.BorderSizePixel = 0 -- شلنا التوهج والحدود عشان يصير رايق
    Instance.new("UICorner", sBox).CornerRadius = UDim.new(0, 6)
    
    -- تم حذف الـ UIStroke من مربع البحث حسب طلبك عشان نشيل التوهج

    local statusLbl = Instance.new("TextLabel", Content)
    statusLbl.Size = UDim2.new(1, -10, 0, 18)
    statusLbl.BackgroundTransparency = 1
    statusLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    statusLbl.Font = SafeFont
    statusLbl.TextSize = 11
    statusLbl.Text = " يعرض سكربتاتك الخاصة، ويجيب نتائج إضافية من البحث العالمي"
    statusLbl.ZIndex = 4

    local gridContainer = Instance.new("Frame", Content)
    gridContainer.Size = UDim2.new(1, -10, 0, 300)
    gridContainer.BackgroundTransparency = 1
    
    local gridLayout = Instance.new("UIGridLayout", gridContainer)
    gridLayout.CellSize = UDim2.new(0.48, 0, 0, 135)
    gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 10)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- سكربتاتك الأصلية كاملة
    local LocalScriptHubDB = {
        {
            Title = "🕺 سكربت الرقصات",
            Desc = "جميع رقصات روبلوكس الشهيرة، يعمل بكل المابات بشكل ممتاز.",
            Trending = true,
            Views = "25.4k",
            Action = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Gaze-emotes-V1-54374"))() end
        },
        {
            Title = "💬 عبود شات",
            Desc = "سكربت مخصص للدردشة والتحكم بالنصوص في اللعبة.",
            Trending = false,
            Views = "12.1k",
            Action = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/abdarhman798/ABD-HUB-Scripts/refs/heads/main/ABD%20CHAT.txt"))() end
        },
        {
            Title = "🏎️ تفحيط بروكهافن",
            Desc = "تحكم كامل بالسيارة، سرعة (بروكهافن فقط).",
            Brookhaven = true,
            Trending = true,
            Views = "48.9k",
            Action = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-BROOKHAVEN-VEHICLE-CONTROLLER-V17-108803"))() end
        },
        {
            Title = "انميشن",
            Desc = "سكربت يقوم بي فرك بي انشاء انميشن وسخ.",
            Trending = true,
            Views = "31.0k",
            Action = function() loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))() end
        },
        {
            Title = "اوتو كليك",
            Desc = "سكربت اوتو كليك يضغط على الشاشة مستحيل يطلعك.",
            Trending = true,
            Views = "19.5k",
            Action = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/abdarhman798/ABD-HUB-Scripts/refs/heads/main/ABDUD.txt"))() end
        },
        {
            Title = "حياة سفانا",
            Desc = "اقوه سكربت ماب سافانا تم تطويره من قبل عبود.",
            Trending = false,
            Views = "8.3k",
            Action = function()loadstring(game:HttpGet("https://raw.githubusercontent.com/abdarhman798/ABD-HUB-Scripts/refs/heads/main/SAVANA.txt"))()
end
        },
        {
            Title = "قفل شاشه (Close)",
            Desc = "سكربت يقوم بتقفيل حركت لاعب كويس لبعض المابات.",
            Trending = false,
            Views = "6.4k",
            Action = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/SALAH142876/SSjJ/refs/heads/main/hhhhgsgsg"))() end
        },
        {
            Title = "جوده وروسومات",
            Desc = "سكربت يغيرلك طقس وجو الماب خصيصاً لبروكهافن.",
            Trending = false,
            Views = "15.2k",
            Action = function() loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-PShade-Ultimate-15694'))() end
        }
    }

    local function RenderCard(titleText, descText, viewsText, isTrending, executeCallback)
        local card = Instance.new("Frame", gridContainer)
        card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        card.ZIndex = 4
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        local str = Instance.new("UIStroke", card)
        str.Color = ThemeColor
        str.Thickness = 1.5
        table.insert(ThemedStrokes, str)
        
        if isTrending then
            local badge = Instance.new("TextLabel", card)
            badge.Size = UDim2.new(0, 50, 0, 16)
            badge.Position = UDim2.new(0.5, -25, 0, -8)
            badge.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            badge.TextColor3 = Color3.new(1,1,1)
            badge.Font = SafeFont
            badge.TextSize = 11
            badge.Text = "🔥 رائج"
            badge.ZIndex = 5
            Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
        end
        
        -- الصورة اللي طلبتها
        local cardIcon = Instance.new("ImageLabel", card)
        cardIcon.Size = UDim2.new(0, 35, 0, 35)
        cardIcon.Position = UDim2.new(0, 8, 0, 10)
        cardIcon.BackgroundTransparency = 1
        cardIcon.Image = "rbxassetid://98441714450166"
        cardIcon.ZIndex = 5
        Instance.new("UICorner", cardIcon).CornerRadius = UDim.new(0, 6)

        -- سحبنا النصوص لليمين شوي عشان ما تغطي على الصورة
        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(1, -55, 0, 20)
        title.Position = UDim2.new(0, 50, 0, 10)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = SafeFont
        title.TextSize = 13
        title.Text = titleText
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.ZIndex = 5
        
        local viewsLbl = Instance.new("TextLabel", card)
        viewsLbl.Size = UDim2.new(1, -55, 0, 15)
        viewsLbl.Position = UDim2.new(0, 50, 0, 30)
        viewsLbl.BackgroundTransparency = 1
        viewsLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
        viewsLbl.Font = SafeFont
        viewsLbl.TextSize = 11
        viewsLbl.Text = "👁️ " .. tostring(viewsText)
        viewsLbl.TextXAlignment = Enum.TextXAlignment.Left
        viewsLbl.ZIndex = 5

        local desc = Instance.new("TextLabel", card)
        desc.Size = UDim2.new(1, -16, 0, 35)
        desc.Position = UDim2.new(0, 8, 0, 50)
        desc.BackgroundTransparency = 1
        desc.TextColor3 = Color3.new(0.7,0.7,0.7)
        desc.Font = SafeFont
        desc.TextSize = 10
        desc.TextWrapped = true
        desc.Text = descText
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.ZIndex = 5

        local execBtn = Instance.new("TextButton", card)
        execBtn.Size = UDim2.new(0.8, 0, 0, 25)
        execBtn.Position = UDim2.new(0.1, 0, 1, -30)
        execBtn.BackgroundColor3 = ThemeColor
        execBtn.TextColor3 = Color3.new(1,1,1)
        execBtn.Font = SafeFont
        execBtn.TextSize = 12
        execBtn.Text = "تشغيل 🚀"
        execBtn.ZIndex = 5
        Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 4)
        table.insert(ThemedBGs, execBtn)
        
        execBtn.MouseButton1Click:Connect(function()
            if PlayClickSound then PlayClickSound() end
            if isBanned then return end
            pcall(function() executeCallback() end)
            SendCustomNotification("✅ تشغيل", "تم تشغيل السكربت بنجاح", 3)
        end)
    end

    local isSearching = false

    local function LoadScripts(query)
        if isSearching then return end
        
        for _, v in pairs(gridContainer:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end
        
        local queryLower = query:lower()
        local count = 0

        for _, scr in ipairs(LocalScriptHubDB) do
            if scr.Brookhaven and not isBrookhaven then continue end
            
            if queryLower == "" or scr.Title:lower():find(queryLower) or scr.Desc:lower():find(queryLower) then
                count = count + 1
                RenderCard(scr.Title, scr.Desc, scr.Views, scr.Trending, scr.Action)
            end
        end

        if queryLower ~= "" then
            isSearching = true
            statusLbl.Text = "⏳ جاري البحث عبر السيرفرات..."
            
            task.spawn(function()
                local url = "https://scriptblox.com/api/script/search?q="..game:GetService("HttpService"):UrlEncode(query).."&max=10&mode=free"
                local success, response = pcall(function()
                    return game:HttpGetAsync(url)
                end)

                if success and response then
                    local decoded = game:GetService("HttpService"):JSONDecode(response)
                    local scripts = {}
                    if decoded and decoded.result and decoded.result.scripts then
                        scripts = decoded.result.scripts
                    end

                    for _, scr in ipairs(scripts) do
                        count = count + 1
                        local viewsCount = tonumber(scr.views) or 0
                        local formattedViews = viewsCount
                        if viewsCount >= 1000 then formattedViews = string.format("%.1fk", viewsCount / 1000) end

                        RenderCard(
                            scr.title or "بدون اسم",
                            scr.features or "لا يوجد وصف",
                            formattedViews,
                            viewsCount > 5000,
                            function()
                                if scr.script then
                                    loadstring(scr.script)()
                                end
                            end
                        )
                    end
                    statusLbl.Text = "✅ تم العثور على " .. count .. " نتيجة"
                else
                    statusLbl.Text = "✅ تم عرض النتائج المحلية فقط"
                end
                
                local rows = math.ceil(count / 2)
                gridContainer.Size = UDim2.new(1, -10, 0, rows * 145)
                isSearching = false
            end)
        else
            statusLbl.Text = "⚡ يعرض سكربتاتك، ويجيب نتائج إضافية من البحث العالمي"
            local rows = math.ceil(count / 2)
            gridContainer.Size = UDim2.new(1, -10, 0, rows * 145)
        end
    end

    local searchDelay = nil
    sBox:GetPropertyChangedSignal("Text"):Connect(function()
        local txt = sBox.Text
        if searchDelay then task.cancel(searchDelay) end
        
        searchDelay = task.delay(0.5, function()
            LoadScripts(txt)
        end)
    end)

    LoadScripts("")
end)


if isBrookhaven then
    Tab("سكنات", 9, function()
        local pprof = Instance.new("Frame", Content); pprof.Size = UDim2.new(1, 0, 0, 95); pprof.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12); pprof.BackgroundTransparency = 0.35; pprof.ZIndex = 4; Instance.new("UICorner", pprof); table.insert(ThemedMenus, pprof)
        local pimg = Instance.new("ImageLabel", pprof); pimg.Size = UDim2.new(0, 70, 0, 70); pimg.Position = UDim2.new(0, 10, 0.5, -35); pimg.ZIndex = 4; Instance.new("UICorner", pimg)
        local ptxt = Instance.new("TextLabel", pprof); ptxt.Size = UDim2.new(1, -220, 0, 25); ptxt.Position = UDim2.new(0, 90, 0, 10); ptxt.BackgroundTransparency = 1; ptxt.TextColor3 = Color3.new(1, 1, 1); ptxt.Font = SafeFont; ptxt.TextSize = 15; ptxt.TextXAlignment = Enum.TextXAlignment.Left; ptxt.ZIndex = 4
        
        local cBox = Instance.new("TextBox", pprof); cBox.Size = UDim2.new(0, 120, 0, 25); cBox.Position = UDim2.new(1, -130, 0, 10); cBox.PlaceholderText = "ابحث عن الاعب"; cBox.Text = ""; cBox.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12); cBox.TextColor3 = Color3.new(1, 1, 1); cBox.Font = SafeFont; cBox.TextSize = 12; cBox.ZIndex = 4; Instance.new("UICorner", cBox); table.insert(ThemedMenus, cBox)

        local cBoxStroke = Instance.new("UIStroke", cBox); cBoxStroke.Color = Color3.fromRGB(255, 255, 255); cBoxStroke.Thickness = 1.5; cBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        local pstatus = Instance.new("TextLabel", pprof); pstatus.Size = UDim2.new(1, -220, 0, 15); pstatus.Position = UDim2.new(0, 90, 0, 35); pstatus.BackgroundTransparency = 1; pstatus.Font = SafeFont; pstatus.TextSize = 12; pstatus.TextXAlignment = Enum.TextXAlignment.Left; pstatus.ZIndex = 4

        if SkinTarget and SkinTarget.Parent == game.Players then
            cBox.Text = SkinTarget.Name
            pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..SkinTarget.UserId.."&w=150&h=150"; ptxt.Text = SkinTarget.DisplayName; pstatus.Text = "@" .. SkinTarget.Name; pstatus.TextColor3 = Color3.fromRGB(0, 200, 0); 
        else
            pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"; ptxt.Text = LP.DisplayName; pstatus.Text = "لم يتم البحث"; pstatus.TextColor3 = Color3.new(0.7,0.7,0.7)
        end

        cBox:GetPropertyChangedSignal("Text"):Connect(function() 
            local txt = cBox.Text:lower(); 
            if txt == "" then
                SkinTarget = nil
                pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
                ptxt.Text = "لم يتم البحث"
                pstatus.Text = "يرجى البحث عن لاعب"
                pstatus.TextColor3 = Color3.new(0.7,0.7,0.7)
            else
                local found = false
                for _, v in pairs(game.Players:GetPlayers()) do 
                    if v ~= LP and (v.Name:lower():find(txt) or v.DisplayName:lower():find(txt)) then 
                        SkinTarget = v; pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..v.UserId.."&w=150&h=150"; ptxt.Text = v.DisplayName; pstatus.Text = "@" .. v.Name; pstatus.TextColor3 = Color3.fromRGB(0, 200, 0); found = true; return 
                    end 
                end 
                if not found then
                    SkinTarget = nil
                    pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
                    ptxt.Text = "اللاعب غير موجود"
                    pstatus.Text = "اللاعب غير موجود!"
                    pstatus.TextColor3 = Color3.fromRGB(200, 0, 0)
                end
            end
        end)

        local function copyAvatar(TPlayer)
            if not TPlayer or not TPlayer.Character then SendCustomNotification(GetTr("🚫 تنبيه"), GetTr("اللاعب غير موجود!"), 3); return end
            if not isBrookhaven then SendCustomNotification(GetTr("⚠️ تنبيه"), GetTr("هذه الميزة تعمل في ماب بروكهافن فقط!"), 3); return end
            
            local LChar = LP.Character; local LHumanoid = LChar and LChar:FindFirstChildOfClass("Humanoid")
            local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid"); if not LHumanoid or not THumanoid then return end
            
            SendCustomNotification(GetTr("👕 سكنات"), GetTr("جاري نسخ سكن: ") .. TPlayer.Name .. "\n(قد يأخذ بعض الوقت للنسخ الكامل)", 5)
            local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 2); if not Remotes then return end

            task.spawn(function()
                pcall(function()
                    local function toggleItem(id) 
                        if id and id ~= "" and id ~= 0 and tonumber(id) and tonumber(id) > 0 then 
                            pcall(function() Remotes.Wear:InvokeServer(tonumber(id)) end)
                            task.wait(0.6) -- ⏳ تم تبطيء التركيب هنا عشان السيرفر يستوعب القطعة بقوة
                        end 
                    end
                    
                    -- الخطوة الأولى: تشليح اللاعب بالكامل للحصول على جسم فارغ تماماً
                    local LDesc = LHumanoid:GetAppliedDescription()
                    if LDesc then
                        for _, acc in ipairs(LDesc:GetAccessories(true)) do 
                            pcall(function() Remotes.Wear:InvokeServer(tonumber(acc.AssetId)) end)
                            task.wait(0.2) -- ⏳ إضافة انتظار خفيف عند مسح الإكسسوارات القديمة
                        end
                        local localClothes = {LDesc.Shirt, LDesc.Pants, LDesc.GraphicTShirt, LDesc.Face, LDesc.Head}
                        for _, c in ipairs(localClothes) do 
                            if c and tonumber(c) and tonumber(c) > 0 then
                                pcall(function() Remotes.Wear:InvokeServer(tonumber(c)) end)
                                task.wait(0.2) 
                            end
                        end
                    end
                    task.wait(1.5) -- ⏳ انتظار أطول لتنظيف الجسم قبل تركيب السكن الجديد

                    -- الخطوة الثانية: تطبيق خصائص الضحية بدقة
                    local PDesc = THumanoid:GetAppliedDescription(); if not PDesc then return end
                    
                    -- نسخ أجزاء الجسم (شامل الأرجل والرأس والأيدي)
                    local argsBody = {[1] = {[1] = PDesc.Torso, [2] = PDesc.RightArm, [3] = PDesc.LeftArm, [4] = PDesc.RightLeg, [5] = PDesc.LeftLeg, [6] = PDesc.Head}}
                    pcall(function() Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody)) end)
                    task.wait(1.5) -- ⏳ انتظار السيرفر يركب أجزاء الجسم الجديد

                    -- نسخ الملابس والوجه
                    toggleItem(PDesc.Shirt)
                    toggleItem(PDesc.Pants)
                    toggleItem(PDesc.GraphicTShirt)
                    toggleItem(PDesc.Face)
                    
                    -- نسخ الإكسسوارات (شعر، قبعات، حقائب...)
                    for _, acc in ipairs(PDesc:GetAccessories(true)) do 
                        toggleItem(acc.AssetId) 
                    end
                    
                    -- نسخ لون البشرة
                    local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")
                    if SkinColor then 
                        pcall(function() Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor)) end)
                        task.wait(0.8) -- ⏳ تبطيء بعد تغيير اللون
                    end
                    
                    -- نسخ الأنيميشن
                    toggleItem(PDesc.IdleAnimation)
                    toggleItem(PDesc.WalkAnimation)
                    toggleItem(PDesc.RunAnimation)
                    toggleItem(PDesc.JumpAnimation)

                    -- نسخ الـ RP Name
                    local Bag = TPlayer:FindFirstChild("PlayersBag")
                    if Bag then
                        if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then pcall(function() Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value) end); task.wait(0.5) end
                        if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then pcall(function() Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value) end); task.wait(0.5) end
                        if Bag:FindFirstChild("RPNameColor") then pcall(function() Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value) end); task.wait(0.5) end
                        if Bag:FindFirstChild("RPBioColor") then pcall(function() Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value) end); task.wait(0.5) end
                    end
                    SendCustomNotification(GetTr("✅ تم النسخ"), GetTr("تم نسخ السكن بنجاح!"), 4)

                    -- 🟢 تسجيل التقدم في مهمة استنساخ السكنات (تاب المهمات) 🟢
                    if _G.AddSkinCopyProgress then _G.AddSkinCopyProgress() end

                end)
            end)
        end
 
        local function createSkinBtn(text, iconStr, color, callback)
            local btn = Instance.new("TextButton", Content)
            btn.Size = UDim2.new(1, -10, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = color
            btn.Font = SafeFont
            btn.TextSize = 15
            btn.Text = iconStr .. " " .. text
            btn.ZIndex = 4
            Instance.new("UICorner", btn)
            
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = ThemeColor
            stroke.Thickness = 1.5
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- ✨ هذا السطر اللي يمنع التوهج عن النص
            table.insert(ThemedStrokes, stroke)
            
            btn.MouseButton1Click:Connect(function() PlayClickSound(); callback() end)
            return btn
        end

        createSkinBtn(GetTr("نسخ سكن اللاعب المحدد"), "🎯", Color3.fromRGB(0, 150, 255), function()
            if SkinTarget then copyAvatar(SkinTarget) else SendCustomNotification(GetTr("🚫 تنبيه"), GetTr("ابحث عن لاعب أولاً!"), 3) end
        end)
        
        createSkinBtn(GetTr("نسخ سكن أقرب لاعب"), "📍", Color3.fromRGB(0, 255, 100), function()
            local LChar = LP.Character; if not LChar or not LChar:FindFirstChild("HumanoidRootPart") then return end
            local closest, minDist = nil, math.huge
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LChar.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < minDist then minDist = dist; closest = p end
                end
            end
            if closest then copyAvatar(closest) else SendCustomNotification(GetTr("🚫 تنبيه"), GetTr("لا يوجد لاعب قريب!"), 3) end
        end)
        
        createSkinBtn(GetTr("نسخ سكن عشوائي"), "🎲", Color3.fromRGB(255, 150, 0), function()
            local others = {}
            for _, p in ipairs(game.Players:GetPlayers()) do if p ~= LP and p.Character then table.insert(others, p) end end
            if #others > 0 then copyAvatar(others[math.random(1, #others)]) else SendCustomNotification(GetTr("🚫 تنبيه"), GetTr("لا يوجد لاعبين!"), 3) end
        end)
    end)
end

if isBrookhaven then
    local musicTabBtn = Tab("الأغاني", 10, function()

        local mFrame = Instance.new("Frame", Content)
        mFrame.Size = UDim2.new(1, -10, 0, 90)
        mFrame.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12)
        mFrame.BackgroundTransparency = 0.35
        mFrame.ZIndex = 4
        Instance.new("UICorner", mFrame)
        table.insert(ThemedMenus, mFrame)
        local stroke = Instance.new("UIStroke", mFrame); stroke.Color = ThemeColor; stroke.Thickness = 2; table.insert(ThemedStrokes, stroke)

        local idBox = Instance.new("TextBox", mFrame)
        idBox.Size = UDim2.new(0.9, 0, 0, 35)
        idBox.Position = UDim2.new(0.05, 0, 0, 10)
        idBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        idBox.TextColor3 = Color3.new(1, 1, 1)
        idBox.Font = SafeFont
        idBox.TextSize = 14
        idBox.PlaceholderText = GetTr("أدخل كود الأغنية هنا...")
        idBox.Text = ""
        idBox.ZIndex = 4
        Instance.new("UICorner", idBox)

        local function PlayGhostMusic(id)
            if not isBrookhaven then SendCustomNotification(GetTr("⚠️ تنبيه"), "الأغاني تعمل فقط في ماب بروكهافن!", 3); return end
            task.spawn(function()
                local RE = game:GetService("ReplicatedStorage"):FindFirstChild("RE")
                local Remote = RE and RE:FindFirstChild("1NoMoto1rVehicle1s")
                if Remote then
                    pcall(function() Remote:FireServer("Delete NoMotorVehicle") end)
                    for _,v in pairs(workspace:GetDescendants()) do
                        if v.Name == "NoMotorVehicleModel" then v:Destroy() end
                    end
                    task.wait(0.5)
                    pcall(function()
                        Remote:FireServer("SkateBoard")
                        Remote:FireServer("PickingScooterMusicText", tostring(id))
                    end)
                    SendCustomNotification("🎵", "تم تشغيل الأغنية للسيرفر بنجاح!", 3)
                end
            end)
        end
        local playBtn = Instance.new("TextButton", mFrame)
        playBtn.Size = UDim2.new(0.9, 0, 0, 30)
        playBtn.Position = UDim2.new(0.05, 0, 0, 50)
        playBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        playBtn.TextColor3 = Color3.new(1, 1, 1)
        playBtn.Font = SafeFont
        playBtn.TextSize = 14
        playBtn.Text = GetTr("▶️ تشغيل الأغنية")
        playBtn.ZIndex = 4
        Instance.new("UICorner", playBtn)

        playBtn.MouseButton1Click:Connect(function()
            PlayClickSound()
            local rawText = idBox.Text
            local id = rawText:match("%d+")
            if id then PlayGhostMusic(id) else SendCustomNotification(GetTr("🚫 تنبيه"), "الرجاء إدخال أرقام فقط!", 3) end
        end)

        local div = Instance.new("Frame", Content); div.Size = UDim2.new(1, -10, 0, 2); div.BackgroundColor3 = ThemeColor; div.BackgroundTransparency = 0.5; div.BorderSizePixel = 0; div.ZIndex = 4

        local function createPresetSong(nameKey, songId)
            local btn = Instance.new("TextButton", Content)
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = SafeFont
            btn.TextSize = 14
            btn.Text = "🎧 " .. GetTr(nameKey)
            btn.ZIndex = 4
            Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(function()
                PlayClickSound()

                local cleanId = songId:match("%d+")
                if cleanId then
                    idBox.Text = cleanId
                    PlayGhostMusic(cleanId)
                end
            end)
        end
        createPresetSong("عود فخم", "114157294180725")
        createPresetSong("ريمكس Dj", "130012558337510")
        createPresetSong("يابهDj", "136909019669593")
        createPresetSong("Dj", "106251060487387")
        createPresetSong("جربها ودعيلي Dj", "73883012408965")
        createPresetSong("عود", "72601818107644")
        createPresetSong("للي عاحبو", "80281881556916")  
        createPresetSong("مصري ليه بتنسى", "109409053513561")
        createPresetSong("مصري الي بيخاف", "115153161936086")
        createPresetSong("كنق ناصر", " 76650356472656 ")
        createPresetSong("ليه ساكت", "13556605790477")
        createPresetSong("مصري رايق", "10609918876009")
        createPresetSong("مصري حلوهه", "132683832148231")
        createPresetSong("كل القلوب عربي", "95995712530649")
        createPresetSong("طبله عربي", "103899260817392")
        createPresetSong("علي يا ابو الحسين عراقي", "98224127892587")
        createPresetSong("عراقي لو تبوس", "80039364766636")
        createPresetSong("دبكه", "76698985299412")
        createPresetSong("سوري يابك ها يا", "98640789490482")
        createPresetSong("دبكة سوري", "130467285446008")
        createPresetSong("تروح وترجعلي مقهور", "131004009162099")
        createPresetSong("ليه ساكت عزا ريمكس", "119437864395329")
        createPresetSong("عود ٢", "82584945884001")
        createPresetSong("عزيز وحنين طاطاوين", "137718075939941")
        createPresetSong("طرب عربي", "85209271197446")
        createPresetSong("عود عربي", "119205613821143")
        createPresetSong("دندن عربي", "97653993295845")
        createPresetSong("عود حائل", "86818715772064")
        createPresetSong("عربي الناس يتغير", "110363399283800")
        createPresetSong("جينا عادي عربي", "131507511127909")
        createPresetSong("شوي شوي انساك", "72918998227337")
        createPresetSong("سعوديين", "87506143975621")
        createPresetSong("اه ياحلو", "93620598835551")
        createPresetSong("مصري طرب", "123555966146480")
        createPresetSong("مصري 1", "98509241790002")
        createPresetSong("مصري 2", "76221024204234")
        createPresetSong("برازيلي 1", "111668097052966")
        createPresetSong("برازيلي 2", "94301557485291")
        createPresetSong("برازيل6", "119372546759640")
        createPresetSong("اجنبي 1", "95583505197638")
        createPresetSong("اجنبي 2", "119936139925486")
        createPresetSong("اجنبي 3", "76578817848504")
        createPresetSong("اجنبي 4", "85481949732828")
        createPresetSong("اجنبي 5", "109805678713575")
        createPresetSong("اجنبي 6", "71517955953236")
        createPresetSong("أجنبي طرب 1", "138465939141547")
        createPresetSong("اجنبي طرب 2", "126422410489839")
        createPresetSong("اجنبي راقي", "135018311294635")
        createPresetSong("اجنبي حريقه", "105976374466752")
        createPresetSong("راب اجنبي طرب", "17422074849")
        createPresetSong("اجنبي 7", "83298925967923")
        createPresetSong("اجنبي طرب 3", "74459138150344")
        createPresetSong("اجنبي قوي", "112448168063121")
        createPresetSong("اجنبي مولع طرب", "132127013599275")
        createPresetSong("اجنبي طرب 4", "93257309679175")
        createPresetSong("برازيلي 3", "100243051031264")
        createPresetSong("كود 1", "93133248032532")
        createPresetSong("كود 2", "71061449238812")
        createPresetSong("اجنبي تخبل", "139202008782317")
        createPresetSong("funk", "119439195710921")
        createPresetSong("funk2", "80442979651569")
        createPresetSong("كود3", "102225934895254")
        createPresetSong("راقي اجنبي", "72892187453679")
        createPresetSong("اجنبي حزين", "ا127012181396114")
        createPresetSong("اجنبي حزين 2", "983103344398449")
        createPresetSong("اجنبي حزين 3", "105848553383746")
        createPresetSong("اجنبي حزين4", "75286443923155")
        createPresetSong("حزين5", "121765516317425")
        createPresetSong("فلاش باك للماضي 💔 ", "81351156382687")
        createPresetSong("اجنبي حلوه", "121559463895939")
        createPresetSong("اجنبي رومنسي", "138067913531622")
        createPresetSong("طرببب", "716117262062506")
        createPresetSong("اجنبي هجوله ", "75817059227467ا")
        createPresetSong("اجنبي طرب2", "131483103484346")
        createPresetSong("اجنبي Arua", "97491944760306")
        createPresetSong("اجنبي بوم", "96915668633711")
        createPresetSong("اجنبي للفيم بوي", "121242950842428")
        createPresetSong("اجنبي مقرنات", "121755260609793")
        createPresetSong("اجنبي حق حفلات", "91007045451630")
        createPresetSong("2اجنبي حق حفلات", "112163139287560")
        createPresetSong("عراقي فخم", "93297302504653")
        createPresetSong("عراقي ياخذني ويطير", "106271890575602")
        createPresetSong("الله يسامحك ياقلبي", "116815742960163")
        createPresetSong("ميت اني من فرقاكم", "98313375960954")
        createPresetSong("عراقي جفاني", "126189830749452")
        createPresetSong("اغنيه", "131241214341563")
        createPresetSong("اغنيه", "99787280635612")
        createPresetSong("اغنيه", "126033753974793")
        createPresetSong("غنيه", "92370754457408")
        createPresetSong("اغاني", "126583820883563")
        createPresetSong("اغنيه", "73174693707449")
        createPresetSong("عثمان بالندور", "118882222304453")
        createPresetSong("اغنيه", "80281881556916")
        createPresetSong("Of", "128289955798159")
        createPresetSong("ريمكس عراقي شراره", "81023003196738")
        createPresetSong("... ", "137486973114353")
        createPresetSong("... ", "113458227429706")
        createPresetSong("نشيد", "124393177931443")
        createPresetSong("نشيد2", "118001441128581")
        createPresetSong("ازعاج", "140498577577255")
        createPresetSong("نشيد3", "100754234156181")
        createPresetSong("نشيد4", "131985065755673")
        createPresetSong("نشيد5", " 131985065755673  ")
        createPresetSong("سكران", " 111811908070601   ")
        createPresetSong("نشيد قامت الدوله", "129963257934687 ")
        createPresetSong("راب كلاش", "94943308357738")
        createPresetSong("سب كسمك", "75745765058107  ")
        createPresetSong("سب1", "6536444735")
        createPresetSong("سب2", "8701632845")
        createPresetSong("سب3", "88304661583351")
        createPresetSong("سب ي قواد", "102909674189396")
        createPresetSong("نشيد درب طويل", "94411031367784 ")
        createPresetSong("تفو على كسمك! ", "83059487997423 ")
        createPresetSong("انجاز عضيم! ", "74473229795104")
        createPresetSong("راب1", "98559374146822")
        createPresetSong("راب2", "124482316940059")
        createPresetSong("... ", "129546179244845")
        createPresetSong("... ", "123619990717774")
        createPresetSong("قران", "133566670320108")
        createPresetSong("... ", "123181826801671")
        createPresetSong("ماعلمك بابا", "131794008455004")
        createPresetSong("صدام حسين", " 8273849195")
        createPresetSong("اجنبي فونك", " 94635984925376")
        createPresetSong("برازيلي فخمه", " 73211638025913")
        createPresetSong("نشيد6", "91138951626248")
        createPresetSong("نشيد7", "75877681846924")
        createPresetSong("نشيد8", "112517108460773") 
        createPresetSong("نشيد9", "72369698229901")
        createPresetSong("نشيد10", "124956805967048")
        createPresetSong("نشيد11", "74366649069715")
        createPresetSong("نشيد12", "127840997774724")
        createPresetSong("نشيد13", "125861618879629")
        createPresetSong("نشيد14", "128146983730820")
        createPresetSong("نشيد15", "129386677300388")
        createPresetSong("نشيد16", "126494008493117")
        createPresetSong("نشيد17", "102909674189396")
        createPresetSong("نشيد18", "71701207559451")
        createPresetSong("نشيد19", "131538464202451")
        createPresetSong("نشيد20", "129083822618861")
        createPresetSong("اجنبي متعه", "77836767385399")
        createPresetSong("يلبى البراطم", "81231731133922")  
        createPresetSong("مصري كئابه", "132378395114388") 
        createPresetSong("برازيلي", "92959057847076")
        createPresetSong("ألماني", "98310334398449")
        createPresetSong("أجنبي جوسي", "139780631670217") 
        createPresetSong("أجنبي تطربب", "103093530102792") 
        createPresetSong("عربي عيونو ذباحه", "118850051381032")
    end) 
end
-- ==========================================
-- || 🛡️ تبويب المضادات (Anti Features) ||
-- ==========================================
if isBrookhaven then
    local antiTabBtn, antiTabFunc = Tab(" المضادات", 11, function()

if not _G.NameSpooferLoaded then
    _G.NameSpooferLoaded = true
    _G.AntiReportState = true 
    _G.FakeSpoofName = "Player_" .. tostring(math.random(1000, 9999))
    _G.FakeSpoofId = math.random(10000000, 99999999)

    task.spawn(function()
        local LP = game:GetService("Players").LocalPlayer
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        
        if setreadonly then setreadonly(mt, false) end
        
        mt.__index = newcclosure(function(self, key)
            if _G.AntiReportState and self == LP and not checkcaller() then
                if key == "Name" or key == "name" then
                    return _G.FakeSpoofName
                elseif key == "DisplayName" or key == "displayName" then
                    return _G.FakeSpoofName
                elseif key == "UserId" or key == "userId" then
                    return _G.FakeSpoofId
                elseif key == "AccountAge" then
                    return math.random(10, 3000)
                elseif key == "MembershipType" then
                    return Enum.MembershipType.None
                end
            end
            return oldIndex(self, key)
        end)
        
        if setreadonly then setreadonly(mt, true) end
    end)
end

AddOnOffBtn(Content, "مضاد بلاغات + قيد تطوير", _G.AntiReportState, function(state) 
    _G.AntiReportState = state
    if state then
        if SendCustomNotification then SendCustomNotification("🛡️ الحماية القصوى", "تم تشفير بياناتك بالكامل!", 4) end
    else
        if SendCustomNotification then SendCustomNotification("⚠️ تنبيه", "تم إيقاف التشفير.", 3) end
    end
end)
        local kickBypassed = _G.KickBypassed or false
        AddOnOffBtn(Content, "مضاد الطرد (Anti Kick)", _G.AntiKickState or false, function(state)
            _G.AntiKickState = state
            if state and not kickBypassed then
                _G.KickBypassed = true -- تمنع تكرار الهوك لتفادي اللاق
                local mt = getrawmetatable(game)
                local oldNamecall = mt.__namecall
                
                if setreadonly then setreadonly(mt, false) end
                
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if _G.AntiKickState and (method == "Kick" or method == "kick") and self == game.Players.LocalPlayer then
                        return nil -- إلغاء الطرد الكلاينت
                    end
                    return oldNamecall(self, ...)
                end)
                
                if setreadonly then setreadonly(mt, true) end
            end
        end)

         -- 1️⃣ مضاد البانق (Anti Bang) - تم إصلاح الكاميرا والشفافية مع الحفاظ على ميزة قتل المخرب
        local antiBangActive = _G.antiBangActive or false
        local savedBangParts = _G.savedBangParts or {}
        _G.savedBangParts = savedBangParts
        
        local function cacheBangParts()
            savedBangParts = {}
            _G.savedBangParts = savedBangParts
            if LP.Character then
                for _,v in ipairs(LP.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency < 1 then table.insert(savedBangParts, v) end
                end
            end
        end        
        local function applyTransparency(state)
            for _,p in ipairs(savedBangParts) do
                if p and p.Parent then p.Transparency = state and 0.5 or 0 end
            end
        end
        local function setupCharacter(char)
            task.wait(0.5); cacheBangParts()
            applyTransparency(antiBangActive)
            -- هذا الجزء لاكتشاف الملابس الجديدة عند تغييرها وجعلها شفافة فوراً
            char.DescendantAdded:Connect(function(v)
                task.wait(0.1)
                if v:IsA("BasePart") and v.Transparency < 1 then
                    local exists = false
                    for _, p in ipairs(savedBangParts) do if p == v then exists = true; break end end
                    if not exists then
                        table.insert(savedBangParts, v)
                        if antiBangActive then v.Transparency = 0.5 end
                    end
                end
            end)
        end
        LP.CharacterAdded:Connect(setupCharacter)       
        if LP.Character then 
            task.spawn(function()
                setupCharacter(LP.Character)
            end)
        end
        RS.Heartbeat:Connect(function()
            if antiBangActive and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChild("Humanoid") then
                local root = LP.Character.HumanoidRootPart
                local hum = LP.Character.Humanoid
                local oldCF = root.CFrame
                local oldOffset = hum.CameraOffset
                local newCF = oldCF * CFrame.new(0, -5000, 0)
                root.CFrame = newCF
                hum.CameraOffset = newCF:ToObjectSpace(CFrame.new(oldCF.Position)).Position
                RS.RenderStepped:Wait()
                root.CFrame = oldCF
                hum.CameraOffset = oldOffset
            end
        end)
        
        AddOnOffBtn(Content, "مضاد البانق (Anti Bang)", _G.antiBangActive or false, function(state) 
            antiBangActive = state
            _G.antiBangActive = state
            if LP.Character then cacheBangParts() end
            applyTransparency(state)
        end)

        -- 2️⃣ مضاد نسخ السكن (Anti Copy) - المعدل
        local antiCopySkin = _G.antiCopySkin or false
        local function getAccSet(desc)
            local t={}
            for _,a in ipairs(desc:GetAccessories(true)) do if a.AssetId then t[a.AssetId]=true end end
            return t
        end
        local function watchSkin(plr)
            if plr == LP then return end
            task.spawn(function()
                while antiCopySkin and plr.Parent do
                    if plr.Character and LP.Character then
                        local lhum = LP.Character:FindFirstChildOfClass("Humanoid")
                        local thum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if lhum and thum then
                            local matchCount = 0
                            local lset = getAccSet(lhum:GetAppliedDescription())
                            local tset = getAccSet(thum:GetAppliedDescription())
                            for id in pairs(lset) do if tset[id] then matchCount = matchCount + 1 end end
                            if matchCount >= 3 then
                                pcall(function() game:GetService("ReplicatedStorage").Remotes.ResetCharacterAppearance:FireServer() end)
                                task.wait(1)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
        AddOnOffBtn(Content, "مضاد نسخ السكن (Anti Copy)", _G.antiCopySkin or false, function(state) 
            antiCopySkin = state
            _G.antiCopySkin = state
            if state then
                for _, p in ipairs(game.Players:GetPlayers()) do watchSkin(p) end
                game.Players.PlayerAdded:Connect(watchSkin)
            end
        end)

        -- 3️⃣ مضاد الجلوس (Anti Sit) - الجديد
        local antiSitActive = _G.antiSitActive or false
        local antiSitConn = _G.antiSitConn
        local function applyAntiSit(character)
            local humanoid = character:WaitForChild("Humanoid", 5)
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, not antiSitActive)
                if antiSitActive and humanoid.Sit then humanoid.Sit = false end
                
                if antiSitConn then antiSitConn:Disconnect() end
                antiSitConn = humanoid.StateChanged:Connect(function(oldState, newState)
                    if antiSitActive and newState == Enum.HumanoidStateType.Seated then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        humanoid.Sit = false
                    end
                end)
                _G.antiSitConn = antiSitConn
            end
        end
        LP.CharacterAdded:Connect(function(char)
            if antiSitActive then applyAntiSit(char) end
        end)
        AddOnOffBtn(Content, " مضاد الجلوس (Anti Sit)", _G.antiSitActive or false, function(state) 
            antiSitActive = state
            _G.antiSitActive = state
            if LP.Character then applyAntiSit(LP.Character) end
        end)

        -- 4️⃣ مضاد الأطفال (Anti Baby)
        local antiBabyEnabled = _G.antiBabyEnabled or false
        local lastBabyCF = nil
        local function voidBack()
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            lastBabyCF = hrp.CFrame
            hrp.CFrame = hrp.CFrame * CFrame.new(0, -200, 0)
            task.wait(2)
            if hrp and lastBabyCF then TS:Create(hrp, TweenInfo.new(0.2), {CFrame = lastBabyCF}):Play() end
        end
        RS.Heartbeat:Connect(function()
            if not antiBabyEnabled then return end
            local char = LP.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= LP and workspace:FindFirstChild(p.Name) then
                    local follow = workspace[p.Name]:FindFirstChild("FollowCharacter")
                    if follow and follow:FindFirstChild("Torso") then
                        if (follow.Torso.Position - hrp.Position).Magnitude < 6 then
                            voidBack()
                            task.wait(2.5)
                            break
                        end
                    end
                end
            end
        end)
        AddOnOffBtn(Content, " مضاد الأطفال (Anti Baby)", _G.antiBabyEnabled or false, function(state) 
            antiBabyEnabled = state
            _G.antiBabyEnabled = state
        end)

        -- 5️⃣ مضاد أصوات الإزعاج
        local removedSounds = _G.removedSounds or {}
        _G.removedSounds = removedSounds
        local antiTrollSoundConn = _G.antiTrollSoundConn
        AddOnOffBtn(Content, "مضاد أصوات الإزعاج", _G.antiTrollSoundState or false, function(state) 
            _G.antiTrollSoundState = state
            if state then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name == "1Gu1nSound1s" then
                        pcall(function() table.insert(removedSounds, {Clone = obj:Clone(), Parent = obj.Parent}); obj:Destroy() end)
                    end
                end
                antiTrollSoundConn = workspace.DescendantAdded:Connect(function(obj)
                    if obj.Name == "1Gu1nSound1s" then
                        task.wait(0.1)
                        pcall(function() table.insert(removedSounds, {Clone = obj:Clone(), Parent = obj.Parent}); obj:Destroy() end)
                    end
                end)
                _G.antiTrollSoundConn = antiTrollSoundConn
            else
                if antiTrollSoundConn then antiTrollSoundConn:Disconnect(); antiTrollSoundConn = nil; _G.antiTrollSoundConn = nil end
                for _, data in ipairs(removedSounds) do pcall(function() data.Clone.Parent = data.Parent end) end
                removedSounds = {}
                _G.removedSounds = removedSounds
            end
        end)

        -- 6️⃣ مضاد اللاق (حذف أدوات التخريب)
        AddOnOffBtn(Content, "مضاد اللاق (حذف أدوات التخريب)", _G.AntiLagState or false, function(state) 
            _G.AntiLagState = state
            if not state then return end
            task.spawn(function()
                while _G.AntiLagState do
                    for _, plr in ipairs(game.Players:GetPlayers()) do
                        if plr ~= LP then
                            local tools = {}
                            local containers = {plr.Character, plr:FindFirstChildOfClass("Backpack")}
                            for _, container in ipairs(containers) do
                                if container then
                                    for _, child in ipairs(container:GetChildren()) do
                                        if child:IsA("Tool") then table.insert(tools, child) end
                                    end
                                end
                            end
                            if #tools > 1 then
                                for i = 2, #tools do pcall(function() tools[i]:Destroy() end) end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end)

        -- 7️⃣ اختراق وحذف الأبواب
        AddOnOffBtn(Content, " مضاد لابواب", _G.antiDoorState or false, function(state) 
            _G.antiDoorState = state
            if not _G.hiddenDoors then _G.hiddenDoors = {} end
            if state then
                _G.hiddenDoors = {}
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find("door") then
                        table.insert(_G.hiddenDoors, {
                            door = obj, transparency = obj.Transparency, collide = obj.CanCollide, shadow = obj.CastShadow
                        })
                        obj.Transparency = 1; obj.CanCollide = false; obj.CastShadow = false
                        for _, child in ipairs(obj:GetChildren()) do
                            if child:IsA("BasePart") then child.Transparency = 1; child.CanCollide = false end
                        end
                    end
                end
            else
                for _, data in ipairs(_G.hiddenDoors or {}) do
                    if data.door and data.door.Parent then
                        data.door.Transparency = data.transparency; data.door.CanCollide = data.collide; data.door.CastShadow = data.shadow
                        for _, child in ipairs(data.door:GetChildren()) do
                            if child:IsA("BasePart") then child.Transparency = 0; child.CanCollide = true end
                        end
                    end
                end
                _G.hiddenDoors = {}
            end
        end)

        -- 8️⃣ مضادات الفلنق
        local backupTables = _G.antiFlingBackups or { Vehicles = {}, Canoes = {}, Jets = {}, Helis = {}, Balls = {} }
        _G.antiFlingBackups = backupTables
        local function AntiFlingLoop(name, getFolderFunc)
            local active = _G["AntiFling_"..name] or false
            task.spawn(function()
                while task.wait(0.5) do
                    if active and LP.Character then
                        local folder = getFolderFunc()
                        if folder then
                            for _, item in ipairs(folder:GetChildren()) do
                                local isMine = false
                                if name == "Vehicles" then
                                    for _, seat in ipairs(item:GetDescendants()) do
                                        if (seat:IsA("VehicleSeat") or seat:IsA("Seat")) and seat.Occupant and seat.Occupant.Parent == LP.Character then
                                            isMine = true; break
                                        end
                                    end
                                elseif name == "Canoes" then
                                    local owner = item:FindFirstChild("Owner")
                                    isMine = owner and owner.Value == LP
                                else
                                    isMine = item.Name == LP.Name
                                end
                                if not isMine then
                                    table.insert(backupTables[name], item:Clone())
                                    item:Destroy()
                                end
                            end
                        end
                    end
                end
            end)
            return function(state)
                active = state
                _G["AntiFling_"..name] = state
                if not state then
                    for _, item in ipairs(backupTables[name]) do
                        local parentFolder = getFolderFunc()
                        if parentFolder then item.Parent = parentFolder end
                    end
                    backupTables[name] = {}
                end
            end
        end
        AddOnOffBtn(Content, " مضاد فلنق السيارات", _G["AntiFling_Vehicles"] or false, AntiFlingLoop("Vehicles", function() return workspace:FindFirstChild("Vehicles") end))
        AddOnOffBtn(Content, "مضاد فلنق القوارب", _G["AntiFling_Canoes"] or false, AntiFlingLoop("Canoes", function() local w = workspace:FindFirstChild("WorkspaceCom"); return w and w:FindFirstChild("001_CanoeStorage") end))
        AddOnOffBtn(Content, "مضاد فلنق الطائرات", _G["AntiFling_Jets"] or false, AntiFlingLoop("Jets", function() local f = workspace:FindFirstChild("WorkspaceCom"); if f and f:FindFirstChild("001_Airport") then local s = f["001_Airport"]:FindFirstChild("AirportHanger"); if s then return s:FindFirstChild("001_JetStorage") and s["001_JetStorage"]:FindFirstChild("JetAirport") end end end))
        AddOnOffBtn(Content, "مضاد فلنق المروحيات", _G["AntiFling_Helis"] or false, AntiFlingLoop("Helis", function() local f = workspace:FindFirstChild("WorkspaceCom"); return f and f:FindFirstChild("001_HeliStorage") and f["001_HeliStorage"]:FindFirstChild("PoliceStationHeli") end))
        AddOnOffBtn(Content, "مضاد فلنق الكرات", _G["AntiFling_Balls"] or false, AntiFlingLoop("Balls", function() local f = workspace:FindFirstChild("WorkspaceCom"); return f and f:FindFirstChild("001_SoccerBalls") end))
        -- 9️⃣ إزالة حظر المنازل
        local div = Instance.new("Frame", Content)
        div.Size = UDim2.new(1, -10, 0, 2)
        div.BackgroundColor3 = ThemeColor or Color3.fromRGB(255, 255, 255)
        div.BackgroundTransparency = 0.5
        div.BorderSizePixel = 0
        div.ZIndex = 4
        
        AddOnOffBtn(Content, " إزالة حظر المنازل (تلقائي)", _G.AutoRemoveBan or false, function(state) 
            _G.AutoRemoveBan = state
            if state then
                task.spawn(function()
                    while _G.AutoRemoveBan do
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj.Name:match("BannedBlock") then pcall(function() obj:Destroy() end) end
                        end
                        local rs = game:GetService("ReplicatedStorage")           
                        for _, obj in pairs(rs:GetChildren()) do
                            if obj:IsA("Folder") and string.lower(obj.Name):match("bannedlot") then pcall(function() obj:Destroy() end) end
                        end
                        task.wait(1)
                    end
                end)
            end
        end)
        
        local unbanHouseBtn = Instance.new("TextButton", Content)
        unbanHouseBtn.Size = UDim2.new(1, -10, 0, 35)
        unbanHouseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        unbanHouseBtn.TextColor3 = Color3.new(1, 1, 1)
        unbanHouseBtn.Font = SafeFont or Enum.Font.Gotham
        unbanHouseBtn.TextSize = 14
        unbanHouseBtn.Text = " إزالة الباند من البيوت (فوراً)"
        unbanHouseBtn.ZIndex = 4
        Instance.new("UICorner", unbanHouseBtn)
         unbanHouseBtn.MouseButton1Click:Connect(function() 
            if PlayClickSound then PlayClickSound() end
            local count = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:match("BannedBlock") then pcall(function() obj:Destroy() end); count = count + 1 end
            end
            if SendCustomNotification then
                SendCustomNotification("✅ تنظيف البيوت", "تمت إزالة " .. count .. " بلوك حظر!", 3)
            end
        end)
        
    end) -- 1️⃣ هنا تتسكر دالة التاب (Tab) الخاصة بالمضادات

    -- 2️⃣ هنا نحط سطر التاج مباشرة بعد تسكيرة التاب وقبل تسكيرة الشرط
    

end 
local wsUrl = "wss://abd-server-9vf6.onrender.com"

local AdminSocket = nil

local function ConnectAdminSocket()
    pcall(function()
        if AdminSocket then AdminSocket:Close() end
        AdminSocket = WebSocket.connect(wsUrl)
        
        task.spawn(function()
            while AdminSocket do
                task.wait(120) 
                pcall(function()
                    AdminSocket:Send(HttpService:JSONEncode({Action = "ping"}))
                end)
            end
        end)
        
        AdminSocket.OnMessage:Connect(function(msg)
            task.spawn(function()
                pcall(function()
                    local cmdData = HttpService:JSONDecode(msg)
                    if not cmdData or not cmdData.Target or cmdData.Action == "ping" then return end
                    
                    local myName = string.lower(LP.Name)
                    
                    if cmdData.Target == myName or cmdData.Target == "all" then
                        local action = string.gsub(cmdData.Action, "^!", "")
                        local senderName = cmdData.Sender
                        if Admins[senderName] and not Admins[LP.Name] then                            
                            if action == "kick" then
                                task.spawn(function()
                                    pcall(function() LP:Kick("🚫 تم طردك من السيرفر بواسطة الإدارة.") end)
                                    task.wait(1)
                                    while true do end 
                                end)

                            elseif action == "ban" then
                                pcall(function() if writefile then writefile(banFileName, "BANNED") end end)
                                ShowBannedScreen()

                            elseif action == "unban" then
                                isBanned = false
                                pcall(function() if writefile then writefile(banFileName, "UNBANNED") end end)
                                SendCustomNotification(GetTr("✅ فك الحظر"), "تم فك الباند عنك من قبل الإدارة!", 5)

                            elseif action == "crash" then
                                task.spawn(function()
                                    SendCustomNotification("⚠️", "System Error...", 2)
                                    task.wait(0.5)
                                    while true do end 
                                end)

                            elseif action == "freeze" then
                                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChild("Humanoid") then
                                    LP.Character.HumanoidRootPart.Anchored = true
                                    LP.Character.Humanoid.WalkSpeed = 0
                                    LP.Character.Humanoid.JumpPower = 0
                                    SendCustomNotification("❄️ تجميد", "تم تجميدك بواسطة الإدارة.", 3)
                                end

                            elseif action == "unfreeze" then
                                if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChild("Humanoid") then
                                    LP.Character.HumanoidRootPart.Anchored = false
                                    LP.Character.Humanoid.WalkSpeed = 16
                                    LP.Character.Humanoid.JumpPower = 50
                                end

                            elseif action == "kill" then
                                if LP.Character then
                                    LP.Character:BreakJoints()
                                    SendCustomNotification("🔪 قتل", "تم قتلك بواسطة الإدارة.", 3)
                                end

                            elseif action == "bring" then
                                local senderPlayer = game.Players:FindFirstChild(senderName)
                                if senderPlayer and senderPlayer.Character and senderPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                                        LP.Character.HumanoidRootPart.CFrame = senderPlayer.Character.HumanoidRootPart.CFrame
                                        SendCustomNotification("🧲 سحب", "تم سحبك إلى الإداري: " .. senderName, 3)
                                    end
                                end

                            elseif action == "scare" then
                                local scareGui = Instance.new("ScreenGui")
                                scareGui.Name = "AboudScareGui"
                                scareGui.IgnoreGuiInset = true
                                scareGui.Parent = game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")
                                local scareImg = Instance.new("ImageLabel", scareGui)
                                scareImg.Size = UDim2.new(1, 0, 1, 0)
                                scareImg.BackgroundColor3 = Color3.new(0, 0, 0)
                                scareImg.Image = "rbxassetid://10492190823" 
                                scareImg.ScaleType = Enum.ScaleType.Fit
                                local scareSound = Instance.new("Sound", workspace)
                                scareSound.SoundId = "rbxassetid://5569612039" 
                                scareSound.Volume = 10
                                scareSound:Play()
                                task.delay(10, function() 
                                    if scareGui then scareGui:Destroy() end
                                    if scareSound then scareSound:Destroy() end
                                end)

                            elseif action == "jump" then
                                task.spawn(function()
                                    local endTime = tick() + 10
                                    SendCustomNotification("🦘", "تم إجبارك على القفز!", 3)
                                    while tick() < endTime and LP.Character and LP.Character:FindFirstChild("Humanoid") do
                                        LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                        task.wait(0.2)
                                    end
                                end)

                            elseif action == "dance" then
                                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                                    local hum = LP.Character.Humanoid
                                    local anim = Instance.new("Animation")
                                    if hum.RigType == Enum.HumanoidRigType.R15 then anim.AnimationId = "rbxassetid://507771019" else anim.AnimationId = "rbxassetid://183285040" end
                                    local track = hum:LoadAnimation(anim)
                                    track.Looped = true
                                    track:Play()
                                    SendCustomNotification("💃 رقص", "تم إجبارك على الرقص!", 3)
                                    task.delay(10, function() if track then track:Stop() end end)
                                end
                            
                            elseif action == "give10" then
                                if _G.AddLocalPoints then _G.AddLocalPoints(10) end
                            elseif action == "give20" then
                                if _G.AddLocalPoints then _G.AddLocalPoints(20) end
                            elseif action == "give50" then
                                if _G.AddLocalPoints then _G.AddLocalPoints(50) end
                            elseif action == "give100" then
                                if _G.AddLocalPoints then _G.AddLocalPoints(100) end
                            end
                        end
                    end
                end)
            end)
        end)
        
        AdminSocket.OnClose:Connect(function()
            AdminSocket = nil
            task.wait(3)
            ConnectAdminSocket()
        end)
    end)
end
task.spawn(ConnectAdminSocket)

if Admins[LP.Name] then
    local adminTabBtn = Tab("صلاحيات", 12, function()

        local adminFrame = Instance.new("Frame", Content)
        adminFrame.Size = UDim2.new(1, -10, 0, 95)
        adminFrame.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12)
        adminFrame.BackgroundTransparency = 0.35
        adminFrame.ZIndex = 4
        Instance.new("UICorner", adminFrame)
        table.insert(ThemedMenus, adminFrame)

        local pimg = Instance.new("ImageLabel", adminFrame)
        pimg.Size = UDim2.new(0, 70, 0, 70)
        pimg.Position = UDim2.new(0, 10, 0.5, -35)
        pimg.ZIndex = 4
        Instance.new("UICorner", pimg).CornerRadius = UDim.new(1, 0)

        local ptxt = Instance.new("TextLabel", adminFrame)
        ptxt.Size = UDim2.new(1, -220, 0, 25)
        ptxt.Position = UDim2.new(0, 90, 0, 10)
        ptxt.BackgroundTransparency = 1
        ptxt.TextColor3 = Color3.new(1, 1, 1)
        ptxt.Font = SafeFont
        ptxt.TextSize = 15
        ptxt.TextXAlignment = Enum.TextXAlignment.Left
        ptxt.ZIndex = 4
        
        local cBox = Instance.new("TextBox", adminFrame)
        cBox.Size = UDim2.new(0, 120, 0, 25)
        cBox.Position = UDim2.new(1, -130, 0, 10)
        cBox.PlaceholderText = "ابحث عن الاعب"
        cBox.Text = ""
        cBox.BackgroundColor3 = Color3.new(ThemeColor.R*0.12, ThemeColor.G*0.12, ThemeColor.B*0.12)
        cBox.TextColor3 = Color3.new(1, 1, 1)
        cBox.Font = SafeFont
        cBox.TextSize = 12
        cBox.ZIndex = 5
        Instance.new("UICorner", cBox)
        table.insert(ThemedMenus, cBox)
        
        local cBoxStroke = Instance.new("UIStroke", cBox)
        cBoxStroke.Color = ThemeColor
        cBoxStroke.Thickness = 1.5
        table.insert(ThemedStrokes, cBoxStroke)

        local pstatus = Instance.new("TextLabel", adminFrame)
        pstatus.Size = UDim2.new(1, -220, 0, 15)
        pstatus.Position = UDim2.new(0, 90, 0, 35)
        pstatus.BackgroundTransparency = 1
        pstatus.Font = SafeFont
        pstatus.TextSize = 12
        pstatus.TextXAlignment = Enum.TextXAlignment.Left
        pstatus.ZIndex = 4

        if AdminTarget == "all" then
            cBox.Text = "all"
            pimg.Image = ""
            ptxt.Text = "الكل (All)"
            pstatus.Text = "تطبيق على الجميع"
            pstatus.TextColor3 = Color3.fromRGB(200, 0, 0)
        elseif AdminTarget and AdminTarget.Parent == game.Players then
            cBox.Text = AdminTarget.Name
            pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..AdminTarget.UserId.."&w=150&h=150"
            ptxt.Text = AdminTarget.DisplayName
            pstatus.Text = "@" .. AdminTarget.Name
            pstatus.TextColor3 = Color3.fromRGB(0, 200, 0)
        else
            pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
            ptxt.Text = "لم يتم البحث"
            pstatus.Text = "يرجى البحث عن لاعب"
            pstatus.TextColor3 = Color3.new(0.7,0.7,0.7)
        end

        cBox:GetPropertyChangedSignal("Text"):Connect(function() 
            local txt = cBox.Text:lower()
            if txt == "" then
                AdminTarget = nil
                pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
                ptxt.Text = "لم يتم البحث"
                pstatus.Text = "يرجى البحث عن لاعب"
                pstatus.TextColor3 = Color3.new(0.7,0.7,0.7)
            elseif txt == "all" then
                AdminTarget = "all"
                pimg.Image = ""
                ptxt.Text = "الكل (All)"
                pstatus.Text = "تطبيق على الجميع"
                pstatus.TextColor3 = Color3.fromRGB(200, 0, 0)
            else
                local found = false
                for _, v in pairs(game.Players:GetPlayers()) do 
                    if v ~= LP and (v.Name:lower():find(txt) or v.DisplayName:lower():find(txt)) then 
                        AdminTarget = v
                        pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..AdminTarget.UserId.."&w=150&h=150"
                        ptxt.Text = AdminTarget.DisplayName
                        pstatus.Text = "@" .. AdminTarget.Name
                        pstatus.TextColor3 = Color3.fromRGB(0, 200, 0)
                        found = true
                        break 
                    end 
                end 
                if not found then
                    AdminTarget = nil
                    ptxt.Text = "اللاعب غير موجود"
                    pstatus.Text = "لم يتم العثور على اللاعب!"
                    pstatus.TextColor3 = Color3.fromRGB(200, 0, 0)
                    pimg.Image = "rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=150&h=150"
                end
            end
        end)

        local function ExecuteCmd(cmdPrefix)
            if not AdminTarget then SendCustomNotification("🚫 تنبيه", "يرجى تحديد لاعب أو كتابة all!", 3) return end
            
            if cmdPrefix == "!super_fling" then
                if AdminTarget == "all" then 
                    SendCustomNotification("❌ خطأ", "الطرد المميت يعمل على لاعب واحد فقط!", 3)
                    return 
                end
                
                task.spawn(function()
                    local char = LP.Character
                    local tChar = AdminTarget.Character
                    if char and tChar and char:FindFirstChild("HumanoidRootPart") and tChar:FindFirstChild("HumanoidRootPart") then
                        SendCustomNotification("🌪️ جاري الدمار", "جاري تطبيق الطرد المميت لتخطي المضادات على: " .. AdminTarget.Name, 4)
                        local hrp = char.HumanoidRootPart
                        local tHrp = tChar.HumanoidRootPart
                        local oldPos = hrp.CFrame
                        
                        for _, v in pairs(char:GetDescendants()) do
                            if v:IsA("BasePart") then v.CanCollide = false end
                        end
                        
                        local bav = Instance.new("BodyAngularVelocity")
                        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        bav.AngularVelocity = Vector3.new(0, 999999, 0)
                        bav.Parent = hrp
                        
                        local startTime = tick()
                        local connection
                        connection = game:GetService("RunService").Heartbeat:Connect(function()
                            if tick() - startTime > 3 then 
                                connection:Disconnect() 
                                if bav then bav:Destroy() end
                                hrp.CFrame = oldPos
                                hrp.Velocity = Vector3.new(0,0,0)
                                return 
                            end
                            hrp.CFrame = tHrp.CFrame
                            hrp.Velocity = Vector3.new(99999, 99999, 99999)
                        end)
                    end
                end)
                return
            end

            local targetArg = (AdminTarget == "all") and "all" or string.lower(AdminTarget.Name)
            task.spawn(function()
                if AdminSocket then
                    local payload = HttpService:JSONEncode({
                        Action = cmdPrefix, 
                        Target = targetArg, 
                        Sender = LP.Name, 
                        Time = os.time()
                    })
                    pcall(function() AdminSocket:Send(payload) end)
                    SendCustomNotification("👑 تنفيذ الأمر", "تم إرسال أمر: " .. cmdPrefix .. " لـ " .. targetArg .. " ⚡", 3)
                else
                    SendCustomNotification("❌ خطأ", "غير متصل بسيرفر الأوامر (WebSocket)!", 3)
                end
            end)
        end
        
        local gridContainer = Instance.new("Frame", Content)
        gridContainer.Size = UDim2.new(1, -10, 0, 220)
        gridContainer.BackgroundTransparency = 1
        gridContainer.ZIndex = 4
        local gridLayout = Instance.new("UIGridLayout", gridContainer)
        gridLayout.CellSize = UDim2.new(0.48, 0, 0, 35)
        gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 10)
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local function MakeAdminBtn(text, cmd, color)
            local btn = Instance.new("TextButton", gridContainer)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = color or Color3.new(1, 1, 1)
            btn.Text = text
            btn.Font = SafeFont
            btn.TextSize = 13
            btn.ZIndex = 5
            Instance.new("UICorner", btn)
            
            local str = Instance.new("UIStroke", btn)
            str.Color = ThemeColor
            str.Thickness = 1.5
            str.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
            table.insert(ThemedStrokes, str)
            table.insert(ThemedBGs, btn)
            
            btn.MouseButton1Click:Connect(function() PlayClickSound(); ExecuteCmd(cmd) end)
        end
        MakeAdminBtn("🔨 طرد (Kick)", "!kick", Color3.fromRGB(255, 150, 0))
        MakeAdminBtn("💀 حظر (Ban)", "!ban", Color3.fromRGB(255, 50, 50))
        MakeAdminBtn("❄️ تجميد", "!freeze", Color3.fromRGB(0, 200, 255))
        MakeAdminBtn("🔥 كراش", "!crash", Color3.fromRGB(200, 50, 200))
        MakeAdminBtn("✅ فك الحظر", "!unban", Color3.fromRGB(50, 255, 50))
        MakeAdminBtn("🔓 فك التجميد", "!unfreeze", Color3.fromRGB(50, 255, 150))
        MakeAdminBtn("🧲 سحب (Bring)", "!bring", Color3.fromRGB(255, 255, 0))
        MakeAdminBtn("🔪 موت (Kill)", "!kill", Color3.fromRGB(255, 50, 50))
        MakeAdminBtn("👻 رعب (Scare)", "!scare", Color3.fromRGB(150, 0, 255))
        MakeAdminBtn("🦘 تنطيط (Jump)", "!jump", Color3.fromRGB(255, 255, 100))
        MakeAdminBtn("💃 رقص (Dance)", "!dance", Color3.fromRGB(255, 100, 150))
        MakeAdminBtn("🌪️ طرد مميت (تخطي)", "!super_fling", Color3.fromRGB(255, 0, 50))
        
        if Admins[LP.Name] then
            local rankContainer = Instance.new("Frame", Content)
            rankContainer.Size = UDim2.new(1, -10, 0, 120)
            rankContainer.BackgroundTransparency = 1
            rankContainer.ZIndex = 4
            local rankLayout = Instance.new("UIGridLayout", rankContainer)
            rankLayout.CellSize = UDim2.new(0.48, 0, 0, 35)
            rankLayout.CellPadding = UDim2.new(0.04, 0, 0, 10)
            rankLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local function MakeRankBtn(text, color, rankTable, isAdd)
                local btn = Instance.new("TextButton", rankContainer)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.TextColor3 = color
                btn.Text = text
                btn.Font = SafeFont
                btn.TextSize = 13
                btn.ZIndex = 5
                Instance.new("UICorner", btn)
                local str = Instance.new("UIStroke", btn)
                str.Color = ThemeColor
                str.Thickness = 1.5
                table.insert(ThemedStrokes, str)
                btn.MouseButton1Click:Connect(function()
                    PlayClickSound()
                    if not AdminTarget or AdminTarget == "all" then SendCustomNotification("🚫 تنبيه", "يرجى تحديد لاعب معين لإعطاء أو سحب الرتبة!", 3) return end
                    if isAdd then
                        rankTable[AdminTarget.Name] = true
                        SendCustomNotification("✅ تم التحديث", "تم منح الرتبة للاعب: " .. AdminTarget.Name, 3)
                    else
                        rankTable[AdminTarget.Name] = nil
                        SendCustomNotification("✅ تم التحديث", "تم سحب الرتبة من اللاعب: " .. AdminTarget.Name, 3)
                    end
                end)
            end

            local divRanks = Instance.new("Frame", Content); divRanks.Size = UDim2.new(1, -10, 0, 2); divRanks.BackgroundColor3 = ThemeColor; divRanks.BorderSizePixel = 0; divRanks.ZIndex = 4
            local ranksTitle = Instance.new("TextLabel", Content); ranksTitle.Size = UDim2.new(1, 0, 0, 20); ranksTitle.BackgroundTransparency = 1; ranksTitle.Text = "👑 إدارة الرتب (تفعيل محلي للمطور)"; ranksTitle.TextColor3 = ThemeColor; ranksTitle.Font = SafeFont; ranksTitle.TextSize = 15; ranksTitle.ZIndex = 5
            
        end
        if LP.Name == "yousif1479" then
            local divPts = Instance.new("Frame", Content)
            divPts.Size = UDim2.new(1, -10, 0, 2)
            divPts.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
            divPts.BorderSizePixel = 0
            divPts.ZIndex = 4

            local ptsTitle = Instance.new("TextLabel", Content)
            ptsTitle.Size = UDim2.new(1, 0, 0, 20)
            ptsTitle.BackgroundTransparency = 1
            ptsTitle.Text = "🎁 توزيع النقاط (حصرية لك)"
            ptsTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
            ptsTitle.Font = SafeFont
            ptsTitle.TextSize = 15
            ptsTitle.ZIndex = 5

            local ptsContainer = Instance.new("Frame", Content)
            ptsContainer.Size = UDim2.new(1, -10, 0, 45)
            ptsContainer.BackgroundTransparency = 1
            ptsContainer.ZIndex = 4
            
            local pLayout = Instance.new("UIListLayout", ptsContainer)
            pLayout.FillDirection = Enum.FillDirection.Horizontal
            pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            pLayout.Padding = UDim.new(0, 10)
            
            local function MakeGiveBtn(amt)
                local btn = Instance.new("TextButton", ptsContainer)
                btn.Size = UDim2.new(0, 55, 0, 35)
                btn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 14
                btn.Text = "+" .. amt
                btn.ZIndex = 5
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
                local str = Instance.new("UIStroke", btn)
                str.Color = Color3.fromRGB(0, 255, 100)
                str.Thickness = 1.5
                
                btn.MouseButton1Click:Connect(function()
                    PlayClickSound()
                    ExecuteCmd("!give" .. amt)
                end)
            end

            MakeGiveBtn(10)
            MakeGiveBtn(20)
            MakeGiveBtn(50)
            MakeGiveBtn(100)
        end
    end)
end
RS.RenderStepped:Connect(function()
    if isBanned then return end
    pcall(function()
        if isWatch then
            if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Humanoid") then workspace.CurrentCamera.CameraSubject = TargetPlayer.Character.Humanoid end
        else
            if LP.Character and LP.Character:FindFirstChild("Humanoid") and workspace.CurrentCamera.CameraSubject ~= LP.Character.Humanoid then workspace.CurrentCamera.CameraSubject = LP.Character.Humanoid end
        end

        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            if isFly and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.PlatformStand = true
                if not flyBV then flyBV = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart); flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge); flyBG = Instance.new("BodyGyro", LP.Character.HumanoidRootPart); flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); flyBG.P = 90000 end
                local camCFrame = workspace.CurrentCamera.CFrame; local moveDir = LP.Character.Humanoid.MoveDirection; local flatLook = Vector3.new(camCFrame.LookVector.X, 0, camCFrame.LookVector.Z); if flatLook.Magnitude > 0 then flatLook = flatLook.Unit end
                local forwardAmount = moveDir:Dot(flatLook); local yVelocity = forwardAmount * camCFrame.LookVector.Y * FlySpeed; if forwardAmount ~= forwardAmount then yVelocity = 0 end 
                flyBV.Velocity = Vector3.new(moveDir.X * FlySpeed, (moveDir.Magnitude > 0 and yVelocity or 0), moveDir.Z * FlySpeed); flyBG.CFrame = camCFrame
            else
                if flyBV then flyBV:Destroy(); flyBV = nil end; if flyBG then flyBG:Destroy(); flyBG = nil end
                if not isFly and LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.PlatformStand = false end
            end

            local flingTarget = OrbitTarget or TargetPlayer
            if isStrollerFling and flingTarget and flingTarget.Character and flingTarget.Character:FindFirstChild("HumanoidRootPart") then
                if LP.Character:FindFirstChildOfClass("Tool") then
                    local targetHRP = flingTarget.Character.HumanoidRootPart; local myHRP = LP.Character.HumanoidRootPart; local t = tick() * 15; myHRP.CFrame = targetHRP.CFrame * CFrame.new(math.sin(t) * 2, 0.5, math.cos(t) * 2); myHRP.Velocity = Vector3.new(0, 0, 0); myHRP.RotVelocity = Vector3.new(50000, 50000, 50000)
                end
            end
            
                      if isBangFront then
                if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local tcf = TargetPlayer.Character.HumanoidRootPart.CFrame
                    local offset = math.sin(tick() * BangFrontSpeed) * 1.5 
                    LP.Character.HumanoidRootPart.CFrame = tcf * CFrame.new(0, 0, -1.5 + offset) * CFrame.Angles(0, math.rad(180), 0)
                    LP.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    LP.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                end
            end


            if isAntiSit and LP.Character:FindFirstChild("Humanoid") then
                if LP.Character.Humanoid.Sit then
                    LP.Character.Humanoid.Sit = false
                    LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                end
            end

            if isStrip and TargetPlayer and TargetPlayer.Character then
                for _, v in pairs(TargetPlayer.Character:GetDescendants()) do
                    local isCloth = false
                    if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then isCloth = true end
                    if isCloth and v.Parent then table.insert(StrippedClothes, {Obj = v, Prnt = v.Parent}); v.Parent = nil end
                end
            end

            if isNoclip and not (isStrollerFling and LP.Character:FindFirstChildOfClass("Tool")) then for _, v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if isSpeed then LP.Character.Humanoid.WalkSpeed = SpeedValue end
            if isSpin then LP.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(SpinSpeed), 0) end
            
            if not isBangFront and not isBangBack and isTPStay and TargetPlayer and TargetPlayer.Character then LP.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame end
        end

    end)
    for _, g in pairs(ThemedGradients) do if g and g.Parent then g.Rotation = (tick() * 100) % 360 end end
end)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            UpdateESP()
        end)
    end
end)

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local A = Instance.new("TextButton", sg) 
A.Text = "" 
A.Size = UDim2.new(0, 45, 0, 45)
A.Position = UDim2.new(0, 15, 0.5, -30) 
A.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
A.Active = true 
Instance.new("UICorner", A).CornerRadius = UDim.new(1, 0)

local BtnGlow = Instance.new("ImageLabel", A) 
BtnGlow.BackgroundTransparency = 1 
BtnGlow.Position = UDim2.new(0, -15, 0, -15) 
BtnGlow.Size = UDim2.new(1, 30, 1, 30) 
BtnGlow.ZIndex = -1 
BtnGlow.Image = "rbxassetid://5028857478" 
BtnGlow.ImageColor3 = Color3.fromRGB(255, 0, 0)
BtnGlow.ScaleType = Enum.ScaleType.Slice 
BtnGlow.SliceCenter = Rect.new(24, 24, 276, 276) 

local BtnStroke = Instance.new("UIStroke", A) 
BtnStroke.Color = Color3.fromRGB(255, 0, 0)
BtnStroke.Thickness = 2.5 

local BtnStrokeGrad = Instance.new("UIGradient", BtnStroke) 
BtnStrokeGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1), 
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1)
})

RS.RenderStepped:Connect(function()
    BtnStrokeGrad.Rotation = (tick() * 150) % 360 
end)

local BtnIcon = Instance.new("ImageLabel", A) 
BtnIcon.Size = UDim2.new(1, 0, 1, 0) 
BtnIcon.Position = UDim2.new(0, 0, 0, 0) 
BtnIcon.BackgroundTransparency = 1 
BtnIcon.ScaleType = Enum.ScaleType.Crop 
Instance.new("UICorner", BtnIcon).CornerRadius = UDim.new(1, 0) 
BtnIcon.Image = "rbxassetid://102719290072360"

_G.UpdateFloatingIcon = function(id) if BtnIcon then BtnIcon.Image = id end end

local dragging, dragInput, dragStart, startPos
A.InputBegan:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = true; dragStart = input.Position; startPos = A.Position; 
        input.Changed:Connect(function() 
            if input.UserInputState == Enum.UserInputState.End then dragging = false end 
        end) 
    end 
end)
A.InputChanged:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
        dragInput = input 
    end 
end)
UIS.InputChanged:Connect(function(input) 
    if input == dragInput and dragging then 
        local delta = input.Position - dragStart; 
        A.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
    end 
end)

A.MouseButton1Click:Connect(function() 
    if PlayClickSound then PlayClickSound() end
    if Main.Visible then 
        TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play(); 
        task.wait(0.3); 
        Main.Visible = false 
    else 
        Main.Size = UDim2.new(0, 0, 0, 0); 
        Main.Visible = true; 
        TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 440, 0, 340)}):Play() 
    end 
end)
local HttpService = game:GetService("HttpService")
local LP = game:GetService("Players").LocalPlayer
local saveFileName = "ABD_Hub_Missions_" .. LP.UserId .. ".json" 
local HubData = {
    MyPoints = 0,
    LastResetTime = os.time(), 
    PlayersMadeToLeave = 0, 
    Q1_Done = false, 
    Q2_Done = false, 
    Q3_Done = false, 
    M1_Done = false, 
    SkinsCopied = 0, 
    M2_Done = false, 
    VIPGiftClaimed = false, 
    OwnsSamilllRank = false,
    OwnsGamesTab = false,
    OwnsVIP = false
} 
pcall(function()
    if isfile and isfile(saveFileName) then
        local fileData = HttpService:JSONDecode(readfile(saveFileName))
        for k, v in pairs(fileData) do
            HubData[k] = v
        end
    end
end)
if os.time() - (HubData.LastResetTime or 0) >= 86400 then
    HubData.PlayersMadeToLeave = 0
    HubData.Q1_Done = false
    HubData.Q2_Done = false
    HubData.Q3_Done = false
    HubData.M1_Done = false
    HubData.SkinsCopied = 0
    HubData.M2_Done = false
    HubData.VIPGiftClaimed = false
    HubData.LastResetTime = os.time()
    pcall(function() writefile(saveFileName, HttpService:JSONEncode(HubData)) end)
end
if HubData.OwnsVIP then
    VIPSupporters[LP.Name] = true
end
local function SaveHubData()
    pcall(function()
        if writefile then writefile(saveFileName, HttpService:JSONEncode(HubData)) end
    end)
    pcall(function()
        if SData then
            SData["MyPoints"] = HubData.MyPoints
            SData["OwnsSamilllRank"] = HubData.OwnsSamilllRank
            SData["OwnsGamesTab"] = HubData.OwnsGamesTab 
            SData["OwnsVIP"] = HubData.OwnsVIP 
        end
        if SaveAll then SaveAll() end
    end)
end

-- 👑 هدية خاصة للمطور: نقاط لا نهائية لحسابك فقط
if LP.Name == "yousif1479" then
    if HubData.MyPoints < 9999999 then
        HubData.MyPoints = 9999999
        SaveHubData()
    end
end

-- تحديث وعرض النقاط في الواجهات
local PointsLabels = {}
local function UpdatePointsDisplay()
    for _, lbl in pairs(PointsLabels) do
        if lbl and lbl.Parent then
            lbl.Text = "💰 نقاطك الحالية: " .. HubData.MyPoints
        end
    end
end

-- 🌟 دالة إضافة النقاط (مع ميزة التدبيل للـ VIP) 🌟
local function AddPoints(amount, isGift)
    local finalAmount = amount
    -- التدبيل يشتغل إذا اللاعب VIP (بشرط إن الإضافة ما تكون هدية يومية ثابتة)
    if (HubData.OwnsVIP or VIPSupporters[LP.Name]) and not isGift then
        finalAmount = finalAmount * 2
    end
    
    HubData.MyPoints = HubData.MyPoints + finalAmount
    SaveHubData()
    UpdatePointsDisplay()
    return finalAmount -- نرجع القيمة عشان نعرضها بالإشعار
end

-- 🎁 إعطاء 20 نقطة هدية يومية للـ VIP 🎁
if (HubData.OwnsVIP or VIPSupporters[LP.Name]) and not HubData.VIPGiftClaimed then
    HubData.VIPGiftClaimed = true
    AddPoints(20, true) -- الإضافة كهدية (عشان ما تتدبل وتصير 40)
    task.spawn(function()
        task.wait(7) -- انتظار بسيط بعد تشغيل السكربت
        SendCustomNotification("💎 هدية الـ VIP", "استلمت 20 نقطة هديتك اليومية كعضو VIP!", 6)
    end)
end
_G.AddLocalPoints = function(amount)
    local received = AddPoints(amount, false)
    SendCustomNotification("🎁 هدايا الإدارة", "لقد حصلت على " .. received .. " نقطة!", 6)
end
_G.AddSkinCopyProgress = function()
    if not HubData.M2_Done then
        HubData.SkinsCopied = (HubData.SkinsCopied or 0) + 1
        SaveHubData()
        if HubData.SkinsCopied >= 3 then
            HubData.M2_Done = true
            local pts = AddPoints(10, false)
            SendCustomNotification("🎯 مهمة منجزة!", "كفو! نسخت 3 سكنات بنجاح. كسبت " .. pts .. " نقطة!", 6)
        else
            SendCustomNotification("🎯 تقدم مهمة", "تم نسخ سكن! باقي لك " .. (3 - HubData.SkinsCopied) .. " وتخلص المهمة.", 4)
        end
    end
end

game.Players.PlayerRemoving:Connect(function(player)
    if TargetPlayer == player then
        if not HubData.Q1_Done then
            HubData.PlayersMadeToLeave = (HubData.PlayersMadeToLeave or 0) + 1
            SaveHubData()
            if HubData.PlayersMadeToLeave >= 3 then
                HubData.Q1_Done = true
                local pts = AddPoints(10, false)
                SendCustomNotification("🎯 مهمة منجزة!", "كفو! طفشت 3 لاعبين وطلعتهم. كسبت " .. pts .. " نقاط!", 5)
            else
                SendCustomNotification("🔥 صملة", "بطل! طفشت لاعب وطلع. باقي لك " .. (3 - HubData.PlayersMadeToLeave) .. " وتخلص المهمة.", 4)
            end
        end
    end
end)

if not _G.AboudHub_SessionStartTime then
    _G.AboudHub_SessionStartTime = tick()
end

task.spawn(function()
    while task.wait(10) do
        local sessionDuration = tick() - _G.AboudHub_SessionStartTime
        
        -- 20 دقيقة = 1200 ثانية
        if sessionDuration >= 1200 and not HubData.Q2_Done then
            HubData.Q2_Done = true
            local pts = AddPoints(30, false)
            SendCustomNotification("🎯 مهمة منجزة!", "كفو! صملت أكثر من 20 دقيقة. كسبت " .. pts .. " نقطة!", 5)
        end
        
        -- 4 ساعات = 14400 ثانية
        if sessionDuration >= 14400 and not HubData.Q3_Done then
            HubData.Q3_Done = true
            local pts = AddPoints(50, false)
            SendCustomNotification("👑 صملة أسطورية!", "وحش! صملت أكثر من 4 ساعات. كسبت " .. pts .. " نقطة!", 8)
        end
        
        -- 8 ساعات = 28800 ثانية
        if sessionDuration >= 28800 and not HubData.M1_Done then
            HubData.M1_Done = true
            local pts = AddPoints(60, false)
            SendCustomNotification("👑 صملة دمار!", "أسطورة! صملت 8 ساعات متواصلة. كسبت " .. pts .. " نقطة!", 8)
        end
    end
end)

-- 3. بناء واجهة المهمات
local missionsTabBtn, missionsTabFunc = Tab("مهمات", 13, function()
    local topBar = Instance.new("Frame", Content)
    topBar.Size = UDim2.new(1, -10, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 20, 0)
    topBar.ZIndex = 4
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)
    local str = Instance.new("UIStroke", topBar); str.Color = Color3.fromRGB(255, 215, 0); str.Thickness = 1.5

    local ptsLbl = Instance.new("TextLabel", topBar)
    ptsLbl.Size = UDim2.new(0.5, 0, 1, 0)
    ptsLbl.Position = UDim2.new(0, 10, 0, 0)
    ptsLbl.BackgroundTransparency = 1
    ptsLbl.Text = "💰 نقاطك الحالية: " .. HubData.MyPoints
    ptsLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    ptsLbl.Font = Enum.Font.GothamBold
    ptsLbl.TextSize = 14
    ptsLbl.TextXAlignment = Enum.TextXAlignment.Left
    ptsLbl.ZIndex = 5
    table.insert(PointsLabels, ptsLbl)

    -- وقت التصفير مع تلميح تدبيل الـ VIP
    local timerLbl = Instance.new("TextLabel", topBar)
    timerLbl.Size = UDim2.new(0.5, -10, 1, 0)
    timerLbl.Position = UDim2.new(0.5, 0, 0, 0)
    timerLbl.BackgroundTransparency = 1
    local isVip = (HubData.OwnsVIP or VIPSupporters[LP.Name])
    timerLbl.TextColor3 = isVip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
    timerLbl.Font = SafeFont
    timerLbl.TextSize = 11
    timerLbl.TextXAlignment = Enum.TextXAlignment.Right
    timerLbl.ZIndex = 5

    task.spawn(function()
        while task.wait(1) do
            if not timerLbl.Parent then break end
            local timeLeft = 86400 - (os.time() - HubData.LastResetTime)
            if timeLeft < 0 then timeLeft = 0 end
            local h = math.floor(timeLeft / 3600)
            local m = math.floor((timeLeft % 3600) / 60)
            local s = timeLeft % 60
            
            if isVip then
                timerLbl.Text = string.format("نقاطك تتدبل (x2) 💎 | تجدد بعد: %02d:%02d:%02d", h, m, s)
            else
                timerLbl.Text = string.format("تتجدد المهام بعد: %02d:%02d:%02d ⏳", h, m, s)
            end
        end
    end)

    local function CreateQuestCard(title, desc, pointsReward, isDone, progressText)
        local card = Instance.new("Frame", Content)
        card.Size = UDim2.new(1, -10, 0, 75)
        card.BackgroundColor3 = isDone and Color3.fromRGB(10, 40, 10) or Color3.fromRGB(25, 25, 30)
        card.ZIndex = 4
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local cStr = Instance.new("UIStroke", card)
        cStr.Color = isDone and Color3.fromRGB(0, 255, 0) or ThemeColor
        cStr.Thickness = 1.5
        if not isDone then table.insert(ThemedStrokes, cStr) end

        local tLbl = Instance.new("TextLabel", card)
        tLbl.Size = UDim2.new(1, -80, 0, 25)
        tLbl.Position = UDim2.new(0, 10, 0, 5)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = title
        tLbl.TextColor3 = Color3.new(1, 1, 1)
        tLbl.Font = SafeFont
        tLbl.TextSize = 15
        tLbl.TextXAlignment = Enum.TextXAlignment.Left
        tLbl.ZIndex = 5

        local dLbl = Instance.new("TextLabel", card)
        dLbl.Size = UDim2.new(1, -80, 0, 40)
        dLbl.Position = UDim2.new(0, 10, 0, 30)
        dLbl.BackgroundTransparency = 1
        local showReward = isVip and (pointsReward*2) or pointsReward
        dLbl.Text = desc .. "\nالجائزة: " .. showReward .. " نقطة" .. (isVip and " (مدبلة)" or "")
        dLbl.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        dLbl.Font = SafeFont
        dLbl.TextSize = 12
        dLbl.TextXAlignment = Enum.TextXAlignment.Left
        dLbl.TextYAlignment = Enum.TextYAlignment.Top
        dLbl.ZIndex = 5

        local statusLbl = Instance.new("TextLabel", card)
        statusLbl.Size = UDim2.new(0, 70, 0, 30)
        statusLbl.Position = UDim2.new(1, -80, 0.5, -15)
        statusLbl.BackgroundColor3 = isDone and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        statusLbl.Text = isDone and "مكتملة ✅" or progressText
        statusLbl.TextColor3 = Color3.new(1,1,1)
        statusLbl.Font = SafeFont
        statusLbl.TextSize = 12
        statusLbl.ZIndex = 5
        Instance.new("UICorner", statusLbl)
        
        if not isDone then
            task.spawn(function()
                while task.wait(1) do
                    if not statusLbl.Parent then break end
                    if title:find("استنساخ") then
                        if HubData.M2_Done then statusLbl.Text = "مكتملة ✅"; statusLbl.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                        else statusLbl.Text = (HubData.SkinsCopied or 0) .. "/3" end
                    elseif title:find("مطفش") then
                        if HubData.Q1_Done then statusLbl.Text = "مكتملة ✅"; statusLbl.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
                        else statusLbl.Text = (HubData.PlayersMadeToLeave or 0) .. "/3" end
                    end
                end
            end)
        end
    end

    CreateQuestCard("🔥 مطفش السيرفر", "اصمل على 3 لاعبين وخلهم يطلعون من الماب.", 10, HubData.Q1_Done, (HubData.PlayersMadeToLeave or 0).."/3")
    CreateQuestCard("⏳ صملة خفيفة", "اصمل في الماب لمدة 20 دقيقة متواصلة.", 30, HubData.Q2_Done, HubData.Q2_Done and "✅" or "جاري..")
    CreateQuestCard("👑 صملة المحترفين", "اصمل في الماب لمدة 4 ساعات متواصلة.", 50, HubData.Q3_Done, HubData.Q3_Done and "✅" or "جاري..")
    CreateQuestCard("🔥 صملة الأساطير", "اصمل في الماب لمدة 8 ساعات متواصلة.", 60, HubData.M1_Done, HubData.M1_Done and "✅" or "جاري..")
    CreateQuestCard("🎭 استنساخ", "قم بنسخ سكنات 3 لاعبين عشوائيين بالسيرفر.", 10, HubData.M2_Done, (HubData.SkinsCopied or 0).."/3")
end)
AddNewBadge(missionsTabBtn)

-- 4. بناء واجهة المتجر (الجديدة)
local shopTabBtn, shopTabFunc = Tab(" متجر", 14, function()
    local topBar = Instance.new("Frame", Content)
    topBar.Size = UDim2.new(1, -10, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(30, 20, 0)
    topBar.ZIndex = 4
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)
    local str = Instance.new("UIStroke", topBar); str.Color = Color3.fromRGB(255, 215, 0); str.Thickness = 1.5

    local ptsLbl = Instance.new("TextLabel", topBar)
    ptsLbl.Size = UDim2.new(1, 0, 1, 0)
    ptsLbl.BackgroundTransparency = 1
    ptsLbl.Text = "💰 نقاطك الحالية: " .. HubData.MyPoints
    ptsLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
    ptsLbl.Font = Enum.Font.GothamBold
    ptsLbl.TextSize = 16
    ptsLbl.ZIndex = 5
    table.insert(PointsLabels, ptsLbl)

    local function CreateShopCard(title, desc, price, isOwned, btnColor, onBuy)
        local card = Instance.new("Frame", Content)
        card.Size = UDim2.new(1, -10, 0, 130)
        card.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        card.ZIndex = 4
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local cStr = Instance.new("UIStroke", card)
        cStr.Color = btnColor
        cStr.Thickness = 1.5

        local tLbl = Instance.new("TextLabel", card)
        tLbl.Size = UDim2.new(1, 0, 0, 30)
        tLbl.Position = UDim2.new(0, 0, 0, 10)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = title
        tLbl.TextColor3 = btnColor
        tLbl.Font = Enum.Font.GothamBlack
        tLbl.TextSize = 20
        tLbl.ZIndex = 5

        local dLbl = Instance.new("TextLabel", card)
        dLbl.Size = UDim2.new(1, -20, 0, 40)
        dLbl.Position = UDim2.new(0, 10, 0, 40)
        dLbl.BackgroundTransparency = 1
        -- ✅ التعديل هنا: حصرية للديسكورد
        if price == "مقفلة" then
            dLbl.Text = desc .. "\nالسعر: حصرية للديسكورد"
        else
            dLbl.Text = desc .. "\nالسعر: " .. price .. " نقطة"
        end
        dLbl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        dLbl.Font = SafeFont
        dLbl.TextSize = 13
        dLbl.TextWrapped = true
        dLbl.ZIndex = 5

        local buyBtn = Instance.new("TextButton", card)
        buyBtn.Size = UDim2.new(0.6, 0, 0, 35)
        buyBtn.Position = UDim2.new(0.2, 0, 1, -45)
        buyBtn.Font = Enum.Font.GothamBold
        buyBtn.TextSize = 15
        buyBtn.TextColor3 = Color3.new(1,1,1)
        buyBtn.ZIndex = 5
        Instance.new("UICorner", buyBtn)

        if isOwned then
            buyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            buyBtn.Text = "مملوكة ✅"
        elseif price == "مقفلة" then
            buyBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
            buyBtn.Text = "لا يمكن الشراء! 🔒"
            buyBtn.MouseButton1Click:Connect(function()
                PlayClickSound()
                SendCustomNotification("🚫 حصرية", "هذه الرتبة حصرية، تُعطى للديسكورد فقط!", 4)
            end)
        else
            buyBtn.BackgroundColor3 = btnColor
            buyBtn.Text = "شراء"
            buyBtn.MouseButton1Click:Connect(function()
                PlayClickSound()
                onBuy(buyBtn)
            end)
        end
    end
    CreateShopCard("🎮 فتح تاب الألعاب", "افتح قسم الألعاب بالكامل لتلعب أونلاين وتتحدى اللاعبين!", 20, HubData.OwnsGamesTab, Color3.fromRGB(0, 150, 255), function(btn)
        if HubData.MyPoints >= 20 then
            HubData.MyPoints = HubData.MyPoints - 20
            HubData.OwnsGamesTab = true
            SaveHubData()
            UpdatePointsDisplay()
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            btn.Text = "مفتوح ✅"
            SendCustomNotification("🎉 مبروك!", "تم فتح تاب الألعاب بنجاح! روح استمتع.", 5)
        else
            SendCustomNotification("🚫 رصيد غير كافي", "تحتاج 20 نقطة!", 4)
        end
    end)

    CreateShopCard("🔥 رتبة صميللل", "تظهر فوق راسك لكل اللاعبين وتثبت إنك أصمل واحد بالسيرفر!", 50, HubData.OwnsSamilllRank, Color3.fromRGB(255, 100, 0), function(btn)
        if HubData.MyPoints >= 50 then
            HubData.MyPoints = HubData.MyPoints - 50
            HubData.OwnsSamilllRank = true
            SaveHubData()
            UpdatePointsDisplay()
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            btn.Text = "مملوكة ✅"
            SendCustomNotification("🎉 مبروك!", "تم شراء رتبة صميللل بنجاح!", 5)
            if _G.UpdateMyRankToSamilll then _G.UpdateMyRankToSamilll() end
        else
            SendCustomNotification("🚫 رصيد غير كافي", "تحتاج 50 نقطة!", 4)
        end
    end)
    CreateShopCard("💎 رتبة VIP الملكية 💎", "تفتح لك الثيمات الحصرية المغلقة (VIP) وتحصل على مميزات أسطورية!", "مقفلة", HubData.OwnsVIP, Color3.fromRGB(255, 215, 0), function() end)

    local shopLayout = Instance.new("UIListLayout", Content)
    shopLayout.Padding = UDim.new(0, 10)
    shopLayout.SortOrder = Enum.SortOrder.LayoutOrder
end)



_G.BlockXOInvites = GetS("BlockXOInvites", false)
_G.CurrentXOGame = nil
_G.MyXOMark = "X"
_G.IsMyTurn = false
_G.XO_IsSearching = false
_G.XOSearchUI = nil

-- 🌐 1. إنشاء اتصال WebSocket خاص بالألعاب فقط!
local GameWsUrl = "wss://free.blr2.piesocket.com/v3/1?api_key=XmHvzh8q4lrmwsYhF7aTSyOyRCoUv1L1YoitkRSF&notify_self=1"
_G.GameSocket = nil

local function ConnectGameSocket()
    pcall(function()
        if _G.GameSocket then _G.GameSocket:Close() end
        _G.GameSocket = WebSocket.connect(GameWsUrl)
        
        _G.GameSocket.OnMessage:Connect(function(message)
            local action, targetName, senderName = string.match(message, "^!(%w+)%s+(%S+)%s*(.*)")
            if not action or not targetName or not senderName then return end
            
            targetName = string.lower(targetName)
            local myName = string.lower(LP.Name)
            
            if action == "xo_invite" and targetName == myName then
                if _G.ShowXOInvite then _G.ShowXOInvite(senderName) end

            elseif action == "xo_accept" and targetName == myName then
                SendCustomNotification("تحدي X O ⚔️", "اللاعب " .. senderName .. " قبل التحدي! اللعبة بتبدأ الآن.", 4)
                _G.IsMyTurn = true
                _G.MyXOMark = "X"
                if _G.CreateOnlineXOGame then _G.CreateOnlineXOGame(senderName, "X") end

            elseif action == "xo_decline" and targetName == myName then
                SendCustomNotification("رفض التحدي ❌", "اللاعب " .. senderName .. " رفض دعوتك.", 4)

            elseif action == "xo_move" and targetName == myName then
                local pos = tonumber(string.match(message, "^!xo_move%s+%S+%s+%S+%s+(%d+)"))
                if pos and _G.CurrentXOGame and _G.CurrentXOGame.Opponent == senderName then
                    local opMark = (_G.MyXOMark == "X") and "O" or "X"
                    if _G.OnlineXOButtons and _G.OnlineXOButtons[pos] then
                        _G.OnlineXOButtons[pos].Text = opMark
                        _G.OnlineXOButtons[pos].TextColor3 = (opMark == "X") and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 50, 255)
                    end
                    
                    -- فحص الفوز بعد حركة الخصم
                    if _G.CheckOnlineWin then 
                        local result = _G.CheckOnlineWin()
                        if result then return end -- إذا انتهت اللعبة نوقف
                    end

                    _G.IsMyTurn = true
                    if _G.CurrentXOGame.StatusLabel then
                        _G.CurrentXOGame.StatusLabel.Text = "دورك (".._G.MyXOMark..")"
                        _G.CurrentXOGame.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                end

            elseif action == "xo_leave" and targetName == myName then
                if _G.CurrentXOGame and _G.CurrentXOGame.Opponent == senderName then
                    _G.CurrentXOGame = nil
                    if sg:FindFirstChild("AboudOnlineXO") then sg.AboudOnlineXO:Destroy() end
                    SendCustomNotification("انسحاب 🏳️", "الخصم انسحب من اللعبة! أنت الفائز.", 5)
                end

            elseif action == "xo_search" and targetName ~= myName then
                if _G.XO_IsSearching then
                    _G.XO_IsSearching = false
                    if _G.XOSearchUI then _G.XOSearchUI:Destroy() end
                    _G.GameSocket:Send("!xo_match_found " .. targetName .. " " .. myName)
                    SendCustomNotification("تم إيجاد خصم! 🌐", "راح تلعب ضد: " .. targetName, 4)
                    _G.IsMyTurn = true
                    _G.MyXOMark = "X"
                    if _G.CreateOnlineXOGame then _G.CreateOnlineXOGame(targetName, "X") end
                end

            elseif action == "xo_match_found" and targetName == myName then
                if _G.XO_IsSearching then
                    _G.XO_IsSearching = false
                    if _G.XOSearchUI then _G.XOSearchUI:Destroy() end
                    SendCustomNotification("تم إيجاد خصم! 🌐", "راح تلعب ضد: " .. senderName, 4)
                    _G.IsMyTurn = false
                    _G.MyXOMark = "O"
                    if _G.CreateOnlineXOGame then _G.CreateOnlineXOGame(senderName, "O") end
                end
            end
        end)
        
        -- إعادة الاتصال التلقائي لو فصل النت
        _G.GameSocket.OnClose:Connect(function()
            task.wait(3)
            ConnectGameSocket()
        end)
    end)
end
task.spawn(ConnectGameSocket)

-- 🏆 2. دالة احترافية لفحص الفوز
_G.CheckOnlineWin = function()
    local winLines = {
        {1,2,3}, {4,5,6}, {7,8,9},
        {1,4,7}, {2,5,8}, {3,6,9},
        {1,5,9}, {3,5,7}
    }
    local btns = _G.OnlineXOButtons
    if not btns then return false end

    for _, line in ipairs(winLines) do
        local b1, b2, b3 = btns[line[1]].Text, btns[line[2]].Text, btns[line[3]].Text
        if b1 ~= "" and b1 == b2 and b2 == b3 then
            _G.IsMyTurn = false
            if _G.CurrentXOGame and _G.CurrentXOGame.StatusLabel then
                if b1 == _G.MyXOMark then
                    _G.CurrentXOGame.StatusLabel.Text = "مبروك! لقد فزت 🎉"
                    _G.CurrentXOGame.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    SendCustomNotification("فوز! 🏆", "لقد فزت على " .. _G.CurrentXOGame.Opponent, 5)
                else
                    _G.CurrentXOGame.StatusLabel.Text = "لقد خسرت 💔"
                    _G.CurrentXOGame.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    SendCustomNotification("خسارة 💔", "لقد خسرت ضد " .. _G.CurrentXOGame.Opponent, 5)
                end
            end
            task.delay(3, function()
                if sg:FindFirstChild("AboudOnlineXO") then sg.AboudOnlineXO:Destroy() end
                _G.CurrentXOGame = nil
            end)
            return true
        end
    end

    local tie = true
    for i=1, 9 do if btns[i].Text == "" then tie = false end end
    if tie then
        _G.IsMyTurn = false
        if _G.CurrentXOGame and _G.CurrentXOGame.StatusLabel then
            _G.CurrentXOGame.StatusLabel.Text = "النتيجة: تعادل 🤝"
            _G.CurrentXOGame.StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        task.delay(3, function()
            if sg:FindFirstChild("AboudOnlineXO") then sg.AboudOnlineXO:Destroy() end
            _G.CurrentXOGame = nil
        end)
        return true
    end
    return false
end
-- 🎮 3. واجهات نظام الأونلاين
_G.CreateOnlineXOGame = function(opponentName, myMark)
    if sg:FindFirstChild("AboudOnlineXO") then sg.AboudOnlineXO:Destroy() end
    
    local GameFrame = Instance.new("Frame", sg)
    GameFrame.Name = "AboudOnlineXO"
    GameFrame.Size = UDim2.new(0, 300, 0, 390)
    GameFrame.Position = UDim2.new(0.5, -150, 0.5, -195)
    GameFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    GameFrame.ZIndex = 9500
    Instance.new("UICorner", GameFrame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", GameFrame); stroke.Color = ThemeColor; stroke.Thickness = 2
    
    local title = Instance.new("TextLabel", GameFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "تحدي ضد: " .. opponentName
    title.TextColor3 = ThemeColor
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.ZIndex = 9501

    local close = Instance.new("TextButton", GameFrame)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.Text = "X"
    close.TextColor3 = Color3.new(1,1,1)
    close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    close.ZIndex = 9501
    Instance.new("UICorner", close)

    local status = Instance.new("TextLabel", GameFrame)
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 40)
    status.Text = _G.IsMyTurn and "دورك ("..myMark..")" or "انتظر دور الخصم..."
    status.TextColor3 = _G.IsMyTurn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 150, 0)
    status.BackgroundTransparency = 1
    status.Font = SafeFont
    status.TextSize = 18
    status.ZIndex = 9501

    local Grid = Instance.new("Frame", GameFrame)
    Grid.Size = UDim2.new(0, 240, 0, 240)
    Grid.Position = UDim2.new(0.5, -120, 0, 100)
    Grid.BackgroundTransparency = 1
    Grid.ZIndex = 9501
    local UIGrid = Instance.new("UIGridLayout", Grid)
    UIGrid.CellSize = UDim2.new(0, 75, 0, 75)
    UIGrid.CellPadding = UDim2.new(0, 5, 0, 5)

    _G.OnlineXOButtons = {}

    for i = 1, 9 do
        local btn = Instance.new("TextButton", Grid)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = ""
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 35
        btn.ZIndex = 9502
        Instance.new("UICorner", btn)
        _G.OnlineXOButtons[i] = btn
        
        btn.MouseButton1Click:Connect(function()
            if not _G.IsMyTurn or btn.Text ~= "" then return end
            if PlayClickSound then PlayClickSound() end
            
            btn.Text = myMark
            btn.TextColor3 = (myMark == "X") and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 50, 255)
            _G.IsMyTurn = false
            status.Text = "انتظر دور الخصم..."
            status.TextColor3 = Color3.fromRGB(255, 150, 0)

            if _G.GameSocket then
                _G.GameSocket:Send("!xo_move " .. opponentName .. " " .. LP.Name .. " " .. tostring(i))
            end

            -- فحص الفوز حقي
            _G.CheckOnlineWin()
        end)
    end

    _G.CurrentXOGame = { Opponent = opponentName, StatusLabel = status, MyMark = myMark }

    close.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        _G.CurrentXOGame = nil
        GameFrame:Destroy()
        if _G.GameSocket then _G.GameSocket:Send("!xo_leave " .. opponentName .. " " .. LP.Name) end
    end)
end

_G.ShowXOInvite = function(senderName)
    if _G.BlockXOInvites then return end

    local InvitePopup = Instance.new("Frame", sg)
    InvitePopup.Size = UDim2.new(0, 320, 0, 180)
    InvitePopup.Position = UDim2.new(0.5, -160, 0.5, -90)
    InvitePopup.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    InvitePopup.ZIndex = 9999
    Instance.new("UICorner", InvitePopup).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", InvitePopup); stroke.Color = ThemeColor; stroke.Thickness = 2

    local blockBtn = Instance.new("TextButton", InvitePopup)
    blockBtn.Size = UDim2.new(0, 35, 0, 35)
    blockBtn.Position = UDim2.new(0, 10, 0, 10)
    blockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    blockBtn.Text = "🚫"
    blockBtn.TextSize = 18
    blockBtn.ZIndex = 10000
    Instance.new("UICorner", blockBtn).CornerRadius = UDim.new(0, 6)
    
    blockBtn.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        _G.BlockXOInvites = true
        SData["BlockXOInvites"] = true 
        if SaveAll then SaveAll() end
        SendCustomNotification("🚫 حظر الدعوات", "تم حظر جميع دعوات الألعاب!", 4)
        InvitePopup:Destroy()
    end)
    local title = Instance.new("TextLabel", InvitePopup)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.Text = "دعوة تحدي X O ⚔️"
    title.TextColor3 = ThemeColor
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.ZIndex = 10000

    local msg = Instance.new("TextLabel", InvitePopup)
    msg.Size = UDim2.new(1, -20, 0, 40)
    msg.Position = UDim2.new(0, 10, 0, 60)
    msg.Text = "اللاعب [" .. senderName .. "] يتحداك أونلاين!"
    msg.TextColor3 = Color3.new(1,1,1)
    msg.BackgroundTransparency = 1
    msg.Font = SafeFont
    msg.TextSize = 15
    msg.ZIndex = 10000
    local acceptBtn = Instance.new("TextButton", InvitePopup)
    acceptBtn.Size = UDim2.new(0.4, 0, 0, 40)
    acceptBtn.Position = UDim2.new(0.55, 0, 1, -55)
    acceptBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    acceptBtn.TextColor3 = Color3.new(1,1,1)
    acceptBtn.Text = "قبول ✅"
    acceptBtn.Font = Enum.Font.GothamBold
    acceptBtn.ZIndex = 10000
    Instance.new("UICorner", acceptBtn)

    local declineBtn = Instance.new("TextButton", InvitePopup)
    declineBtn.Size = UDim2.new(0.4, 0, 0, 40)
    declineBtn.Position = UDim2.new(0.05, 0, 1, -55)
    declineBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    declineBtn.TextColor3 = Color3.new(1,1,1)
    declineBtn.Text = "رفض ❌"
    declineBtn.Font = Enum.Font.GothamBold
    declineBtn.ZIndex = 10000
    Instance.new("UICorner", declineBtn)

    acceptBtn.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        if _G.GameSocket then _G.GameSocket:Send("!xo_accept " .. senderName .. " " .. LP.Name) end
        InvitePopup:Destroy()
        _G.IsMyTurn = false
        _G.MyXOMark = "O"
        if _G.CreateOnlineXOGame then _G.CreateOnlineXOGame(senderName, "O") end
    end)

    declineBtn.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        if _G.GameSocket then _G.GameSocket:Send("!xo_decline " .. senderName .. " " .. LP.Name) end
        InvitePopup:Destroy()
    end)
end
_G.ShowPlayerListForXO = function()
    local InviteFrame = Instance.new("Frame", sg)
    InviteFrame.Size = UDim2.new(0, 320, 0, 380)
    InviteFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
    InviteFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    InviteFrame.ZIndex = 9500
    Instance.new("UICorner", InviteFrame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", InviteFrame); stroke.Color = ThemeColor; stroke.Thickness = 2

    local title = Instance.new("TextLabel", InviteFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "تحدي لاعب بالسيرفر 🎯"
    title.TextColor3 = ThemeColor
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.ZIndex = 9501
    local closeBtn = Instance.new("TextButton", InviteFrame)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 9501
    Instance.new("UICorner", closeBtn)

    closeBtn.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        InviteFrame:Destroy()
    end)
    local scroll = Instance.new("ScrollingFrame", InviteFrame)
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ZIndex = 9501
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 8)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= LP then
            local plrBtn = Instance.new("TextButton", scroll)
            plrBtn.Size = UDim2.new(1, -10, 0, 45)
            plrBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            plrBtn.Text = plr.DisplayName
            plrBtn.TextColor3 = Color3.new(1,1,1)
            plrBtn.Font = SafeFont
            plrBtn.TextSize = 14
            plrBtn.ZIndex = 9502
            Instance.new("UICorner", plrBtn)

            plrBtn.MouseButton1Click:Connect(function()
                if PlayClickSound then PlayClickSound() end
                if _G.GameSocket then
                    _G.GameSocket:Send("!xo_invite " .. plr.Name .. " " .. LP.Name)
                end
                SendCustomNotification("تم الإرسال", "تم إرسال دعوة للاعب: " .. plr.DisplayName, 3)
                InviteFrame:Destroy()
            end)
        end
    end
end
_G.ShowXOSearchingUI = function()
    if _G.XOSearchUI then _G.XOSearchUI:Destroy() end
    local SearchFrame = Instance.new("Frame", sg)
    SearchFrame.Size = UDim2.new(0, 280, 0, 150)
    SearchFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
    SearchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SearchFrame.ZIndex = 9999
    Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 10)
    local str = Instance.new("UIStroke", SearchFrame); str.Color = Color3.fromRGB(0, 150, 255); str.Thickness = 2
    
    local title = Instance.new("TextLabel", SearchFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.Text = "جاري البحث... 🌐"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.ZIndex = 10000

    local sub = Instance.new("TextLabel", SearchFrame)
    sub.Size = UDim2.new(1, 0, 0, 30)
    sub.Position = UDim2.new(0, 0, 0, 50)
    sub.Text = "نبحث لك عن خصم عشوائي يلعب السكربت..."
    sub.TextColor3 = Color3.new(0.8,0.8,0.8)
    sub.BackgroundTransparency = 1
    sub.Font = SafeFont
    sub.TextSize = 13
    sub.ZIndex = 10000

    local cancelBtn = Instance.new("TextButton", SearchFrame)
    cancelBtn.Size = UDim2.new(0.6, 0, 0, 35)
    cancelBtn.Position = UDim2.new(0.2, 0, 1, -45)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    cancelBtn.TextColor3 = Color3.new(1,1,1)
    cancelBtn.Text = "إلغاء ❌"
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.TextSize = 14
    cancelBtn.ZIndex = 10000
    Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 6)

    _G.XOSearchUI = SearchFrame
    _G.XO_IsSearching = true

    cancelBtn.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        _G.XO_IsSearching = false
        SearchFrame:Destroy()
    end)
    task.spawn(function()
        while _G.XO_IsSearching and SearchFrame.Parent do
            if _G.GameSocket then
                _G.GameSocket:Send("!xo_search " .. LP.Name)
            end
            task.wait(3)
        end
    end)
end
_G.ShowXOOnlineMenu = function()
    local MenuFrame = Instance.new("Frame", sg)
    MenuFrame.Size = UDim2.new(0, 300, 0, 220)
    MenuFrame.Position = UDim2.new(0.5, -150, 0.5, -110)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MenuFrame.ZIndex = 9500
    Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", MenuFrame); stroke.Color = ThemeColor; stroke.Thickness = 2

    local title = Instance.new("TextLabel", MenuFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "اختر طريقة اللعب ⚔️"
    title.TextColor3 = ThemeColor
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.ZIndex = 9501

    local close = Instance.new("TextButton", MenuFrame)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 5)
    close.Text = "X"
    close.TextColor3 = Color3.new(1,1,1)
    close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    close.ZIndex = 9501
    Instance.new("UICorner", close)

    close.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        MenuFrame:Destroy()
    end)

    local randomBtn = Instance.new("TextButton", MenuFrame)
    randomBtn.Size = UDim2.new(0.9, 0, 0, 50)
    randomBtn.Position = UDim2.new(0.05, 0, 0, 60)
    randomBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    randomBtn.TextColor3 = Color3.new(1,1,1)
    randomBtn.Text = "🌐 بحث عن خصم عشوائي (عالمي)"
    randomBtn.Font = Enum.Font.GothamBold
    randomBtn.TextSize = 14
    randomBtn.ZIndex = 9501
    Instance.new("UICorner", randomBtn).CornerRadius = UDim.new(0, 8)

    local serverBtn = Instance.new("TextButton", MenuFrame)
    serverBtn.Size = UDim2.new(0.9, 0, 0, 50)
    serverBtn.Position = UDim2.new(0.05, 0, 0, 130)
    serverBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    serverBtn.TextColor3 = Color3.new(1,1,1)
    serverBtn.Text = "🎯 تحدي لاعب بالسيرفر"
    serverBtn.Font = Enum.Font.GothamBold
    serverBtn.TextSize = 14
    serverBtn.ZIndex = 9501
    Instance.new("UICorner", serverBtn).CornerRadius = UDim.new(0, 8)

    randomBtn.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        MenuFrame:Destroy()
        _G.ShowXOSearchingUI()
    end)

    serverBtn.MouseButton1Click:Connect(function()
        if PlayClickSound then PlayClickSound() end
        MenuFrame:Destroy()
        _G.ShowPlayerListForXO()
    end)
end

local gamesTabBtn, gamesTabFunc = Tab(" الألعاب", 15, function()
    -- 🔒 التحقق من الملكية أولاً
    if not HubData.OwnsGamesTab then
        local lockFrame = Instance.new("Frame", Content)
        lockFrame.Size = UDim2.new(1, -10, 0, 200)
        lockFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
        lockFrame.BackgroundTransparency = 0.2
        lockFrame.ZIndex = 4
        Instance.new("UICorner", lockFrame).CornerRadius = UDim.new(0, 10)
        
        local str = Instance.new("UIStroke", lockFrame)
        str.Color = Color3.fromRGB(255, 50, 50)
        str.Thickness = 2
        
        local icon = Instance.new("TextLabel", lockFrame)
        icon.Size = UDim2.new(1, 0, 0, 60)
        icon.Position = UDim2.new(0, 0, 0, 20)
        icon.BackgroundTransparency = 1
        icon.Text = "🔒"
        icon.TextSize = 50
        icon.ZIndex = 5

        local title = Instance.new("TextLabel", lockFrame)
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 90)
        title.BackgroundTransparency = 1
        title.Text = "CLOSED"
        title.TextColor3 = Color3.fromRGB(255, 50, 50)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 30
        title.ZIndex = 5
        
        local desc = Instance.new("TextLabel", lockFrame)
        desc.Size = UDim2.new(1, -20, 0, 40)
        desc.Position = UDim2.new(0, 10, 0, 135)
        desc.BackgroundTransparency = 1
        desc.Text = "عذراً، هذا التاب مقفل!\nيرجى التوجه للمتجر وفتحه مقابل 20 نقطة."
        desc.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        desc.Font = SafeFont
        desc.TextSize = 14
        desc.ZIndex = 5
        
        return -- إيقاف تنفيذ الباقي لكي لا ترسم الألعاب
    end

    -- ✨ رسم الألعاب في حال كان التاب مفتوحاً
    local layout = Instance.new("UIListLayout", Content)
    layout.Padding = UDim.new(0, 12)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local function CreateGameBanner(title, desc, bgEmoji, statText, localCallback, onlineCallback)
        local card = Instance.new("Frame", Content)
        card.Size = UDim2.new(1, -10, 0, 110)
        card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        card.BackgroundTransparency = 0.2
        card.ZIndex = 4
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = ThemeColor
        stroke.Thickness = 1.5
        table.insert(ThemedStrokes, stroke)

        local emojiBg = Instance.new("TextLabel", card)
        emojiBg.Size = UDim2.new(0, 80, 0, 80)
        emojiBg.Position = UDim2.new(1, -90, 0.5, -40)
        emojiBg.BackgroundTransparency = 1
        emojiBg.TextTransparency = 0.85
        emojiBg.Text = bgEmoji
        emojiBg.TextScaled = true
        emojiBg.ZIndex = 4

        local tLbl = Instance.new("TextLabel", card)
        tLbl.Size = UDim2.new(1, -100, 0, 25)
        tLbl.Position = UDim2.new(0, 10, 0, 10)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = title
        tLbl.TextColor3 = ThemeColor
        tLbl.Font = Enum.Font.GothamBold
        tLbl.TextSize = 16
        tLbl.TextXAlignment = Enum.TextXAlignment.Left
        tLbl.ZIndex = 5
        table.insert(ThemedTexts, tLbl)

        local dLbl = Instance.new("TextLabel", card)
        dLbl.Size = UDim2.new(1, -100, 0, 35)
        dLbl.Position = UDim2.new(0, 10, 0, 35)
        dLbl.BackgroundTransparency = 1
        dLbl.Text = desc
        dLbl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        dLbl.Font = SafeFont
        dLbl.TextSize = 12
        dLbl.TextWrapped = true
        dLbl.TextXAlignment = Enum.TextXAlignment.Left
        dLbl.TextYAlignment = Enum.TextYAlignment.Top
        dLbl.ZIndex = 5

        if statText and statText ~= "" then
            local sLbl = Instance.new("TextLabel", card)
            sLbl.Size = UDim2.new(0, 120, 0, 20)
            sLbl.Position = UDim2.new(0, 10, 1, -30)
            sLbl.BackgroundTransparency = 1
            sLbl.Text = statText
            sLbl.TextColor3 = Color3.fromRGB(255, 215, 0) 
            sLbl.Font = Enum.Font.GothamBold
            sLbl.TextSize = 12
            sLbl.TextXAlignment = Enum.TextXAlignment.Left
            sLbl.ZIndex = 5
            
            if title:find("النقرات") then
                task.spawn(function()
                    while task.wait(1) do
                        if not sLbl.Parent then break end
                        sLbl.Text = "🏆 أعلى سكور: " .. HighScore
                    end
                end)
            end
        end

        if onlineCallback then
            local localBtn = Instance.new("TextButton", card)
            localBtn.Size = UDim2.new(0, 75, 0, 30)
            localBtn.Position = UDim2.new(1, -170, 1, -35)
            localBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            localBtn.TextColor3 = Color3.new(1, 1, 1)
            localBtn.Font = Enum.Font.GothamBold
            localBtn.TextSize = 12
            localBtn.Text = "محلي 🤖"
            localBtn.ZIndex = 5
            Instance.new("UICorner", localBtn).CornerRadius = UDim.new(0, 6)
            local lStr = Instance.new("UIStroke", localBtn)
            lStr.Color = ThemeColor
            lStr.Thickness = 1.5
            table.insert(ThemedStrokes, lStr)

            local onlineBtn = Instance.new("TextButton", card)
            onlineBtn.Size = UDim2.new(0, 80, 0, 30)
            onlineBtn.Position = UDim2.new(1, -85, 1, -35)
            onlineBtn.BackgroundColor3 = ThemeColor
            onlineBtn.TextColor3 = Color3.new(1, 1, 1)
            onlineBtn.Font = Enum.Font.GothamBold
            onlineBtn.TextSize = 12
            onlineBtn.Text = "أونلاين 🌐"
            onlineBtn.ZIndex = 5
            Instance.new("UICorner", onlineBtn).CornerRadius = UDim.new(0, 6)
            table.insert(ThemedBGs, onlineBtn)

            localBtn.MouseButton1Click:Connect(function()
                if PlayClickSound then PlayClickSound() end
                localCallback()
            end)
            onlineBtn.MouseButton1Click:Connect(function()
                if PlayClickSound then PlayClickSound() end
                onlineCallback()
            end)
        else
            local playBtn = Instance.new("TextButton", card)
            playBtn.Size = UDim2.new(0, 100, 0, 30)
            playBtn.Position = UDim2.new(1, -110, 1, -35)
            playBtn.BackgroundColor3 = ThemeColor
            playBtn.TextColor3 = Color3.new(1, 1, 1)
            playBtn.Font = Enum.Font.GothamBold
            playBtn.TextSize = 13
            playBtn.Text = "العب الآن 🚀"
            playBtn.ZIndex = 5
            Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)
            table.insert(ThemedBGs, playBtn)

            playBtn.MouseButton1Click:Connect(function()
                if PlayClickSound then PlayClickSound() end
                localCallback()
            end)
        end
    end
    CreateGameBanner(
        "⚡ تحدي سرعة النقرات", 
        "اختبر سرعتك! كم مرة تقدر تضغط الزر في 10 ثواني؟", 
        "⚡", 
        "🏆 أعلى سكور: " .. HighScore, 
        function() CreateSpeedClickerGame(sg) end
    )

    CreateGameBanner(
        "🎮 لعبة X O", 
        "تحدى البوت محلياً، أو العب أونلاين ضد سيرفرك أو العالم!", 
        "❌", 
        "العب أونلاين مع ناس! ", 
        function() CreateXOGame(sg) end,
        function() if _G.ShowXOOnlineMenu then _G.ShowXOOnlineMenu() end end
    )

    CreateGameBanner(
        "🐍 لعبة الأفعى", 
        "لعبة الثعبان الكلاسيكية! كل التفاح وكبر حجمك بس انتبه تصدم في الجدار.", 
        "🐍", 
        "السكور محفوظ 🍎", 
        function() CreateSnakeGame(sg) end
    )
end)

-- ==========================================
-- || 🛡️ تاب الحمايه - يشتغل على كل المابات ||
-- ==========================================
local protectionTabBtn = Tab("🛡️ حمايه", 16, function()

    -- ── مضاد الفويد بانج (Anti Void Bang Tool) ──
    local avbBtn = Instance.new("TextButton", Content)
    avbBtn.Size = UDim2.new(1, 0, 0, 50)
    avbBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
    avbBtn.TextColor3 = Color3.new(1, 1, 1)
    avbBtn.Font = Enum.Font.GothamBold
    avbBtn.TextSize = 14
    avbBtn.Text = "🛡️ تشغيل مضاد الفويد بانج (Anti-Void Bang)"
    avbBtn.ZIndex = 4
    Instance.new("UICorner", avbBtn).CornerRadius = UDim.new(0, 8)
    local avbStr = Instance.new("UIStroke", avbBtn)
    avbStr.Color = Color3.fromRGB(0, 200, 0)
    avbStr.Thickness = 1.5

    local avbDesc = Instance.new("TextLabel", Content)
    avbDesc.Size = UDim2.new(1, 0, 0, 30)
    avbDesc.BackgroundTransparency = 1
    avbDesc.Text = "يحميك من الفويد بانج — يفتح نافذة صغيرة مستقلة."
    avbDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
    avbDesc.Font = Enum.Font.Gotham
    avbDesc.TextSize = 12
    avbDesc.TextWrapped = true
    avbDesc.TextXAlignment = Enum.TextXAlignment.Left
    avbDesc.ZIndex = 4

    local avbLoaded = false
    avbBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        if avbLoaded then
            SendCustomNotification("⚠️", "مضاد الفويد شغال مسبقاً!", 2)
            return
        end
        avbLoaded = true
        task.spawn(function()
            pcall(function()
                local tweenService = game:GetService("TweenService")
                local runService = game:GetService("RunService")
                local userInputService = game:GetService("UserInputService")
                local players = game:GetService("Players")
                local tarekscripterAntiBangCore = Instance.new("ScreenGui")
                local mainFrame = Instance.new("Frame")
                local textLabel = Instance.new("TextLabel")
                local closeBtn = Instance.new("TextButton")
                local textButton = Instance.new("TextButton")
                local uiCorner = Instance.new("UICorner")
                local uiStroke = Instance.new("UIStroke")
                local uiGradient = Instance.new("UIGradient")
                local v1 = tweenService
                local v2 = runService
                local v3 = userInputService
                local localPlayer = players.LocalPlayer
                local playerGui = localPlayer:WaitForChild("PlayerGui")
                
                tarekscripterAntiBangCore.Name = "AntiVoidBangTool"
                tarekscripterAntiBangCore.Parent = playerGui
                tarekscripterAntiBangCore.ResetOnSpawn = false
                tarekscripterAntiBangCore.DisplayOrder = 999
                
                mainFrame.Name = "MainFrame"
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                mainFrame.BorderSizePixel = 0
                mainFrame.Active = true
                mainFrame.ClipsDescendants = true
                mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                mainFrame.Parent = tarekscripterAntiBangCore
                
                uiCorner.CornerRadius = UDim.new(0, 10)
                uiCorner.Parent = mainFrame
                
                uiStroke.Color = Color3.fromRGB(0, 150, 255)
                uiStroke.Thickness = 2
                uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                uiStroke.Parent = mainFrame
                
                uiGradient.Color = ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 50, 150)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255)),
                })
                
                uiGradient.Rotation = 0
                uiGradient.Parent = uiStroke
                
                textLabel.Size = UDim2.new(1, -40, 0, 35)
                textLabel.Position = UDim2.new(0, 10, 0, 0)
                textLabel.Text = "Anti Void Bang Tool"
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextSize = 14
                textLabel.TextXAlignment = Enum.TextXAlignment.Left
                textLabel.Parent = mainFrame
                
                closeBtn.Name = "CloseBtn"
                closeBtn.Size = UDim2.new(0, 30, 0, 30)
                closeBtn.Position = UDim2.new(1, -35, 0, 2)
                closeBtn.Text = "×"
                closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                closeBtn.BackgroundTransparency = 0.8
                closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 20
                closeBtn.Parent = mainFrame
                
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
                
                local function f1(p1)
                  p1.MouseEnter:Connect(function()
                    tweenService:Create(p1, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()
                  end)
                
                  p1.MouseLeave:Connect(function()
                    tweenService:Create(p1, TweenInfo.new(0.2), { BackgroundTransparency = 0.8 }):Play()
                  end)
                end
                
                textButton.Size = UDim2.new(0, 200, 0, 45)
                textButton.Position = UDim2.new(0, 10, 0, 50)
                textButton.Text = "EXECUTE ANTI-VOID BANG"
                textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                textButton.Font = Enum.Font.GothamMedium
                textButton.TextSize = 12
                textButton.Parent = mainFrame
                
                Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
                
                local instance = Instance.new("UIStroke", textButton)
                instance.Color = Color3.fromRGB(0, 150, 255)
                instance.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                
                f1(closeBtn)
                f1(textButton)
                
                local v4, position, position2
                
                mainFrame.InputBegan:Connect(function(input)
                  if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    v4 = true
                    position = input.Position
                    position2 = mainFrame.Position
                
                    input.Changed:Connect(function()
                      if input.UserInputState == Enum.UserInputState.End then
                        v4 = false
                      end
                    end)
                  end
                end)
                
                local v5
                
                mainFrame.InputChanged:Connect(function(input2)
                  if input2.UserInputType == Enum.UserInputType.MouseMovement
                    or input2.UserInputType == Enum.UserInputType.Touch then
                    v5 = input2
                  end
                end)
                
                userInputService.InputChanged:Connect(function(input3)
                  if input3 == v5 and v4 then
                    local v6 = input3.Position - position
                
                    mainFrame.Position = UDim2.new(
                      position2.X.Scale, position2.X.Offset + v6.X, position2.Y.Scale, position2.Y.Offset + v6.Y
                    )
                  end
                end)
                
                runService.RenderStepped:Connect(function() uiGradient.Rotation = uiGradient.Rotation + 3 end)
                mainFrame.Size = UDim2.new(0, 0, 0, 0)
                
                tweenService:Create(
                  mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                  { Size = UDim2.new(0, 220, 0, 110) }
                ):Play()
                
                workspace.FallenPartsDestroyHeight = (0 / 0)
                
                textButton.MouseButton1Click:Connect(function()
                  if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = localPlayer.Character.HumanoidRootPart
                    local cframe = humanoidRootPart.CFrame
                    humanoidRootPart.CFrame = cframe * CFrame.new(0, -999, 0)
                
                    for i = 1, 10 do
                      runService.Heartbeat:Wait()
                    end
                
                    humanoidRootPart.CFrame = cframe
                  end
                end)
                
                closeBtn.MouseButton1Click:Connect(function()
                  tweenService:Create(
                    mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                    { Size = UDim2.new(0, 0, 0, 0) }
                  ):Play()
                
                  task.wait(0.3)
                  tarekscripterAntiBangCore:Destroy()
                end)
            end)
        end)
        SendCustomNotification("🛡️ حمايه", "تم تشغيل مضاد الفويد بانج!", 3)
    end)

    -- Divider
    local div1 = Instance.new("Frame", Content)
    div1.Size = UDim2.new(1, -10, 0, 1)
    div1.BackgroundColor3 = ThemeColor
    div1.BackgroundTransparency = 0.5
    div1.BorderSizePixel = 0
    div1.ZIndex = 4

    -- ── الحماية المتقدمة (نظام حماية كامل) ──
    local advBtn = Instance.new("TextButton", Content)
    advBtn.Size = UDim2.new(1, 0, 0, 50)
    advBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
    advBtn.TextColor3 = Color3.new(1, 1, 1)
    advBtn.Font = Enum.Font.GothamBold
    advBtn.TextSize = 14
    advBtn.Text = "🔰 تشغيل نظام الحماية المتقدمة"
    advBtn.ZIndex = 4
    Instance.new("UICorner", advBtn).CornerRadius = UDim.new(0, 8)
    local advStr = Instance.new("UIStroke", advBtn)
    advStr.Color = Color3.fromRGB(0, 150, 255)
    advStr.Thickness = 1.5

    local advDesc = Instance.new("TextLabel", Content)
    advDesc.Size = UDim2.new(1, 0, 0, 50)
    advDesc.BackgroundTransparency = 1
    advDesc.Text = "نافذة حماية كاملة — مانع فلنق، مانع جلوس، مانع بانق، بانق عكسي، مانع مص، مص عكسي، مانع جلخ، اختفاء.
يعمل على كل المابات."
    advDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
    advDesc.Font = Enum.Font.Gotham
    advDesc.TextSize = 12
    advDesc.TextWrapped = true
    advDesc.TextXAlignment = Enum.TextXAlignment.Left
    advDesc.ZIndex = 4

    local advLoaded = false
    advBtn.MouseButton1Click:Connect(function()
        PlayClickSound()
        if advLoaded then
            SendCustomNotification("⚠️", "نظام الحماية شغال مسبقاً!", 2)
            return
        end
        advLoaded = true
        advBtn.Text = "⏳ جاري التشغيل..."
        task.spawn(function()
            pcall(function()
                do
                end
                
                local players = game:GetService("Players")
                local localPlayer = players.LocalPlayer
                
                local function f1(p1)
                  local v1 = p1
                  local v2 = p1
                
                  do
                  end
                
                  if p1 and p1.Parent then
                    pcall(function()
                      local v3 = p1
                      p1:Destroy()
                      return
                    end)
                  end
                
                  return
                end
                
                local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22,
                  v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40
                
                if _G.SuperProtectionSystem then
                  if (localPlayer:FindFirstChild("PlayerGui")) then
                    local playerGui
                    playerGui = localPlayer.PlayerGui
                
                    f1(playerGui:FindFirstChild("SuperRingPartsGUI"))
                    f1(playerGui:FindFirstChild("NotificationGui"))
                  end
                
                  _G.SuperProtectionSystem = nil
                end
                
                for key, value in pairs(_G) do
                  local v41
                  v41 = (type(value)) == "table"
                
                  local v42
                  v42 = v41
                
                  if v41 then
                    do
                    end
                
                    do
                    end
                
                    v42 = (rawget(value, "Connections")) and rawget(value, "Tracks")
                  end
                
                  if v42 then
                    if value ~= _G.SuperProtectionSystem then
                      for key2, value2 in pairs(value.Connections) do
                      end
                
                      for key3, value3 in pairs(value.Tracks) do
                      end
                
                      for key4 in pairs(value) do
                        value[key4] = nil
                      end
                    end
                  end
                end
                
                _G.SuperProtectionSystem = { Connections = {}, Tracks = {} }
                
                
                local function f2(p2, p3, p4, p5)
                  local v45 = p4
                  local v46 = p2
                  local v47 = p3
                  local v48 = p5
                
                  do
                  end
                
                  local tweenService = (game:GetService("TweenService"))
                
                  do
                  end
                
                  local playerGui2 = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                  local sound = (Instance.new("Sound"))
                  local v49, v50, v51, v52
                
                  sound.SoundId = "rbxassetid://5515669992"
                  sound.Volume = 5
                
                  do
                  end
                
                  sound.Parent = game:GetService("SoundService")
                  local v53 = sound
                  sound:Play()
                
                  do
                  end
                
                  sound.Ended:Connect(function()
                    local v54 = sound
                    sound:Destroy()
                    return
                  end)
                
                  local notificationGui = playerGui2:FindFirstChild("NotificationGui")
                  local v55 = notificationGui
                
                  do
                  end
                
                  local notificationGui2 = notificationGui or Instance.new("ScreenGui")
                  notificationGui2.Name = "NotificationGui"
                  notificationGui2.Parent = playerGui2
                
                  local frame = (Instance.new("Frame"))
                  frame.Size = UDim2.new(0, 220, 0, 60)
                  frame.Position = UDim2.new(0, -200, 0, 20)
                  frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                  frame.BackgroundTransparency = 0.2
                  frame.BorderSizePixel = 1
                  frame.BorderColor3 = Color3.fromRGB(128, 128, 128)
                  frame.ClipsDescendants = true
                  frame.Parent = notificationGui2
                
                  ;(Instance.new("UICorner", frame)).CornerRadius = UDim.new(0, 19)
                
                  local textLabel = Instance.new("TextLabel")
                  textLabel.Size = UDim2.new(1, 0, 1, 0)
                  textLabel.Text = p2
                  textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                  textLabel.TextSize = 13
                  textLabel.TextWrapped = true
                  textLabel.BackgroundTransparency = 1
                  textLabel.Font = Enum.Font.GothamBold
                  textLabel.Parent = frame
                
                  local frame2 = Instance.new("Frame")
                  frame2.Size = UDim2.new(1, 0, 0.1, 0)
                  frame2.Position = UDim2.new(0, 9, 0.8, 0)
                  frame2.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                  frame2.BorderSizePixel = 0
                  frame2.Parent = frame
                
                  ;(Instance.new("UICorner", frame2)).CornerRadius = UDim.new(0, 5)
                
                  local imageLabel = Instance.new("ImageLabel")
                  imageLabel.Size = UDim2.new(0, 20, 0, 20)
                  imageLabel.Position = UDim2.new(1, -213, 0, 5)
                  imageLabel.BackgroundTransparency = 1
                  imageLabel.Image = p4
                  imageLabel.Parent = frame
                
                  local v56 = tweenService
                
                  do
                  end
                
                  ;(tweenService:Create(
                    frame, (TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)),
                    { Position = (UDim2.new(0, 20, 0, 20)) }
                  )):Play()
                
                  local v57 = tweenService
                
                  do
                  end
                
                  ;(tweenService:Create(
                    frame2, (TweenInfo.new(p3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)),
                    { Size = (UDim2.new(0, 0, 0.1, 0)) }
                  )):Play()
                
                  local function f3()
                    local v58 = tweenService
                
                    local create = tweenService:Create(frame, (TweenInfo.new(
                      0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In
                    )), {
                      Position = (UDim2.new(0, -200, 0, frame.Position.Y.Offset)),
                    })
                
                    local v59
                    create:Play()
                
                    do
                    end
                
                    create.Completed:Wait()
                    local v60 = frame
                    frame:Destroy()
                
                    if p5 then
                      p5()
                    end
                
                    return
                  end
                
                  task.spawn(function()
                    task.wait(p3)
                    f3()
                    return
                  end)
                
                  return
                end
                
                f2("✅ تم تحميل نظام الحماية المتقدمة", 5, "rbxassetid://132036502772790", function()
                  print("تم بدء سكربت الحمايةء")
                  return
                end)
                
                task.wait(5)
                local v61 = game
                
                do
                end
                
                local v62 = v61.GetService(v61, "Players")
                
                do
                end
                
                local runService = (game:GetService("RunService"))
                
                do
                end
                
                game:GetService("UserInputService")
                
                do
                end
                
                game:GetService("Workspace")
                
                do
                end
                
                local soundService = (game:GetService("SoundService"))
                local localPlayer2 = v62.LocalPlayer
                
                if not localPlayer2.Character then
                  do
                  end
                
                  localPlayer2.CharacterAdded:Wait()
                end
                
                local function f4(p6)
                  local v63 = p6
                  local sound2 = (Instance.new("Sound"))
                  local v64
                
                  sound2.SoundId = "rbxassetid://" .. p6
                  sound2.Parent = soundService
                
                  local v65 = sound2
                  sound2:Play()
                
                  do
                  end
                
                  sound2.Ended:Connect(function()
                    local v66 = sound2
                    sound2:Destroy()
                    return
                  end)
                
                  return
                end
                
                local superRingPartsGUI = Instance.new("ScreenGui")
                superRingPartsGUI.Name = "SuperRingPartsGUI"
                superRingPartsGUI.ResetOnSpawn = false
                
                local v67 = localPlayer2
                superRingPartsGUI.Parent = localPlayer2:WaitForChild("PlayerGui")
                
                local frame3 = (Instance.new("Frame"))
                frame3.Size = UDim2.new(0, 180, 0, 360)
                frame3.Position = UDim2.new(0.5, -90, 0.5, -180)
                frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame3.BorderSizePixel = 0
                frame3.Parent = superRingPartsGUI
                
                ;(Instance.new("UICorner", frame3)).CornerRadius = UDim.new(0, 15)
                
                frame3.Active = true
                frame3.Draggable = true
                
                local instance = (Instance.new("UIStroke", frame3))
                instance.Color = Color3.fromRGB(0, 170, 255)
                instance.Thickness = 4
                instance.Transparency = 0.2
                
                local v68 = 1
                
                do
                end
                
                runService.Heartbeat:Connect(function(delta)
                  local v69 = delta
                
                  if instance.Thickness >= 5 then
                    v68 = -1
                  else
                    if instance.Thickness <= 2 then
                      v68 = 1
                    end
                  end
                
                  local v70 = instance
                  instance.Thickness = instance.Thickness + v68 * delta * 2
                  return
                end)
                
                local instance2 = Instance.new("TextLabel", frame3)
                instance2.Size = UDim2.new(1, 0, 0, 30)
                instance2.Text = "ح@ماي@ة مت@ق@دم@ة"
                instance2.TextColor3 = Color3.fromRGB(0, 170, 255)
                instance2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                instance2.Font = Enum.Font.SourceSansBold
                instance2.TextSize = 16
                
                Instance.new("UICorner", instance2)
                
                local instance3 = Instance.new("Frame", frame3)
                instance3.Size = UDim2.new(0.5, 0, 0, 2)
                instance3.Position = UDim2.new(0.25, 0, 0, 30)
                instance3.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                instance3.BorderSizePixel = 0
                
                ;(Instance.new("UICorner", instance3)).CornerRadius = UDim.new(0, 1)
                
                local instance4 = (Instance.new("TextButton", frame3))
                instance4.Size = UDim2.new(0, 20, 0, 20)
                instance4.Position = UDim2.new(1, -25, 0, 5)
                instance4.Text = "-"
                instance4.BackgroundColor3 = Color3.fromRGB(205, 84, 75)
                instance4.TextColor3 = instance4.BackgroundColor3
                instance4.Font = Enum.Font.SourceSansBold
                instance4.TextSize = 14
                
                Instance.new("UICorner", instance4)
                local v71 = false
                
                do
                end
                
                instance4.MouseButton1Click:Connect(function()
                  local v72 = not v71
                  local v73, v74, v75, v76, v77
                  v71 = v72
                  local v78 = frame3
                  local v79 = v71
                
                  local udim = v79
                  udim = v79 and UDim2.new(0, 180, 0, 30)
                
                  local v80 = udim
                
                  do
                  end
                
                  frame3:TweenSize(udim or UDim2.new(0, 180, 0, 360), "Out", "Quad", 0.3, true)
                  local v81 = instance4
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  instance4.Text = v71 and "+" or "-"
                  local v82 = frame3
                
                  for key5, value4 in pairs(frame3:GetChildren()) do
                    do
                    end
                
                    do
                    end
                
                    if (value4:IsA("TextButton")) and value4 ~= instance4 then
                      value4.Visible = not v71
                    end
                  end
                
                  f4("12221967")
                  return
                end)
                
                local function f5(p7, p8)
                  local v83 = p7
                  local v84 = p8
                  local instance5 = (Instance.new("TextButton", frame3))
                  local v85, v86
                
                  instance5.Size = UDim2.new(0.8, 0, 0, 30)
                  instance5.Position = UDim2.new(0.1, 0, p8, 0)
                  instance5.Text = p7
                  instance5.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                  instance5.TextColor3 = Color3.new(0, 0, 0)
                  instance5.Font = Enum.Font.SourceSansBold
                  instance5.TextSize = 14
                
                  Instance.new("UICorner", instance5)
                
                  do
                  end
                
                  instance5.MouseEnter:Connect(function()
                    local v87 = instance5
                    instance5:TweenSize((UDim2.new(0.85, 0, 0, 32)), "Out", "Quad", 0.2, true)
                    return
                  end)
                
                  do
                  end
                
                  instance5.MouseLeave:Connect(function()
                    local v88 = instance5
                    instance5:TweenSize((UDim2.new(0.8, 0, 0, 30)), "Out", "Quad", 0.2, true)
                    return
                  end)
                
                  return instance5
                end
                
                local v89 = (f5("مان@ع فل@نق | OFF", 0.12))
                local v90 = (f5("مان@ع جل@وس | OFF", 0.22))
                local v91 = (f5("مان@ع بان@ق | OFF", 0.32))
                local v92 = (f5("بان@ق ع�@سي | OFF", 0.42))
                local v93 = (f5("مان@ع م@ص | OFF", 0.52))
                local v94 = (f5("م@ص عك@سي | OFF", 0.62))
                local v95 = (f5("مان@ع جل@خ | OFF", 0.72))
                
                local instance6 = Instance.new("Frame", frame3)
                instance6.Size = UDim2.new(0.5, 0, 0, 2)
                instance6.Position = UDim2.new(0.25, 0, 0.84, 0)
                instance6.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                instance6.BorderSizePixel = 0
                
                ;(Instance.new("UICorner", instance6)).CornerRadius = UDim.new(0, 1)
                local v96 = (f5("اخ@ت@فاء | OFF", 0.88))
                
                if _G.InvisConnections then
                  for key6, value5 in pairs(_G.InvisConnections) do
                    local v97 = value5
                
                    if v97 then
                      pcall(function()
                        local v98 = v97
                        v97:Disconnect()
                        return
                      end)
                    end
                  end
                end
                
                local v99 = false
                local v100 = {}
                local v101 = {}
                local v102, humanoid, humanoidRootPart
                
                local function f6()
                  local character = localPlayer2.Character
                  local wait = character
                  local v103, v104, v105, v106, v107, v108
                
                  if not character then
                    do
                    end
                
                    wait = localPlayer2.CharacterAdded:Wait()
                  end
                
                  v102 = wait
                
                  do
                  end
                
                  humanoid = (v102:WaitForChild("Humanoid"))
                
                  do
                  end
                
                  humanoidRootPart = (v102:WaitForChild("HumanoidRootPart"))
                  v101 = {}
                
                  do
                  end
                
                  for key7, value6 in pairs(v102:GetDescendants()) do
                    do
                    end
                
                    do
                    end
                
                    if (value6:IsA("BasePart")) and value6.Transparency == 0 then
                      table.insert(v101, value6)
                    end
                  end
                
                  return
                end
                
                f6()
                
                do
                end
                
                v100[1] = runService.Heartbeat:Connect(function()
                  local v109 = v99
                  local v110 = v109
                  local v111, v112, v113, v114, v115, v116
                
                  if v109 then
                    do
                    end
                
                    do
                    end
                
                    v110 = humanoidRootPart and humanoid
                  end
                
                  if v110 then
                    local cframe
                    cframe = humanoidRootPart.CFrame
                
                    do
                    end
                
                    local cameraOffset
                    cameraOffset = humanoid.CameraOffset
                
                    local v117
                    v117 = cframe * (CFrame.new(0, -200000, 0))
                
                    local cframe2
                    cframe2 = CFrame
                
                    local toObjectSpace
                    toObjectSpace = v117.ToObjectSpace
                
                    local new
                    new = cframe2.new
                
                    do
                    end
                
                    do
                    end
                
                    local position
                    position = (toObjectSpace(v117, new(cframe.Position))).Position
                
                    humanoidRootPart.CFrame = v117
                    humanoid.CameraOffset = position
                
                    do
                    end
                
                    runService.RenderStepped:Wait()
                    humanoidRootPart.CFrame = cframe
                    humanoid.CameraOffset = cameraOffset
                  end
                
                  return
                end)
                
                do
                end
                
                v100[2] = localPlayer2.CharacterAdded:Connect(function()
                  v99 = false
                  f6()
                
                  v96.Text = "اخ@ت@فاء | OFF"
                  v96.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                
                  return
                end)
                
                _G.InvisConnections = v100
                local mouseButton1Click = v96.MouseButton1Click
                
                do
                end
                
                local function f7(p9)
                  local v118 = p9
                  local v119 = workspace
                  local v120, v121
                
                  for key8, value7 in pairs(v119:GetDescendants()) do
                    local v122 = value7
                
                    local v123
                    v123 = v122
                
                    local basePart
                    basePart = v122:IsA("BasePart")
                
                    local v124
                    v124 = basePart
                
                    if basePart then
                      local v125
                      v125 = v122
                
                      do
                      end
                
                      do
                      end
                
                      v124 = not (v122:IsDescendantOf(v102)) and not v122.Anchored
                    end
                
                    if v124 then
                      pcall(function()
                        v122.CanCollide = not p9
                        return
                      end)
                    end
                  end
                
                  return
                end
                
                mouseButton1Click:Connect(function()
                  local v126, v127, v128
                  v99 = not v99
                
                  for key9, value8 in pairs(v101) do
                    if value8 then
                      value8.Transparency = v99 and 0.5 or 0
                    end
                  end
                
                  local v129 = v96
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v96.Text = "اخ@ت@فاء | " .. (v99 and "ON" or "OFF")
                  local v130 = v96
                  local v131 = v99
                
                  local color = v131
                  color = v131 and Color3.fromRGB(160, 60, 60)
                
                  local v132 = color
                
                  do
                  end
                
                  v96.BackgroundColor3 = color or Color3.fromRGB(0, 170, 255)
                  f4("12221967")
                  return
                end)
                
                local v133 = false
                local v134 = f7
                
                do
                end
                
                local connect
                
                v89.MouseButton1Click:Connect(function()
                  local v135 = not v133
                  local v136, v137, v138, v139, v140, v141
                  v133 = v135
                  local v142 = v89
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v89.Text = "مان@ع فل@نق | " .. (v133 and "ON" or "OFF")
                  local v143 = v89
                  local v144 = v133
                
                  local color2 = v144
                  color2 = v144 and Color3.fromRGB(160, 60, 60)
                
                  local v145 = color2
                
                  do
                  end
                
                  v89.BackgroundColor3 = color2 or Color3.fromRGB(0, 170, 255)
                  f7(v133)
                
                  if v133 then
                    if connect then
                      do
                      end
                
                      connect:Disconnect()
                    end
                
                    do
                    end
                
                    connect = (workspace.DescendantAdded:Connect(function(descendant)
                      local v146 = descendant
                      local basePart2 = descendant:IsA("BasePart")
                      local v147 = basePart2
                      local v148, v149
                
                      if basePart2 then
                        do
                        end
                
                        do
                        end
                
                        v147 = not (descendant:IsDescendantOf(v102)) and not descendant.Anchored
                      end
                
                      if v147 then
                        descendant.CanCollide = false
                      end
                
                      return
                    end))
                  else
                    if connect then
                      do
                      end
                
                      connect:Disconnect()
                    end
                  end
                
                  f4("12221967")
                  return
                end)
                
                local function f8()
                  local character2 = localPlayer2.Character
                  local wait2 = character2
                  local v150, v151, v152
                
                  if not character2 then
                    do
                    end
                
                    wait2 = localPlayer2.CharacterAdded:Wait()
                  end
                
                  v102 = wait2
                
                  do
                  end
                
                  humanoid = (v102:WaitForChild("Humanoid"))
                
                  do
                  end
                
                  humanoidRootPart = (v102:WaitForChild("HumanoidRootPart"))
                  return
                end
                
                local v153 = false
                local v154 = {}
                local v155 = f8
                f8()
                
                local function f9()
                  local v156, v157, v158, v159, v160, v161
                
                  if v153 == false then
                    return
                  else
                    do
                    end
                
                    do
                    end
                
                    if not humanoid or humanoid.Health <= 0 then
                      return
                    else
                      do
                      end
                
                      humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                
                      do
                      end
                
                      humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                
                      do
                      end
                
                      local sit
                      sit = humanoid:GetPropertyChangedSignal("Sit")
                
                      table.insert(v154, sit:Connect(function()
                        if v153 then
                          humanoid.Sit = false
                        end
                
                        return
                      end))
                
                      local stateChanged
                      stateChanged = humanoid.StateChanged
                
                      table.insert(v154, stateChanged:Connect(function(p10, p11)
                        local v162 = p11
                
                        do
                        end
                
                        local v163 = v153 and p11 == Enum.HumanoidStateType.Seated
                        local v164
                
                        if v163 then
                          do
                          end
                
                          humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                
                        return
                      end))
                
                      local stepped
                      stepped = runService.Stepped
                
                      table.insert(v154, stepped:Connect(function()
                        local v165, v166
                
                        if not v153 then
                          return
                        else
                          local v167
                          v167 = humanoidRootPart
                
                          local seatWeld
                          seatWeld = v167
                
                          if v167 then
                            do
                            end
                
                            seatWeld = humanoidRootPart:FindFirstChild("SeatWeld")
                          end
                
                          if seatWeld then
                            do
                            end
                
                            humanoidRootPart.SeatWeld:Destroy()
                          end
                
                          if humanoid.Sit then
                            humanoid.Sit = false
                          end
                
                          return
                        end
                      end))
                
                      do
                      end
                
                      for index, value9 in ipairs(workspace:GetDescendants()) do
                        local seat
                        seat = value9:IsA("Seat")
                
                        local v168
                        v168 = seat
                
                        do
                        end
                
                        if seat or value9:IsA("VehicleSeat") then
                          value9.Disabled = true
                          value9.CanTouch = false
                        end
                      end
                
                      local descendantAdded
                      descendantAdded = workspace.DescendantAdded
                
                      table.insert(v154, descendantAdded:Connect(function(p12)
                        local v169 = p12
                        local v170 = v153
                        local vehicleSeat = v170
                
                        if v170 then
                          local seat2
                          seat2 = p12:IsA("Seat")
                
                          local v171
                          v171 = seat2
                
                          do
                          end
                
                          vehicleSeat = seat2 or p12:IsA("VehicleSeat")
                        end
                
                        if vehicleSeat then
                          p12.Disabled = true
                          p12.CanTouch = false
                        end
                
                        return
                      end))
                
                      return
                    end
                  end
                end
                
                local function f10()
                  local v172, v173, v174
                
                  for index2, value10 in ipairs(v154) do
                  end
                
                  v154 = {}
                
                  if humanoid then
                    do
                    end
                
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                
                    do
                    end
                
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                  end
                
                  do
                  end
                
                  for index3, value11 in ipairs(workspace:GetDescendants()) do
                    local seat3
                    seat3 = value11:IsA("Seat")
                
                    local v175
                    v175 = seat3
                
                    do
                    end
                
                    if seat3 or value11:IsA("VehicleSeat") then
                      value11.Disabled = false
                      value11.CanTouch = true
                    end
                  end
                
                  return
                end
                
                do
                end
                
                v90.MouseButton1Click:Connect(function()
                  local v176 = not v153
                  local v177, v178, v179
                  v153 = v176
                  local v180 = v90
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v90.Text = "مان@ع جل@وس | " .. (v153 and "ON" or "OFF")
                  local v181 = v90
                  local v182 = v153
                
                  local color3 = v182
                  color3 = v182 and Color3.fromRGB(160, 60, 60)
                
                  local v183 = color3
                
                  do
                  end
                
                  v90.BackgroundColor3 = color3 or Color3.fromRGB(0, 170, 255)
                
                  if v153 then
                    f9()
                  else
                    f10()
                  end
                
                  f4("12221967")
                  return
                end)
                
                do
                end
                
                localPlayer2.CharacterAdded:Connect(function()
                  task.wait()
                  f8()
                
                  if v153 then
                    f9()
                  end
                
                  return
                end)
                
                local loadAnimation
                
                local function f11()
                  local v184
                
                  if loadAnimation then
                    do
                    end
                
                    loadAnimation:Stop()
                    loadAnimation = nil
                  end
                
                  return
                end
                
                local function f12()
                  local v185, v186, v187
                
                  if not humanoid then
                    return
                  else
                    do
                    end
                
                    local animator
                    animator = humanoid:FindFirstChildOfClass("Animator")
                
                    local v188
                    v188 = animator
                
                    do
                    end
                
                    local instance7
                    instance7 = animator or Instance.new("Animator", humanoid)
                
                    local animation
                    animation = Instance.new("Animation")
                    animation.AnimationId = "rbxassetid://117139383441813"
                
                    loadAnimation = (instance7:LoadAnimation(animation))
                    loadAnimation.Priority = Enum.AnimationPriority.Action
                
                    do
                    end
                
                    loadAnimation:Play()
                    loadAnimation.TimePosition = 0.5
                
                    do
                    end
                
                    loadAnimation:AdjustSpeed(0)
                    return
                  end
                end
                
                local v189 = false
                loadAnimation = nil
                local v190 = f11
                local v191 = f12
                
                do
                end
                
                v91.MouseButton1Click:Connect(function()
                  local v192 = not v189
                  local v193, v194, v195
                  v189 = v192
                  local v196 = v91
                  local v197 = v189
                
                  local color4 = v197
                  color4 = v197 and Color3.fromRGB(160, 60, 60)
                
                  local v198 = color4
                
                  do
                  end
                
                  v91.BackgroundColor3 = color4 or Color3.fromRGB(0, 170, 255)
                  local v199 = v91
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v91.Text = "مانع بانق | " .. (v189 and "ON" or "OFF")
                
                  if v189 then
                    f12()
                  else
                    f11()
                  end
                
                  f4("12221967")
                  return
                end)
                
                do
                end
                
                localPlayer2.CharacterAdded:Connect(function(character3)
                  local v200 = character3
                  v102 = character3
                  humanoid = (character3:WaitForChild("Humanoid"))
                
                  if v189 then
                    f12()
                  end
                
                  return
                end)
                
                local v201 = false
                local v202 = { Value = false }
                
                local function f13(p13, p14, p15, p16, p17)
                  local v203 = p13
                  local v204 = p14
                  local v205 = p15
                  local v206 = p16
                  local v207 = p17
                
                  task.spawn(function()
                    local v208, v209
                
                    while not p17.Value do
                      local v210
                      v210 = p13
                
                      p13:Play()
                
                      local v211
                      v211 = p13
                
                      p13:AdjustSpeed(p14)
                      p13.TimePosition = p15
                
                      while true do
                        do
                        end
                
                        do
                        end
                
                        if p13.TimePosition < p16 and not p17.Value then
                          task.wait()
                        else
                          break
                        end
                      end
                
                      p13.TimePosition = p16
                
                      local v212
                      v212 = p13
                
                      p13:AdjustSpeed(0)
                      task.wait(0.1)
                    end
                
                    local v213 = p13
                    p13:Stop()
                    return
                  end)
                
                  return
                end
                
                local v214 = f13
                
                do
                end
                
                local loadAnimation2
                
                v92.MouseButton1Click:Connect(function()
                  local v215 = not v201
                  local v216, v217, v218, v219
                  v201 = v215
                  local v220 = v92
                  local v221 = v201
                
                  local color5 = v221
                  color5 = v221 and Color3.fromRGB(160, 60, 60)
                
                  local v222 = color5
                
                  do
                  end
                
                  v92.BackgroundColor3 = color5 or Color3.fromRGB(0, 170, 255)
                  local v223 = v92
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v92.Text = "بان@ق عك@سي | " .. (v201 and "ON" or "OFF")
                
                  if not humanoid then
                    return
                  else
                    if not loadAnimation2 then
                      do
                      end
                
                      local animator2
                      animator2 = humanoid:FindFirstChildOfClass("Animator")
                
                      local v224
                      v224 = animator2
                
                      do
                      end
                
                      local instance8
                      instance8 = animator2 or Instance.new("Animator", humanoid)
                
                      local animation2
                      animation2 = Instance.new("Animation")
                      animation2.AnimationId = "rbxassetid://122458935180603"
                
                      loadAnimation2 = (instance8:LoadAnimation(animation2))
                      loadAnimation2.Priority = Enum.AnimationPriority.Action
                    end
                
                    v202.Value = not v201
                
                    if v201 then
                      f13(loadAnimation2, 0.5, 0.5, 0.65, v202)
                    end
                
                    f4("12221967")
                    return
                  end
                end)
                
                do
                end
                
                localPlayer2.CharacterAdded:Connect(function(character4)
                  local v225 = character4
                  local v226
                  v102 = character4
                  humanoid = (character4:WaitForChild("Humanoid"))
                  loadAnimation2 = nil
                
                  if v201 then
                    do
                    end
                
                    local animator3
                    animator3 = humanoid:FindFirstChildOfClass("Animator")
                
                    local instance9
                    instance9 = animator3
                    instance9 = animator3 or Instance.new("Animator", humanoid)
                
                    local animation3
                    animation3 = Instance.new("Animation")
                    animation3.AnimationId = "rbxassetid://122458935180603"
                
                    loadAnimation2 = (instance9:LoadAnimation(animation3))
                    loadAnimation2.Priority = Enum.AnimationPriority.Action
                
                    v202.Value = false
                    f13(loadAnimation2, 0.5, 0.5, 0.65, v202)
                  end
                
                  return
                end)
                
                local function f14(p18)
                  local v227 = p18
                  local sound3 = (Instance.new("Sound"))
                  local v228
                
                  sound3.SoundId = "rbxassetid://" .. p18
                  sound3.Volume = 1
                  sound3.Parent = workspace
                
                  local v229 = sound3
                  sound3:Play()
                
                  do
                  end
                
                  sound3.Ended:Connect(function()
                    local v230 = sound3
                    sound3:Destroy()
                    return
                  end)
                
                  return
                end
                
                local localPlayer3 = game.Players.LocalPlayer
                local v231 = f14
                local v232 = false
                
                local v233 = {
                  id = "rbxassetid://102316572910864",
                  speed = 1,
                  looped = true,
                  priority = Enum.AnimationPriority.Action4,
                  fade = 0.2,
                  weight = 1,
                }
                
                do
                end
                
                local v234, f15
                
                local function f16()
                  local v235 = f15()
                  local v236
                
                  if v234 then
                    do
                    end
                
                    v234:Stop(v233.fade)
                  end
                
                  local animation4 = Instance.new("Animation")
                  animation4.AnimationId = v233.id
                
                  local loadAnimation3 = v235:LoadAnimation(animation4)
                  loadAnimation3.Looped = v233.looped
                  loadAnimation3.Priority = v233.priority
                  loadAnimation3:Play(v233.fade, v233.weight)
                  loadAnimation3:AdjustSpeed(v233.speed)
                
                  v234 = loadAnimation3
                  return
                end
                
                f15 = function()
                  local character5 = localPlayer3.Character
                  local wait3 = character5
                  local v237, v238
                
                  if not character5 then
                    do
                    end
                
                    wait3 = localPlayer3.CharacterAdded:Wait()
                  end
                
                  do
                  end
                
                  return wait3:WaitForChild("Humanoid")
                end
                
                local function f17()
                  local v239
                
                  if v234 then
                    do
                    end
                
                    v234:Stop(v233.fade)
                    v234 = nil
                  end
                
                  return
                end
                
                local v240 = f16
                local v241 = f17
                
                do
                end
                
                v93.MouseButton1Click:Connect(function()
                  local v242, v243, v244, v245
                  f14("12221967")
                
                  do
                  end
                
                  v232 = not v232
                  local v246 = v93
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v93.Text = "مان@ع م@ص | " .. (v232 and "ON" or "OFF")
                  local v247 = v93
                  local v248 = v232
                
                  local color6 = v248
                  color6 = v248 and Color3.fromRGB(160, 60, 60)
                
                  local v249 = color6
                
                  do
                  end
                
                  v93.BackgroundColor3 = color6 or Color3.fromRGB(0, 170, 255)
                
                  if v232 then
                    f16()
                  else
                    f17()
                  end
                
                  return
                end)
                
                do
                end
                
                local players2 = game:GetService("Players")
                
                local function f18(p19)
                  local v250 = p19
                  local sound4 = (Instance.new("Sound"))
                  local v251
                
                  sound4.SoundId = "rbxassetid://" .. p19
                  sound4.Volume = 1
                  sound4.Parent = workspace
                
                  local v252 = sound4
                  sound4:Play()
                
                  do
                  end
                
                  sound4.Ended:Connect(function()
                    local v253 = sound4
                    sound4:Destroy()
                    return
                  end)
                
                  return
                end
                
                local localPlayer4 = players2.LocalPlayer
                local v254 = f18
                local v255 = false
                
                local v256 = {
                  id = "rbxassetid://87140791839062",
                  speed = 1,
                  looped = true,
                  priority = Enum.AnimationPriority.Action4,
                  fade = 0.2,
                  weight = 1,
                }
                
                local function f19()
                  local character6 = localPlayer4.Character
                  local wait4 = character6
                  local v257, v258
                
                  if not character6 then
                    do
                    end
                
                    wait4 = localPlayer4.CharacterAdded:Wait()
                  end
                
                  do
                  end
                
                  return wait4:WaitForChild("Humanoid")
                end
                
                local v259
                
                local function f20()
                  local v260 = f19()
                  local v261
                
                  if not v260 then
                    return
                  else
                    if v259 then
                      do
                      end
                
                      v259:Stop(v256.fade)
                    end
                
                    local animation5
                    animation5 = Instance.new("Animation")
                    animation5.AnimationId = v256.id
                
                    local loadAnimation4
                    loadAnimation4 = v260:LoadAnimation(animation5)
                    loadAnimation4.Looped = v256.looped
                    loadAnimation4.Priority = v256.priority
                    loadAnimation4:AdjustWeight(v256.weight)
                    loadAnimation4:AdjustSpeed(v256.speed)
                
                    v259 = loadAnimation4
                    return
                  end
                end
                
                do
                end
                
                v94.MouseButton1Click:Connect(function()
                  local v262, v263, v264, v265, v266, v267
                  f18("12221967")
                
                  do
                  end
                
                  v255 = not v255
                  local v268 = v94
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v94.Text = "م@ص عك@سي | " .. (v255 and "ON" or "OFF")
                  local v269 = v94
                  local v270 = v255
                
                  local color7 = v270
                  color7 = v270 and Color3.fromRGB(160, 60, 60)
                
                  local v271 = color7
                
                  do
                  end
                
                  v94.BackgroundColor3 = color7 or Color3.fromRGB(0, 170, 255)
                
                  if v255 then
                    f20()
                
                    do
                    end
                
                    v259:Play(v256.fade)
                    v259.TimePosition = 0
                  else
                    if v259 then
                      do
                      end
                
                      v259:Stop(v256.fade)
                    end
                  end
                
                  return
                end)
                
                local v272 = false
                local v273
                
                local function f21(p20)
                  local v274 = p20
                  v102 = p20
                  humanoid = (p20:WaitForChild("Humanoid"))
                
                  if v273 then
                    pcall(function()
                      do
                      end
                
                      v273:Stop()
                      return
                    end)
                
                    v273 = nil
                  end
                
                  return
                end
                
                if localPlayer2.Character then
                  f21(localPlayer2.Character)
                end
                
                do
                end
                
                localPlayer2.CharacterAdded:Connect(f21)
                
                local function f22()
                  do
                  end
                
                  local v275 = not humanoid or humanoid.Health <= 0
                  local v276, v277, loadAnimation5
                
                  if v275 then
                    return
                  else
                    if v273 then
                      do
                      end
                
                      v273:Stop()
                      v273 = nil
                    end
                
                    local animation6
                    animation6 = Instance.new("Animation")
                    animation6.AnimationId = "rbxassetid://87058607990254"
                
                    do
                    end
                
                    local animator4
                    animator4 = humanoid:FindFirstChildOfClass("Animator")
                
                    if not animator4 then
                      animator4 = Instance.new("Animator", humanoid)
                    end
                
                    loadAnimation5 = (animator4:LoadAnimation(animation6))
                    loadAnimation5.Priority = Enum.AnimationPriority.Action4
                
                    local v278
                    v278 = loadAnimation5
                
                    loadAnimation5:Play(0, 1, 1)
                    loadAnimation5.TimePosition = 0.8
                
                    task.spawn(function()
                      local v279
                
                      while loadAnimation5.IsPlaying do
                        task.wait()
                
                        do
                        end
                
                        if loadAnimation5.TimePosition >= 0.8 then
                          local v280
                          v280 = loadAnimation5
                
                          loadAnimation5:AdjustSpeed(0)
                          break
                        end
                      end
                
                      return
                    end)
                
                    v273 = loadAnimation5
                    return
                  end
                end
                
                local function f23()
                  local v281
                
                  if v273 then
                    do
                    end
                
                    v273:Stop()
                    v273 = nil
                  end
                
                  return
                end
                
                local v282 = f22
                local v283 = f23
                
                do
                end
                
                v95.MouseButton1Click:Connect(function()
                  local v284 = not v272
                  local v285, v286, v287
                  v272 = v284
                  local v288 = v95
                
                  do
                  end
                
                  do
                  end
                
                  do
                  end
                
                  v95.Text = "مان@ع جلخ | " .. (v272 and "ON" or "OFF")
                  local v289 = v95
                  local v290 = v272
                
                  local color8 = v290
                  color8 = v290 and Color3.fromRGB(160, 60, 60)
                
                  local v291 = color8
                
                  do
                  end
                
                  v95.BackgroundColor3 = color8 or Color3.fromRGB(0, 170, 255)
                
                  if v272 then
                    f22()
                  else
                    f23()
                  end
                
                  f18("12221967")
                  return
                end)
                
                do
                end
                
                localPlayer2.CharacterAdded:Connect(function(character7)
                  f21(character7)
                  if v232 then pcall(f16) end
                  if v255 then pcall(f20) end
                  if v272 then pcall(f22) end
                  return
                end)
                
                return
            end)
            advBtn.Text = "✅ نظام الحماية شغال"
            advBtn.BackgroundColor3 = Color3.fromRGB(10, 50, 80)
            SendCustomNotification("✅ حمايه", "تم تشغيل نظام الحماية المتقدمة بنجاح!", 4)
        end)
    end)

    -- Info card
    local infoCard = Instance.new("Frame", Content)
    infoCard.Size = UDim2.new(1, 0, 0, 60)
    infoCard.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    infoCard.BackgroundTransparency = 0.3
    infoCard.ZIndex = 4
    Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0, 8)
    local infoStr = Instance.new("UIStroke", infoCard)
    infoStr.Color = ThemeColor
    infoStr.Thickness = 1
    infoStr.Transparency = 0.5

    local infoLbl = Instance.new("TextLabel", infoCard)
    infoLbl.Size = UDim2.new(1, -10, 1, 0)
    infoLbl.Position = UDim2.new(0, 5, 0, 0)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = "🛡️ تاب الحمايه — جميع الأدوات تشتغل على كل المابات بدون قيود."
    infoLbl.TextColor3 = Color3.fromRGB(180, 200, 180)
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextSize = 12
    infoLbl.TextWrapped = true
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.ZIndex = 5

end)
