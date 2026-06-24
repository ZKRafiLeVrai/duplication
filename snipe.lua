-- ============================================
-- DEVCORP DUPLICATIONS v1 By Nerdify
-- LOADER + DUPE INTÉGRÉ (Proxy Google, UserId)
-- ============================================

local PROXY_URL = "https://script.google.com/macros/s/AKfycbzSiShyDdajCKcD5XR7pLFYKaM9-QGQQcydj1oZeuDe0FHOq0_rolU0wWndBx0HBKzG/exec"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players.LocalPlayerAdded:Wait()

local function getUserId()
    return tostring(LocalPlayer.UserId)
end

-- Interface
local LicenseGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", LicenseGui)
Frame.Size = UDim2.new(0, 300, 0, 180)
Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Text = "DEVCORP - Entrez votre clé"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.new(0, 20, 0, 50)
KeyBox.PlaceholderText = "DC-XXXX"
KeyBox.Text = ""
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 20, 0, 100)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(255, 100, 100)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(1, -40, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 130)
Button.Text = "ACTIVER & LANCER"
Button.BackgroundColor3 = Color3.fromRGB(35, 134, 58)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

-- Vérification licence (GET via proxy)
local function checkLicense(key, userId)
    local fullUrl = PROXY_URL .. "?license_key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(userId)
    local success, result = pcall(function()
        if syn and syn.request then
            local res = syn.request({ Url = fullUrl, Method = "GET" })
            return res.Body
        elseif request then
            local res = request({ Url = fullUrl, Method = "GET" })
            return res.Body
        else
            return game:HttpGet(fullUrl)
        end
    end)
    if not success or not result then
        return false, "❌ Erreur réseau / exécuteur"
    end
    return true, result
end

-- Le Dupe intégré
local dupeScript = [[
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
ScreenGui.Name = "DevcorpDupeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Configuration lumière
local lightConfig = {
    color = Color3.fromRGB(35, 134, 58),
    mode = "neon",
    enabled = true,
    speed = 2
}

local colorOptions = {
    {name = "Devcorp Green", color = Color3.fromRGB(35, 134, 58)},
    {name = "Ocean Blue", color = Color3.fromRGB(50, 150, 250)},
    {name = "Crimson Red", color = Color3.fromRGB(255, 50, 50)},
    {name = "Neon Green", color = Color3.fromRGB(50, 255, 100)},
    {name = "Royal Purple", color = Color3.fromRGB(180, 50, 255)},
    {name = "Electric Orange", color = Color3.fromRGB(255, 150, 50)},
    {name = "Cyan", color = Color3.fromRGB(50, 255, 255)},
    {name = "Hot Pink", color = Color3.fromRGB(255, 100, 200)},
    {name = "Gold", color = Color3.fromRGB(255, 215, 0)},
    {name = "Pure White", color = Color3.fromRGB(255, 255, 255)},
}

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

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 300)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 23)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 14)

local glowStrokes = {}
local function createGlowStroke(parent, thickness, transparency)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = lightConfig.color
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    return stroke
end

local mainStroke = createGlowStroke(MainFrame, 2, 0.3)
table.insert(glowStrokes, mainStroke)

local glowFrame1 = Instance.new("Frame")
glowFrame1.Size = UDim2.new(1, 4, 1, 4)
glowFrame1.Position = UDim2.new(0, -2, 0, -2)
glowFrame1.BackgroundTransparency = 1
glowFrame1.ZIndex = 0
glowFrame1.Parent = MainFrame
local glowCorner1 = Instance.new("UICorner", glowFrame1)
glowCorner1.CornerRadius = UDim.new(0, 16)
local glowStroke1 = createGlowStroke(glowFrame1, 3, 0.6)
table.insert(glowStrokes, glowStroke1)

local glowFrame2 = Instance.new("Frame")
glowFrame2.Size = UDim2.new(1, 8, 1, 8)
glowFrame2.Position = UDim2.new(0, -4, 0, -4)
glowFrame2.BackgroundTransparency = 1
glowFrame2.ZIndex = 0
glowFrame2.Parent = MainFrame
local glowCorner2 = Instance.new("UICorner", glowFrame2)
glowCorner2.CornerRadius = UDim.new(0, 18)
local glowStroke2 = createGlowStroke(glowFrame2, 4, 0.8)
table.insert(glowStrokes, glowStroke2)

local lightAnimationConnection = nil

local function updateLightAnimation()
    if lightAnimationConnection then lightAnimationConnection:Disconnect() end
    if not lightConfig.enabled then
        for _, stroke in ipairs(glowStrokes) do stroke.Transparency = 1 end
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
                local colorShift = math.sin(time * 0.5) * 0.05
                stroke.Transparency = math.clamp(0.1 + fastPulse, 0, 0.6)
                stroke.Thickness = 4 + (i - 1) * 2 + math.abs(math.sin(time * 3 + pulseOffset)) * 2
                local h, s, v = lightConfig.color:ToHSV()
                stroke.Color = Color3.fromHSV((h + colorShift) % 1, s, math.clamp(v + math.sin(time * 3) * 0.2, 0.5, 1))
            end
        end
    end)
