-- // AUTOJOINER GLOBAL - SCAN DE TOUS LES SERVEURS \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local CollectionService = game:GetService("CollectionService")

-- ===== CONFIGURATION =====
local WEBHOOK_URL = "https://discord.com/api/webhooks/1494437937725837434/LK-b_JVnYLuZkdMpqeLnZoTpgzCY8ra01kKRe3LD-TDzNvTX0qtBGuTP9Prj-EDigti_"
local PLACE_ID = game.PlaceId
local RARITY_THRESHOLD = 50 -- Million/s minimum
local SCAN_INTERVAL = 60 -- Secondes entre chaque scan global
local MAX_PAGES = 3 -- Nombre de pages à scanner (100 serveurs par page)

-- ===== CHARGEMENT DES DONNÉES =====
local SharedAnimals = require(ReplicatedStorage.Shared.Animals)
local AnimalsData = require(ReplicatedStorage.Datas.Animals)
local TraitsData = require(ReplicatedStorage.Datas.Traits)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

-- ===== FONCTIONS DE CALCUL =====
local function calculateExactValue(animalData, owner)
    local index = animalData.Index
    local mutation = animalData.Mutation
    local traits = animalData.Traits
    
    if not index then return 0 end
    
    local generation = SharedAnimals:GetGeneration(index, mutation, traits, owner)
    return generation / 1000000
end

-- ===== SCAN DES SERVEURS VIA API ROBLOX =====
local function scanAllServers(cursor)
    local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?limit=100"
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)
    
    if not success then
        return nil, nil
    end
    
    local data = HttpService:JSONDecode(result)
    return data.data or {}, data.nextPageCursor
end

-- ===== ESTIMATION RAPIDE (avant de rejoindre) =====
local function estimateValueFromServer(server)
    local players = server.playing or 0
    local maxPlayers = server.maxPlayers or 1
    local fillRate = players / maxPlayers
    
    -- Estimation basée sur le remplissage
    if fillRate > 0.8 then
        return 50 + math.random(0, 30)
    elseif fillRate > 0.6 then
        return 30 + math.random(0, 20)
    elseif fillRate > 0.4 then
        return 15 + math.random(0, 15)
    else
        return 5 + math.random(0, 10)
    end
end

-- ===== SCAN GLOBAL =====
local function performGlobalScan()
    print("🌐 Début du scan global...")
    
    local allServers = {}
    local cursor = nil
    local pagesScanned = 0
    
    repeat
        local servers, nextCursor = scanAllServers(cursor)
        if servers then
            for _, s in ipairs(servers) do
                local estimatedValue = estimateValueFromServer(s)
                if estimatedValue >= RARITY_THRESHOLD then
                    table.insert(allServers, {
                        jobId = s.id,
                        players = s.playing or 0,
                        maxPlayers = s.maxPlayers or 1,
                        estimatedValue = estimatedValue,
                        joinLink = "https://www.roblox.com/games/" .. PLACE_ID .. "?privateServerLinkCode=" .. s.id
                    })
                end
            end
        end
        cursor = nextCursor
        pagesScanned = pagesScanned + 1
        StatusLabel.Text = string.format("🟡 Scan page %d... (%d serveurs prometteurs)", pagesScanned, #allServers)
        task.wait(0.5)
    until not cursor or pagesScanned >= MAX_PAGES
    
    -- Trier par valeur estimée
    table.sort(allServers, function(a, b) return a.estimatedValue > b.estimatedValue end)
    
    print("✅ Scan terminé : " .. #allServers .. " serveurs prometteurs trouvés")
    
    return allServers
end

-- ===== ENVOI WEBHOOK =====
local function sendWebhook(server)
    local embed = {
        ["title"] = "🌐 SERVEUR PROMETTEUR DÉTECTÉ !",
        ["color"] = 0x3498DB,
        ["fields"] = {
            {["name"] = "👥 Joueurs", ["value"] = string.format("%d/%d", server.players, server.maxPlayers), ["inline"] = true},
            {["name"] = "💰 Valeur estimée", ["value"] = string.format("~%dM/s", server.estimatedValue), ["inline"] = true},
            {["name"] = "🔗 Lien direct", ["value"] = "[Clique pour rejoindre](" .. server.joinLink .. ")", ["inline"] = false}
        },
        ["footer"] = {["text"] = "Autojoiner Global • " .. os.date("%H:%M:%S")}
    }
    
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({["embeds"] = {embed}}))
    end)
