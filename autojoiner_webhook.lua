
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local CollectionService = game:GetService("CollectionService")
-- ===== CONFIGURATION =====
local WEBHOOK_URL = "https://discord.com/api/webhooks/1494437937725837434/LK-b_JVnYLuZkdMpqeLnZoTpgzCY8ra01kKRe3LD-TDzNvTX0qtBGuTP9Prj-EDigti_"
local PLACE_ID = game.PlaceId
local RARITY_THRESHOLD = 0 -- Million/s minimum pour être signalé
local SCAN_INTERVAL = 10 -- Secondes entre chaque scan

-- ===== CHARGEMENT DES DONNÉES =====
local SharedAnimals = require(ReplicatedStorage.Shared.Animals)
local AnimalsData = require(ReplicatedStorage.Datas.Animals)
local MutationsData = require(ReplicatedStorage.Datas.Mutations)
local TraitsData = require(ReplicatedStorage.Datas.Traits)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

-- ===== FONCTIONS DE CALCUL =====
local function calculateExactValue(animalData, owner)
    local index = animalData.Index
    local mutation = animalData.Mutation
    local traits = animalData.Traits
    
    if not index then return 0 end
    
    local generation = SharedAnimals:GetGeneration(index, mutation, traits, owner)
    return generation / 1000000  -- Conversion en millions/s
end

local function getMutationModifier(mutationName)
    if not mutationName then return 1 end
    local mutationData = MutationsData[mutationName]
    return mutationData and (1 + mutationData.Modifier) or 1
end

local function getTraitsModifier(traits)
    if not traits or #traits == 0 then return 1 end
    
    local modifier = 1
    local hasSleepy = false
    
    for _, traitName in ipairs(traits) do
        local traitData = TraitsData[traitName]
        if traitData then
            if traitName == "Sleepy" then
                hasSleepy = true
            else
                modifier = modifier + traitData.MultiplierModifier
            end
        end
    end
    
    if hasSleepy then
        modifier = modifier * 0.5
    end
    
    return modifier
end