end
updateLightAnimation()

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 14)

local TitleCover = Instance.new("Frame")
TitleCover.Size = UDim2.new(1, 0, 0, 14)
TitleCover.Position = UDim2.new(0, 0, 1, -14)
TitleCover.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
TitleCover.BorderSizePixel = 0
TitleCover.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "DEVCORP DUPLICATIONS v1"
TitleText.TextColor3 = Color3.fromRGB(220, 220, 220)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 15
TitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 36, 0, 36)
CloseButton.Position = UDim2.new(1, -36, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    if lightAnimationConnection then lightAnimationConnection:Disconnect() end
    ScreenGui:Destroy()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
end)

-- Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -12, 0, 34)
TabContainer.Position = UDim2.new(0, 6, 0, 42)
TabContainer.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabCorner = Instance.new("UICorner", TabContainer)
TabCorner.CornerRadius = UDim.new(0, 8)

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -12, 1, -84)
ContentFrame.Position = UDim2.new(0, 6, 0, 80)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = lightConfig.color
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame

local tabs = {"⚡ EXPLOITS", "⚙️ CONFIG", "🎨 LIGHT"}
local activeTab = 1
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#tabs, -3, 1, -6)
    btn.Position = UDim2.new((i-1)/#tabs, 2, 0, 3)
    btn.Text = tabName
    btn.BackgroundColor3 = i == 1 and lightConfig.color or Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = TabContainer

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for j, b in ipairs(tabButtons) do
            TweenService:Create(b, TweenInfo.new(0.3), {
                BackgroundColor3 = j == i and lightConfig.color or Color3.fromRGB(35, 35, 35),
                TextColor3 = j == i and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            }):Play()
        end
        activeTab = i
        updateContent()
    end)

    table.insert(tabButtons, btn)
end

-- Helper functions
local function createSection(title, parent, yOffset)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 26)
    section.Position = UDim2.new(0, 5, 0, yOffset)
    section.BackgroundTransparency = 1
    section.Parent = parent
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = lightConfig.color
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    return section.Size.Y.Offset + 5
end

local function createButton(text, callback, parent, yOffset, customColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, yOffset)
    btn.Text = text
    btn.BackgroundColor3 = customColor or Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = text == "DUPE" and 18 or 14
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = lightConfig.color
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.7
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = customColor or Color3.fromRGB(30, 30, 30)}):Play()
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
    local labelObj = Instance.new("TextLabel", container)
    labelObj.Size = UDim2.new(0.45, -5, 1, 0)
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = Color3.fromRGB(180, 180, 180)
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.Font = Enum.Font.Gotham
    labelObj.TextSize = 13
    local input = Instance.new("TextBox", container)
    input.Size = UDim2.new(0.55, 0, 1, -8)
    input.Position = UDim2.new(0.45, 0, 0, 4)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Text = tostring(defaultValue)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.BorderSizePixel = 0
    local inputCorner = Instance.new("UICorner", input)
    inputCorner.CornerRadius = UDim.new(0, 6)
    local inputStroke = Instance.new("UIStroke", input)
    inputStroke.Color = lightConfig.color
    inputStroke.Thickness = 1
    inputStroke.Transparency = 0.8
    return container.Size.Y.Offset + 5, input
end

local function createToggle(label, defaultValue, callback, parent, yOffset)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 42)
    container.Position = UDim2.new(0, 5, 0, yOffset)
    container.BackgroundTransparency = 1
    container.Parent = parent
    local labelObj = Instance.new("TextLabel", container)
    labelObj.Size = UDim2.new(0.55, -5, 1, 0)
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = Color3.fromRGB(180, 180, 180)
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.Font = Enum.Font.Gotham
    labelObj.TextSize = 13
    local toggleBtn = Instance.new("TextButton", container)
    toggleBtn.Size = UDim2.new(0.45, -5, 1, -8)
    toggleBtn.Position = UDim2.new(0.55, 5, 0, 4)
    toggleBtn.BackgroundColor3 = defaultValue and lightConfig.color or Color3.fromRGB(35, 35, 35)
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.BorderSizePixel = 0
    local toggleCorner = Instance.new("UICorner", toggleBtn)
    toggleCorner.CornerRadius = UDim.new(0, 6)
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

local function findPlayerPlot()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if plot:GetAttribute("Player") == LocalPlayer.Name then return plot end
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
            if data == nil or data == "Empty" then return index end
        end
    end
    return nil
end

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
                if inputRefs.podium then inputRefs.podium.Text = tostring(nextEmpty) end
            end
        elseif config.autoIncrement then
            config.podiumIndex = config.podiumIndex + 1
            if inputRefs.podium then inputRefs.podium.Text = tostring(config.podiumIndex) end
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
    if autoDupeThread then task.cancel(autoDupeThread) autoDupeThread = nil end
end

local function setInstantInteract(enabled)
    if enabled then
        if not instantInteractConnection then
            instantInteractConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, player)
                if player == LocalPlayer then fireproximityprompt(prompt) end
            end)
        end
    else
        if instantInteractConnection then instantInteractConnection:Disconnect() instantInteractConnection = nil end
    end
