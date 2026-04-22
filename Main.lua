-- // AUTO DUP VOL - AVEC MÉMORISATION DE L'ANIMAL \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ===== SYSTÈME DE KEY =====
local VALID_KEY = "5hi_gi737.yueu.6269"
local DISCORD_INVITE = "https://discord.gg/XdBdXWbP"

local function checkKey(k)
    return k == VALID_KEY
end

-- ===== GUI DE LOGIN =====
local LoginGui = Instance.new("ScreenGui")
local LoginFrame = Instance.new("Frame")
local LoginTitle = Instance.new("TextLabel")
local KeyBox = Instance.new("TextBox")
local SubmitButton = Instance.new("TextButton")
local ErrorLabel = Instance.new("TextLabel")
local DiscordButton = Instance.new("TextButton")

LoginGui.Name = "LoginGui"
LoginGui.Parent = Player:WaitForChild("PlayerGui")
LoginGui.ResetOnSpawn = false

LoginFrame.Name = "LoginFrame"
LoginFrame.Parent = LoginGui
LoginFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
LoginFrame.BorderSizePixel = 0
LoginFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
LoginFrame.Size = UDim2.new(0, 300, 0, 220)
LoginFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0, 8)
LoginCorner.Parent = LoginFrame

local LoginStroke = Instance.new("UIStroke")
LoginStroke.Color = Color3.fromRGB(255, 50, 50)
LoginStroke.Thickness = 1.5
LoginStroke.Parent = LoginFrame

LoginTitle.Name = "LoginTitle"
LoginTitle.Parent = LoginFrame
LoginTitle.BackgroundTransparency = 1
LoginTitle.Size = UDim2.new(1, 0, 0, 30)
LoginTitle.Position = UDim2.new(0, 0, 0.1, 0)
LoginTitle.Text = "🔑 ENTRER LA KEY"
LoginTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginTitle.TextSize = 16
LoginTitle.Font = Enum.Font.GothamBold

DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = LoginFrame
DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordButton.Size = UDim2.new(0.7, 0, 0, 35)
DiscordButton.Position = UDim2.new(0.15, 0, 0.25, 0)
DiscordButton.Text = "📱 Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.TextSize = 13
DiscordButton.Font = Enum.Font.GothamBold

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 6)
DiscordCorner.Parent = DiscordButton

DiscordButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_INVITE)
        DiscordButton.Text = "✅ Copié !"
        task.wait(2)
        DiscordButton.Text = "📱 Discord"
    end
end)

KeyBox.Name = "KeyBox"
KeyBox.Parent = LoginFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
KeyBox.BorderSizePixel = 0
KeyBox.Size = UDim2.new(0.7, 0, 0, 35)
KeyBox.Position = UDim2.new(0.15, 0, 0.48, 0)
KeyBox.PlaceholderText = "Entre ta key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeyBox

SubmitButton.Name = "SubmitButton"
SubmitButton.Parent = LoginFrame
SubmitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
SubmitButton.Size = UDim2.new(0.7, 0, 0, 35)
SubmitButton.Position = UDim2.new(0.15, 0, 0.7, 0)
SubmitButton.Text = "VALIDER"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 14
SubmitButton.Font = Enum.Font.GothamBold

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitButton

ErrorLabel.Name = "ErrorLabel"
ErrorLabel.Parent = LoginFrame
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0, 0, 0.9, 0)
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorLabel.TextSize = 11
ErrorLabel.Font = Enum.Font.Gotham

local function onSubmit()
    if checkKey(KeyBox.Text) then
        ErrorLabel.Text = "✅ Key valide ! Chargement..."
        ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        LoginGui:Destroy()
        loadMainGUI()
    else
        ErrorLabel.Text = "❌ Key invalide !"
    end
end

SubmitButton.MouseButton1Click:Connect(onSubmit)
KeyBox.FocusLost:Connect(function(ep) if ep then onSubmit() end end)