end

-- ===== SCAN LOCAL (UNE FOIS DANS LE SERVEUR) =====
local function scanCurrentServer()
    local results = {}
    
    for _, obj in pairs(CollectionService:GetTagged("Plot")) do
        if obj:IsA("Model") then
            local plotChannel = Synchronizer:Get(obj.Name)
            if plotChannel then
                local owner = plotChannel:Get("Owner")
                local ownerName = owner and owner.Name or "Inconnu"
                local animalList = plotChannel:Get("AnimalList") or {}
                
                for slot, animal in pairs(animalList) do
                    if type(animal) == "table" and animal.Index and animal.Index ~= "Empty" then
                        local animalData = AnimalsData[animal.Index]
                        if animalData and not animalData.LuckyBlock then
                            local valueMS = calculateExactValue(animal, owner)
                            
                            table.insert(results, {
                                name = animal.Index,
                                value = valueMS,
                                mutation = animal.Mutation or "Aucune",
                                traits = animal.Traits or {},
                                owner = ownerName
                            })
                        end
                    end
                end
            end
        end
    end
    
    table.sort(results, function(a, b) return a.value > b.value end)
    return results
end

-- ===== ENVOI WEBHOOK ANIMAL RARE =====
local function sendAnimalWebhook(animal)
    local traitsText = "Aucun"
    if animal.traits and #animal.traits > 0 then
        local traitNames = {}
        for _, t in ipairs(animal.traits) do
            local traitData = TraitsData[t]
            table.insert(traitNames, traitData and traitData.Display or t)
        end
        traitsText = table.concat(traitNames, ", ")
    end
    
    local embed = {
        ["title"] = "🔥 ANIMAL RARE CONFIRMÉ !",
        ["color"] = 0xFF5500,
        ["fields"] = {
            {["name"] = "🧬 Animal", ["value"] = animal.name, ["inline"] = true},
            {["name"] = "💰 Valeur EXACTE", ["value"] = string.format("$%.1fM/s", animal.value), ["inline"] = true},
            {["name"] = "✨ Mutation", ["value"] = animal.mutation, ["inline"] = true},
            {["name"] = "🎯 Traits", ["value"] = traitsText, ["inline"] = true},
            {["name"] = "👤 Propriétaire", ["value"] = animal.owner, ["inline"] = true}
        },
        ["footer"] = {["text"] = "Autojoiner • " .. os.date("%H:%M:%S")}
    }
    
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({["embeds"] = {embed}}))
    end)
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutojoinerGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 340)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "🌐 AUTOJOINER GLOBAL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.12, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "⚫ Prêt"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

local GlobalInfoLabel = Instance.new("TextLabel")
GlobalInfoLabel.Size = UDim2.new(1, 0, 0, 40)
GlobalInfoLabel.Position = UDim2.new(0, 0, 0.22, 0)
GlobalInfoLabel.BackgroundTransparency = 1
GlobalInfoLabel.Text = "Scan global:\nEn attente..."
GlobalInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
GlobalInfoLabel.TextSize = 12
GlobalInfoLabel.Font = Enum.Font.Gotham
GlobalInfoLabel.Parent = MainFrame

local LocalInfoLabel = Instance.new("TextLabel")
LocalInfoLabel.Size = UDim2.new(1, 0, 0, 40)
LocalInfoLabel.Position = UDim2.new(0, 0, 0.36, 0)
LocalInfoLabel.BackgroundTransparency = 1
LocalInfoLabel.Text = "Serveur actuel:\nAucun animal"
LocalInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
LocalInfoLabel.TextSize = 12
LocalInfoLabel.Font = Enum.Font.Gotham
LocalInfoLabel.Parent = MainFrame

local BestLabel = Instance.new("TextLabel")
BestLabel.Size = UDim2.new(1, 0, 0, 30)
BestLabel.Position = UDim2.new(0, 0, 0.50, 0)
BestLabel.BackgroundTransparency = 1
BestLabel.Text = "Meilleur: Aucun"
BestLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
BestLabel.TextSize = 12
BestLabel.Font = Enum.Font.Gotham
BestLabel.Parent = MainFrame

