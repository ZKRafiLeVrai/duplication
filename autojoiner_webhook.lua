-- // SCAN EXACT AVEC ENVOI VERS SERVEUR LOCAL \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer
local CollectionService = game:GetService("CollectionService")

local SERVER_URL = "http://127.0.0.1:5000/scan"
local RARITY_THRESHOLD = 20 -- Million/s minimum

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

-- Scan des plots
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
                            
                            if valueMS >= RARITY_THRESHOLD then
                                local traitsText = "Aucun"
                                if animal.Traits and #animal.Traits > 0 then
                                    local traitNames = {}
                                    for _, t in ipairs(animal.Traits) do
                                        local traitData = TraitsData[t]
                                        table.insert(traitNames, traitData and traitData.Display or t)
                                    end
                                    traitsText = table.concat(traitNames, ", ")
                                end
                                
                                table.insert(results, {
                                    name = animal.Index,
                                    value = valueMS,
                                    mutation = animal.Mutation or "Aucune",
                                    traits = traitsText,
                                    rarity = animalData.Rarity or "Inconnu",
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

-- Envoi au serveur local
local function sendToServer(animal)
    local data = {
        animal = animal.name,
        value = animal.value,
        mutation = animal.mutation,
        traits = animal.traits,
        rarity = animal.rarity,
        owner = animal.owner,
        join_link = "https://www.roblox.com/games/" .. game.PlaceId
    }
    
    local success, err = pcall(function()
        HttpService:PostAsync(SERVER_URL, HttpService:JSONEncode(data))
    end)
    
    if success then
        print("📢 Envoyé au serveur: " .. animal.name)
    else
        print("❌ Erreur envoi: " .. tostring(err))
    end
end

-- Scan et envoi
local function scanAndSend()
    print("🔍 Scan en cours...")
    local results = scanCurrentServer()
    
    if #results > 0 then
        print("✅ " .. #results .. " animaux rares trouvés")
        for _, animal in ipairs(results) do
            sendToServer(animal)
            task.wait(1)
        end
    else
        print("📭 Aucun animal > " .. RARITY_THRESHOLD .. "M/s")
    end
end

-- GUI minimal
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

print("✅ Scanner exact prêt !")
print("📡 Envoi vers http://127.0.0.1:5000/scan")
