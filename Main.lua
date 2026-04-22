local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    LocalPlayer = Players.LocalPlayerAdded:Wait()
end

-- ===== SYSTÈME DE KEY =====
local VALID_KEY = "5hi_gi737.yueu.6269"
local DISCORD_INVITE = "https://discord.gg/XdBdXWbP"

local function checkKey(k)
    return k == VALID_KEY
end

-- ===== GUI DE LOGIN =====
local LoginGui = Instance.new("ScreenGui")
LoginGui.Name = "LoginGUI"
LoginGui.ResetOnSpawn = false
LoginGui.Parent = game:GetService("CoreGui")

local LoginFrame = Instance.new("Frame")
LoginFrame.Size = UDim2.new(0, 300, 0, 220)
LoginFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
LoginFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
LoginFrame.BorderSizePixel = 0
LoginFrame.Active = true
LoginFrame.Draggable = true
LoginFrame.Parent = LoginGui

local LoginCorner = Instance.new("UICorner")
LoginCorner.CornerRadius = UDim.new(0, 8)
LoginCorner.Parent = LoginFrame

local LoginStroke = Instance.new("UIStroke")
LoginStroke.Color = Color3.fromRGB(255, 50, 50)
LoginStroke.Thickness = 1.5
LoginStroke.Parent = LoginFrame

local LoginTitle = Instance.new("TextLabel")
LoginTitle.Size = UDim2.new(1, 0, 0, 30)
LoginTitle.Position = UDim2.new(0, 0, 0.1, 0)
LoginTitle.BackgroundTransparency = 1
LoginTitle.Text = "🔑 ENTRER LA KEY"
LoginTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginTitle.TextSize = 16
LoginTitle.Font = Enum.Font.GothamBold
LoginTitle.Parent = LoginFrame

local DiscordButton = Instance.new("TextButton")
DiscordButton.Size = UDim2.new(0.7, 0, 0, 35)
DiscordButton.Position = UDim2.new(0.15, 0, 0.25, 0)
DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordButton.BorderSizePixel = 0
DiscordButton.Text = "📱 Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.TextSize = 13
DiscordButton.Parent = LoginFrame

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

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.7, 0, 0, 35)
KeyBox.Position = UDim2.new(0.15, 0, 0.48, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
KeyBox.BorderSizePixel = 0
KeyBox.PlaceholderText = "Entre ta key..."
KeyBox.Text = ""
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = LoginFrame

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 6)
KeyCorner.Parent = KeyBox

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0.7, 0, 0, 35)
SubmitButton.Position = UDim2.new(0.15, 0, 0.7, 0)
SubmitButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
SubmitButton.BorderSizePixel = 0
SubmitButton.Text = "VALIDER"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 14
SubmitButton.Parent = LoginFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitButton

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0, 0, 0.9, 0)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorLabel.TextSize = 11
ErrorLabel.Font = Enum.Font.Gotham
ErrorLabel.Parent = LoginFrame

local function onSubmit()
    if checkKey(KeyBox.Text) then
        ErrorLabel.Text = "✅ Key valide ! Chargement..."
        ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        LoginGui:Destroy()
        loadMainLoader()
    else
        ErrorLabel.Text = "❌ Key invalide !"
    end
end

SubmitButton.MouseButton1Click:Connect(onSubmit)
KeyBox.FocusLost:Connect(function(ep) if ep then onSubmit() end end)

