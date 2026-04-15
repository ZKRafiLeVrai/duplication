-- // AUTO DUP VOL - GUI PREMIUM v3.0 (FIX COMPLET) \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ===== SYSTÈME DE KEY =====
local VALID_KEY = "5hi_gi737.yueu.6269"
local DISCORD_INVITE = "https://discord.gg/XdBdXWbP"

local function checkKey(k)
    return k == VALID_KEY
end

-- ===== BIBLIOTHÈQUE UI PREMIUM =====
local Library = {
    Theme = {
        Primary = Color3.fromRGB(255, 50, 50),
        Secondary = Color3.fromRGB(30, 30, 35),
        Background = Color3.fromRGB(20, 20, 25),
        Accent = Color3.fromRGB(0, 255, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180)
    }
}

-- Fonction pour créer une fenêtre principale
function Library:CreateWindow(title, subtitle)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoDupPremium"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    
    ScreenGui.Enabled = false
    task.wait()
    ScreenGui.Enabled = true
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
    MainFrame.Size = UDim2.new(0, 380, 0, 260)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundTransparency = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true  -- FIX : GUI déplaçable
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Library.Theme.Primary
    UIStroke.Thickness = 1.5
    UIStroke.Transparency = 0.3
    UIStroke.Parent = MainFrame
    
    -- Barre supérieure avec gradient
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Library.Theme.Secondary
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar
    
    -- Gradient animé sur la barre supérieure
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Library.Theme.Primary),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 20, 100)),
        ColorSequenceKeypoint.new(1, Library.Theme.Accent)
    })
    Gradient.Rotation = 90
    Gradient.Parent = TopBar
    
    -- Titre principal
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
    TitleLabel.Text = title or "AUTO DUP VOL"
    TitleLabel.TextColor3 = Library.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Sous-titre
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Parent = TopBar
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
    SubtitleLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
    SubtitleLabel.Text = subtitle or "by ZKR Scripts"
    SubtitleLabel.TextColor3 = Library.Theme.TextSecondary
    SubtitleLabel.TextSize = 10
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Logo (cercle)
    local Logo = Instance.new("Frame")
    Logo.Name = "Logo"
    Logo.Parent = TopBar
    Logo.BackgroundColor3 = Library.Theme.Primary
    Logo.BorderSizePixel = 0
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Position = UDim2.new(1, -40, 0.5, 0)
    Logo.AnchorPoint = Vector2.new(0, 0.5)
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(1, 0)
    LogoCorner.Parent = Logo
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Parent = Logo
    LogoText.BackgroundTransparency = 1
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.Text = "⚡"
    LogoText.TextColor3 = Library.Theme.Text
    LogoText.TextSize = 18
    LogoText.Font = Enum.Font.GothamBold
    
    -- Contenu principal
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, 0, 1, -50)
    ContentFrame.Position = UDim2.new(0, 0, 0, 50)
    
    -- Animation d'ouverture
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 260)
    })
    openTween:Play()
    
    local Window = { ScreenGui = ScreenGui, MainFrame = MainFrame, ContentFrame = ContentFrame }
    
    -- Méthode pour créer un toggle stylisé
    function Window:CreateToggle(options)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = options.Name or "Toggle"
        ToggleFrame.Parent = self.ContentFrame
        ToggleFrame.BackgroundColor3 = Library.Theme.Secondary
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Size = UDim2.new(0.9, 0, 0, 45)
        ToggleFrame.Position = UDim2.new(0.05, 0, options.Y or 0.1, 0)
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        ToggleLabel.Position = UDim2.new(0.05, 0, 0, 0)
        ToggleLabel.Text = options.Text or "Toggle"
        ToggleLabel.TextColor3 = Library.Theme.Text
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Size = UDim2.new(0, 45, 0, 22)
        ToggleButton.Position = UDim2.new(0.88, 0, 0.5, 0)
        ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
        ToggleButton.Text = ""
        
        local ToggleButtonCorner = Instance.new("UICorner")
        ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
        ToggleButtonCorner.Parent = ToggleButton
        
        local ToggleDot = Instance.new("Frame")
        ToggleDot.Parent = ToggleButton
        ToggleDot.BackgroundColor3 = Library.Theme.Text
        ToggleDot.BorderSizePixel = 0
        ToggleDot.Size = UDim2.new(0, 18, 0, 18)
        ToggleDot.Position = UDim2.new(0.15, 0, 0.5, 0)
        ToggleDot.AnchorPoint = Vector2.new(0, 0.5)
        
        local ToggleDotCorner = Instance.new("UICorner")
        ToggleDotCorner.CornerRadius = UDim.new(1, 0)
        ToggleDotCorner.Parent = ToggleDot
        
        local enabled = false
        local callback = options.Callback or function() end
        
        local function UpdateToggle(state)
            enabled = state
            local targetColor = state and Library.Theme.Accent or Color3.fromRGB(60, 60, 65)
            local targetPos = state and UDim2.new(0.85, -18, 0.5, 0) or UDim2.new(0.15, 0, 0.5, 0)
            
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = targetPos}):Play()
            
            callback(state)
        end
        
        ToggleButton.MouseButton1Click:Connect(function()
            UpdateToggle(not enabled)
        end)
        
        return { SetState = UpdateToggle }
    end
    
    -- Méthode pour créer un label stylisé
    function Window:CreateLabel(options)
        local Label = Instance.new("TextLabel")
        Label.Name = options.Name or "Label"
        Label.Parent = self.ContentFrame
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(0.9, 0, 0, 25)
        Label.Position = UDim2.new(0.05, 0, options.Y or 0.1, 0)
        Label.Text = options.Text or ""
        Label.TextColor3 = options.Color or Library.Theme.TextSecondary
        Label.TextSize = options.Size or 13
        Label.Font = options.Font or Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        local labelObj = { Label = Label }
        
        function labelObj:SetText(text)
            Label.Text = text
        end
        
        function labelObj:SetColor(color)
            Label.TextColor3 = color
        end
        
        return labelObj
    end
    
    -- Méthode pour créer une barre de progression
    function Window:CreateProgressBar(options)
        local ProgressFrame = Instance.new("Frame")
        ProgressFrame.Name = options.Name or "Progress"
        ProgressFrame.Parent = self.ContentFrame
        ProgressFrame.BackgroundColor3 = Library.Theme.Secondary
        ProgressFrame.BorderSizePixel = 0
        ProgressFrame.Size = UDim2.new(0.9, 0, 0, 20)
        ProgressFrame.Position = UDim2.new(0.05, 0, options.Y or 0.1, 0)
        
        local ProgressCorner = Instance.new("UICorner")
        ProgressCorner.CornerRadius = UDim.new(0, 4)
        ProgressCorner.Parent = ProgressFrame
        
        local ProgressFill = Instance.new("Frame")
        ProgressFill.Name = "Fill"
        ProgressFill.Parent = ProgressFrame
        ProgressFill.BackgroundColor3 = Library.Theme.Accent
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Size = UDim2.new(0, 0, 1, 0)
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(0, 4)
        FillCorner.Parent = ProgressFill
        
        local ProgressLabel = Instance.new("TextLabel")
        ProgressLabel.Parent = ProgressFrame
        ProgressLabel.BackgroundTransparency = 1
        ProgressLabel.Size = UDim2.new(1, 0, 1, 0)
        ProgressLabel.Text = options.Text or "0%"
        ProgressLabel.TextColor3 = Library.Theme.Text
        ProgressLabel.TextSize = 11
        ProgressLabel.Font = Enum.Font.GothamBold
        ProgressLabel.ZIndex = 2
        
        local progressObj = {}
        
        function progressObj:SetProgress(percent)
            percent = math.clamp(percent, 0, 100)
            TweenService:Create(ProgressFill, TweenInfo.new(0.3), {Size = UDim2.new(percent / 100, 0, 1, 0)}):Play()
            ProgressLabel.Text = string.format("%d%%", percent)
        end
        
        return progressObj
    end
    
    return Window