local ScanGlobalBtn = Instance.new("TextButton")
ScanGlobalBtn.Size = UDim2.new(0.8, 0, 0, 35)
ScanGlobalBtn.Position = UDim2.new(0.1, 0, 0.63, 0)
ScanGlobalBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ScanGlobalBtn.BorderSizePixel = 0
ScanGlobalBtn.Text = "🌍 SCAN GLOBAL"
ScanGlobalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanGlobalBtn.TextSize = 14
ScanGlobalBtn.Font = Enum.Font.GothamBold
ScanGlobalBtn.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = ScanGlobalBtn

local HopBestBtn = Instance.new("TextButton")
HopBestBtn.Size = UDim2.new(0.8, 0, 0, 35)
HopBestBtn.Position = UDim2.new(0.1, 0, 0.77, 0)
HopBestBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
HopBestBtn.BorderSizePixel = 0
HopBestBtn.Text = "🏆 REJOINDRE MEILLEUR"
HopBestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBestBtn.TextSize = 13
HopBestBtn.Font = Enum.Font.GothamBold
HopBestBtn.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = HopBestBtn

local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(0.8, 0, 0, 35)
HopBtn.Position = UDim2.new(0.1, 0, 0.91, 0)
HopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
HopBtn.BorderSizePixel = 0
HopBtn.Text = "🚀 SERVER HOP"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 14
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Parent = MainFrame

local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(0, 6)
UICorner4.Parent = HopBtn

-- ===== VARIABLES =====
local bestServers = {}
local lastNotified = {}
local NOTIFY_COOLDOWN = 300

-- ===== FONCTIONS =====
local function updateLocalScan()
    local results = scanCurrentServer()
    
    if #results > 0 then
        local best = results[1]
        LocalInfoLabel.Text = string.format("Serveur actuel:\n%d animaux - Meilleur: %s", #results, best.name)
        BestLabel.Text = string.format("Meilleur: %s - $%.1fM/s - %s", best.name, best.value, best.mutation)
        
        for _, animal in ipairs(results) do
            if animal.value >= RARITY_THRESHOLD then
                local key = animal.owner .. "_" .. animal.name
                local now = os.time()
                if not lastNotified[key] or (now - lastNotified[key]) > NOTIFY_COOLDOWN then
                    sendAnimalWebhook(animal)
                    lastNotified[key] = now
                    print("📢 Webhook envoyé pour: " .. animal.name)
                end
            end
        end
    else
        LocalInfoLabel.Text = "Serveur actuel:\nAucun animal"
        BestLabel.Text = "Meilleur: Aucun"
    end
end

local function doGlobalScan()
    StatusLabel.Text = "🟡 Scan global en cours..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    bestServers = performGlobalScan()
    
    if #bestServers > 0 then
        GlobalInfoLabel.Text = string.format("Scan global:\n%d serveurs prometteurs", #bestServers)
        StatusLabel.Text = string.format("🟢 %d serveurs trouvés !", #bestServers)
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        -- Envoyer les 3 meilleurs au webhook
        for i = 1, math.min(3, #bestServers) do
            sendWebhook(bestServers[i])
            task.wait(1)
        end
    else
        GlobalInfoLabel.Text = "Scan global:\nAucun serveur prometteur"
        StatusLabel.Text = "🟠 Aucun serveur trouvé"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
    end
end

local function joinBestServer()
    if #bestServers > 0 then
        local best = bestServers[1]
        StatusLabel.Text = "🚀 Rejoindre le meilleur serveur..."
        pcall(function()
            TeleportService:TeleportToPlaceInstance(PLACE_ID, best.jobId, Player)
        end)
    else
        StatusLabel.Text = "❌ Aucun serveur disponible"
    end
end

local function serverHop()
    StatusLabel.Text = "🚀 Server hop..."
    pcall(function()
        TeleportService:Teleport(PLACE_ID, Player)
    end)
end

-- ===== CONNEXIONS =====
ScanGlobalBtn.MouseButton1Click:Connect(doGlobalScan)
HopBestBtn.MouseButton1Click:Connect(joinBestServer)
HopBtn.MouseButton1Click:Connect(serverHop)

-- ===== SCAN LOCAL AUTO =====
task.spawn(function()
    while true do
        task.wait(SCAN_INTERVAL)
        updateLocalScan()
    end
end)

-- Premier scan local
task.wait(2)
updateLocalScan()

print("✅ Autojoiner Global chargé !")
print("🌐 Scan global pour trouver les serveurs prometteurs")
print("📊 Scan local pour confirmation avec valeur exacte")