-- ===== GUI PRINCIPAL =====
function loadMainGUI()
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

    -- ===== GUI =====
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DupeGUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
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
    StatusLabel.Position = UDim2.new(0, 0, 0.15, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⚫ En attente..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 13
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame

    local TargetLabel = Instance.new("TextLabel")
    TargetLabel.Size = UDim2.new(1, 0, 0, 20)
    TargetLabel.Position = UDim2.new(0, 0, 0.3, 0)
    TargetLabel.BackgroundTransparency = 1
    TargetLabel.Text = "🎯 Mémorisé: Aucun"
    TargetLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    TargetLabel.TextSize = 12
    TargetLabel.Font = Enum.Font.Gotham
    TargetLabel.Parent = MainFrame

    local SlotLabel = Instance.new("TextLabel")
    SlotLabel.Size = UDim2.new(1, 0, 0, 20)
    SlotLabel.Position = UDim2.new(0, 0, 0.43, 0)
    SlotLabel.BackgroundTransparency = 1
    SlotLabel.Text = "📦 Slots 1 & 2: Libres"
    SlotLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    SlotLabel.TextSize = 11
    SlotLabel.Font = Enum.Font.Gotham
    SlotLabel.Parent = MainFrame

    -- Bouton Mémoriser
    local MemoBtn = Instance.new("TextButton")
    MemoBtn.Size = UDim2.new(0.8, 0, 0, 30)
    MemoBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
    MemoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    MemoBtn.BorderSizePixel = 0
    MemoBtn.Text = "📌 MÉMORISER L'ANIMAL"
    MemoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MemoBtn.Font = Enum.Font.GothamBold
    MemoBtn.TextSize = 12
    MemoBtn.Parent = MainFrame

    local MemoCorner = Instance.new("UICorner")
    MemoCorner.CornerRadius = UDim.new(0, 6)
    MemoCorner.Parent = MemoBtn

    -- Bouton Auto Dup
    local AutoDupBtn = Instance.new("TextButton")
    AutoDupBtn.Size = UDim2.new(0.8, 0, 0, 35)
    AutoDupBtn.Position = UDim2.new(0.1, 0, 0.73, 0)
    AutoDupBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    AutoDupBtn.BorderSizePixel = 0
    AutoDupBtn.Text = "🤖 AUTO DUP: OFF"
    AutoDupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoDupBtn.Font = Enum.Font.GothamBold
    AutoDupBtn.TextSize = 13
    AutoDupBtn.Parent = MainFrame

    local AutoCorner = Instance.new("UICorner")
    AutoCorner.CornerRadius = UDim.new(0, 6)
    AutoCorner.Parent = AutoDupBtn

    -- ===== VARIABLES =====
    local autoDupEnabled = false
    local isProcessing = false
    local DUP_DELAY = 0.3
    local memorizedAnimal = nil
    local memorizedPlot = nil
    local memorizedPodium = nil

    -- ===== FONCTIONS SLOTS =====
    local function getOurPodiums()
        local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
        local ourChannel = Synchronizer:Get(Player)
        if not ourChannel then return {} end
        return ourChannel:Get("AnimalPodiums") or {}
    end

    local function findEmptySlot()
        local podiums = getOurPodiums()
        for i = 3, 200 do
            if podiums[i] == "Empty" or podiums[i] == nil then
                return i
            end
        end
        return nil
    end

    local function freeSlots1and2()
        if not grabRemote then return end
        local podiums = getOurPodiums()
        for _, slot in pairs({1, 2}) do
            if podiums[slot] and podiums[slot] ~= "Empty" then
                local emptySlot = findEmptySlot()
                if emptySlot then
                    pcall(function() grabRemote:FireServer("Grab", slot) end)
                    task.wait(0.1)
                    pcall(function() grabRemote:FireServer("Place", emptySlot) end)
                    task.wait(0.1)
                end
            end
        end
        podiums = getOurPodiums()
        local filled = (podiums[1] and podiums[1] ~= "Empty") or (podiums[2] and podiums[2] ~= "Empty")
        SlotLabel.Text = filled and "⚠️ Slots 1 & 2: Occupés" or "📦 Slots 1 & 2: Libres"
        SlotLabel.TextColor3 = filled and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(100, 255, 100)
    end

    -- ===== TROUVER L'ANIMAL DEVANT SOI =====
    local function findAnimalInFront()
        local char = Player.Character
        if not char then return nil, nil, nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil, nil end
        
        local pos = root.Position
        local bestPlot, bestPodium, bestDist = nil, nil, 15
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.ActionText == "Steal" and obj.Enabled then
                local p = obj.Parent
                if p and p:IsA("Attachment") then p = p.Parent end
                if p and p:IsA("BasePart") then
                    local d = (p.Position - pos).Magnitude
                    if d < bestDist then
                        local parent = obj.Parent
                        while parent do
                            if parent:IsA("Model") and parent:FindFirstChild("AnimalPodiums") then
                                for _, child in pairs(parent.AnimalPodiums:GetChildren()) do
                                    if child:FindFirstChild("ProximityPrompt", true) == obj then
                                        bestDist = d
                                        bestPlot = parent
                                        bestPodium = tonumber(child.Name)
                                        break
                                    end
                                end
                            end
                            parent = parent.Parent
                        end
                    end
                end
            end
        end
        
        if bestPlot and bestPodium then
            local animalName = "Animal"
            pcall(function()
                local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
                local plotChannel = Synchronizer:Get(bestPlot.Name)
                if plotChannel then
                    local animal = plotChannel:Get("AnimalList") or {}
                    if animal[bestPodium] and animal[bestPodium].Index then
                        animalName = animal[bestPodium].Index
                    end
                end
            end)
            return bestPlot, bestPodium, animalName
        end
        
        return nil, nil, nil
    end

    -- ===== MÉMORISER =====
    local function memorizeAnimal()
        local plot, podium, name = findAnimalInFront()
        if plot and podium and name then
            memorizedPlot = plot
            memorizedPodium = podium
            memorizedAnimal = name
            TargetLabel.Text = "🎯 Mémorisé: " .. name
            StatusLabel.Text = "✅ Animal mémorisé !"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            task.wait(2)
            StatusLabel.Text = "⚫ Prêt pour Auto Dup"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            return true
        else
            StatusLabel.Text = "❌ Approche-toi d'un animal !"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            task.wait(2)
            StatusLabel.Text = "⚫ En attente..."
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            return false
        end
    end

    -- ===== DUPLICATION =====
    local function performDupe()
        if isProcessing then return end
        isProcessing = true
        
        StatusLabel.Text = "🟡 Duplication..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        freeSlots1and2()
        
        -- Utiliser l'animal mémorisé
        if memorizedPlot and memorizedPodium then
            -- Démarrer le vol sur l'animal mémorisé
            local stealStart = remotes["RE/5aa39ea1-0c65-4fcf-aff9-b18a7ef277c3"]
            if stealStart then
                local ts = workspace:GetServerTimeNow()
                pcall(function() stealStart:FireServer(ts, "c262398d-68e3-4499-8bea-99766bf11686", memorizedPlot.Name, memorizedPodium) end)
                pcall(function() stealStart:FireServer(ts, "579e6c26-5a80-407d-9488-0f84752e8f1f", memorizedPlot.Name, memorizedPodium) end)
            end
            task.wait(0.15)
        end
        
        if stealComplete then
            pcall(function() stealComplete:FireServer("7799aa8a-03f9-4df1-ab0f-b6df84f6b36c") end)
        end
        
        task.wait(0.1)
        
        if grabRemote then
            pcall(function() grabRemote:FireServer("Place", memorizedPodium or 1) end)
        end
        
        task.wait(0.2)
        
        Player:SetAttribute("Stealing", false)
        Player:SetAttribute("StealingIndex", "")
        
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
        
        freeSlots1and2()
        
        StatusLabel.Text = "✅ Dupliqué !"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        isProcessing = false
    end

    -- ===== BOUCLE AUTO DUP =====
    local function autoDupLoop()
        while autoDupEnabled do
            if isProcessing then
                task.wait(0.1)
                continue
            end
            
            if memorizedPlot and memorizedPodium then
                StatusLabel.Text = "🟢 Auto Dup actif"
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                performDupe()
                task.wait(DUP_DELAY)
            else
                StatusLabel.Text = "🟠 Mémorise d'abord un animal !"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
                autoDupEnabled = false
                AutoDupBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                AutoDupBtn.Text = "🤖 AUTO DUP: OFF"
                break
            end
        end
    end

    -- ===== CONNEXIONS =====
    MemoBtn.MouseButton1Click:Connect(memorizeAnimal)

    AutoDupBtn.MouseButton1Click:Connect(function()
        if not memorizedPlot then
            StatusLabel.Text = "❌ Mémorise d'abord un animal !"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        autoDupEnabled = not autoDupEnabled
        
        if autoDupEnabled then
            AutoDupBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            AutoDupBtn.Text = "🤖 AUTO DUP: ON"
            task.spawn(autoDupLoop)
        else
            AutoDupBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            AutoDupBtn.Text = "🤖 AUTO DUP: OFF"
            StatusLabel.Text = "⚫ Auto Dup arrêté"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)

    print("✅ Script chargé !")
    print("📌 1. Approche-toi d'un animal et clique sur MÉMORISER")
    print("🤖 2. Active AUTO DUP pour dupliquer en boucle !")
end
