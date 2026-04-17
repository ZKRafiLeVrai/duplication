-- // SCANNER DE MACHINE STOCK EVENT \\
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

local TOKEN = "a694d84f-7b1b-4cec-b21d-c831b291a0c0"
local machines = {"Taco4", "WorL", "WinterHour", "Taco5", "MainStock", "Taco6"}

print("🔍 SCAN DES MACHINES STOCK EVENT")
print("═══════════════════════════════")

for _, machineName in ipairs(machines) do
    print("\n📦 Machine: " .. machineName)
    
    local success, data = pcall(function()
        return ListItems:InvokeServer(TOKEN, machineName)
    end)
    
    if success and data then
        print("   ✅ Données reçues !")
        
        for itemName, itemData in pairs(data) do
            print("   🎁 " .. itemName)
            if itemData.Inputs then
                print("      Requiert: " .. table.concat(itemData.Inputs, ", "))
            end
            if itemData.Output then
                print("      Output: " .. itemData.Output)
            end
        end
    else
        print("   ❌ Échec ou pas de données")
    end
    
    task.wait(0.3)
end

print("\n✅ Scan terminé !")