-- ===== LOADER PRINCIPAL =====
function loadMainLoader()
    local LoaderGui = Instance.new("ScreenGui")
    LoaderGui.Name = "LoaderGUI"
    LoaderGui.ResetOnSpawn = false
    LoaderGui.Parent = game:GetService("CoreGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = LoaderGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.Text = "DUPE V4 - By ZKR Scripts"
    Title.TextColor3 = Color3.fromRGB(220, 220, 220)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Frame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title

    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(0, 160, 0, 40)
    MainBtn.Position = UDim2.new(0.5, -80, 0.5, -20)
    MainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainBtn.Text = "Launch"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.GothamBold
    MainBtn.TextSize = 18
    MainBtn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = MainBtn

    local mainScript = [[
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Net = require(ReplicatedStorage.Packages.Net)
local Synchronizer = require(ReplicatedStorage.Packages.Synchronizer)

local LocalPlayer = Players.LocalPlayer

local STEAL_COOLDOWN = 0.1
local HOLD_DURATION = 0.5
local MAX_DISTANCE = 10

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DupeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Configuration lumière
local lightConfig = {
    color = Color3.fromRGB(50, 150, 250),
    mode = "normal", -- normal, bright, neon
    enabled = true,
    speed = 2
}

-- Couleurs disponibles
local colorOptions = {
    {name = "Blue", color = Color3.fromRGB(50, 150, 250)},
    {name = "Red", color = Color3.fromRGB(255, 50, 50)},
    {name = "Green", color = Color3.fromRGB(50, 255, 100)},
    {name = "Purple", color = Color3.fromRGB(180, 50, 255)},
    {name = "Orange", color = Color3.fromRGB(255, 150, 50)},
    {name = "Cyan", color = Color3.fromRGB(50, 255, 255)},
    {name = "Pink", color = Color3.fromRGB(255, 100, 200)},
    {name = "Yellow", color = Color3.fromRGB(255, 255, 50)},
    {name = "White", color = Color3.fromRGB(255, 255, 255)},
    {name = "Black", color = Color3.fromRGB(80, 80, 80)},
}

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Création des bordures lumineuses animées
local glowStrokes = {}

local function createGlowStroke(parent, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = lightConfig.color
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    stroke.Parent = parent
    return stroke
end

-- Bordure principale
local mainStroke = createGlowStroke(MainFrame, 2, 0.3)
table.insert(glowStrokes, mainStroke)

-- Bordures secondaires pour effet glow
local glowFrame1 = Instance.new("Frame")
glowFrame1.Size = UDim2.new(1, 4, 1, 4)
glowFrame1.Position = UDim2.new(0, -2, 0, -2)
glowFrame1.BackgroundTransparency = 1
glowFrame1.ZIndex = 0
glowFrame1.Parent = MainFrame

local glowCorner1 = Instance.new("UICorner")
glowCorner1.CornerRadius = UDim.new(0, 12)
glowCorner1.Parent = glowFrame1

local glowStroke1 = createGlowStroke(glowFrame1, 3, 0.6)
table.insert(glowStrokes, glowStroke1)

local glowFrame2 = Instance.new("Frame")
glowFrame2.Size = UDim2.new(1, 8, 1, 8)
glowFrame2.Position = UDim2.new(0, -4, 0, -4)
glowFrame2.BackgroundTransparency = 1
glowFrame2.ZIndex = 0
glowFrame2.Parent = MainFrame

local glowCorner2 = Instance.new("UICorner")
glowCorner2.CornerRadius = UDim.new(0, 14)
glowCorner2.Parent = glowFrame2

local glowStroke2 = createGlowStroke(glowFrame2, 4, 0.8)
table.insert(glowStrokes, glowStroke2)

-- Animation de lumière
local lightAnimationConnection = nil

local function updateLightAnimation()
    if lightAnimationConnection then
        lightAnimationConnection:Disconnect()
    end
    
    if not lightConfig.enabled then
        for _, stroke in ipairs(glowStrokes) do
            stroke.Transparency = 1
        end
        return
    end
    
    lightAnimationConnection = RunService.Heartbeat:Connect(function()
        local time = tick() * lightConfig.speed
        
        for i, stroke in ipairs(glowStrokes) do
            stroke.Color = lightConfig.color
            
            local baseTransparency = 0.3 + (i - 1) * 0.2
            local pulseOffset = (i - 1) * 0.5
            
            if lightConfig.mode == "normal" then
                local pulse = math.sin(time + pulseOffset) * 0.15
                stroke.Transparency = math.clamp(baseTransparency + pulse, 0.1, 0.9)
                stroke.Thickness = 2 + (i - 1) + math.sin(time * 1.5 + pulseOffset) * 0.5
                
            elseif lightConfig.mode == "bright" then
                local pulse = math.sin(time * 2 + pulseOffset) * 0.2
                stroke.Transparency = math.clamp(baseTransparency - 0.2 + pulse, 0, 0.7)
                stroke.Thickness = 3 + (i - 1) * 1.5 + math.sin(time * 2 + pulseOffset)
                
            elseif lightConfig.mode == "neon" then
                local fastPulse = math.sin(time * 4 + pulseOffset) * 0.3
                local colorShift = math.sin(time * 0.5) * 0.1
                stroke.Transparency = math.clamp(0.1 + fastPulse, 0, 0.6)
                stroke.Thickness = 4 + (i - 1) * 2 + math.abs(math.sin(time * 3 + pulseOffset)) * 2
                
                -- Effet neon avec variation de couleur légère
                local h, s, v = lightConfig.color:ToHSV()
                stroke.Color = Color3.fromHSV((h + colorShift) % 1, s, math.clamp(v + math.sin(time * 3) * 0.2, 0.5, 1))
            end
        end
    end)
end

-- Initialiser l'animation
updateLightAnimation()

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Dupe V4 - By ZKR Scripts"
TitleText.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -32, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    if lightAnimationConnection then
        lightAnimationConnection:Disconnect()
    end
    ScreenGui:Destroy()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
end)

-- Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -10, 0, 32)
TabContainer.Position = UDim2.new(0, 5, 0, 36)
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabContainer

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -10, 1, -80)
ContentFrame.Position = UDim2.new(0, 5, 0, 72)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.ScrollBarImageColor3 = lightConfig.color
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

-- Tabs
local tabs = {"EXPLOITS", "SETTINGS", "LIGHT"}
local activeTab = 1
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -4, 1, -6)
    btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 3)
    btn.Text = tabName
    btn.BackgroundColor3 = i == 1 and lightConfig.color or Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Parent = TabContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for j, b in ipairs(tabButtons) do
            TweenService:Create(b, TweenInfo.new(0.3), {
                BackgroundColor3 = j == i and lightConfig.color or Color3.fromRGB(25, 25, 25),
                TextColor3 = j == i and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            }):Play()
        end
        activeTab = i
        updateContent()
    end)

    table.insert(tabButtons, btn)
