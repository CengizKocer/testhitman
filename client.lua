QBCore = nil
local QBCore = exports['qb-core']:GetCoreObject()


local hasHitmanJob = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distance = #(coords - Config.PedCoords)
        if distance <= 10.0 and not hasHitmanJob then
            DrawMarker(2, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 0.98, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 255, 0, 0, 200, 0, 0, 0, 0)
            if distance <= 2.0 then
                DrawText3D(Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z, "[E] Interact")
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('qb-hitman:server:checkForHit')
                end
            end
        end
    end
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


RegisterNetEvent('qb-hitman:client:spawned')
AddEventHandler('qb-hitman:client:spawned', function()
    local playerPed = PlayerPedId()
    RequestModel(Config.PedModel)
    while not HasModelLoaded(Config.PedModel) do
        Citizen.Wait(10)
    end
    ped = CreatePed(4, Config.PedModel, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 1, Config.PedHeading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
