-- // GLOBAL SCANNER SANS TELEPORTATION \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- ===== CONFIGURATION =====
local PLACE_ID = game.PlaceId
local SCAN_INTERVAL = 60
local MAX_SERVERS = 50

-- ===== REMOTES =====
-- Essaie de trouver un RemoteEvent qui peut donner des infos sur d'autres serveurs
local function findInfoRemote()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            if name:find("server") or name:find("info") or name:find("list") then
                print("🔍 Remote trouvé: " .. obj:GetFullName())
                return obj
            end
        end
    end
    return nil
end

local InfoRemote = findInfoRemote()

-- ===== SCAN VIA API =====
local function getServerList()
    local servers = {}
    local cursor = nil
    
    for page = 1, 3 do
        local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?limit=100"
        if cursor then url = url .. "&cursor=" .. cursor end
        
        local success, result = pcall(function()
            return HttpService:GetAsync(url)
        end)
        
        if success then
            local data = HttpService:JSONDecode(result)
            for _, s in ipairs(data.data or {}) do
                table.insert(servers, s.id)
            end
            cursor = data.nextPageCursor
        end
        
        if not cursor then break end
        task.wait(0.5)
    end
    
    return servers
end

-- ===== TENTATIVE D'ENVOI DE REQUÊTE À UN AUTRE SERVEUR =====
local function probeServer(jobId)
    print("🔍 Test du serveur: " .. jobId:sub(1, 8) .. "...")
    
    -- Méthode 1: Via TeleportService (sans se téléporter)
    -- Certains jeux ont un système de "preview" de serveur
    
    -- Méthode 2: Via un RemoteEvent qui accepte un JobId
    if InfoRemote then
        -- Essaie d'appeler le remote avec le JobId
        local success, result = pcall(function()
            if InfoRemote:IsA("RemoteFunction") then
                return InfoRemote:InvokeServer(jobId)
            else
                InfoRemote:FireServer(jobId)
                return nil
            end
        end)
        
        if success and result then
            print("   ✅ Réponse reçue: " .. tostring(result))
            return result
        end
    end
    
    print("   ❌ Aucune réponse")
    return nil
end

-- ===== SCAN GLOBAL =====
local function globalScan()
    print("🌐 Récupération de la liste des serveurs...")
    local servers = getServerList()
    print("📊 " .. #servers .. " serveurs trouvés")
    
    local scanned = 0
    for _, jobId in ipairs(servers) do
        if scanned >= MAX_SERVERS then break end
        
        local info = probeServer(jobId)
        if info then
            print("   📡 Infos: " .. HttpService:JSONEncode(info))
        end
        
        scanned = scanned + 1
        task.wait(0.2)  -- Petit délai pour éviter de spammer
    end
    
    print("✅ Scan terminé: " .. scanned .. " serveurs testés")
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlobalScanner"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 200, 0, 40)
Button.Position = UDim2.new(0.5, -100, 0.5, -20)
Button.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
Button.Text = "🌍 SCAN GLOBAL"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.Parent = ScreenGui

Button.MouseButton1Click:Connect(globalScan)

print("✅ Global Scanner prêt !")
print("🔍 Recherche de RemoteEvents...")

if InfoRemote then
    print("   ✅ Remote trouvé: " .. InfoRemote.Name)
else
    print("   ❌ Aucun Remote de serveur trouvé")
    print("   📝 Liste des Remotes disponibles:")
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("      - " .. obj:GetFullName())
        end
    end
end