end

function updateContent()
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
    end
    inputRefs = {}
    local yOffset = 0
    if activeTab == 1 then
        yOffset = yOffset + createSection("DUPLICATION", ContentFrame, yOffset)
        yOffset = yOffset + createButton("DUPE", dupe, ContentFrame, yOffset)
        local _, autoDupeToggle = createToggle("Auto Dupe", config.autoDupe, function(newState)
            config.autoDupe = newState
            if newState then startAutoDupe() else stopAutoDupe() end
        end, ContentFrame, yOffset)
        inputRefs.autoDupeToggle = autoDupeToggle
        yOffset = yOffset + _
    elseif activeTab == 2 then
        yOffset = yOffset + createSection("CONFIGURATION", ContentFrame, yOffset)
        local _, podiumInput = createInput("Podium Index", config.podiumIndex, ContentFrame, yOffset)
        inputRefs.podium = podiumInput
        yOffset = yOffset + _
        local _, autoToggle = createToggle("Auto Increment", config.autoIncrement, function(newState) config.autoIncrement = newState end, ContentFrame, yOffset)
        inputRefs.autoToggle = autoToggle
        yOffset = yOffset + _
        local _, lockToggle = createToggle("Lock to Empty", config.lockToEmpty, function(newState)
            if newState then
                local emptyIndex = getEmptyPodiumIndex()
                if emptyIndex then
                    config.podiumIndex = emptyIndex
                    if inputRefs.podium then inputRefs.podium.Text = tostring(emptyIndex) end
                    config.lockToEmpty = true
                else
                    config.lockToEmpty = false
                    if inputRefs.lockToggle then inputRefs.lockToggle.Text = "OFF" end
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
            if not config.lockToEmpty then config.podiumIndex = tonumber(podiumInput.Text) or 1 end
        end)
        applyLockState()
    elseif activeTab == 3 then
        yOffset = yOffset + createSection("COLOR SELECTION", ContentFrame, yOffset)
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
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
            btn.Position = UDim2.new(0, xPos, 0, yPos)
            btn.BackgroundColor3 = colorData.color
            btn.Text = ""
            btn.BorderSizePixel = 0
            btn.Parent = colorContainer
            local btnCorner = Instance.new("UICorner", btn) btnCorner.CornerRadius = UDim.new(0, 6)
            local btnStroke = Instance.new("UIStroke", btn) btnStroke.Color = Color3.fromRGB(60, 60, 60) btnStroke.Thickness = 2
            btn.MouseButton1Click:Connect(function()
                lightConfig.color = colorData.color
                updateLightAnimation()
                for i, tabBtn in ipairs(tabButtons) do
                    if i == activeTab then TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = lightConfig.color}):Play() end
                end
                ContentFrame.ScrollBarImageColor3 = lightConfig.color
                updateContent()
            end)
        end
        yOffset = yOffset + 95
        yOffset = yOffset + createSection("LIGHT MODE", ContentFrame, yOffset)
        for _, modeData in ipairs({{"normal", "⚡ NORMAL"}, {"bright", "☀️ BRIGHT"}, {"neon", "💡 NEON"}}) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 45)
            btn.Position = UDim2.new(0, 5, 0, yOffset)
            btn.BackgroundColor3 = lightConfig.mode == modeData[1] and lightConfig.color or Color3.fromRGB(22, 22, 22)
            btn.Text = modeData[2]
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.BorderSizePixel = 0
            btn.Parent = ContentFrame
            local btnCorner = Instance.new("UICorner", btn) btnCorner.CornerRadius = UDim.new(0, 8)
            local btnStroke = Instance.new("UIStroke", btn)
            btnStroke.Color = lightConfig.color
            btnStroke.Thickness = lightConfig.mode == modeData[1] and 2 or 1
            btnStroke.Transparency = lightConfig.mode == modeData[1] and 0 or 0.7
            btn.MouseButton1Click:Connect(function()
                lightConfig.mode = modeData[1]
                updateLightAnimation()
                updateContent()
            end)
            yOffset = yOffset + btn.Size.Y.Offset + 8
        end
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
    if instantInteractConnection then instantInteractConnection:Disconnect() end
    if lightAnimationConnection then lightAnimationConnection:Disconnect() end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("✅ Devcorp Duplications v1 - Chargé avec succès !")
]]

-- Bouton d'activation
Button.MouseButton1Click:Connect(function()
    local key = string.gsub(KeyBox.Text, "%s+", "")
    if #key < 3 then Status.Text = "❌ Clé trop courte"; return end
    Status.Text = "⏳ Vérification..."
    Button.Interactable = false

    local ok, response = checkLicense(key, getUserId())
    if not ok then
        Status.Text = response
        Button.Interactable = true
        return
    end

    local decoded = HttpService:JSONDecode(response)
    if decoded.status == "success" then
        Status.Text = "✅ " .. (decoded.message or "OK !")
        task.wait(0.5)
        LicenseGui:Destroy()
        loadstring(dupeScript)()
    else
        Status.Text = "❌ " .. (decoded.message or "Clé invalide")
        Button.Interactable = true
    end
end)
