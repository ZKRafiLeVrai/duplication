-- AUTO DUP VOL - PROTÉGÉ PAR KEY (CORRIGÉ)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ===== SYSTÈME DE KEY (CORRIGÉ) =====
local VALID_KEY = "5hi_gi737.yueu.6269"  -- Key simplifiée sans caractères spéciaux
local keyAccepted = false

-- Fonction pour vérifier la key
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
local KeyHint = Instance.new("TextLabel")

LoginGui.Name = "LoginGui"
LoginGui.Parent = Player:WaitForChild("PlayerGui")
LoginGui.ResetOnSpawn = false

LoginFrame.Name = "LoginFrame"
LoginFrame.Parent = LoginGui
LoginFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoginFrame.BorderSizePixel = 0
LoginFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
LoginFrame.Size = UDim2.new(0, 320, 0, 220)
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

KeyHint.Name = "KeyHint"
KeyHint.Parent = LoginFrame
KeyHint.BackgroundTransparency = 1
KeyHint.Size = UDim2.new(1, 0, 0, 20)
KeyHint.Position = UDim2.new(0, 0, 0.25, 0)
KeyHint.Text = "Get The key on discord"
KeyHint.TextColor3 = Color3.fromRGB(150, 150, 150)
KeyHint.TextSize = 11
KeyHint.Font = Enum.Font.Gotham

KeyBox.Name = "KeyBox"
KeyBox.Parent = LoginFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.BorderSizePixel = 0
KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
KeyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
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
SubmitButton.Size = UDim2.new(0.6, 0, 0, 35)
SubmitButton.Position = UDim2.new(0.2, 0, 0.65, 0)
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

