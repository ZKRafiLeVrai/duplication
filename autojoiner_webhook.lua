-- // AUTOJOINER AVEC WEBHOOK DISCORD + LIEN JOIN \\
-- Loadstring: loadstring(game:HttpGet("https://raw.githubusercontent.com/ZKRafiLeVrai/duplication/refs/heads/main/autojoiner_webhook.lua"))()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- ===== CONFIGURATION =====
local WEBHOOK_URL = "https://discord.com/api/webhooks/1494437937725837434/LK-b_JVnYLuZkdMpqeLnZoTpgzCY8ra01kKRe3LD-TDzNvTX0qtBGuTP9Prj-EDigti_" -- ⚠️ REMPLACE PAR TON WEBHOOK
local RARITY_THRESHOLD = 20 -- Million/s minimum pour être considéré comme "rare"
local CHECK_MUTATIONS = true -- Activer la détection des mutations

-- ===== FONCTIONS HTTP =====
local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

local function http_call(params)
  if req then
    return req(params)
  else
    if (params.Method == "GET" or not params.Method) and params.Url then
      local ok, body = pcall(function() return game:HttpGet(params.Url) end)
      if ok then return { StatusCode = 200, Body = body } end
    end
    return { StatusCode = 0, Body = "" }
  end
end

local API = "http://127.0.0.1:5000"

-- ===== FONCTION POUR GÉNÉRER LE LIEN DE JOIN =====
local function generateJoinLink(placeId, jobId)
    placeId = placeId or game.PlaceId
    jobId = jobId or ""
    
    if jobId ~= "" then
        return string.format("https://www.roblox.com/games/%d?privateServerLinkCode=%s", placeId, jobId)
    else
        return string.format("https://www.roblox.com/games/%d", placeId)
    end
end

-- ===== ENVOI WEBHOOK DISCORD AVEC LIEN JOIN =====
local function sendDiscordWebhook(serverInfo)
    if WEBHOOK_URL == "https://discord.com/api/webhooks/TON_WEBHOOK_ICI" then
        print("⚠️ Webhook non configuré")
        return
    end
    
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
    
    local payload = HttpService:JSONEncode({
        ["embeds"] = {embed},
        ["content"] = "|| <@&ID_ROLE> ||" -- Optionnel: Mentionne un rôle (remplace ID_ROLE)
    })
    
    pcall(function()
        http_call({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = payload
        })
    end)
end

-- ===== ANALYSE DES SERVEURS =====
local function analyzeServers()
    local ok, res = pcall(function() return http_call({Url = API.."/servers", Method = "GET"}) end)
    if not ok or not res or res.StatusCode ~= 200 then return end
    
    local data = HttpService:JSONDecode(res.Body or "{}")
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
    
    -- Trier par valeur décroissante
    table.sort(rareServers, function(a, b) return a.value > b.value end)
    
    return rareServers
end

-- ===== SURVEILLANCE PÉRIODIQUE =====
local lastNotified = {}
local NOTIFY_COOLDOWN = 300 -- 5 minutes entre chaque notification pour le même animal

task.spawn(function()
    while true do
        task.wait(30) -- Vérifie toutes les 30 secondes
        
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

-- ===== BOUTON MANUEL DANS L'UI =====
-- Ajoute ceci après la création de l'UI

local scanRareBtn = Instance.new("TextButton")
scanRareBtn.Size = UDim2.new(0, 130, 0, 28)
scanRareBtn.Position = UDim2.new(0, 16, 0, 210) -- Ajuste la position selon ton UI
scanRareBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
scanRareBtn.BorderSizePixel = 0
scanRareBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanRareBtn.Font = Enum.Font.GothamBold
scanRareBtn.TextSize = 12
scanRareBtn.Text = "🔍 SCAN RARE"
scanRareBtn.Parent = Left -- ou Right selon où tu veux le placer

scanRareBtn.MouseButton1Click:Connect(function()
    local rareServers = analyzeServers()
    if rareServers and #rareServers > 0 then
        for _, server in ipairs(rareServers) do
            sendDiscordWebhook(server)
        end
        showToast(#rareServers .. " animaux rares signalés sur Discord !")
    else
        showToast("Aucun animal rare trouvé...")
    end
end)

-- ===== BOUTON COPIER LE LIEN =====
local copyLinkBtn = Instance.new("TextButton")
copyLinkBtn.Size = UDim2.new(0, 130, 0, 28)
copyLinkBtn.Position = UDim2.new(0, 16, 0, 245)
copyLinkBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
copyLinkBtn.BorderSizePixel = 0
copyLinkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyLinkBtn.Font = Enum.Font.GothamBold
copyLinkBtn.TextSize = 12
copyLinkBtn.Text = "🔗 COPIER LIEN"
copyLinkBtn.Parent = Left

copyLinkBtn.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local link = generateJoinLink(placeId, "")
    
    if setclipboard then
        setclipboard(link)
        showToast("✅ Lien du jeu copié !")
    else
        showToast("❌ setclipboard non disponible")
    end
end)

print("✅ Autojoiner avec Webhook Discord + Lien Join chargé !")
print("📢 Les animaux > " .. RARITY_THRESHOLD .. "M/s seront signalés")
