-- // TEST DE ListItems AVEC DIFFÉRENTS PARAMÈTRES \\
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local ListItems = ReplicatedStorage.Packages.Net:FindFirstChild("RF/StockEventService/ListItems")

if not ListItems then
    print("❌ ListItems introuvable")
    return
end

print("✅ ListItems trouvé: " .. ListItems:GetFullName())
print("   Type: " .. ListItems.ClassName)

-- Tester différents paramètres
local testParams = {
    nil,
    {},
    {type = "animals"},
    {type = "brainrots"},
    {type = "all"},
    {serverJobId = game.JobId},
    {jobId = game.JobId},
    game.JobId,
    "list",
    {action = "list"}
}

for i, params in ipairs(testParams) do
    print("\n🔍 Test " .. i .. ": " .. HttpService:JSONEncode(params))
    
    local success, result = pcall(function()
        if params then
            return ListItems:InvokeServer(params)
        else
            return ListItems:InvokeServer()
        end
    end)
    
    if success then
        print("   ✅ Succès !")
        print("   Type de résultat: " .. type(result))
        
        if type(result) == "table" then
            local count = 0
            for _ in pairs(result) do count = count + 1 end
            print("   📊 " .. count .. " éléments")
            
            -- Afficher les premières clés
            local keys = {}
            for k, v in pairs(result) do
                table.insert(keys, tostring(k))
                if #keys >= 5 then break end
            end
            print("   🔑 Clés: " .. table.concat(keys, ", "))
        elseif type(result) == "string" then
            print("   📝 " .. result:sub(1, 100))
        end
    else
        print("   ❌ Échec: " .. tostring(result))
    end
    
    task.wait(0.5)
end
