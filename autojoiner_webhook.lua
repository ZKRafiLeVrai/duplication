-- // GLOBAL SCANNER AVEC REMOTEFUNCTION \\
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- ===== CONFIGURATION =====
local PLACE_ID = game.PlaceId
local MAX_SERVERS = 30  -- Nombre de serveurs à tester
local DELAY_BETWEEN = 0.3  -- Délai entre chaque requête

-- ===== REMOTE FUNCTION =====
local ListItemsRemote = ReplicatedStorage.Packages.Net:FindFirstChild("RF/StockEventsService/ListItems")

print("📡 ListItems RemoteFunction: " .. (ListItemsRemote and "✅ Trouvé" or "❌ Introuvable"))
if ListItemsRemote then
    print("   Type: " .. ListItemsRemote.ClassName)
end

-- ===== RÉCUPÉRATION DES SERVEURS =====
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
                if s.playing and s.playing > 0 then
                    table.insert(servers, {
                        id = s.id,
                        players = s.playing,
                        maxPlayers = s.maxPlayers
                    })
                end
            end
            cursor = data.nextPageCursor
        end
        
        if not cursor then break end
        task.wait(0.5)
    end
    
    -- Trier par nombre de joueurs (les plus remplis d'abord)
    table.sort(servers, function(a, b) return a.players > b.players end)
    return servers
end

-- ===== TEST D'UN SERVEUR =====
local function probeServer(jobId)
    if not ListItemsRemote then return nil end
    
    local results = {}
    
    -- Essayer différents paramètres possibles
    local testParams = {
        {serverJobId = jobId},
        {jobId = jobId},
        {job_id = jobId},
        {ServerId = jobId},
        jobId,
        {["jobId"] = jobId},
        {["serverId"] = jobId},
        {["placeId"] = PLACE_ID, ["jobId"] = jobId}
    }
    
    for _, params in ipairs(testParams) do
        local success, result = pcall(function()
            return ListItemsRemote:InvokeServer(params)
        end)
        
        if success and result then
            table.insert(results, {
                params = params,
                result = result
            })
        end
    end
    
    if #results > 0 then
        return results[1].result  -- Retourne le premier qui a marché
    end
    
    return nil
end

-- ===== ANALYSE DES RÉSULTATS =====
local function analyzeResult(result, serverInfo)
    if not result then return nil end
    
    print("   📦 Type de résultat: " .. type(result))
    
    if type(result) == "table" then
        -- Essayer de compter les éléments
        local count = 0
        for _ in pairs(result) do count = count + 1 end
        print("   📊 " .. count .. " éléments trouvés")
        
        -- Afficher les premières clés
        local keys = {}
        for k, v in pairs(result) do
            table.insert(keys, tostring(k))
            if #keys >= 5 then break end
        end
        print("   🔑 Clés: " .. table.concat(keys, ", "))
        
        -- Chercher des animaux
        local animals = {}
        for k, v in pairs(result) do
            if type(v) == "table" then
                -- Chercher un champ "name" ou "Index"
                if v.name or v.Index or v.Name then
                    local name = v.name or v.Index or v.Name
                    if type(name) == "string" and #name > 0 then
                        table.insert(animals, name)
                    end
                end
            elseif type(k) == "string" and type(v) == "string" then
                -- Peut-être une liste nom -> valeur
                table.insert(animals, k .. " = " .. v)
            end
        end
        
        if #animals > 0 then
            print("   🐾 Animaux trouvés:")
            for i, name in ipairs(animals) do
                print("      " .. i .. ". " .. name)
                if i >= 5 then break end
            end
            return animals
        end
    elseif type(result) == "string" then
        print("   📝 Résultat texte: " .. result:sub(1, 100) .. (result:len() > 100 and "..." or ""))
    end
    
    return nil
end

-- ===== SCAN GLOBAL =====
local function globalScan()
    print("\n🌐 Récupération de la liste des serveurs...")
    local servers = getServerList()
    print("📊 " .. #servers .. " serveurs avec joueurs trouvés")
    
    local scanned = 0
    local successfulProbes = 0
    local allAnimals = {}
    
    for _, server in ipairs(servers) do
        if scanned >= MAX_SERVERS then break end
        
        scanned = scanned + 1
        print("\n📍 Serveur " .. scanned .. "/" .. math.min(#servers, MAX_SERVERS))
        print("   👥 " .. server.players .. "/" .. server.maxPlayers .. " joueurs")
        print("   🔍 Test du JobId: " .. server.id:sub(1, 8) .. "...")
        
        local result = probeServer(server.id)
        
        if result then
            successfulProbes = successfulProbes + 1
            local animals = analyzeResult(result, server)
            if animals then
                for _, animal in ipairs(animals) do
                    table.insert(allAnimals, {
                        server = server,
                        animal = animal
                    })
                end
            end
        else
            print("   ❌ Aucune réponse")
        end
        
        task.wait(DELAY_BETWEEN)
    end
    
    print("\n═══════════════════════════════")
    print("✅ Scan terminé !")
    print("📊 " .. scanned .. " serveurs testés")
    print("📡 " .. successfulProbes .. " réponses reçues")
    print("🐾 " .. #allAnimals .. " animaux trouvés")
    
    if #allAnimals > 0 then
        print("\n🏆 TOP DES ANIMAUX:")
        for i = 1, math.min(10, #allAnimals) do
            local item = allAnimals[i]
            print("   " .. i .. ". " .. tostring(item.animal) .. " (Serveur: " .. item.server.players .. " joueurs)")
        end
    end
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlobalScanner"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 220, 0, 40)
Button.Position = UDim2.new(0.5, -110, 0.5, -20)
Button.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
Button.Text = "🌍 SCAN GLOBAL"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.Parent = ScreenGui

Button.MouseButton1Click:Connect(globalScan)

print("✅ Global Scanner prêt !")
print("📡 RemoteFunction: " .. (ListItemsRemote and ListItemsRemote:GetFullName() or "INTROUVABLE"))
