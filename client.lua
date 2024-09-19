local HRLib <const>, Translation <const> = HRLib --[[@as HRLibClientFunctions]], Translation --[[@as HRExtraCommandsTranslation]]
local config <const> = HRLib.require('@HRExtraCommands/config.lua') --[[@as HRExtraCommandsConfig]]

-- Events

RegisterNetEvent('ExtraCommands:heal', function(targetId, health)
    local targetPed <const> = GetPlayerPed(GetPlayerFromServerId(targetId))
    health = health or IsPedMale(targetPed) and 200 or 100

    SetEntityHealth(targetPed, health)
end)

RegisterNetEvent('ExtraCommands:tpm', function()
    local waypoint <const> = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) then
        local coords <const> = GetBlipInfoIdCoord(waypoint) + vector3(0.0, 0.0, 0.0)
        SetPedCoordsKeepVehicle(PlayerPedId(), coords) ---@diagnostic disable-line: missing-parameter, param-type-mismatch

        HRLib.Notify(Translation.tpm_successful, 'success')
    else
        HRLib.Notify(Translation.tpm_failed, 'error')
    end
end)

RegisterNetEvent('ExtraCommands:ressurectPlayer', function()
    DoScreenFadeOut(300)

    while not IsScreenFadedOut() do
        Wait(50)
    end

    DoScreenFadeIn(1000)

    local ped <const> = PlayerPedId()
    NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped), 0, false) ---@diagnostic disable-line: missing-parameter, param-type-mismatch
end)

RegisterNetEvent('HRExtraCommands:deleteVehicle', function()
    local veh = HRLib.ClosestVehicle()
    if veh and veh.distance <= config.dvDistance then
        DeleteEntity(veh.vehicle)
        HRLib.Notify(Translation.dv_successful, 'success')
    else
        HRLib.Notify(Translation.dv_failed, 'error')
    end
end)

-- Callbacks

HRLib.CreateCallback('ExtraCommands:doesVehicleExist', true, function(vehicleName)
    return GetDisplayNameFromVehicleModel(vehicleName) ~= 'CARNOTFOUND'
end)