-- Fonction de validation
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
    -- Trouver les RemoteEvents
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

    print("=== AUTO DUP CHARGÉ ===")
    print("GrabRemote:", GrabRemote ~= nil)
    print("StealCompleteRemote:", StealCompleteRemote ~= nil)
    print("StealStartRemote:", StealStartRemote ~= nil)

    -- GUI
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local ToggleButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")
    local CountLabel = Instance.new("TextLabel")
    local SpeedLabel = Instance.new("TextLabel")

    ScreenGui.Name = "AutoDupGUI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
    MainFrame.Size = UDim2.new(0, 240, 0, 150)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 255, 0)
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

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
    TitleLabel.Text = "AUTO DUP"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold

    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = MainFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleButton.Size = UDim2.new(0.85, 0, 0, 40)
    ToggleButton.Position = UDim2.new(0.075, 0, 0.25, 0)
    ToggleButton.Text = "DÉMARRER"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Font = Enum.Font.GothamBold

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton

    CountLabel.Name = "CountLabel"
    CountLabel.Parent = MainFrame
    CountLabel.BackgroundTransparency = 1
    CountLabel.Size = UDim2.new(1, 0, 0, 20)
    CountLabel.Position = UDim2.new(0, 0, 0.58, 0)
    CountLabel.Text = "0"
    CountLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    CountLabel.TextSize = 18
    CountLabel.Font = Enum.Font.GothamBold

    SpeedLabel.Name = "SpeedLabel"
    SpeedLabel.Parent = MainFrame
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Size = UDim2.new(1, 0, 0, 15)
    SpeedLabel.Position = UDim2.new(0, 0, 0.72, 0)
    SpeedLabel.Text = "⚡ ULTRA RAPIDE ⚡"
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    SpeedLabel.TextSize = 10
    SpeedLabel.Font = Enum.Font.Gotham

    StatusLabel.Name = "Status"
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, 0, 0, 15)
    StatusLabel.Position = UDim2.new(0, 0, 0.85, 0)
    StatusLabel.Text = "Prêt"
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusLabel.TextSize = 10
    StatusLabel.Font = Enum.Font.Gotham

    -- Variables
    local autoDupEnabled = false
    local dupeCount = 0
    local isProcessing = false
    local DUP_DELAY = 0.15

    -- Fonctions
    local function FindEmptySlot()
        local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
        local ourChannel = Synchronizer:Get(Player)
        if not ourChannel then return nil end
        local ourPodiums = ourChannel:Get("AnimalPodiums") or {}
        for i = 1, 200 do
            if ourPodiums[i] == "Empty" or ourPodiums[i] == nil then
                return i
            end
        end
        return nil
    end

    local function IsBaseFull()
        return FindEmptySlot() == nil
    end

    local function MoveAnimal(fromSlot, toSlot)
        if not GrabRemote then return false end
        pcall(function() GrabRemote:FireServer("Grab", fromSlot) end)
        task.wait(0.05)
        pcall(function() GrabRemote:FireServer("Place", toSlot) end)
        return true
    end

    local function FreeSlots1and2()
        local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
        local ourChannel = Synchronizer:Get(Player)
        if not ourChannel then return end
        local ourPodiums = ourChannel:Get("AnimalPodiums") or {}

        for _, slot in pairs({1, 2}) do
            if ourPodiums[slot] and ourPodiums[slot] ~= "Empty" then
                local emptySlot = FindEmptySlot()
                if emptySlot and emptySlot ~= 1 and emptySlot ~= 2 then
                    MoveAnimal(slot, emptySlot)
                    task.wait(0.05)
                end
            end
        end
    end

    local function FindAnimalToSteal()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.ActionText == "Steal" and obj.Enabled then
                local parent = obj.Parent
                while parent do
                    if parent:IsA("Model") and parent:GetAttribute("Loaded") then
                        local plotModel = parent
                        for _, child in pairs(plotModel.AnimalPodiums:GetChildren()) do
                            local prompt = child:FindFirstChild("ProximityPrompt", true)
                            if prompt == obj then
                                return plotModel, tonumber(child.Name)
                            end
                        end
                    end
                    parent = parent.Parent
                end
            end
        end
        return nil, nil
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

        if workspace.CurrentCamera then
            for _, child in pairs(workspace.CurrentCamera:GetChildren()) do
                if child:IsA("Model") and child.PrimaryPart then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end

    local function PerformDupe(plotModel, podiumIndex)
        if IsBaseFull() then
            StatusLabel.Text = "BASE PLEINE !"
            return false
        end

        FreeSlots1and2()

        if StealStartRemote and plotModel and podiumIndex then
            local timestamp = workspace:GetServerTimeNow()
            pcall(function() StealStartRemote:FireServer(timestamp, "c262398d-68e3-4499-8bea-99766bf11686", plotModel.Name, podiumIndex) end)
            pcall(function() StealStartRemote:FireServer(timestamp, "579e6c26-5a80-407d-9488-0f84752e8f1f", plotModel.Name, podiumIndex) end)
        end

        task.wait(0.08)

        if GrabRemote then
            for i = 1, 50 do
                pcall(function() GrabRemote:FireServer("Place", i) end)
            end
        end

        if StealCompleteRemote then
            pcall(function() StealCompleteRemote:FireServer("7799aa8a-03f9-4df1-ab0f-b6df84f6b36c") end)
        end

        StopStealAnimation()

        dupeCount = dupeCount + 1
        CountLabel.Text = tostring(dupeCount)

        return true
    end

    local function AutoDupLoop()
        while autoDupEnabled do
            if isProcessing then
                task.wait(0.01)
                continue
            end

            if IsBaseFull() then
                StatusLabel.Text = "BASE PLEINE !"
                autoDupEnabled = false
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                ToggleButton.Text = "DÉMARRER"
                break
            end

            local plotModel, podiumIndex = FindAnimalToSteal()

            if plotModel and podiumIndex then
                isProcessing = true
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                StatusLabel.Text = "DUPLICATION..."

                PerformDupe(plotModel, podiumIndex)

                isProcessing = false
                task.wait(DUP_DELAY)
            else
                StatusLabel.Text = "Approche-toi d'un animal"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
                task.wait(0.2)
            end
        end

        StatusLabel.Text = "Arrêté"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "DÉMARRER"
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
        end
    end)

    print("✅ AUTO DUP PRÊT !")
    print("Appuie sur V ou clique pour activer !")
end