-- ===== SCAN DES PLOTS (CORRIGÉ) =====
local function scanAllPlots()
    local results = {}
    
    -- Méthode 1 : Chercher les plots via le tag "Plot"
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
                                owner = ownerName,
                                slot = slot,
                                plotName = obj.Name,
                                rarity = animalData.Rarity or "Inconnu",
                                baseGen = animalData.Generation or 0,
                                price = animalData.Price or 0
                            })
                        end
                    end
                end
            end
        end
    end
    
    -- Si aucun plot trouvé via le tag, on essaie une autre méthode
    if #results == 0 then
        print("🔍 Méthode 1 échouée, tentative méthode 2...")
        
        -- Méthode 2 : Parcourir tous les modèles dans workspace
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("AnimalPodiums") then
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
                                    owner = ownerName,
                                    slot = slot,
                                    plotName = obj.Name,
                                    rarity = animalData.Rarity or "Inconnu"
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Debug : afficher ce qu'on a trouvé
    print("📊 Plots scannés : " .. #results .. " animaux trouvés")
    if #results > 0 then
        print("   Premier animal : " .. results[1].name .. " - " .. string.format("%.1fM/s", results[1].value))
    end
    
    -- Trier par valeur décroissante
    table.sort(results, function(a, b) return a.value > b.value end)
    
    return results
end
-- ===== ENVOI WEBHOOK =====
local function sendWebhook(animal)
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
        ["title"] = "🔥 ANIMAL RARE DÉTECTÉ !",
        ["color"] = 0xFF5500,
        ["fields"] = {
            {["name"] = "🧬 Animal", ["value"] = animal.name, ["inline"] = true},
            {["name"] = "💰 Valeur", ["value"] = string.format("$%.1fM/s", animal.value), ["inline"] = true},
            {["name"] = "✨ Mutation", ["value"] = animal.mutation, ["inline"] = true},
            {["name"] = "🎯 Traits", ["value"] = traitsText, ["inline"] = true},
            {["name"] = "📊 Rareté", ["value"] = animal.rarity, ["inline"] = true},
            {["name"] = "👤 Propriétaire", ["value"] = animal.owner, ["inline"] = true},
            {["name"] = "🔗 Rejoindre", ["value"] = "[Clique ici](https://www.roblox.com/games/" .. PLACE_ID .. ")", ["inline"] = false}
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
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
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
Title.Text = "🔍 AUTOJOINER EXACT"
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

local ServerInfoLabel = Instance.new("TextLabel")
ServerInfoLabel.Size = UDim2.new(1, 0, 0, 60)
ServerInfoLabel.Position = UDim2.new(0, 0, 0.22, 0)
ServerInfoLabel.BackgroundTransparency = 1
ServerInfoLabel.Text = "Serveur actuel:\nAucun animal détecté"
ServerInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
ServerInfoLabel.TextSize = 12
ServerInfoLabel.Font = Enum.Font.Gotham
ServerInfoLabel.Parent = MainFrame

local BestLabel = Instance.new("TextLabel")
BestLabel.Size = UDim2.new(1, 0, 0, 40)
BestLabel.Position = UDim2.new(0, 0, 0.44, 0)
BestLabel.BackgroundTransparency = 1
BestLabel.Text = "Meilleur animal:\nAucun"
BestLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
BestLabel.TextSize = 12
BestLabel.Font = Enum.Font.Gotham
BestLabel.Parent = MainFrame

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.8, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.1, 0, 0.62, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ScanBtn.BorderSizePixel = 0
ScanBtn.Text = "🔍 SCANNER"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.TextSize = 14
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = ScanBtn

local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(0.8, 0, 0, 35)
HopBtn.Position = UDim2.new(0.1, 0, 0.77, 0)
HopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
HopBtn.BorderSizePixel = 0
HopBtn.Text = "🚀 SERVER HOP"
HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HopBtn.TextSize = 14
HopBtn.Font = Enum.Font.GothamBold
HopBtn.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = HopBtn

local CountLabel = Instance.new("TextLabel")
CountLabel.Size = UDim2.new(1, 0, 0, 20)
CountLabel.Position = UDim2.new(0, 0, 0.92, 0)
CountLabel.BackgroundTransparency = 1
CountLabel.Text = "0 animaux scannés"
CountLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
CountLabel.TextSize = 11
CountLabel.Font = Enum.Font.Gotham
CountLabel.Parent = MainFrame

-- ===== VARIABLES =====
local lastNotified = {}
local NOTIFY_COOLDOWN = 300 -- 5 minutes

-- ===== FONCTIONS UI =====
local function updateUI()
    local results = scanAllPlots()
    
    CountLabel.Text = #results .. " animaux scannés"
    
    if #results > 0 then
        local best = results[1]
        ServerInfoLabel.Text = string.format("Serveur actuel:\n%d animaux trouvés", #results)
        BestLabel.Text = string.format("Meilleur:\n%s - $%.1fM/s - %s", best.name, best.value, best.mutation)
        
        -- Compter les animaux rares (> seuil)
        local rareCount = 0
        for _, animal in ipairs(results) do
            if animal.value >= RARITY_THRESHOLD then
                rareCount = rareCount + 1
                
                -- Envoyer webhook (avec cooldown)
                local key = animal.plotName .. "_" .. animal.slot
                local now = os.time()
                if not lastNotified[key] or (now - lastNotified[key]) > NOTIFY_COOLDOWN then
                    sendWebhook(animal)
                    lastNotified[key] = now
                end
            end
        end
        
        if rareCount > 0 then
            StatusLabel.Text = string.format("🟢 %d animal(aux) > %dM/s !", rareCount, RARITY_THRESHOLD)
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            StatusLabel.Text = string.format("🟠 Aucun animal > %dM/s", RARITY_THRESHOLD)
            StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
        end
    else
        ServerInfoLabel.Text = "Serveur actuel:\nAucun animal détecté"
        BestLabel.Text = "Meilleur animal:\nAucun"
        StatusLabel.Text = "⚫ Aucun animal"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

local function serverHop()
    StatusLabel.Text = "🚀 Server hop..."
    pcall(function()
        TeleportService:Teleport(PLACE_ID, Player)
    end)
end

-- ===== CONNEXIONS =====
ScanBtn.MouseButton1Click:Connect(function()
    StatusLabel.Text = "🟡 Scan en cours..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    task.wait(0.5)
    updateUI()
end)

HopBtn.MouseButton1Click:Connect(serverHop)

-- ===== SCAN AUTO =====
task.spawn(function()
    while true do
        task.wait(SCAN_INTERVAL)
        updateUI()
    end
end)

-- Premier scan
task.wait(2)
updateUI()

print("✅ Autojoiner Exact chargé !")
print("📊 Calcul basé sur SharedAnimals:GetGeneration()")
