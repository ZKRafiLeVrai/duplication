-- // SCAN EXACT CORRIGÉ \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

local SERVER_URL = "http://127.0.0.1:5000/scan"
local RARITY_THRESHOLD = 1 -- Baissé à 1M/s pour tout voir

-- Chargement des données
local SharedAnimals = require(ReplicatedStorage.Shared.Animals)
local AnimalsData = require(ReplicatedStorage.Datas.Animals)
local TraitsData = require(ReplicatedStorage.Datas.Traits)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

-- Calcul exact
local function calculateExactValue(animalData, owner)
    local index = animalData.Index
    local mutation = animalData.Mutation
    local traits = animalData.Traits
    
    if not index then return 0 end
    
    local generation = SharedAnimals:GetGeneration(index, mutation, traits, owner)
    return generation / 1000000
end

-- Scan des plots CORRIGÉ
local function scanCurrentServer()
    local results = {}
    
    print("🔍 Scan des plots...")
    
    -- Parcourir TOUS les modèles dans workspace
    for _, obj in pairs(workspace:GetChildren()) do
        -- Un plot est un modèle qui contient "AnimalPodiums"
        if obj:IsA("Model") and obj:FindFirstChild("AnimalPodiums") then
            print("   Plot trouvé: " .. obj.Name)
            
            -- Essayer d'obtenir le canal Synchronizer
            local plotChannel = Synchronizer:Get(obj.Name)
            if plotChannel then
                local owner = plotChannel:Get("Owner")
                local ownerName = owner and owner.Name or "Inconnu"
                local animalList = plotChannel:Get("AnimalList") or {}
                
                print("      Propriétaire: " .. ownerName)
                print("      Animaux dans la liste: " .. #animalList)
                
                -- Parcourir les animaux dans AnimalList
                for slot, animal in pairs(animalList) do
                    if type(animal) == "table" and animal.Index and animal.Index ~= "Empty" then
                        local animalData = AnimalsData[animal.Index]
                        if animalData and not animalData.LuckyBlock then
                            local valueMS = calculateExactValue(animal, owner)
                            
                            print("         Slot " .. slot .. ": " .. animal.Index .. " - " .. string.format("%.1fM/s", valueMS))
                            
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
            else
                print("      ❌ Pas de plotChannel pour " .. obj.Name)
            end
        end
    end
    
    print("✅ Total animaux trouvés: " .. #results)
    
    table.sort(results, function(a, b) return a.value > b.value end)
    return results
end

-- Envoi au serveur local
local function sendToServer(animal)
    local traitsText = "Aucun"
    if animal.traits and #animal.traits > 0 then
        local traitNames = {}
        for _, t in ipairs(animal.traits) do
            local traitData = TraitsData[t]
            table.insert(traitNames, traitData and traitData.Display or t)
        end
        traitsText = table.concat(traitNames, ", ")
    end
    
    local data = {
        animal = animal.name,
        value = animal.value,
        mutation = animal.mutation,
        traits = traitsText,
        rarity = AnimalsData[animal.name] and AnimalsData[animal.name].Rarity or "Inconnu",
        owner = animal.owner,
        join_link = "https://www.roblox.com/games/" .. game.PlaceId
    }
    
    print("📡 Envoi de " .. animal.name .. " vers le serveur...")
    
    local success, err = pcall(function()
        HttpService:PostAsync(SERVER_URL, HttpService:JSONEncode(data))
    end)
    
    if success then
        print("   ✅ Envoyé avec succès !")
    else
        print("   ❌ Erreur: " .. tostring(err))
    end
end

-- Scan et envoi
local function scanAndSend()
    print(" ")
    print("═══════════════════════════════")
    print("🔍 SCAN DÉMARRÉ")
    print("═══════════════════════════════")
    
    local results = scanCurrentServer()
    
    if #results > 0 then
        print(" ")
        print("📢 ENVOI DE " .. #results .. " ANIMAUX")
        
        -- Envoyer les 5 meilleurs
        for i = 1, math.min(5, #results) do
            sendToServer(results[i])
            task.wait(0.5)
        end
    else
        print("📭 Aucun animal trouvé")
    end
    
    print("═══════════════════════════════")
    print("✅ TERMINÉ")
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScanGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 200, 0, 40)
Button.Position = UDim2.new(0.5, -100, 0.5, -20)
Button.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
Button.Text = "🔍 SCAN + ENVOI"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.Parent = ScreenGui

Button.MouseButton1Click:Connect(scanAndSend)

-- Test immédiat
task.wait(1)
scanAndSend()

print("✅ Scanner corrigé prêt !")