end

-- Helper Functions
local function createSection(title, parent, yOffset)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 28)
    section.Position = UDim2.new(0, 5, 0, yOffset)
    section.BackgroundTransparency = 1
    section.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = lightConfig.color
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.Parent = section

    return section.Size.Y.Offset + 5
end

local function createButton(text, callback, parent, yOffset, customColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, yOffset)
    btn.Text = text
    btn.BackgroundColor3 = customColor or Color3.fromRGB(22, 22, 22)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = text == "DUPE" and 18 or 14
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = lightConfig.color
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.7
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = customColor or Color3.fromRGB(22, 22, 22)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    end)

    return btn.Size.Y.Offset + 5
end

local function createInput(label, defaultValue, parent, yOffset)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 42)
    container.Position = UDim2.new(0, 5, 0, yOffset)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local labelObj = Instance.new("TextLabel")
    labelObj.Size = UDim2.new(0.45, -5, 1, 0)
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = Color3.fromRGB(180, 180, 180)
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.Font = Enum.Font.Gotham
    labelObj.TextSize = 14
    labelObj.Parent = container

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.55, 0, 1, -10)
    input.Position = UDim2.new(0.45, 0, 0, 5)
    input.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Text = tostring(defaultValue)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.BorderSizePixel = 0
    input.Parent = container

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = input

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = lightConfig.color
    inputStroke.Thickness = 1
    inputStroke.Transparency = 0.8
    inputStroke.Parent = input

    return container.Size.Y.Offset + 5, input
end

