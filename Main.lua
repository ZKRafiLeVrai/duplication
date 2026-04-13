-- AUTO DUP VOL - FIX SLOT 1 (Fonctionnel)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ===== SYSTÈME DE KEY =====
local VALID_KEY = "5hi_gi737.yueu.6269"
local DISCORD_INVITE = "https://discord.gg/XdBdXWbP"

local function checkKey(k) return k == VALID_KEY end

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
LoginFrame.Size = UDim2.new(0, 280, 0, 230)
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
    if setclipboard then setclipboard(DISCORD_INVITE) DiscordButton.Text = "✅ Copié !" task.wait(2) DiscordButton.Text = "📱 Discord" end
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

-- ===== MAIN GUI =====
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

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local ToggleButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")
    local CountLabel = Instance.new("TextLabel")
    local SlotLabel = Instance.new("TextLabel")

    ScreenGui.Name = "AutoDupGUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
    MainFrame.Size = UDim2.new(0, 220, 0, 140)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Draggable = true
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = MainFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleButton.Size = UDim2.new(0.8, 0, 0, 45)
    ToggleButton.Position = UDim2.new(0.1, 0, 0.15, 0)
    ToggleButton.Text = "DÉMARRER"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Font = Enum.Font.GothamBold
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton

    SlotLabel.Name = "SlotLabel"
    SlotLabel.Parent = MainFrame
    SlotLabel.BackgroundTransparency = 1
    SlotLabel.Size = UDim2.new(1, 0, 0, 20)
    SlotLabel.Position = UDim2.new(0, 0, 0.52, 0)
    SlotLabel.Text = "Slot: -"
    SlotLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    SlotLabel.TextSize = 12
    SlotLabel.Font = Enum.Font.Gotham

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
    local isProcessing = false
    local dupeCount = 0
    local lastSlot = 0

    local function GetRealEmptySlot()
        local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
        local ourChannel = Synchronizer:Get(Player)
        if not ourChannel then return nil end
        local ourPodiums = ourChannel:Get("AnimalPodiums") or {}
        
        for i = 1, 200 do
            local slot = ourPodiums[i]
            -- Un slot est vide si nil, "Empty", ou table avec Index nil
            if slot == nil or slot == "Empty" or (type(slot) == "table" and slot.Index == nil) then
                return i
            end
        end
        return nil
    end

    local function IsBaseFull()
        return GetRealEmptySlot() == nil
    end

    local function FindTargetedAnimal()
        local char = Player.Character
        if not char then return nil, nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil end
        
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
        return bestPlot, bestPodium
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

    local function PerformDupe(plot, podium)
        local targetSlot = GetRealEmptySlot()
        if not targetSlot then
            StatusLabel.Text = "BASE PLEINE !"
            return false
        end
        
        SlotLabel.Text = "Slot cible: " .. targetSlot
        lastSlot = targetSlot
        
        -- Démarrer le vol
        if StealStartRemote and plot and podium then
            local ts = workspace:GetServerTimeNow()
            pcall(function() StealStartRemote:FireServer(ts, "c262398d-68e3-4499-8bea-99766bf11686", plot.Name, podium) end)
            pcall(function() StealStartRemote:FireServer(ts, "579e6c26-5a80-407d-9488-0f84752e8f1f", plot.Name, podium) end)
        end
        
        task.wait(0.2)
        
        -- Annuler chez la victime
        if GrabRemote then
            pcall(function() GrabRemote:FireServer("Place", podium) end)
        end
        
        task.wait(0.15)
        
        -- Compléter le vol
        if StealCompleteRemote then
            pcall(function() StealCompleteRemote:FireServer("7799aa8a-03f9-4df1-ab0f-b6df84f6b36c") end)
        end
        
        task.wait(0.3)
        
        -- Déplacer vers le slot cible
        if GrabRemote and targetSlot then
            local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
            local ourChannel = Synchronizer:Get(Player)
            if ourChannel then
                local ourPodiums = ourChannel:Get("AnimalPodiums") or {}
                for src = 1, 5 do
                    if ourPodiums[src] and ourPodiums[src] ~= "Empty" and ourPodiums[src] ~= nil then
                        if src ~= targetSlot then
                            pcall(function() GrabRemote:FireServer("Grab", src) end)
                            task.wait(0.1)
                            pcall(function() GrabRemote:FireServer("Place", targetSlot) end)
                        end
                        break
                    end
                end
            end
        end
        
        StopStealAnimation()
        dupeCount = dupeCount + 1
        CountLabel.Text = dupeCount .. " dupes"
        
        return true
    end

    local function AutoDupLoop()
        while autoDupEnabled do
            if isProcessing then
                task.wait(0.1)
                continue
            end
            
            if IsBaseFull() then
                StatusLabel.Text = "BASE PLEINE !"
                autoDupEnabled = false
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                ToggleButton.Text = "DÉMARRER"
                break
            end
            
            local plot, podium = FindTargetedAnimal()
            
            if plot and podium then
                isProcessing = true
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                StatusLabel.Text = "DUPLICATION..."
                
                PerformDupe(plot, podium)
                
                isProcessing = false
                task.wait(0.4) -- Attendre que le slot soit vraiment rempli
            else
                StatusLabel.Text = "Approche-toi"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                task.wait(0.3)
            end
        end
        
        StatusLabel.Text = "Arrêté"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "DÉMARRER"
        SlotLabel.Text = "Slot: -"
    end

    ToggleButton.MouseButton1Click:Connect(function()
        autoDupEnabled = not autoDupEnabled
        
        if autoDupEnabled then
            if IsBaseFull() then
                StatusLabel.Text = "BASE PLEINE !"
                autoDupEnabled = false
                return
            end
            
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
            ToggleButton.MouseButton1Click:Connect(function() end)() -- Simuler le clic
        end
    end)

    print("✅ FIX SLOT 1 - Commence au premier slot vide !")
end