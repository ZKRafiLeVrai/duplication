-- AUTO DUP VOL - FIX FINAL (Duplication infinie)
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

-- GUI Login (compact)
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
LoginFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoginFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
LoginFrame.Size = UDim2.new(0, 300, 0, 230)
LoginFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0, 8)
LoginCorner.Parent = LoginFrame

LoginTitle.Name = "LoginTitle"
LoginTitle.Parent = LoginFrame
LoginTitle.BackgroundTransparency = 1
LoginTitle.Size = UDim2.new(1, 0, 0, 30)
LoginTitle.Position = UDim2.new(0, 0, 0.08, 0)
LoginTitle.Text = "🔑 ENTRER LA KEY"
LoginTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginTitle.TextSize = 16
LoginTitle.Font = Enum.Font.GothamBold

DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = LoginFrame
DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordButton.Size = UDim2.new(0.8, 0, 0, 35)
DiscordButton.Position = UDim2.new(0.1, 0, 0.25, 0)
DiscordButton.Text = "📱 Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.TextSize = 14
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
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
KeyBox.Position = UDim2.new(0.1, 0, 0.47, 0)
KeyBox.PlaceholderText = "Key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeyBox

SubmitButton.Name = "SubmitButton"
SubmitButton.Parent = LoginFrame
SubmitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
SubmitButton.Size = UDim2.new(0.6, 0, 0, 35)
SubmitButton.Position = UDim2.new(0.2, 0, 0.7, 0)
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
ErrorLabel.Position = UDim2.new(0, 0, 0.88, 0)
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorLabel.TextSize = 11
ErrorLabel.Font = Enum.Font.Gotham

local function onSubmit()
    if checkKey(KeyBox.Text) then
        ErrorLabel.Text = "✅ Chargement..."
        ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(1)
        LoginGui:Destroy()
        loadMainGUI()
    else
        ErrorLabel.Text = "❌ Key invalide"
    end
end

SubmitButton.MouseButton1Click:Connect(onSubmit)
KeyBox.FocusLost:Connect(function(ep) if ep then onSubmit() end end)

-- ===== GUI PRINCIPAL =====
function loadMainGUI()
    local function FindRemote(n)
        for _, o in pairs(ReplicatedStorage:GetDescendants()) do
            if o:IsA("RemoteEvent") and o.Name == n then return o end
        end
        return nil
    end

    local GrabRemote = FindRemote("RE/StealService/Grab")
    local StealCompleteRemote = FindRemote("RE/5c8f0dd0-0f9e-44ba-8f9b-197958b661ab")
    local StealStartRemote = FindRemote("RE/5aa39ea1-0c65-4fcf-aff9-b18a7ef277c3")

    print("=== AUTO DUP INFINI ===")

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local ToggleButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")
    local CountLabel = Instance.new("TextLabel")
    local TargetLabel = Instance.new("TextLabel")

    ScreenGui.Name = "AutoDupGUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
    MainFrame.Size = UDim2.new(0, 220, 0, 130)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = MainFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.15, 0)
    ToggleButton.Text = "DÉMARRER"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Font = Enum.Font.GothamBold

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton

    TargetLabel.Name = "TargetLabel"
    TargetLabel.Parent = MainFrame
    TargetLabel.BackgroundTransparency = 1
    TargetLabel.Size = UDim2.new(1, 0, 0, 20)
    TargetLabel.Position = UDim2.new(0, 0, 0.5, 0)
    TargetLabel.Text = "Cible: Aucune"
    TargetLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    TargetLabel.TextSize = 12
    TargetLabel.Font = Enum.Font.Gotham

    CountLabel.Name = "CountLabel"
    CountLabel.Parent = MainFrame
    CountLabel.BackgroundTransparency = 1
    CountLabel.Size = UDim2.new(1, 0, 0, 20)
    CountLabel.Position = UDim2.new(0, 0, 0.68, 0)
    CountLabel.Text = "0 dupes"
    CountLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    CountLabel.TextSize = 14
    CountLabel.Font = Enum.Font.GothamBold

    StatusLabel.Name = "Status"
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
    StatusLabel.Text = "Prêt"
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusLabel.TextSize = 10
    StatusLabel.Font = Enum.Font.Gotham

    local autoDupEnabled = false
    local dupeCount = 0
    local isProcessing = false

    local function FindTargetedAnimal()
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
                            if parent:IsA("Model") and parent:GetAttribute("Loaded") then
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

    local function StopStealAnimation()
        local char = Player.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                local anim = hum:FindFirstChild("Animator")
                if anim then
                    for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                        t:Stop(0)
                    end
                end
            end
        end
        Player:SetAttribute("Stealing", false)
        Player:SetAttribute("StealingIndex", "")
    end

    local function PerformDupe(plot, podium, animalName)
        -- 1. Démarrer le vol
        if StealStartRemote and plot and podium then
            local ts = workspace:GetServerTimeNow()
            pcall(function() StealStartRemote:FireServer(ts, "c262398d-68e3-4499-8bea-99766bf11686", plot.Name, podium) end)
            pcall(function() StealStartRemote:FireServer(ts, "579e6c26-5a80-407d-9488-0f84752e8f1f", plot.Name, podium) end)
        end
        
        task.wait(0.15)
        
        -- 2. Compléter le vol (recevoir l'animal) - À FAIRE AVANT d'annuler !
        if StealCompleteRemote then
            pcall(function() StealCompleteRemote:FireServer("7799aa8a-03f9-4df1-ab0f-b6df84f6b36c") end)
        end
        
        task.wait(0.1)
        
        -- 3. Annuler chez la victime (pour qu'elle garde l'animal)
        if GrabRemote then
            pcall(function() GrabRemote:FireServer("Place", podium) end)
        end
        
        task.wait(0.15)
        
        StopStealAnimation()
        
        dupeCount = dupeCount + 1
        CountLabel.Text = dupeCount .. " dupes"
        TargetLabel.Text = "Cible: " .. animalName
        
        return true
    end

    local function AutoDupLoop()
        while autoDupEnabled do
            if isProcessing then
                task.wait(0.1)
                continue
            end
            
            local plot, podium, animalName = FindTargetedAnimal()
            
            if plot and podium then
                isProcessing = true
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                StatusLabel.Text = "DUPLICATION..."
                
                PerformDupe(plot, podium, animalName)
                
                isProcessing = false
                task.wait(0.3)
            else
                StatusLabel.Text = "Approche-toi"
                TargetLabel.Text = "Cible: Aucune"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                task.wait(0.3)
            end
        end
        
        StatusLabel.Text = "Arrêté"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "DÉMARRER"
    end

    ToggleButton.MouseButton1Click:Connect(function()
        autoDupEnabled = not autoDupEnabled
        
        if autoDupEnabled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            ToggleButton.Text = "ARRÊTER"
            StatusLabel.Text = "En marche..."
            task.spawn(AutoDupLoop)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ToggleButton.Text = "DÉMARRER"
            StatusLabel.Text = "Arrêté"
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.V then
            if autoDupEnabled then
                autoDupEnabled = false
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                ToggleButton.Text = "DÉMARRER"
                StatusLabel.Text = "Arrêté"
            else
                autoDupEnabled = true
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                ToggleButton.Text = "ARRÊTER"
                StatusLabel.Text = "En marche..."
                task.spawn(AutoDupLoop)
            end
        end
    end)

    print("✅ AUTO DUP INFINI - Prêt !")
end