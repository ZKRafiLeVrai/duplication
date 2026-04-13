-- AUTO DUP VOL - FIX FINAL SANS REMPLACEMENT
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ===== SYSTÈME DE KEY =====
local VALID_KEY = "5hi_gi737.yueu.6269"
local DISCORD_INVITE = "https://discord.gg/XdBdXWbP"
local keyAccepted = false

local function checkKey(inputKey)
    if inputKey == VALID_KEY then
        keyAccepted = true
        return true
    end
    return false
end

-- GUI de login
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
LoginFrame.BorderSizePixel = 0
LoginFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
LoginFrame.Size = UDim2.new(0, 340, 0, 260)
LoginFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0, 8)
LoginCorner.Parent = LoginFrame

local LoginStroke = Instance.new("UIStroke")
LoginStroke.Color = Color3.fromRGB(255, 50, 50)
LoginStroke.Thickness = 2
LoginStroke.Parent = LoginFrame

LoginTitle.Name = "LoginTitle"
LoginTitle.Parent = LoginFrame
LoginTitle.BackgroundTransparency = 1
LoginTitle.Size = UDim2.new(1, 0, 0, 30)
LoginTitle.Position = UDim2.new(0, 0, 0.08, 0)
LoginTitle.Text = "🔑 ENTRER LA KEY 🔑"
LoginTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginTitle.TextSize = 16
LoginTitle.Font = Enum.Font.GothamBold

DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = LoginFrame
DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordButton.Size = UDim2.new(0.85, 0, 0, 40)
DiscordButton.Position = UDim2.new(0.075, 0, 0.23, 0)
DiscordButton.Text = "📱 Rejoindre le Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.TextSize = 14
DiscordButton.Font = Enum.Font.GothamBold

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 6)
DiscordCorner.Parent = DiscordButton

local function copyDiscordLink()
    if setclipboard then
        setclipboard(DISCORD_INVITE)
        DiscordButton.Text = "✅ Lien copié !"
        DiscordButton.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
        task.wait(2)
        DiscordButton.Text = "📱 Rejoindre le Discord"
        DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    end
end

DiscordButton.MouseButton1Click:Connect(copyDiscordLink)

KeyBox.Name = "KeyBox"
KeyBox.Parent = LoginFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.BorderSizePixel = 0
KeyBox.Size = UDim2.new(0.85, 0, 0, 40)
KeyBox.Position = UDim2.new(0.075, 0, 0.45, 0)
KeyBox.PlaceholderText = "Entre ta key ici..."
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
SubmitButton.Size = UDim2.new(0.7, 0, 0, 40)
SubmitButton.Position = UDim2.new(0.15, 0, 0.68, 0)
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
    local inputKey = KeyBox.Text
    if checkKey(inputKey) then
        ErrorLabel.Text = "✅ Key valide ! Chargement..."
        ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(1)
        LoginGui:Destroy()
        loadMainGUI()
    else
        ErrorLabel.Text = "❌ Key invalide !"
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

SubmitButton.MouseButton1Click:Connect(onSubmit)
KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        onSubmit()
    end
end)

