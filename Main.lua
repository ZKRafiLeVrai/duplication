-- // AUTO DUP VOL - COMPLET AVEC DÉPLACEMENT DES SLOTS \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ===== CONFIGURATION =====
local VALID_KEY = "5hi_gi737.yueu.6269"

-- ===== GUI SIMPLE =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DupeGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 140)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -70)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "🔥 AUTO DUP VOL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.25, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "⚫ En attente de vol..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

local SlotLabel = Instance.new("TextLabel")
SlotLabel.Size = UDim2.new(1, 0, 0, 20)
SlotLabel.Position = UDim2.new(0, 0, 0.45, 0)
SlotLabel.BackgroundTransparency = 1
SlotLabel.Text = "Slots 1 & 2: Libres"
SlotLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
SlotLabel.TextSize = 11
SlotLabel.Font = Enum.Font.Gotham
SlotLabel.Parent = MainFrame

local DupeBtn = Instance.new("TextButton")
DupeBtn.Size = UDim2.new(0.8, 0, 0, 35)
DupeBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
DupeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DupeBtn.BorderSizePixel = 0
DupeBtn.Text = "DUPER (V)"
DupeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeBtn.Font = Enum.Font.GothamBold
DupeBtn.TextSize = 14
DupeBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = DupeBtn

-- ===== FONCTIONS =====
local function findRemotes()
    local remotes = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            remotes[obj.Name] = obj
        end
    end
    return remotes
end

local remotes = findRemotes()
local grabRemote = remotes["RE/StealService/Grab"]
local stealComplete = remotes["RE/5c8f0dd0-0f9e-44ba-8f9b-197958b661ab"]

print("🔍 Remotes trouvés:")
print("   Grab: " .. (grabRemote and "✅" or "❌"))
print("   StealComplete: " .. (stealComplete and "✅" or "❌"))

-- ===== GESTION DES SLOTS =====
local function getOurPodiums()
    local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
    local ourChannel = Synchronizer:Get(Player)
    if not ourChannel then return {} end
    return ourChannel:Get("AnimalPodiums") or {}
end

local function findEmptySlot()
    local podiums = getOurPodiums()
    for i = 3, 200 do  -- On commence à 3 pour garder 1 et 2 libres
        if podiums[i] == "Empty" or podiums[i] == nil then
            return i
        end
    end
    return nil
end

local function freeSlots1and2()
    if not grabRemote then return end
    
    local podiums = getOurPodiums()
    local moved = false
    
    for _, slot in pairs({1, 2}) do
        if podiums[slot] and podiums[slot] ~= "Empty" then
            local emptySlot = findEmptySlot()
            if emptySlot then
                print("📦 Déplacement du slot " .. slot .. " vers " .. emptySlot)
                
                -- Grab l'animal
                pcall(function()
                    grabRemote:FireServer("Grab", slot)
                end)
                
                task.wait(0.15)
                
                -- Le placer dans le slot vide
                pcall(function()
                    grabRemote:FireServer("Place", emptySlot)
                end)
                
                moved = true
                task.wait(0.15)
            end
        end
    end
    
    if moved then
        SlotLabel.Text = "Slots 1 & 2: Libérés !"
        SlotLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(1)
    end
    
    -- Mettre à jour l'affichage
    podiums = getOurPodiums()
    local slot1filled = podiums[1] and podiums[1] ~= "Empty"
    local slot2filled = podiums[2] and podiums[2] ~= "Empty"
    
    if slot1filled or slot2filled then
        SlotLabel.Text = "⚠️ Slots 1 & 2: Occupés"
        SlotLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    else
        SlotLabel.Text = "Slots 1 & 2: Libres"
        SlotLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end

local function dupeCurrentSteal()
    local isStealing = Player:GetAttribute("Stealing")
    
    if not isStealing then
        StatusLabel.Text = "❌ Pas de vol en cours !"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        task.wait(2)
        StatusLabel.Text = "⚫ En attente de vol..."
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    
    StatusLabel.Text = "🟡 Duplication en cours..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    DupeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    
    -- 1. Libérer les slots 1 et 2 AVANT la duplication
    freeSlots1and2()
    
    -- 2. Envoyer StealComplete (donne l'animal)
    if stealComplete then
        print("📡 Envoi StealComplete...")
        pcall(function()
            stealComplete:FireServer("7799aa8a-03f9-4df1-ab0f-b6df84f6b36c")
        end)
    end
    
    task.wait(0.2)
    
    -- 3. Annuler chez la victime
    if grabRemote then
        print("📡 Annulation chez la victime...")
        for i = 1, 50 do
            pcall(function()
                grabRemote:FireServer("Place", i)
            end)
        end
    end
    
    task.wait(0.3)
    
    -- 4. Nettoyer l'animation
    Player:SetAttribute("Stealing", false)
    Player:SetAttribute("StealingIndex", "")
    
    -- Arrêter l'animation de vol
    local char = Player.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            local anim = hum:FindFirstChild("Animator")
            if anim then
                for _, track in pairs(anim:GetPlayingAnimationTracks()) do
                    track:Stop(0)
                end
            end
        end
    end
    
    -- 5. Libérer les slots 1 et 2 APRÈS la duplication (au cas où)
    task.wait(0.2)
    freeSlots1and2()
    
    StatusLabel.Text = "✅ Duplication terminée !"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    DupeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    
    task.wait(2)
    StatusLabel.Text = "⚫ En attente de vol..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DupeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end

-- ===== CONNEXIONS =====
DupeBtn.MouseButton1Click:Connect(dupeCurrentSteal)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        dupeCurrentSteal()
    end
end)

-- Surveillance du vol
Player:GetAttributeChangedSignal("Stealing"):Connect(function()
    if Player:GetAttribute("Stealing") then
        local animal = Player:GetAttribute("StealingIndex") or "Animal"
        StatusLabel.Text = "🟢 VOL: " .. animal
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        DupeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    else
        StatusLabel.Text = "⚫ En attente de vol..."
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        DupeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Mise à jour périodique des slots
task.spawn(function()
    while true do
        task.wait(2)
        if not Player:GetAttribute("Stealing") then
            local podiums = getOurPodiums()
            local slot1filled = podiums[1] and podiums[1] ~= "Empty"
            local slot2filled = podiums[2] and podiums[2] ~= "Empty"
            
            if slot1filled or slot2filled then
                SlotLabel.Text = "⚠️ Slots 1 & 2: Occupés"
                SlotLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
            else
                SlotLabel.Text = "Slots 1 & 2: Libres"
                SlotLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        end
    end
end)

print("✅ Script de duplication COMPLET chargé !")
print("📦 Système de déplacement des slots 1 et 2 activé !")