end

-- ===== GUI DE LOGIN PREMIUM =====
local LoginGui = Instance.new("ScreenGui")
local LoginFrame = Instance.new("Frame")
local LoginTitle = Instance.new("TextLabel")
local LoginSubtitle = Instance.new("TextLabel")
local KeyBox = Instance.new("TextBox")
local SubmitButton = Instance.new("TextButton")
local ErrorLabel = Instance.new("TextLabel")
local DiscordButton = Instance.new("TextButton")
local PriceButton = Instance.new("TextButton")

LoginGui.Name = "LoginGui"
LoginGui.Parent = CoreGui
LoginGui.ResetOnSpawn = false

LoginFrame.Name = "LoginFrame"
LoginFrame.Parent = LoginGui
LoginFrame.BackgroundColor3 = Library.Theme.Background
LoginFrame.BorderSizePixel = 0
LoginFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoginFrame.Size = UDim2.new(0, 340, 0, 320)
LoginFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoginFrame.Active = true
LoginFrame.Draggable = true

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0, 12)
LoginCorner.Parent = LoginFrame

local LoginStroke = Instance.new("UIStroke")
LoginStroke.Color = Library.Theme.Primary
LoginStroke.Thickness = 2
LoginStroke.Transparency = 0.5
LoginStroke.Parent = LoginFrame

-- Logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Name = "Logo"
LogoFrame.Parent = LoginFrame
LogoFrame.BackgroundColor3 = Library.Theme.Primary
LogoFrame.BorderSizePixel = 0
LogoFrame.Size = UDim2.new(0, 60, 0, 60)
LogoFrame.Position = UDim2.new(0.5, 0, 0.12, 0)
LogoFrame.AnchorPoint = Vector2.new(0.5, 0)

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(1, 0)
LogoCorner.Parent = LogoFrame

local LogoText = Instance.new("TextLabel")
LogoText.Parent = LogoFrame
LogoText.BackgroundTransparency = 1
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.Text = "🔥"
LogoText.TextColor3 = Library.Theme.Text
LogoText.TextSize = 32
LogoText.Font = Enum.Font.GothamBold

LoginTitle.Name = "LoginTitle"
LoginTitle.Parent = LoginFrame
LoginTitle.BackgroundTransparency = 1
LoginTitle.Size = UDim2.new(1, 0, 0, 25)
LoginTitle.Position = UDim2.new(0, 0, 0.32, 0)
LoginTitle.Text = "AUTO DUP VOL"
LoginTitle.TextColor3 = Library.Theme.Text
LoginTitle.TextSize = 20
LoginTitle.Font = Enum.Font.GothamBold

LoginSubtitle.Name = "LoginSubtitle"
LoginSubtitle.Parent = LoginFrame
LoginSubtitle.BackgroundTransparency = 1
LoginSubtitle.Size = UDim2.new(1, 0, 0, 18)
LoginSubtitle.Position = UDim2.new(0, 0, 0.4, 0)
LoginSubtitle.Text = "by ZKR Scripts"
LoginSubtitle.TextColor3 = Library.Theme.TextSecondary
LoginSubtitle.TextSize = 12
LoginSubtitle.Font = Enum.Font.Gotham

KeyBox.Name = "KeyBox"
KeyBox.Parent = LoginFrame
KeyBox.BackgroundColor3 = Library.Theme.Secondary
KeyBox.BorderSizePixel = 0
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.52, 0)
KeyBox.PlaceholderText = "🔑 Entre ta key ici..."
KeyBox.Text = ""
KeyBox.TextColor3 = Library.Theme.Text
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 8)
KeyCorner.Parent = KeyBox

