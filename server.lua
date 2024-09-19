local HRLib <const> = HRLib --[[@as HRLibServerFunctions]]
local config <const> = HRLib.require(('@%s/config.lua'):format(GetCurrentResourceName())) --[[@as HRExtraCommandsConfig]]

-- Functions

---@param playerId integer
local isAllowed = function(playerId)
    if not config.enableWhitelistedIdentifiers or playerId == 0 then return true end

    local identifiers <const> = HRLib.PlayerIdentifier(playerId, 'all', false, true) --[[@as string[] ]]
    for i=1, #identifiers do
        for l=1, #config.whitelistedIdentifiers do
            if config.whitelistedIdentifiers[l] == identifiers[i] then
                return true
            end
        end
    end
end

-- Commands

HRLib.RegCommand('heal', true, true, function(args, _, IPlayer, FPlayer)
    local playerId <const> = tonumber(args[1])
    if isAllowed(IPlayer.source) then
        if HRLib.DoesIdExist(playerId) then
            TriggerClientEvent('ExtraCommands:heal', -1, playerId)
            FPlayer:Notify(Translation.heal_successful:format(GetPlayerName(playerId --[[@as integer]])), 'success')
        else
            FPlayer:Notify(Translation.invalid_playerId, 'error')
        end
    else
        FPlayer:Notify(Translation.access_denied, 'error')
    end
end, true, { help = Translation.heal_help, args = { { name = 'playerId', help = Translation.heal_arg1_help } } })

HRLib.RegCommand('giveweapon', true, true, function(args, _, IPlayer, FPlayer)
    args[3] = args[3] or 'nil'
    if args[3]:find('.') then args[3] = HRLib.string.split(args[3], '.', 'number', true)[1] end

    local playerId <const> = tonumber(args[1])
    if playerId and HRLib.DoesIdExist(playerId) then
        if isAllowed(IPlayer.source) then
            GiveWeaponToPed(GetPlayerPed(playerId), joaat(args[2]), args[3], true, false)
            FPlayer:Notify(Translation.giveweapon_successful:format(HRLib.string.split(args[2], '_', nil, true)[2], GetPlayerName(playerId)), 'success')
        else
            FPlayer:Notify(Translation.access_denied, 'error')
        end
    else
        FPlayer:Notify(Translation.invalid_playerId, 'error')
    end
end, true, { help = 'Give weapon to someone', args = { { name = 'playerId', help = 'The target server Id' }, { name = 'weaponName', help = 'The target weapon name' }, { name = 'ammo', help = 'The weapon ammo' } } })

HRLib.RegCommand('tpm', false, true, function(_, _, IPlayer, FPlayer)
    if isAllowed(IPlayer.source) then
        TriggerClientEvent('ExtraCommands:tpm', IPlayer.source)
    else
        FPlayer:Notify(Translation.access_denied, 'error')
    end
end, true, { help = Translation.tpm_help })

HRLib.RegCommand('car', false, true, function(args, _, IPlayer, FPlayer)
    if isAllowed(IPlayer.source) then
        if HRLib.ClientCallback('ExtraCommands:doesVehicleExist', nil, args[1]) then
            local veh <const> = FPlayer:SpawnVehicle(args[1], true)
            SetPedIntoVehicle(IPlayer.ped, veh --[[@as integer]], -1)
            FPlayer:Notify(Translation.car_successful:format(args[1]), 'success')
        else
            FPlayer:Notify(Translation.car_failed_invalidSpawnCode, 'error')
        end

    else
        FPlayer:Notify(Translation.access_denied, 'error')
    end
end, true, { help = 'Spawn a vehicle', args = { { name = 'spawnCode', help = 'The target vehicle spawn code' } } })

HRLib.RegCommand('dv', false, true, function(_, _, IPlayer, FPlayer)
    if isAllowed(IPlayer.source) then
        FPlayer:FocusedEvent('HRExtraCommands:deleteVehicle')
    else
        FPlayer:Notify(Translation.access_denied, 'error')
    end
end, true, { help = 'Delete the current vehicle you\'re in' })

HRLib.RegCommand('revive', true, true, function(args, _, IPlayer, FPlayer)
    if isAllowed(IPlayer.source) then
        local playerId <const> = tonumber(args[1]) --[[@as integer]]
        if playerId ~= 0 then
            if playerId and not HRLib.DoesIdExist(playerId) then
                FPlayer:Notify(Translation.invalid_playerId, 'error')
            end

            TriggerClientEvent('ExtraCommands:ressurectPlayer', HRLib.DoesIdExist(playerId) and playerId or IPlayer.source)
            FPlayer:Notify(Translation.revive_successful:format(HRLib.DoesIdExist(playerId) and GetPlayerName(playerId) or 'yourself'), 'success')
        else
            FPlayer:Notify(Translation.revive_failed, 'error')
        end
    else
        FPlayer:Notify(Translation.access_denied)
    end
end, true, { help = 'Revive someone', args = { { name = 'targetId', help = 'The target player server Id' } } })