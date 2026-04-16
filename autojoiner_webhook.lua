-- // VAULT AUTOJOINER COMPLET AVEC WEBHOOK + LIEN JOIN \\
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/ZKRafiLeVrai/duplication/refs/heads/main/autojoiner_complet.lua"))()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

local function http_call(params)
  if req then return req(params)
  else
    if (params.Method == "GET" or not params.Method) and params.Url then
      local ok, body = pcall(function() return game:HttpGet(params.Url) end)
      if ok then return { StatusCode = 200, Body = body } end
    end
    return { StatusCode = 0, Body = "" }
  end
end

local API = "http://127.0.0.1:5000"
local TITLE = "Vault Autojoiner"
local DISCORD = "https://discord.gg/cq29atkGA6"

-- ===== CONFIGURATION WEBHOOK =====
local WEBHOOK_URL = "https://discord.com/api/webhooks/1494437937725837434/LK-b_JVnYLuZkdMpqeLnZoTpgzCY8ra01kKRe3LD-TDzNvTX0qtBGuTP9Prj-EDigti_" -- ⚠️ REMPLACE PAR TON WEBHOOK
local RARITY_THRESHOLD = 20 -- Million/s minimum

local state = {
  running = false,
  auto = false,
  lastJob = "",
  blacklist = {},
  min_money_raw = 0,
}

local _min_last = 0
local showJoinInfo
local inBlacklist
local blacklistOn = true

inBlacklist = function(name)
  local nm = string.lower(tostring(name or ""))
  for term, on in pairs(state.blacklist) do
    if on and string.find(nm, string.lower(tostring(term)), 1, true) then
      return true
    end
  end
  return false
end

local function jsonDecode(s)
  local ok, data = pcall(function() return HttpService:JSONDecode(s) end)
  if ok then return data end
  return nil
end

local function normalizeJobId(id)
  if not id then return nil end
  local s = tostring(id):gsub("\r", " "):gsub("\n", " "):gsub("\t", " "):gsub("%s+", ""):gsub("^[\"']+", ""):gsub("[\"']+$", "")
  if #s < 32 or #s > 64 then return nil end
  if not s:find("%-") then return nil end
  for i = 1, #s do
    local ch = s:sub(i, i)
    local isHex = ch:match("%x") ~= nil
    if (not isHex) and ch ~= '-' then return nil end
  end
  return s
end

local function parseJoinScript(js)
  if type(js) ~= "string" or #js == 0 then return nil, nil end
  local s = tostring(js):gsub('"', ""):gsub("'", "")
  local GUID = "%x+%-%x+%-%x+%-%x+%-%x+"
  local pid, jid = s:match("TeleportService:%s*TeleportToPlaceInstance%(%s*(%d+)%s*,%s*("..GUID..")%s*%)")
  if not pid or not jid then
    pid, jid = s:match("TeleportToPlaceInstance%(%s*(%d+)%s*,%s*("..GUID..")%s*%)")
  end
  if not pid or not jid then
    pid, jid = s:match("placeId%s*=%s*(%d+).-[jJ]ob[Ii]d%s*=%s*("..GUID..")")
  end
  if not pid or not jid then
    local p2, j2 = s:match("(%d+).-("..GUID..")")
    if p2 and j2 then pid, jid = p2, j2 end
  end
  local njid = normalizeJobId(jid)
  local npid = pid and tonumber(pid) or nil
  return njid, npid
end

local function teleport(jobId, placeId)
  jobId = normalizeJobId(jobId)
  if not jobId or #jobId == 0 then return end
  local pid = placeId or game.PlaceId
  TeleportService:TeleportToPlaceInstance(pid, jobId, Players.LocalPlayer)
end