local function createToggle(label, defaultValue, callback, parent, yOffset)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 42)
    container.Position = UDim2.new(0, 5, 0, yOffset)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local labelObj = Instance.new("TextLabel")
    labelObj.Size = UDim2.new(0.55, -5, 1, 0)
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = Color3.fromRGB(180, 180, 180)
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.Font = Enum.Font.Gotham
    labelObj.TextSize = 14
    labelObj.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.45, -5, 1, -10)
    toggleBtn.Position = UDim2.new(0.55, 5, 0, 5)
    toggleBtn.BackgroundColor3 = defaultValue and lightConfig.color or Color3.fromRGB(35, 35, 35)
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = container

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleBtn

    local state = defaultValue
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBtn, TweenInfo.new(0.3), {
            BackgroundColor3 = state and lightConfig.color or Color3.fromRGB(35, 35, 35)
        }):Play()
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return container.Size.Y.Offset + 5, toggleBtn
end

local function createColorButton(colorData, parent, yOffset, xOffset, size)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, size, 0, size)
    btn.Position = UDim2.new(0, xOffset, 0, yOffset)
    btn.BackgroundColor3 = colorData.color
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(60, 60, 60)
    btnStroke.Thickness = 2
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        lightConfig.color = colorData.color
        updateLightAnimation()
        
        -- Mettre à jour les tabs actifs
        for i, tabBtn in ipairs(tabButtons) do
            if i == activeTab then
                TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = lightConfig.color}):Play()
            end
        end
        
        -- Mettre à jour la scrollbar
        ContentFrame.ScrollBarImageColor3 = lightConfig.color
        
        updateContent()
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255), Thickness = 3}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60), Thickness = 2}):Play()
    end)

    return btn
end

local function createModeButton(modeName, displayName, parent, yOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.Position = UDim2.new(0, 5, 0, yOffset)
    btn.BackgroundColor3 = lightConfig.mode == modeName and lightConfig.color or Color3.fromRGB(22, 22, 22)
    btn.Text = displayName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = lightConfig.color
    btnStroke.Thickness = lightConfig.mode == modeName and 2 or 1
    btnStroke.Transparency = lightConfig.mode == modeName and 0 or 0.7
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        lightConfig.mode = modeName
        updateLightAnimation()
        updateContent()
    end)

    btn.MouseEnter:Connect(function()
        if lightConfig.mode ~= modeName then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if lightConfig.mode ~= modeName then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
        end
    end)

    return btn.Size.Y.Offset + 8
end

-- Helper functions for lock to empty
local function findPlayerPlot()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if plot:GetAttribute("Player") == LocalPlayer.Name then
                return plot
            end
        end
    end
    return workspace:FindFirstChild(LocalPlayer.Name .. "'s Plot")
end

local function getEmptyPodiumIndex()
    local plot = findPlayerPlot()
    if not plot then return nil end
    local podiumsFolder = plot:FindFirstChild("AnimalPodiums")
    if not podiumsFolder then return nil end
    local playerChannel = Synchronizer:Get(LocalPlayer)
    if not playerChannel then return nil end
    local animalList = playerChannel:Get("AnimalPodiums") or {}
    for _, podiumPart in ipairs(podiumsFolder:GetChildren()) do
        local index = tonumber(podiumPart.Name)
        if index then
            local data = animalList[index]
            if data == nil or data == "Empty" then
                return index
            end
        end
    end
    return nil
end

-- Configuration
local config = {
    podiumIndex = 1,
    autoIncrement = true,
    lockToEmpty = false,
    autoDupe = false,
    instantInteract = false,
}
local inputRefs = {}

local autoDupeRunning = false
local autoDupeThread = nil
local instantInteractConnection = nil

local function getRemote(name, isFunction)
    local prefix = isFunction and "RF/" or "RE/"
    return ReplicatedStorage:FindFirstChild("Packages")
        and ReplicatedStorage.Packages:FindFirstChild("Net")
        and ReplicatedStorage.Packages.Net:FindFirstChild(prefix .. name)
end