SubmitButton.Name = "SubmitButton"
SubmitButton.Parent = LoginFrame
SubmitButton.BackgroundColor3 = Library.Theme.Primary
SubmitButton.Size = UDim2.new(0.8, 0, 0, 40)
SubmitButton.Position = UDim2.new(0.1, 0, 0.68, 0)
SubmitButton.Text = "VALIDER"
SubmitButton.TextColor3 = Library.Theme.Text
SubmitButton.TextSize = 14
SubmitButton.Font = Enum.Font.GothamBold

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 8)
SubmitCorner.Parent = SubmitButton

-- Bouton Prix
PriceButton.Name = "PriceButton"
PriceButton.Parent = LoginFrame
PriceButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
PriceButton.Size = UDim2.new(0.35, 0, 0, 30)
PriceButton.Position = UDim2.new(0.1, 0, 0.83, 0)
PriceButton.Text = "💰 20€"
PriceButton.TextColor3 = Library.Theme.Text
PriceButton.TextSize = 12
PriceButton.Font = Enum.Font.GothamBold

local PriceCorner = Instance.new("UICorner")
PriceCorner.CornerRadius = UDim.new(0, 6)
PriceCorner.Parent = PriceButton

-- Bouton Discord
DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = LoginFrame
DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordButton.Size = UDim2.new(0.35, 0, 0, 30)
DiscordButton.Position = UDim2.new(0.55, 0, 0.83, 0)
DiscordButton.Text = "📱 Discord"
DiscordButton.TextColor3 = Library.Theme.Text
DiscordButton.TextSize = 12
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

PriceButton.MouseButton1Click:Connect(function()
    ErrorLabel.Text = "💰 20€ | 🐉 Dragon +1.5B | 🎮 Garama Boosté"
    ErrorLabel.TextColor3 = Library.Theme.Accent
    task.wait(3)
    ErrorLabel.Text = ""
end)

ErrorLabel.Name = "ErrorLabel"
ErrorLabel.Parent = LoginFrame
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0, 0, 0.93, 0)
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Library.Theme.Primary
ErrorLabel.TextSize = 11
ErrorLabel.Font = Enum.Font.Gotham