-- ===== GUI PRINCIPAL =====
function loadMainGUI()
    local function FindRemoteByName(remoteName)
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name == remoteName then
                return obj
            end
        end
        return nil
    end

    local GrabRemote = FindRemoteByName("RE/StealService/Grab")
    local StealCompleteRemote = FindRemoteByName("RE/5c8f0dd0-0f9e-44ba-8f9b-197958b661ab")
    local StealStartRemote = FindRemoteByName("RE/5aa39ea1-0c65-4fcf-aff9-b18a7ef277c3")

    print("=== AUTO DUP FIX FINAL ===")

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local ToggleButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")
    local CountLabel = Instance.new("TextLabel")
    local TargetLabel = Instance.new("TextLabel")
    local SlotLabel = Instance.new("TextLabel")

    ScreenGui.Name = "AutoDupGUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
    MainFrame.Size = UDim2.new(0, 260, 0, 190)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.Position = UDim2.new(0, 0, 0, 0)

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    TitleLabel.Name = "Title"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.15, 0, 0, 0)
    TitleLabel.Text = "AUTO DUP FIX"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold

    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = MainFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleButton.Size = UDim2.new(0.85, 0, 0, 40)
    ToggleButton.Position = UDim2.new(0.075, 0, 0.18, 0)
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
    TargetLabel.Position = UDim2.new(0, 0, 0.43, 0)
    TargetLabel.Text = "Cible: Aucune"
    TargetLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    TargetLabel.TextSize = 11
    TargetLabel.Font = Enum.Font.Gotham

    SlotLabel.Name = "SlotLabel"
    SlotLabel.Parent = MainFrame
    SlotLabel.BackgroundTransparency = 1
    SlotLabel.Size = UDim2.new(1, 0, 0, 20)
    SlotLabel.Position = UDim2.new(0, 0, 0.55, 0)
    SlotLabel.Text = "Slots: 0/0"
    SlotLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SlotLabel.TextSize = 11
    SlotLabel.Font = Enum.Font.Gotham

    CountLabel.Name = "CountLabel"
    CountLabel.Parent = MainFrame
    CountLabel.BackgroundTransparency = 1
    CountLabel.Size = UDim2.new(1, 0, 0, 20)
    CountLabel.Position = UDim2.new(0, 0, 0.68, 0)
    CountLabel.Text = "0"
    CountLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    CountLabel.TextSize = 18
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
    local DUP_DELAY = 0.5

    local function GetFilledSlots()
        local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
        local ourChannel = Synchronizer:Get(Player)
        if not ourChannel then return 0 end
        local ourPodiums = ourChannel:Get("AnimalPodiums") or {}
        local count = 0
        for i = 1, 200 do
            if ourPodiums[i] and ourPodiums[i] ~= "Empty" and ourPodiums[i] ~= nil then
                count = count + 1
            end
        end
        return count
    end

    local function GetTotalSlots()
        local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
        local ourChannel = Synchronizer:Get(Player)
        if not ourChannel then return 0 end
        local ourPodiums = ourChannel:Get("AnimalPodiums") or {}
        local maxSlot = 0
        for i in pairs(ourPodiums) do
            if type(i) == "number" and i > maxSlot then
                maxSlot = i
            end
        end
        return maxSlot
    end

    local function FindTargetedAnimal()
        local character = Player.Character
        if not character then return nil, nil, nil end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil, nil end
        
        local playerPos = root.Position
        local closestPlot = nil
        local closestPodium = nil
        local closestDistance = 15
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.ActionText == "Steal" and obj.Enabled then
                local promptPos = obj.Parent
                if promptPos and promptPos:IsA("Attachment") then
                    promptPos = promptPos.Parent
                end
                if promptPos and promptPos:IsA("BasePart") then
                    local distance = (promptPos.Position - playerPos).Magnitude
                    if distance < closestDistance then
                        local parent = obj.Parent
                        while parent do
                            if parent:IsA("Model") and parent:GetAttribute("Loaded") then
                                local plotModel = parent
                                for _, child in pairs(plotModel.AnimalPodiums:GetChildren()) do
                                    local prompt = child:FindFirstChild("ProximityPrompt", true)
                                    if prompt == obj then
                                        closestDistance = distance
                                        closestPlot = plotModel
                                        closestPodium = tonumber(child.Name)
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
        
        if closestPlot and closestPodium then
            local animalName = "Animal"
            pcall(function()
                local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
                local plotChannel = Synchronizer:Get(closestPlot.Name)
                if plotChannel then
                    local animalList = plotChannel:Get("AnimalList") or {}
                    local animal = animalList[closestPodium]
                    if animal and animal.Index then
                        animalName = animal.Index
                    end
                end
            end)
            return closestPlot, closestPodium, animalName
        end
        
        return nil, nil, nil
    end

    local function StopStealAnimation()
        local character = Player.Character
        if not character then return end
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChild("Animator")
            if animator then
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop(0)
                end
            end
        end
        Player:SetAttribute("Stealing", false)
        Player:SetAttribute("StealingIndex", "")
    end

    local function PerformDupe(plotModel, podiumIndex, animalName)
        -- Démarrer le vol
        if StealStartRemote and plotModel and podiumIndex then
            local timestamp = workspace:GetServerTimeNow()
            pcall(function() StealStartRemote:FireServer(timestamp, "c262398d-68e3-4499-8bea-99766bf11686", plotModel.Name, podiumIndex) end)
            pcall(function() StealStartRemote:FireServer(timestamp, "579e6c26-5a80-407d-9488-0f84752e8f1f", plotModel.Name, podiumIndex) end)
        end

        task.wait(0.2)

        -- Annuler chez la victime
        if GrabRemote then
            pcall(function() GrabRemote:FireServer("Place", podiumIndex) end)
        end

        task.wait(0.15)

        -- Compléter le vol (l'animal arrive automatiquement dans le premier slot libre)
        if StealCompleteRemote then
            pcall(function() StealCompleteRemote:FireServer("7799aa8a-03f9-4df1-ab0f-b6df84f6b36c") end)
        end

        task.wait(0.3)

        StopStealAnimation()

        dupeCount = dupeCount + 1
        CountLabel.Text = tostring(dupeCount)
        TargetLabel.Text = "Cible: " .. (animalName or "Animal")
        
        local filled = GetFilledSlots()
        local total = GetTotalSlots()
        SlotLabel.Text = "Slots: " .. filled .. "/" .. total

        return true
    end

    local function AutoDupLoop()
        while autoDupEnabled do
            if isProcessing then
                task.wait(0.1)
                continue
            end

            local plotModel, podiumIndex, animalName = FindTargetedAnimal()

            if plotModel and podiumIndex then
                isProcessing = true
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                StatusLabel.Text = "DUPLICATION..."

                PerformDupe(plotModel, podiumIndex, animalName)

                isProcessing = false
                task.wait(DUP_DELAY)
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
            
            local filled = GetFilledSlots()
            local total = GetTotalSlots()
            SlotLabel.Text = "Slots: " .. filled .. "/" .. total

            task.spawn(AutoDupLoop)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ToggleButton.Text = "DÉMARRER"
            StatusLabel.Text = "Arrêté"
        end
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
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
                
                local filled = GetFilledSlots()
                local total = GetTotalSlots()
                SlotLabel.Text = "Slots: " .. filled .. "/" .. total

                task.spawn(AutoDupLoop)
            end
        end
    end)

    print("✅ AUTO DUP FIX FINAL - Sans remplacement !")
end