local function turboGetJobId()
  local minOn = (tonumber(state.min_money_raw) or 0) > 0
  local bl={}; for k,v in pairs(state.blacklist) do if v then table.insert(bl,k) end end
  local body = HttpService:JSONEncode({ blacklist = bl, min_money = (tonumber(state.min_money_raw) or 0) * 1000000 })
  local ok,res = pcall(function()
    return http_call({ Url = API.."/next", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
  end)
  if ok and res and (res.StatusCode==200 or res.StatusCode==201) and res.Body then
    local d=jsonDecode(res.Body)
    if d and d.ok and d.server then
      local jid,pid = parseJoinScript(d.server.join_script or "")
      if not jid and d.server.job_id then jid = normalizeJobId(tostring(d.server.job_id)) end
      if not pid and d.server.place_id then pid = tonumber(d.server.place_id) end
      if jid then return jid, pid end
    end
  end
  local ok2, res2 = pcall(function() return http_call({ Url = API.."/servers", Method = "GET" }) end)
  if ok2 and res2 and res2.StatusCode == 200 and res2.Body then
    local d2 = jsonDecode(res2.Body)
    if d2 and d2.servers and type(d2.servers) == "table" then
      local best = nil
      for _, it in ipairs(d2.servers) do
        local nm = tostring(it.pet_name or "")
        local val = tonumber(it.value or 0) or 0
        local isBlk = (type(inBlacklist) == "function") and inBlacklist(nm) or false
        if not (blacklistOn and isBlk) and (not string.find(string.lower(nm), "brainrot notify")) then
          if not minOn or val >= (state.min_money_raw * 1e6) then
            if (not best) or (val > (tonumber(best.value or 0) or 0)) then best = it end
          end
        end
      end
      if best then
        local jid, pid = nil, nil
        if best.join_script then jid, pid = parseJoinScript(best.join_script) end
        if not jid and best.job_id then jid = normalizeJobId(tostring(best.job_id)) end
        if not pid and best.place_id then pid = tonumber(best.place_id) end
        if jid then return jid, pid end
      end
    end
  end
  return nil
end

-- ===== FONCTIONS WEBHOOK =====
local function generateJoinLink(placeId, jobId)
    placeId = placeId or game.PlaceId
    jobId = jobId or ""
    if jobId ~= "" then
        return string.format("https://www.roblox.com/games/%d?privateServerLinkCode=%s", placeId, jobId)
    else
        return string.format("https://www.roblox.com/games/%d", placeId)
    end
end

local function sendDiscordWebhook(serverInfo)
    if WEBHOOK_URL == "https://discord.com/api/webhooks/TON_WEBHOOK_ICI" then return end
    
    local petName = serverInfo.pet_name or "Inconnu"
    local value = tonumber(serverInfo.value or 0) or 0
    local valueMS = string.format("$%.1fM/s", value / 1000000)
    local mutation = serverInfo.mutation or "Aucune"
    local jobId = serverInfo.job_id or ""
    local placeId = serverInfo.place_id or game.PlaceId
    local joinLink = generateJoinLink(placeId, jobId)
    
    local embed = {
        ["title"] = "🔥 ANIMAL RARE DÉTECTÉ !",
        ["color"] = 0xFF5500,
        ["fields"] = {
            {["name"] = "🧬 Animal", ["value"] = petName, ["inline"] = true},
            {["name"] = "💰 Valeur", ["value"] = valueMS, ["inline"] = true},
            {["name"] = "✨ Mutation", ["value"] = mutation, ["inline"] = true},
            {["name"] = "🔗 Lien direct", ["value"] = "[Clique ici pour rejoindre](" .. joinLink .. ")", ["inline"] = false},
            {["name"] = "🆔 JobId", ["value"] = "||" .. jobId .. "||", ["inline"] = false}
        },
        ["footer"] = {["text"] = "Autojoiner Vault • " .. os.date("%H:%M:%S")},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    
    local payload = HttpService:JSONEncode({["embeds"] = {embed}})
    pcall(function() http_call({Url = WEBHOOK_URL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = payload}) end)
end

local function analyzeServers()
    local ok, res = pcall(function() return http_call({Url = API.."/servers", Method = "GET"}) end)
    if not ok or not res or res.StatusCode ~= 200 then return end
    local data = jsonDecode(res.Body or "{}")
    local servers = data.servers or {}
    local rareServers = {}
    for _, server in ipairs(servers) do
        local value = tonumber(server.value or 0) or 0
        local valueM = value / 1000000
        if valueM >= RARITY_THRESHOLD then
            table.insert(rareServers, {
                pet_name = server.pet_name,
                value = value,
                job_id = server.job_id,
                place_id = server.place_id,
                mutation = server.mutation or server.pet_name:match("%[(.+)%]") or "Inconnue"
            })
        end
    end
    table.sort(rareServers, function(a, b) return a.value > b.value end)
    return rareServers
end

-- ===== SURVEILLANCE WEBHOOK =====
local lastNotified = {}
local NOTIFY_COOLDOWN = 300

task.spawn(function()
    while true do
        task.wait(30)
        local rareServers = analyzeServers()
        if rareServers then
            for _, server in ipairs(rareServers) do
                local key = server.pet_name .. "_" .. (server.mutation or "")
                local now = os.time()
                if not lastNotified[key] or (now - lastNotified[key]) > NOTIFY_COOLDOWN then
                    sendDiscordWebhook(server)
                    lastNotified[key] = now
                    print("📢 Webhook envoyé pour: " .. server.pet_name)
                end
            end
        end
    end
end)

-- ===== UI COMPLÈTE =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VaultJoinerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function protect_gui(gui)
  pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
  local lp = Players.LocalPlayer
  local playerGui = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui"))
  local parent = playerGui
  if not parent then parent = game:FindFirstChildOfClass("CoreGui") end
  if not parent then parent = game:GetService("StarterGui") end
  gui.Parent = parent
end

local green = Color3.fromRGB(24,164,99)
local red = Color3.fromRGB(196,62,62)
local gray = Color3.fromRGB(28,28,28)
local gray2 = Color3.fromRGB(40,40,40)
local gray3 = Color3.fromRGB(52,52,52)

local Root = Instance.new("Frame")
Root.Size = UDim2.new(0, 980, 0, 560)
Root.Position = UDim2.new(0.5, -490, 0.5, -280)
Root.BackgroundColor3 = gray
Root.BorderSizePixel = 0
Root.Active = true
Root.Draggable = true
Root.Parent = ScreenGui

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = gray2
Header.BorderSizePixel = 0
Header.Parent = Root

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 14, 0, 8)
Title.Size = UDim2.new(1, -28, 0, 28)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(230,230,230)
Title.Text = "Auto Joiner | Vault"
Title.Parent = Header

local RunningDot = Instance.new("TextLabel")
RunningDot.BackgroundTransparency = 1
RunningDot.Size = UDim2.new(0, 120, 1, 0)
RunningDot.Position = UDim2.new(1, -130, 0, 0)
RunningDot.Font = Enum.Font.Gotham
RunningDot.TextSize = 14
RunningDot.TextXAlignment = Enum.TextXAlignment.Right
RunningDot.TextColor3 = Color3.fromRGB(130,130,130)
RunningDot.Text = "+ IDLE"
RunningDot.Parent = Header

local Body = Instance.new("Frame")
Body.BackgroundColor3 = gray
Body.BorderSizePixel = 0
Body.Position = UDim2.new(0, 0, 0, 44)
Body.Size = UDim2.new(1, 0, 1, -44)
Body.Parent = Root

local Left = Instance.new("Frame")
Left.BackgroundColor3 = gray
Left.BorderSizePixel = 0
Left.Position = UDim2.new(0, 0, 0, 0)
Left.Size = UDim2.new(0, 270, 1, 0)
Left.Parent = Body

local Right = Instance.new("Frame")
Right.BackgroundColor3 = gray
Right.BorderSizePixel = 0
Right.Position = UDim2.new(0, 270, 0, 0)
Right.Size = UDim2.new(1, -270, 1, 0)
Right.Parent = Body

local function makeBtn(parent, text, bg, pos)
  local b = Instance.new("TextButton")
  b.Size = UDim2.new(0, 120, 0, 36)
  b.Position = pos
  b.BackgroundColor3 = bg
  b.BorderSizePixel = 0
  b.TextColor3 = Color3.fromRGB(255,255,255)
  b.Font = Enum.Font.GothamBold
  b.TextSize = 14
  b.Text = text
  b.AutoButtonColor = true
  b.Parent = parent
  return b
end

local runningBtn = makeBtn(Left, "START", green, UDim2.new(0, 16, 0, 16))
local stopBtn = makeBtn(Left, "STOP", red, UDim2.new(0, 16, 0, 56))
local turboBtn = makeBtn(Left, "TURBO [J]", Color3.fromRGB(200,120,60), UDim2.new(0, 16, 0, 170))

local autoLabel = Instance.new("TextLabel")
autoLabel.BackgroundTransparency = 1
autoLabel.Position = UDim2.new(0, 16, 0, 96)
autoLabel.Size = UDim2.new(0, 240, 0, 24)
autoLabel.Font = Enum.Font.Gotham
autoLabel.TextSize = 14
autoLabel.TextColor3 = Color3.fromRGB(210,210,210)
autoLabel.TextXAlignment = Enum.TextXAlignment.Left
autoLabel.Text = "AUTO JOIN: OFF"
autoLabel.Parent = Left

local minLabel = Instance.new("TextLabel")
minLabel.BackgroundTransparency = 1
minLabel.Position = UDim2.new(0, 16, 0, 116)
minLabel.Size = UDim2.new(0, 240, 0, 20)
minLabel.Font = Enum.Font.Gotham
minLabel.TextSize = 14
minLabel.TextColor3 = Color3.fromRGB(200,200,200)
minLabel.TextXAlignment = Enum.TextXAlignment.Left
minLabel.Text = "MIN: 0M"
minLabel.Parent = Left

local mfToggle = Instance.new("TextButton")
mfToggle.Size = UDim2.new(0, 120, 0, 22)
mfToggle.Position = UDim2.new(0, 16, 0, 140)
mfToggle.BackgroundColor3 = Color3.fromRGB(90,90,90)
mfToggle.BorderSizePixel = 0
mfToggle.TextColor3 = Color3.fromRGB(255,255,255)
mfToggle.Font = Enum.Font.GothamBold
mfToggle.TextSize = 13
mfToggle.Text = "FILTER: OFF"
mfToggle.Parent = Left

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 28, 0, 22)
minusBtn.Position = UDim2.new(0, 182, 0, 116)
minusBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
minusBtn.BorderSizePixel = 0
minusBtn.TextColor3 = Color3.fromRGB(255,255,255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 14
minusBtn.Text = "-"
minusBtn.Parent = Left

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 28, 0, 22)
plusBtn.Position = UDim2.new(0, 214, 0, 116)
plusBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
plusBtn.BorderSizePixel = 0
plusBtn.TextColor3 = Color3.fromRGB(255,255,255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 14
plusBtn.Text = "+"
plusBtn.Parent = Left

-- ===== BOUTON SCAN RARE (NOUVEAU) =====
local scanRareBtn = Instance.new("TextButton")
scanRareBtn.Size = UDim2.new(0, 120, 0, 28)
scanRareBtn.Position = UDim2.new(0, 16, 0, 210)
scanRareBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
scanRareBtn.BorderSizePixel = 0
scanRareBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanRareBtn.Font = Enum.Font.GothamBold
scanRareBtn.TextSize = 11
scanRareBtn.Text = "🔍 SCAN RARE"
scanRareBtn.Parent = Left

local toast = Instance.new("TextLabel")
toast.Size = UDim2.new(1, 0, 0, 22)
toast.Position = UDim2.new(0, 0, 0, 0)
toast.BackgroundColor3 = Color3.fromRGB(20,20,20)
toast.BackgroundTransparency = 0.2
toast.Visible = false
toast.Text = ""
toast.TextColor3 = Color3.fromRGB(200,200,255)
toast.Font = Enum.Font.Gotham
toast.TextSize = 14
toast.Parent = ScreenGui

local function showToast(msg)
  toast.Text = msg
  toast.Visible = true
  task.delay(1.5, function() toast.Visible = false end)
end

scanRareBtn.MouseButton1Click:Connect(function()
    local rareServers = analyzeServers()
    if rareServers and #rareServers > 0 then
        for _, server in ipairs(rareServers) do
            sendDiscordWebhook(server)
        end
        showToast(#rareServers .. " animaux rares signalés sur Discord !")
        print("📢 " .. #rareServers .. " animaux rares signalés")
    else
        showToast("Aucun animal > " .. RARITY_THRESHOLD .. "M/s trouvé")
        print("📢 Aucun animal > " .. RARITY_THRESHOLD .. "M/s trouvé")
    end
end)

local inviBtn = makeBtn(Left, "INVI: OFF [H]", Color3.fromRGB(68,114,196), UDim2.new(0, 16, 0, 254))

-- ===== SUITE DE L'UI (SCROLLER, TABS, ETC.) =====
local tabBar = Instance.new("Frame")
tabBar.BackgroundColor3 = gray
tabBar.BorderSizePixel = 0
tabBar.Size = UDim2.new(1, -16, 0, 28)
tabBar.Position = UDim2.new(0, 8, 0, 8)
tabBar.Parent = Right

local function makeTab(txt, x)
  local b = Instance.new("TextButton")
  b.Size = UDim2.new(0, 110, 0, 28)
  b.Position = UDim2.new(0, x, 0, 0)
  b.BackgroundColor3 = gray2
  b.BorderSizePixel = 0
  b.TextColor3 = Color3.fromRGB(230,230,230)
  b.Font = Enum.Font.GothamBold
  b.TextSize = 14
  b.Text = txt
  b.AutoButtonColor = true
  b.Parent = tabBar
  return b
end
local tabBtnServers = makeTab("SERVERS", 0)
local tabBtnMulti = makeTab("MULTI PETS", 120)
local currentTab = "servers"

local rowHeader = Instance.new("Frame")
rowHeader.BackgroundColor3 = gray2
rowHeader.BorderSizePixel = 0
rowHeader.Size = UDim2.new(1, -16, 0, 34)
rowHeader.Position = UDim2.new(0, 8, 0, 50)
rowHeader.Parent = Right

local function headerText(txt, x)
  local l = Instance.new("TextLabel")
  l.BackgroundTransparency = 1
  l.Position = UDim2.new(0, x, 0, 7)
  l.Size = UDim2.new(0, 160, 0, 20)
  l.Font = Enum.Font.GothamBold
  l.TextSize = 14
  l.TextColor3 = Color3.fromRGB(220,220,220)
  l.TextXAlignment = Enum.TextXAlignment.Left
  l.Text = txt
  l.Parent = rowHeader
end
headerText("PET", 12)

local moneyHead = Instance.new("TextLabel")
moneyHead.BackgroundTransparency = 1
moneyHead.Position = UDim2.new(0.72, 0, 0, 7)
moneyHead.Size = UDim2.new(0, 120, 0, 20)
moneyHead.Font = Enum.Font.GothamBold
moneyHead.TextSize = 14
moneyHead.TextColor3 = Color3.fromRGB(220,220,220)
moneyHead.TextXAlignment = Enum.TextXAlignment.Left
moneyHead.Text = "MONEY/s"
moneyHead.Parent = rowHeader

local Scroller = Instance.new("ScrollingFrame")
Scroller.Position = UDim2.new(0, 8, 0, 84)
Scroller.Size = UDim2.new(1, -16, 1, -100)
Scroller.BackgroundTransparency = 1
Scroller.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroller.ScrollBarThickness = 6
Scroller.Parent = Right

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = Scroller

local function makeRow(info)
  local row = Instance.new("Frame")
  row.BackgroundColor3 = gray2
  row.BorderSizePixel = 0
  row.Size = UDim2.new(1, -10, 0, 40)

  local pet = Instance.new("TextLabel")
  pet.BackgroundTransparency = 1
  pet.Position = UDim2.new(0, 10, 0, 10)
  pet.Size = UDim2.new(0, 320, 0, 20)
  pet.Font = Enum.Font.Gotham
  pet.TextSize = 14
  pet.TextColor3 = Color3.fromRGB(230,230,230)
  pet.TextXAlignment = Enum.TextXAlignment.Left
  pet.Text = tostring(info.pet_name or "Unknown")
  pet.Parent = row

  local money = Instance.new("TextLabel")
  money.BackgroundTransparency = 1
  money.Position = UDim2.new(0, 420, 0, 10)
  money.Size = UDim2.new(0, 140, 0, 20)
  money.Font = Enum.Font.GothamBold
  money.TextSize = 14
  money.TextColor3 = Color3.fromRGB(50,220,140)
  local v = tonumber(info.value or 0) or 0
  if v > 0 then
    money.Text = string.format("$%.1fM/s", v/1e6)
  else
    money.Text = "--"
  end
  money.Parent = row

  local join = Instance.new("TextButton")
  join.Size = UDim2.new(0, 100, 0, 28)
  join.Position = UDim2.new(1, -116, 0, 6)
  join.BackgroundColor3 = Color3.fromRGB(200,60,60)
  join.BorderSizePixel = 0
  join.TextColor3 = Color3.fromRGB(255,255,255)
  join.Font = Enum.Font.GothamBold
  join.TextSize = 14
  join.Text = "JOIN"
  join.Parent = row
  join.MouseButton1Click:Connect(function()
    local jid, pid = nil, nil
    if info.join_script then jid, pid = parseJoinScript(info.join_script) end
    if not jid and info.job_id then jid = normalizeJobId(tostring(info.job_id)) end
    if not pid and info.place_id then pid = tonumber(info.place_id) end
    if jid then
      showJoinInfo({ pet_name = info.pet_name, value = info.value, source = "List" }, jid, pid)
      teleport(jid, pid)
    end
  end)

  return row
end

local function refreshList()
  local ok, res = pcall(function() return http_call({Url = API.."/servers", Method = "GET"}) end)
  if ok and res and res.StatusCode == 200 then
    local data = jsonDecode(res.Body or "") or {}
    local items = data.servers or {}
    if currentTab == "servers" then
      for _, child in ipairs(Scroller:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
      end
      local count = 0
      for _, info in ipairs(items) do
        local nm = tostring(info.pet_name or "")
        local isBlk2 = (type(inBlacklist) == "function") and inBlacklist(nm) or false
        if not (blacklistOn and isBlk2) and (not string.find(string.lower(nm), "brainrot notify")) then
          local row = makeRow(info)
          row.Parent = Scroller
          count += 1
        end
      end
      Scroller.CanvasSize = UDim2.new(0, 0, 0, count * (40 + 8))
    end
  end
end

local function showServersTab()
  currentTab = "servers"
  rowHeader.Visible = true
  Scroller.Visible = true
  refreshList()
end

tabBtnServers.MouseButton1Click:Connect(showServersTab)
tabBtnMulti.MouseButton1Click:Connect(function()
  currentTab = "multi"
  rowHeader.Visible = false
  Scroller.Visible = false
end)

showJoinInfo = function(meta, jid, pid)
  local name = meta and meta.pet_name or nil
  local val = meta and meta.value or nil
  local src = meta and meta.source or nil
  local money = (tonumber(val or 0) or 0) > 0 and ("$"..string.format("%.1f", val/1e6).."M/s") or "--"
  local parts = {}
  if name and #tostring(name) > 0 then table.insert(parts, tostring(name)) end
  if money ~= "--" then table.insert(parts, money) end
  local info = table.concat(parts, "  –  ")
  if #info == 0 then info = "job " .. (jid and jid:sub(1,8).."…" or "?") end
  if src and #src > 0 then
    showToast("Joining: "..info.."  ("..src..")")
  else
    showToast("Joining: "..info)
  end
end

local function setRunning(on)
  state.running = on and true or false
  runningBtn.BackgroundColor3 = on and green or Color3.fromRGB(90,90,90)
  RunningDot.TextColor3 = on and green or Color3.fromRGB(130,130,130)
  RunningDot.Text = on and "+ RUNNING" or "+ IDLE"
end

local function setAuto(on)
  state.auto = on and true or false
  autoLabel.Text = on and "AUTO JOIN: ON" or "AUTO JOIN: OFF"
end

local function setMinRaw(m)
  local mnum = tonumber(m) or 0
  if mnum < 0 then mnum = 0 end
  state.min_money_raw = mnum
  minLabel.Text = "MIN: "..tostring(mnum).."M"
end

local function setFilterOn(on)
  if on then
    if (tonumber(state.min_money_raw) or 0) <= 0 then
      if _min_last <= 0 then _min_last = 5 end
      setMinRaw(_min_last)
    end
    mfToggle.Text = "FILTER: ON"
    mfToggle.BackgroundColor3 = green
  else
    _min_last = tonumber(state.min_money_raw) or 0
    setMinRaw(0)
    mfToggle.Text = "FILTER: OFF"
    mfToggle.BackgroundColor3 = Color3.fromRGB(90,90,90)
  end
end

local heartbeat
local _lastPost = 0
local function stop()
  setRunning(false)
  if heartbeat then heartbeat:Disconnect() heartbeat = nil end
end

local function start()
  if state.running then return end
  setRunning(true)
  heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
    if not state.running then return end
    if state.auto then
      local nowt = tick()
      if nowt - _lastPost < 0.15 then return end
      _lastPost = nowt
      local bl = {}
      for name, on in pairs(state.blacklist) do if on then table.insert(bl, name) end end
      local body = HttpService:JSONEncode({ blacklist = bl, min_money = (tonumber(state.min_money_raw) or 0) * 1000000 })
      local ok, res = pcall(function()
        return http_call({Url = API.."/next", Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
      end)
      local jid, pid
      if ok and res and (res.StatusCode == 200 or res.StatusCode == 201) and res.Body then
        local data = jsonDecode(res.Body)
        if data and data.ok and data.server then
          if data.server.join_script then jid, pid = parseJoinScript(data.server.join_script) end
          if not jid and data.server.job_id then jid = normalizeJobId(tostring(data.server.job_id)) end
          if not pid and data.server.place_id then pid = tonumber(data.server.place_id) end
        end
      end
      if jid and jid ~= state.lastJob then
        state.lastJob = jid
        showJoinInfo({ source = "Auto" }, jid, pid)
        teleport(jid, pid)
      end
    end
  end)
end

runningBtn.MouseButton1Click:Connect(function()
  setAuto(true)
  start()
end)

stopBtn.MouseButton1Click:Connect(function()
  setAuto(false)
  stop()
end)

turboBtn.MouseButton1Click:Connect(function()
  local jid, pid = turboGetJobId()
  if jid then
    showJoinInfo({ source = "Turbo" }, jid, pid)
    teleport(jid, pid)
  end
end)

mfToggle.MouseButton1Click:Connect(function()
  local on = (tonumber(state.min_money_raw) or 0) <= 0
  setFilterOn(on)
  showToast(on and ("Money filter: "..tostring(state.min_money_raw).."M+") or "Money filter: OFF")
end)

minusBtn.MouseButton1Click:Connect(function()
  local v = (tonumber(state.min_money_raw) or 0) - 5
  if v < 0 then v = 0 end
  setMinRaw(v)
  if v <= 0 then setFilterOn(false) else setFilterOn(true) end
  showToast("Money filter: "..tostring(state.min_money_raw).."M+")
end)

plusBtn.MouseButton1Click:Connect(function()
  local v = (tonumber(state.min_money_raw) or 0) + 5
  setMinRaw(v)
  if v <= 0 then setFilterOn(false) else setFilterOn(true) end
  showToast("Money filter: "..tostring(state.min_money_raw).."