local function onSubmit()
    if checkKey(KeyBox.Text) then
        ErrorLabel.Text = "✅ Key valide ! Chargement..."
        ErrorLabel.TextColor3 = Library.Theme.Accent
        
        local closeTween = TweenService:Create(LoginFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        
        LoginGui:Destroy()
        loadMainGUI()
    else
        ErrorLabel.Text = "❌ Key invalide !"
        ErrorLabel.TextColor3 = Library.Theme.Primary
        
        local originalPos = LoginFrame.Position
        for i = 1, 4 do
            TweenService:Create(LoginFrame, TweenInfo.new(0.05), {
                Position = originalPos + UDim2.new(0, 5 * (i % 2 == 0 and 1 or -1), 0, 0)
            }):Play()
            task.wait(0.05)
        end
        TweenService:Create(LoginFrame, TweenInfo.new(0.05), {Position = originalPos}):Play()
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

    local Window = Library:CreateWindow("AUTO DUP VOL", "by ZKR Scripts")
    
    local StatusLabel = Window:CreateLabel({
        Name = "Status",
        Text = "⚫ Prêt",
        Color = Library.Theme.TextSecondary,
        Size = 14,
        Y = 0.05
    })
    
    local TargetLabel = Window:CreateLabel({
        Name = "Target",
        Text = "🎯 Aucune cible",
        Color = Color3.fromRGB(255, 200, 100),
        Size = 13,
        Y = 0.18
    })
    
    local CountLabel = Window:CreateLabel({
        Name = "Count",
        Text = "📊 0 duplications",
        Color = Library.Theme.Accent,
        Size = 14,
        Y = 0.31
    })
    
    local ProgressBar = Window:CreateProgressBar({
        Name = "Progress",
        Text = "0%",
        Y = 0.48
    })
    
    local autoDupEnabled = false
    local dupeCount = 0
    local isProcessing = false
    local DUP_DELAY = 0.3
    
    local Toggle = Window:CreateToggle({
        Name = "AutoDup",
        Text = "🤖 Auto Dup Activé",
        Y = 0.62,
        Callback = function(state)
            autoDupEnabled = state
            if state then
                StatusLabel:SetText("🟢 Auto Dup en marche...")
                StatusLabel:SetColor(Library.Theme.Accent)
                task.spawn(AutoDupLoop)
            else
                StatusLabel:SetText("🔴 Auto Dup arrêté")
                StatusLabel:SetColor(Library.Theme.Primary)
            end
        end
    })
    
    Window:CreateLabel({
        Name = "Hotkey",
        Text = "⌨️ Raccourci: Touche V",
        Color = Library.Theme.TextSecondary,
        Size = 11,
        Y = 0.8
    })
    
    Window:CreateLabel({
        Name = "Credit",
        Text = "⚡ ZKR Scripts - v3.0 Premium",
        Color = Color3.fromRGB(100, 200, 255),
        Size = 11,
        Y = 0.92
    })

    local function GetFilledSlots()
        local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)
        local ourChannel = Synchronizer:Get(Player)
        if not ourChannel then return 0, 0 end
        local ourPodiums = ourChannel:Get("AnimalPodiums") or {}
        local filled = 0
        local total = 0
        for i in pairs(ourPodiums) do
            if type(i) == "number" then
                total = math.max(total, i)
                if ourPodiums[i] and ourPodiums[i] ~= "Empty" then
                    filled = filled + 1
                end
            end
        end
        return filled, total
    end

    -- FIX : Détection corrigée avec GetAttribute("State")
    local function FindTargetedAnimal()
        local char = Player.Character
        if not char then return nil, nil, nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil, nil, nil end
        
        local pos = root.Position
        local bestPlot, bestPodium, bestDist = nil, nil, 15
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local state = obj:GetAttribute("State")
                if state == "Steal" and obj.Enabled then
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
        if StealStartRemote and plot and podium then
            local ts = workspace:GetServerTimeNow()
            pcall(function() StealStartRemote:FireServer(ts, "c262398d-68e3-4499-8bea-99766bf11686", plot.Name, podium) end)
            pcall(function() StealStartRemote:FireServer(ts, "579e6c26-5a80-407d-9488-0f84752e8f1f", plot.Name, podium) end)
        end
        
        task.wait(0.15)
        
        if StealCompleteRemote then
            pcall(function() StealCompleteRemote:FireServer("7799aa8a-03f9-4df1-ab0f-b6df84f6b36c") end)
        end
        
        task.wait(0.1)
        
        if GrabRemote then
            pcall(function() GrabRemote:FireServer("Place", podium) end)
        end
        
        task.wait(0.15)
        
        StopStealAnimation()
        
        dupeCount = dupeCount + 1
        CountLabel:SetText("📊 " .. dupeCount .. " duplications")
        TargetLabel:SetText("🎯 " .. animalName)
        
        local filled, total = GetFilledSlots()
        if total > 0 then
            local percent = math.floor(filled / total * 100)
            ProgressBar:SetProgress(percent)
        end
        
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
                StatusLabel:SetText("🟡 Duplication en cours...")
                StatusLabel:SetColor(Color3.fromRGB(255, 255, 100))
                
                PerformDupe(plot, podium, animalName)
                
                isProcessing = false
                StatusLabel:SetText("🟢 Auto Dup en marche...")
                StatusLabel:SetColor(Library.Theme.Accent)
                task.wait(DUP_DELAY)
            else
                StatusLabel:SetText("🟠 Approche-toi d'un animal...")
                StatusLabel:SetColor(Color3.fromRGB(255, 180, 100))
                TargetLabel:SetText("🎯 Aucune cible")
                task.wait(0.3)
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.V then
            Toggle:SetState(not autoDupEnabled)
        end
    end)
    
    local filled, total = GetFilledSlots()
    if total > 0 then
        ProgressBar:SetProgress(math.floor(filled / total * 100))
    end

    print("✅ AUTO DUP PREMIUM v3.0 CHARGÉ !")
end