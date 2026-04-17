-- // AUTOJOINER - SCAN LOCAL + TEST WEBHOOK \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local CollectionService = game:GetService("CollectionService")

-- ===== CONFIGURATION =====
local WEBHOOK_URL = "https://discord.com/api/webhooks/1494437937725837434/LK-b_JVnYLuZkdMpqeLnZoTpgzCY8ra01kKRe3LD-TDzNvTX0qtBGuTP9Prj-EDigti_"
local PLACE_ID = game.PlaceId
local SCAN_INTERVAL = 10 -- Secondes entre chaque scan local

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

-- ===== SCAN LOCAL =====
local function scanCurrentServer()
    local results = {}
    
    -- Méthode 1 : Tag "Plot"
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
    
    -- Méthode 2 : AnimalPodiums
    if #results == 0 then
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
                                    owner = ownerName
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    
    table.sort(results, function(a, b) return a.value > b.value end)
    return results
end

-- ===== ENVOI WEBHOOK (TEST FORCÉ) =====
local function sendTestWebhook(animal)
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
        ["title"] = "🧪 TEST WEBHOOK - ANIMAL TROUVÉ !",
        ["color"] = 0x00FF00,
        ["fields"] = {
            {["name"] = "🧬 Animal", ["value"] = animal.name, ["inline"] = true},
            {["name"] = "💰 Valeur EXACTE", ["value"] = string.format("$%.1fM/s", animal.value), ["inline"] = true},
            {["name"] = "✨ Mutation", ["value"] = animal.mutation, ["inline"] = true},
            {["name"] = "🎯 Traits", ["value"] = traitsText, ["inline"] = true},
            {["name"] = "👤 Propriétaire", ["value"] = animal.owner, ["inline"] = true}
        },
        ["footer"] = {["text"] = "Autojoiner Test • " .. os.date("%H:%M:%S")}
    }
    
    print("📢 Tentative d'envoi du webhook...")
    print("   URL: " .. WEBHOOK_URL:sub(1, 50) .. "...")
    print("   Animal: " .. animal.name .. " - " .. string.format("%.1fM/s", animal.value))
    
    local success, err = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode({["embeds"] = {embed}}))
    end)
    
    if success then
        print("✅ Webhook envoyé avec succès !")
    else
        print("❌ Échec du webhook: " .. tostring(err))
    end
end

-- ===== GUI SIMPLE =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutojoinerGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
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
Title.Text = "🔍 SCAN LOCAL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 60)
InfoLabel.Position = UDim2.new(0, 0, 0.20, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "En attente de scan..."
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Parent = MainFrame

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.8, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ScanBtn.BorderSizePixel = 0
ScanBtn.Text = "🔍 SCAN + WEBHOOK"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.TextSize = 14
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = ScanBtn

local HopBtn = Instance.new("TextButton")
HopBtn.Size = UDim2.new(0.8, 0, 0, 35)
HopBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
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

-- ===== FONCTIONS =====
local function doScanAndSend()
    InfoLabel.Text = "🟡 Scan en cours..."
    
    local results = scanCurrentServer()
    
    if #results > 0 then
        local best = results[1]
        InfoLabel.Text = string.format("✅ %d animaux trouvés\nMeilleur: %s\n$%.1fM/s", #results, best.name, best.value)
        
        -- ENVOI FORCÉ DU WEBHOOK
        sendTestWebhook(best)
    else
        InfoLabel.Text = "❌ Aucun animal trouvé"
    end
end

local function serverHop()
    InfoLabel.Text = "🚀 Server hop..."
    pcall(function()
        TeleportService:Teleport(PLACE_ID, Player)
    end)
end

-- ===== CONNEXIONS =====
ScanBtn.MouseButton1Click:Connect(doScanAndSend)
HopBtn.MouseButton1Click:Connect(serverHop)

-- Scan automatique au lancement
task.wait(1)
doScanAndSend()

print("✅ Autojoiner Test chargé !")
print("📢 Clique sur 'SCAN + WEBHOOK' pour tester l'envoi Discord")
