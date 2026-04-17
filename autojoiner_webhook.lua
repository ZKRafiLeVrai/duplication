-- // EXPORT DES REMOTES EN JSON \\
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

print("═══════════════════════════════")
print("🔍 SCAN DE TOUS LES REMOTES")
print("═══════════════════════════════")

local remotes = {
    RemoteEvents = {},
    RemoteFunctions = {}
}

-- Parcourir tout ReplicatedStorage
for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        table.insert(remotes.RemoteEvents, {
            Name = obj.Name,
            Path = obj:GetFullName(),
            Parent = obj.Parent and obj.Parent.Name or "nil"
        })
    elseif obj:IsA("RemoteFunction") then
        table.insert(remotes.RemoteFunctions, {
            Name = obj.Name,
            Path = obj:GetFullName(),
            Parent = obj.Parent and obj.Parent.Name or "nil"
        })
    end
end

-- Trier par nom
table.sort(remotes.RemoteEvents, function(a, b) return a.Name < b.Name end)
table.sort(remotes.RemoteFunctions, function(a, b) return a.Name < b.Name end)

-- Afficher le résumé
print("\n📡 REMOTE EVENTS: " .. #remotes.RemoteEvents)
for i, remote in ipairs(remotes.RemoteEvents) do
    print("   " .. remote.Name)
    if i >= 10 then
        print("   ... et " .. (#remotes.RemoteEvents - 10) .. " autres")
        break
    end
end

print("\n📡 REMOTE FUNCTIONS: " .. #remotes.RemoteFunctions)
for i, remote in ipairs(remotes.RemoteFunctions) do
    print("   " .. remote.Name)
    if i >= 10 then
        print("   ... et " .. (#remotes.RemoteFunctions - 10) .. " autres")
        break
    end
end

-- Ajouter des infos utiles
local exportData = {
    PlaceId = game.PlaceId,
    PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    TotalRemoteEvents = #remotes.RemoteEvents,
    TotalRemoteFunctions = #remotes.RemoteFunctions,
    Remotes = remotes,
    ExportedAt = os.date("%Y-%m-%d %H:%M:%S")
}

-- Convertir en JSON
local jsonString = HttpService:JSONEncode(exportData)

-- Sauvegarder dans un fichier
local fileName = "remotes_export_" .. os.date("%Y%m%d_%H%M%S") .. ".json"
writefile(fileName, jsonString)

print("\n✅ Export terminé !")
print("📁 Fichier sauvegardé: " .. fileName)
print("📍 Emplacement: Dossier 'workspace' de Delta")

-- Afficher les 20 premiers RemoteEvents (pour debug)
print("\n📋 APERÇU DES 20 PREMIERS REMOTE EVENTS:")
for i = 1, math.min(20, #remotes.RemoteEvents) do
    local r = remotes.RemoteEvents[i]
    print("   " .. i .. ". " .. r.Name .. " -> " .. r.Path)
end

print("\n📋 APERÇU DES REMOTE FUNCTIONS:")
for i = 1, math.min(20, #remotes.RemoteFunctions) do
    local r = remotes.RemoteFunctions[i]
    print("   " .. i .. ". " .. r.Name .. " -> " .. r.Path)
end
