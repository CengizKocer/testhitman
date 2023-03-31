
QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local QBCore = exports['qb-core']:GetCoreObject()

local pedCoords = vector3(-32.62, -1088.47, 26.42)

Citizen.CreateThread(function()
    RequestModel("a_m_y_business_03")
    while not HasModelLoaded("a_m_y_business_03") do
        Citizen.Wait(0)
    end
    local ped = CreatePed(4, "a_m_y_business_03", pedCoords.x, pedCoords.y, pedCoords.z - 1.0, 0.0, true, false)
    SetEntityHeading(ped, 301.13)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
end)

Citizen.CreateThread(function()
    local hash = GetHashKey('a_m_y_business_03')
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Citizen.Wait(10)
    end
    local ped = CreatePed(5, hash, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 1.0, Config.PedCoords.h, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, Config.PedCoords.h)
end)


AddEventHandler('playerSpawned', function(spawn)
    TriggerClientEvent('qb-hitman:client:spawned')
end)

RegisterServerEvent('qb-hitman:server:checkForHit')
AddEventHandler('qb-hitman:server:checkForHit', function()
    local src = source
    local ped = GetClosestPed(pedCoords.x, pedCoords.y, pedCoords.z, 1.0, 0, 71)
    if ped ~= nil and ped ~= 0 then
        local playerPed = GetPlayerPed(src)
        local distance = #(GetEntityCoords(ped) - GetEntityCoords(playerPed))
        if distance <= 2.0 then
            TriggerClientEvent('qb-hitman:client:openMenu', src)
        end
    end
end)
