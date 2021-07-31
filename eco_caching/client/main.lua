ESX = nil
ECO = {
    closestZones = {},
    closestNpc = {},
    activeSession = false,
    inAnim = {},
    SESSION = {},
    OBJECT = {},
    LOADED = {},
    POINT = {},
    NEWSTATE = {},
    STATS = {},
    BOXBLIP = {},
    NPC = {}
}

local _PlayerPedId
local hasAlreadyEnteredMarker, currentActionData = false, {}
local currentAction, currentActionMsg, lastZone, lastZoneType

Citizen.CreateThread(function()

    while ESX == nil do

        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end

    _PlayerPedId = PlayerPedId()

    -- NPC BLIPS
    for _, v in pairs(Config.npc) do

        if v.enable then

            local data = v.action == 'shop' and Config.shopBlip or Config.geoBlip

            createBlip(v.pos,
                data.sprite,
                data.color,
                data.scale,
                data.name)
        end
    end

    -- SET SHOP ITEM LABELS
    for k, v in pairs(Config.shopItem) do

        v.label = _(v.item)
    end
end)


-- CHECKPOINT HANDLE - Enter / Exit marker events
Citizen.CreateThread(function()

    local closestZones, closestNpc, coords, distance, currentZone, zoneType, isInMarker, point

    while true do

        Citizen.Wait(1000)

        -- ZONALISTA VÁLTÁS
        point = ECO.POINT

        _PlayerPedId = PlayerPedId()
        coords = GetEntityCoords(_PlayerPedId)
        isInMarker = false
        currentZone = nil
        closestZones = {}
        closestNpc = {}
        zoneType = ''

        if ECO.activeSession then

            if next(point) == nil then

                ECO.activeSession = false
                DoCustomHudText('information', _('no_more_box'))
                setHud()
                objectDeleter()
            end

            for k, v in pairs(point) do

                if not v.state or v.state ~= '-' then

                    distance = #(coords - v.pos)

                    if distance < 80 then table.insert(closestZones, k) end -- 80
                    if distance < 2.0 then isInMarker = true; currentZone = k; zoneType = 'box' end
                end
            end

            if Config.showObject then

                objectHandler(closestZones)
            end
        end


        if not Config.shopCommand or not Config.geoCommand then

            for k, v in pairs(Config.npc) do

                if v.enable then

                    distance = #(coords - v.pos)

                    if distance < 80 then table.insert(closestNpc, k) end -- 80
                    if distance < 2.0 then isInMarker = true; currentZone = k; zoneType = v.action end
                end
            end

            npcHandler(closestNpc)
        end

        ECO.closestZones = closestZones
        ECO.closestNpc = closestNpc

        if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then

            hasAlreadyEnteredMarker = true
            lastZone = currentZone
            lastZoneType = zoneType
            TriggerEvent('eco_caching:hasEnteredMarker', currentZone, zoneType)
        end

        if not isInMarker and hasAlreadyEnteredMarker then

            hasAlreadyEnteredMarker = false
            TriggerEvent('eco_caching:hasExitedMarker', lastZoneType)
        end
    end
end)


