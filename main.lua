local ESX
local ox_inventory = exports.ox_inventory

CreateThread(function()
    while not ESX do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local attachedWeapons = {}

local function SetGear(weaponData)
    local ped = PlayerPedId()
    if attachedWeapons[weaponData.name] then return end

    ESX.Game.SpawnObject(weaponData.model, { x = 0, y = 0, z = 0 }, function(object)
        AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, weaponData.bone),
            weaponData.x, weaponData.y, weaponData.z,
            weaponData.xRot, weaponData.yRot, weaponData.zRot,
            true, true, false, true, 1, true)
        attachedWeapons[weaponData.name] = object
    end)
end

local function RemoveAllGears()
    for weaponName, object in pairs(attachedWeapons) do
        if DoesEntityExist(object) then
            DeleteEntity(object)
        end
    end
    attachedWeapons = {}
end

local function UpdateWeapons()
    local ped = PlayerPedId()
    local items = ox_inventory:Search('slots', 'weapon')

    -- Clear old attached weapons
    RemoveAllGears()

    -- Attach weapons except the one equipped
    local currentWeaponHash = GetSelectedPedWeapon(ped)

    for _, weaponData in pairs(Config.RealWeapons) do
        local hasWeapon = false

        for _, item in pairs(items) do
            if item.name:upper() == weaponData.name then
                hasWeapon = true
                break
            end
        end

        if hasWeapon then
            if GetHashKey(weaponData.name) ~= currentWeaponHash then
                SetGear(weaponData)
            end
        end
    end
end

CreateThread(function()
    local lastWeapon = GetSelectedPedWeapon(PlayerPedId())

    while true do
        Wait(500)
        local ped = PlayerPedId()
        local currentWeapon = GetSelectedPedWeapon(ped)

        if lastWeapon ~= currentWeapon then
            lastWeapon = currentWeapon
            UpdateWeapons()
        end
    end
end)

AddEventHandler('esx:playerLoaded', function()
    Citizen.Wait(3000)  -- Attente de 3 secondes de manière propre
    if IsPlayerLoaded() then  -- Vérifie si le joueur est bien chargé avant de lancer la fonction
        UpdateWeapons()
    end
end)

