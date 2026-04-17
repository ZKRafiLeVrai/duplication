-- // TEST DE ListItems AVEC LES BONS PARAMÈTRES \\
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local function findRemote(name)
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and obj.Name == name then
            return obj
        end
    end
    return nil
end

local ListItems = findRemote("RF/StockEventService/ListItems")

if not ListItems then
    print("❌ ListItems introuvable")
    return
end

print("✅ ListItems trouvé")

-- Les machines disponibles dans le jeu (à deviner ou à trouver)
local machinesToTest = {
    "StockEvent",
    "CraftingMachine",
    "FuseMachine",
    "CupidsMachine",
    "ValentinesMachine",
    "DivineEvent",
    "Adminboard"
}

local TOKEN = "a694d84f-7b1b-4cec-b21d-c831b291a0c0"

for _, machineName in ipairs(machinesToTest) do
    print("\n🔍 Test de la machine: " .. machineName)
    
    local success, items = pcall(function()
        return ListItems:InvokeServer(TOKEN, machineName)
    end)
    
    if success then
        print("   ✅ Succès !")
        
        if items then
            print("   Type: " .. type(items))
            
            if type(items) == "table" then
                local count = 0
                for _ in pairs(items) do count = count + 1 end
                print("   📊 " .. count .. " éléments")
                
                -- Afficher les 5 premiers éléments
                local shown = 0
                for k, v in pairs(items) do
                    print("      " .. tostring(k) .. " = " .. tostring(v))
                    shown = shown + 1
                    if shown >= 5 then break end
                end
            else
                print("   📝 " .. tostring(items))
            end
        else
            print("   ⚠️ Réponse vide (nil)")
        end
    else
        print("   ❌ Erreur: " .. tostring(items))
    end
    
    task.wait(0.5)
end

print("\n✅ Tests terminés")