-- Display Action points markers
Citizen.CreateThread(function()

    local index, ePoint, item, zones, npc

    while true do

        Citizen.Wait(0)

        index = ECO.closestZones
        npc = ECO.closestNpc
        ePoint = ECO.POINT

        if index[1] or npc[1] then

            -- Key controls
            if currentAction then

                if IsControlJustReleased(0, 38) then

                    if not IsPedInAnyVehicle(_PlayerPedId, true) and not IsPedDeadOrDying(_PlayerPedId) and IsPedOnFoot(_PlayerPedId) then

                        sendHudActionData({}, 'close')

                        if currentAction == 'point' then

                            TriggerEvent('eco_caching:searchBox')

                        elseif currentAction == 'shop' then

                            TriggerEvent('eco_caching:openShop')

                        elseif currentAction == 'geo' then

                            TriggerEvent('eco_caching:geoAction')
                        end

                        currentAction = nil
                    end
                end
            end

            -- DrawMarker
            if Config.showMarker and index[1] then

                for i = 1, #index do

                    item = ePoint[index[i]]

                    if item then

                        DrawMarker(32, -- 32 QuestionMark
                            item.pos + vector3(0.0, 0.0, 1.2),
                            0.0, 0.0, 0.0, -- dir
                            0, 0.0, 0.0, -- rot
                            0.5, 0.1, 0.5, -- scale
                            255, 215, 0, 255, -- rgba
                            false, -- bobUpAndDown
                            true, -- faceCamera
                            2,
                            false, -- rotate
                            false, -- textureDict
                            false, -- textureName
                            false) -- drawOnEnts
                    end
                end
            end
        else

            Citizen.Wait(1000)
        end
    end
end)