local function applyLockState()
    if not inputRefs.podium or not inputRefs.lockToggle then return end
    if config.lockToEmpty then
        inputRefs.podium.ReadOnly = true
        TweenService:Create(inputRefs.podium, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        inputRefs.lockToggle.Text = "ON"
        TweenService:Create(inputRefs.lockToggle, TweenInfo.new(0.2), {BackgroundColor3 = lightConfig.color}):Play()
    else
        inputRefs.podium.ReadOnly = false
        TweenService:Create(inputRefs.podium, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
        inputRefs.lockToggle.Text = "OFF"
        TweenService:Create(inputRefs.lockToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
    end
end

local function dupe()
    local grabRemote = getRemote("StealService/Grab", false)
    if grabRemote then
        grabRemote:FireServer("Place", config.podiumIndex)

        if config.lockToEmpty then
            local nextEmpty = getEmptyPodiumIndex()
            if nextEmpty then
                config.podiumIndex = nextEmpty
                if inputRefs.podium then
                    inputRefs.podium.Text = tostring(nextEmpty)
                end
            end
        elseif config.autoIncrement then
            config.podiumIndex = config.podiumIndex + 1
            if inputRefs.podium then
                inputRefs.podium.Text = tostring(config.podiumIndex)
            end
        end
    end
end

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart", 5)
end

local HRP = getHRP()
local Humanoid = getCharacter():WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    HRP = newChar:WaitForChild("HumanoidRootPart", 5)
    Humanoid = newChar:WaitForChild("Humanoid")
end)

local function getPromptPart(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then return parent end
    if parent:IsA("Model") then
        return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
    end
    if parent:IsA("Attachment") then return parent.Parent end
    return parent:FindFirstChildWhichIsA("BasePart", true)
end

local function hasLineOfSight(from, toPart)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, toPart}
    local direction = toPart.Position - from
    local result = workspace:Raycast(from, direction, raycastParams)
    return result == nil
end

local function findValidStealPrompt()
    local nearestPrompt = nil
    local minDist = math.huge
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end

    for _, desc in pairs(plots:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Enabled and desc.ActionText == "Steal" then
            local part = getPromptPart(desc)
            if part then
                local dist = (HRP.Position - part.Position).Magnitude
                if dist <= MAX_DISTANCE and dist < minDist then
                    if hasLineOfSight(HRP.Position, part) then
                        minDist = dist
                        nearestPrompt = desc
                    end
                end
            end
        end
    end
    return nearestPrompt
end

local function triggerPrompt(prompt)
    if not prompt or not prompt:IsDescendantOf(workspace) then return end

    prompt.MaxActivationDistance = 9e9
    prompt.RequiresLineOfSight = false
    prompt.ClickablePrompt = true

    local usedFire = pcall(function()
        fireproximityprompt(prompt, 9e9, HOLD_DURATION)
    end)

    if not usedFire then
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(HOLD_DURATION)
            prompt:InputHoldEnd()
        end)
    end
end

local function startAutoDupe()
    if autoDupeRunning then return end
    autoDupeRunning = true
    autoDupeThread = task.spawn(function()
        while autoDupeRunning do
            local prompt = findValidStealPrompt()
            if prompt then
                triggerPrompt(prompt)
                task.wait(HOLD_DURATION)
                dupe()
            end
            task.wait(STEAL_COOLDOWN)
        end
    end)
end

local function stopAutoDupe()
    autoDupeRunning = false
    if autoDupeThread then
        task.cancel(autoDupeThread)
        autoDupeThread = nil
    end
end

local function setInstantInteract(enabled)
    if enabled then
        if not instantInteractConnection then
            instantInteractConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, player)
                if player == LocalPlayer then
                    fireproximityprompt(prompt)
                end
            end)
        end
    else
        if instantInteractConnection then
            instantInteractConnection:Disconnect()
            instantInteractConnection = nil
        end
    end
end

