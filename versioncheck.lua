CreateThread(function()
    local currentVersion = "1.0.0"
    local resourceName = GetCurrentResourceName()
    local githubRawVersionURL = "https://raw.githubusercontent.com/Ducratif/esx_realweapons/refs/heads/main/version.txt" -- Modifie ton URL GitHub ici !

    print("^3["..resourceName.."]^7 - Le script est en cours de chargement... (version ^2" .. currentVersion .. "^7)")

    PerformHttpRequest(githubRawVersionURL, function(statusCode, response, headers)
        if statusCode == 200 then
            if response then
                local latestVersion = response:gsub("%s+", "")
                if latestVersion ~= currentVersion then
                    print("^1["..resourceName.."] - Une mise à jour est disponible ! (^0" .. latestVersion .. "^1). Vous utilisez la version (^0" .. currentVersion .. "^1)^7 https://github.com/Ducratif/esx_realweapons/releases")
                else
                    print("^2["..resourceName.."] - Ducratif | ^7 - Vous utilisez la dernière version du script.")
                end
            end
        else
            print("^1["..resourceName.."]^7 - Impossible de vérifier la dernière version. (Serveur GitHub indisponible ?) -> ^1https://github.com/Ducratif/esx_realweapons/releases")
        end
    end, "GET", "", {})
end)