AddEventHandler('eco_caching:searchBox', function()

    local pid = currentActionData.pid
    local zid = ECO.POINT[pid].zid
    local sid = ECO.POINT[pid].sid
    local state = ECO.POINT[pid].state


    -- PLAY ANIMATION
    local idx = math.random(#Config.anim.search)
    local animParam = Config.anim.search[idx]


    animPlay(PlayerPedId(),
        animParam.dict,
        animParam.anim,
        animParam.duration)


    -- REMOVE BOXBLIP
    deleteBlip('BOXBLIP', pid)


    -- SERVER SIDE
    TriggerServerEvent('eco_caching:lootHandler', {
        pid = pid,
        zid = zid,
        sid = sid,
        state = state,
        disableZone = deleteZoneState(pid, zid),
    })
end)


AddEventHandler('eco_caching:hasEnteredMarker', function(id, zoneType)


    if zoneType == 'box' then

        currentAction = 'point'
        currentActionData = { pid = id }

        sendHudActionData({
            name = _('area'),
            description = _('possible_position'),
            message = _('box_search')
        }, 'append') -- append, close

    elseif zoneType == 'shop' then

        currentAction = 'shop'
        currentActionData = {}

        sendHudActionData({
            name = _('shop_area'),
            description = _('shop_description'),
            message = _('shop_open')
        }, 'append') -- append, close

        local idx = math.random(#Config.anim.greeting)
        local animParam = Config.anim.greeting[idx]

        animPlay(getClosestNpc(),
            animParam.dict,
            animParam.anim,
            animParam.duration)

    elseif zoneType == 'geo' then

        currentAction = 'geo'
        currentActionData = {}

        sendHudActionData({
            name = _('geo_action'),
            description = ECO.activeSession and _('geo_stop_description') or _('geo_start_description'),
            message = ECO.activeSession and _('geo_stop') or _('geo_start'),
        }, 'append') -- append, close

        local idx = math.random(#Config.anim.greeting)
        local animParam = Config.anim.greeting[idx]

        animPlay(getClosestNpc(),
            animParam.dict,
            animParam.anim,
            animParam.duration)
    end
end)


AddEventHandler('eco_caching:hasExitedMarker', function(lastZoneType)

    sendHudActionData({}, 'close')
    currentAction = nil

    if lastZoneType == 'geo' or lastZoneType == 'shop' then

        local idx = math.random(#Config.anim.bye)
        local animParam = Config.anim.bye[idx]

        animPlay(getClosestNpc(),
            animParam.dict,
            animParam.anim,
            animParam.duration)
    end
end)


RegisterCommand('geo', function()

    if Config.geoCommand then

        TriggerEvent('eco_caching:geoAction')
    else

        TriggerEvent('chat:addMessage', { args = { "^2[ECO CACHING] ", _('geocommand_not_active') } })
    end
end)


AddEventHandler('eco_caching:geoAction', function()

    if ECO.activeSession then

        DoCustomHudText('information', _('bye'))

        -- BOXBLIP DELETE
        deleteBlip('BOXBLIP', 'all')

        -- OBJECT DELETE
        objectDeleter()

        ECO.activeSession = false
    else

        math.randomseed(GetGameTimer() * math.random(100, 1000))
        math.random(); math.random(); math.random()

        DoCustomHudText('information', _('promotion'), 10000)

        serverSync()

        initSession()

        if next(ECO.POINT) then

            ECO.activeSession = true
        else

            ECO.activeSession = false
            DoCustomHudText('fail', _('no_session'))
        end
    end

    setHud()
end)


RegisterNetEvent('eco_caching:endSession')
AddEventHandler('eco_caching:endSession', function(sid)

    resetSessionData(sid)

    if ECO.SESSION[sid] then

        ECO.SESSION[sid].active = '0'
    end
end)


RegisterNetEvent('eco_caching:startSession')
AddEventHandler('eco_caching:startSession', function(sid, sData)

    -- UPDATE SESSION
    if ECO.SESSION[sid] then

        for k, v in pairs(sData) do

            ECO.SESSION[sid][k] = v -- index null
        end
    end

    resetSessionData(sid)

    if ECO.activeSession then

        sendHudLiveData(ECO.STATS)
        Citizen.Wait(1100)
        initSession()
    end
end)


function initSession()

    for sid, v in pairs(ECO.SESSION) do

        if v.active == '1' and (sid == 1 or ECO.STATS.event == 0) then -- 1:STANDARD, 2:EVENT

            local allocation = json.decode(v.state_allocation)

            if not loadedSession(sid) then

                if sid == 1 then -- STANDARD

                    for zid, piece in pairs(allocation) do

                        stateDistribution('b', piece, sid, zid)
                    end

                    bonusStateDistribution('s', math.random(1, 3), sid) -- shiney
                    bonusStateDistribution('f', math.random(0, 2), sid) -- fortune
                    bonusStateDistribution('l', math.random(0, 2), sid) -- lucky

                elseif sid == 2 and ECO.STATS.event == 0 then -- EVENT

                    bonusStateDistribution('e', allocation['10'], sid) -- event
                end
            end
        end
    end

    -- BLIPS
    for pid, v in pairs(ECO.POINT) do

        if not ECO.BOXBLIP[pid] then

            local zone = Config.zone[v.zid]

            local sprite = zone.blipSprite and zone.blipSprite or Config.boxBlip.sprite
            local color = zone.blipColor and zone.blipColor or Config.boxBlip.color

            ECO.BOXBLIP[pid] = createBlip(v.pos,
                sprite,
                color,
                Config.boxBlip.scale,
                Config.boxBlip.name)
        end
    end


    -- SAVE STATE
    if next(ECO.NEWSTATE) then

        TriggerServerEvent('eco_caching:saveState', ECO.NEWSTATE)
        ECO.NEWSTATE = {}
    end
end


RegisterNetEvent('eco_caching:statsUpdate')
AddEventHandler('eco_caching:statsUpdate', function(stats)

    for k, v in pairs(stats) do

        if tonumber(ECO.STATS[k]) and tonumber(v) then

            ECO.STATS[k] = ECO.STATS[k] + v
        end
    end

    sendHudLiveData(ECO.STATS)
end)


RegisterNUICallback('exit', function(data, cb)

    SetNuiFocus(false, false)
    cb('ok')
end)


AddEventHandler('onResourceStop', function(resource)

    if resource == GetCurrentResourceName() then

        objectDeleter()
    end
end)



-- DEVELOPER
--[[
--
- ExecuteCommand('go')

RegisterCommand('go', function(source, args, rawCommand)

    local idList = {}

    for k, _ in pairs(ECO.POINT) do

        table.insert(idList, k)
    end

    table.sort(idList)

    local id = idList[1]

    print('CURRENT ID:', id)

    if id then
        ESX.Game.Teleport(PlayerPedId(), Config.point[id][2])
        ESX.ShowNotification('pid: ' .. id)
    end
end)
]]