function updateContent()
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    inputRefs = {}

    local yOffset = 0

    if activeTab == 1 then -- EXPLOITS
        yOffset = yOffset + createSection("DUPLICATION", ContentFrame, yOffset)
        yOffset = yOffset + createButton("DUPE", dupe, ContentFrame, yOffset)
        
        local _, autoDupeToggle = createToggle("Auto Dupe", config.autoDupe, function(newState)
            config.autoDupe = newState
            if newState then
                startAutoDupe()
            else
                stopAutoDupe()
            end
        end, ContentFrame, yOffset)
        inputRefs.autoDupeToggle = autoDupeToggle
        yOffset = yOffset + _
        
    elseif activeTab == 2 then -- SETTINGS
        yOffset = yOffset + createSection("CONFIGURATION", ContentFrame, yOffset)

        local _, podiumInput = createInput("Podium Index", config.podiumIndex, ContentFrame, yOffset)
        inputRefs.podium = podiumInput
        yOffset = yOffset + _

        local _, autoToggle = createToggle("Auto Increment", config.autoIncrement, function(newState)
            config.autoIncrement = newState
        end, ContentFrame, yOffset)
        inputRefs.autoToggle = autoToggle
        yOffset = yOffset + _

        local _, lockToggle = createToggle("Lock to Empty", config.lockToEmpty, function(newState)
            if newState then
                local emptyIndex = getEmptyPodiumIndex()
                if emptyIndex then
                    config.podiumIndex = emptyIndex
                    if inputRefs.podium then
                        inputRefs.podium.Text = tostring(emptyIndex)
                    end
                    config.lockToEmpty = true
                else
                    config.lockToEmpty = false
                    if inputRefs.lockToggle then
                        inputRefs.lockToggle.Text = "OFF"
                        TweenService:Create(inputRefs.lockToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                    end
                    return
                end
            else
                config.lockToEmpty = false
            end
            applyLockState()
        end, ContentFrame, yOffset)
        inputRefs.lockToggle = lockToggle
        yOffset = yOffset + _

        local _, instantToggle = createToggle("Instant Interact", config.instantInteract, function(newState)
            config.instantInteract = newState
            setInstantInteract(newState)
        end, ContentFrame, yOffset)
        inputRefs.instantToggle = instantToggle
        yOffset = yOffset + _

        podiumInput:GetPropertyChangedSignal("Text"):Connect(function()
            if not config.lockToEmpty then
                config.podiumIndex = tonumber(podiumInput.Text) or 1
            end
        end)

        applyLockState()
        
    elseif activeTab == 3 then -- LIGHT
        yOffset = yOffset + createSection("COLOR SELECTION", ContentFrame, yOffset)
        
        -- Grille de couleurs
        local colorContainer = Instance.new("Frame")
        colorContainer.Size = UDim2.new(1, -10, 0, 90)
        colorContainer.Position = UDim2.new(0, 5, 0, yOffset)
        colorContainer.BackgroundTransparency = 1
        colorContainer.Parent = ContentFrame
        
        local buttonSize = 50
        local spacing = 8
        local buttonsPerRow = 5
        
        for i, colorData in ipairs(colorOptions) do
            local row = math.floor((i - 1) / buttonsPerRow)
            local col = (i - 1) % buttonsPerRow
            local xPos = col * (buttonSize + spacing)
            local yPos = row * (buttonSize + spacing)
            createColorButton(colorData, colorContainer, yPos, xPos, buttonSize)
        end
        
        yOffset = yOffset + 95
        
        yOffset = yOffset + createSection("LIGHT MODE", ContentFrame, yOffset)
        
        yOffset = yOffset + createModeButton("normal", "⚡ NORMAL", ContentFrame, yOffset)
        yOffset = yOffset + createModeButton("bright", "☀️ BRIGHT", ContentFrame, yOffset)
        yOffset = yOffset + createModeButton("neon", "💡 NEON", ContentFrame, yOffset)
        
        yOffset = yOffset + 5
        
        -- Toggle lumière on/off
        local _, lightToggle = createToggle("Light Effects", lightConfig.enabled, function(newState)
            lightConfig.enabled = newState
            updateLightAnimation()
        end, ContentFrame, yOffset)
        yOffset = yOffset + _
    end

    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
end

updateContent()

ScreenGui.Destroying:Connect(function()
    stopAutoDupe()
    if instantInteractConnection then
        instantInteractConnection:Disconnect()
        instantInteractConnection = nil
    end
    if lightAnimationConnection then
        lightAnimationConnection:Disconnect()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
]]

    MainBtn.MouseButton1Click:Connect(function()
        LoaderGui:Destroy()
        loadstring(mainScript)()
    end)
end
