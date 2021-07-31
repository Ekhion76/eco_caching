ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ECO = {
    SESSION = {},
    LOADED = {}
}

local hit = 0


-- SESSION EXPIRE INSPECT
function inspectSession()

    for _, v in pairs(ECO.SESSION) do

        if v.expire ~= 0 and (v.expire < os.time() and v.active ~= '0') then

            endSession(v.id)
        end
    end

    ECO.LOADED.session = true
    SetTimeout(60000, inspectSession)
end


MySQL.ready(function()

    MySQL.Async.fetchAll('SELECT * FROM eco_caching_session', {}, function(result)

        if result[1] then

            for _, v in pairs(result) do

                v.expire = v.expire == 0 and 0 or math.floor(v.expire / 1000) -- unix_timestamp
                ECO.SESSION[v.id] = v
            end
        end

        inspectSession()
    end)
end)


ESX.RegisterServerCallback('eco_caching:serverSync', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    if xPlayer then

        getState(identifier, function(state)
            getStats(identifier, function(stats)

                cb({
                    session = ECO.SESSION,
                    state = state,
                    stats = stats
                })
            end)
        end)
    end
end)


function getState(identifier, cb)

    MySQL.Async.fetchAll('SELECT sid, zid, pid, state FROM eco_caching_state WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)

        local state = {}

        if result[1] then

            for i = 1, #result do

                state[result[i].pid] = result[i]
            end
        end

        cb(state)
    end)
end


function getStats(identifier, cb)

    MySQL.Async.fetchAll('SELECT * FROM eco_caching_stats WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)

        local stats = {
            opened = 0,
            hit = 0,
            point = 0,
            coin = 0,
            event = 0
        }

        if result[1] then stats = result[1] end
        cb(stats)
    end)
end


RegisterNetEvent('eco_caching:saveState')
AddEventHandler('eco_caching:saveState', function(state)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    if xPlayer then

        local separator = ''
        local sql = 'INSERT INTO `eco_caching_state` (`identifier`, `sid`, `zid`, `pid`, `state`) VALUES '

        for pid, v in pairs(state) do

            sql = sql .. separator
            sql = sql .. ('("%s", %s, %s, %s, "%s")'):format(identifier, v.sid, v.zid, pid, v.state)
            separator = ", "
        end

        MySQL.Async.execute(sql, {})
    end
end)


RegisterNetEvent('eco_caching:lootHandler')
AddEventHandler('eco_caching:lootHandler', function(data)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    -- state átírás
    if data.disableZone then

        MySQL.Async.execute('DELETE FROM eco_caching_state WHERE identifier = @identifier AND zid = @zid', {
            ['@identifier'] = identifier,
            ['@zid'] = data.zid
        })
    else

        MySQL.Async.fetchAll('SELECT * FROM eco_caching_state WHERE identifier = @identifier AND pid = @pid', {
            ['@identifier'] = identifier,
            ['@pid'] = data.pid
        }, function(result)

            if result[1] then

                MySQL.Async.execute('UPDATE `eco_caching_state` SET `state` = "-" WHERE identifier = @identifier AND pid = @pid', {
                    ['@identifier'] = identifier,
                    ['@pid'] = data.pid
                })
            else

                local sql = [[
                        INSERT INTO
                            `eco_caching_state` (`identifier`, `sid`, `zid`, `pid`, `state`)
                        VALUES
                            (@identifier, @sid, @zid, @pid, @state)
                    ]]

                MySQL.Async.execute(sql, {
                    ['@identifier'] = identifier,
                    ['@sid'] = data.sid,
                    ['@zid'] = data.zid,
                    ['@pid'] = data.pid,
                    ['@state'] = '-',
                })
            end
        end)
    end

    local state = data.state and data.state or 'x'
    local placement, event, coin = 0, 0, 0
    local congratulation = ''

    local reward = addReward(state)

    if state == 'e' then -- EVENT LÁDA

        event = 1

        ECO.LOADED.stats = false

        MySQL.Async.fetchAll('SELECT * FROM `eco_caching_stats` WHERE identifier = @identifier', {
            ['@identifier'] = identifier,
        }, function(result)

            if result[1] then

                if result[1].event + 1 > 2 then


                    placement = ECO.SESSION[data.sid].next_award

                    coin = Config.eventCoin[placement]

                    TriggerClientEvent('chat:addMessage', -1, { args = { "^2[ECO CACHING] ", _('event_award' .. placement) } })

                    if placement < 3 then

                        ECO.SESSION[data.sid].next_award = ECO.SESSION[data.sid].next_award + 1
                        MySQL.Async.execute('UPDATE `eco_caching_session` SET `next_award` = `next_award` + 1 WHERE `id` = 2', {})
                    else

                        endSession(data.sid)
                    end
                end

                result = nil
            end


            ECO.LOADED.stats = true
        end)

        while not ECO.LOADED.stats do Citizen.Wait(10) end
    end


    if reward.money > 0 then

        xPlayer.addMoney(reward.money)
    end

    if reward.item ~= '' then

        xPlayer.addInventoryItem(reward.item, 1)
    end

    local hitIdx = math.random(#Config.hitList)

    TriggerClientEvent('eco_caching:showPopupNotification', _source, {
        state = state,
        title = _('area_result', _(state)),
        text = _('reward_prefix', Config.hitList[hitIdx]),
        placement = placement,
        reward = {
            money = reward.money,
            item = reward.item == '' and '' or _(reward.item),
            point = reward.point,
            coin = coin
        }
    })




    -- STAT RECORD
    local sql = [[
        INSERT INTO `eco_caching_stats` (
            `identifier`,
            `opened`,
            `hit`,
            `point`,
            `coin`,
            `event`)
        VALUES (
            @identifier,
            @opened,
            @hit,
            @point,
            @coin,
            @event)
        ON DUPLICATE KEY UPDATE
            `opened` = `opened` + @opened,
            `hit` = `hit` + @hit,
            `point` = `point` + @point,
            `coin` = `coin` + @coin,
            `event` = `event` + @event
    ]]


    MySQL.Async.execute(sql,
        {
            ['@identifier'] = xPlayer.identifier,
            ['@opened'] = 1,
            ['@hit'] = state ~= 'x' and 1 or 0,
            ['@point'] = reward.point and reward.point or 0,
            ['@coin'] = coin,
            ['@event'] = event
        })


    -- CHAT BROADCAST
    if state ~= 'x' then

        hit = hit + 1

        local density = Config.broadcast[data.sid] and Config.broadcast[data.sid] or 5

        if hit % density == 0 then

            TriggerClientEvent('chat:addMessage', -1, { args = { "^2[ECO CACHING] ", _('promotion_bradcast') } })
        end
    end


    TriggerClientEvent('eco_caching:statsUpdate', _source, {
        opened = 1,
        hit = state ~= 'x' and 1 or 0,
        point = reward.point and reward.point or 0,
        coin = coin,
        event = event
    })
end)


ESX.RegisterServerCallback('eco_caching:getAllStatistics', function(source, cb, data)

    if not data.orderBy or data.orderBy == '' then data.orderBy = 'opened' end
    if not data.dir or data.dir == '' then data.dir = 'DESC' end

    -- STAT RECORD
    local sql = [[
        SELECT `eco_caching_stats`.*,
        `users`.`firstname`,
        `users`.`lastname`
        FROM `eco_caching_stats`
        LEFT JOIN `users`
        USING (`identifier`)
        ORDER BY `]] .. data.orderBy .. [[` ]] .. data.dir .. [[
        LIMIT 50
    ]]

    MySQL.Async.fetchAll(sql, {}, function(result)

        cb(result)
    end)
end)


ESX.RegisterServerCallback('eco_caching:getStatistics', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    if xPlayer then

        -- STAT RECORD
        local sql = [[
        SELECT `eco_caching_stats`.*,
        `users`.`firstname`,
        `users`.`lastname`
        FROM `eco_caching_stats`
        LEFT JOIN `users`
        USING (`identifier`)
        WHERE `eco_caching_stats`.`identifier` = @identifier
    ]]

        MySQL.Async.fetchAll(sql, {
            ['@identifier'] = identifier
        }, function(result)

            cb(result)
        end)
    end
end)


function endSession(sid)

    sid = tonumber(sid)

    ECO.SESSION[sid].next_award = 1
    ECO.SESSION[sid].active = '0'

    TriggerClientEvent('eco_caching:endSession', -1, sid)

    MySQL.Async.execute("UPDATE `eco_caching_session` SET `next_award` = 1, `active` = '0' WHERE `id` = @id", {
        ["@id"] = sid
    }, function()

        MySQL.Async.execute('DELETE FROM eco_caching_state WHERE sid = @sid', {
            ['@sid'] = sid
        }, function()

            if sid == 2 then

                MySQL.Async.execute("UPDATE eco_caching_stats SET event = 0", {})
            end
        end)
    end)
end


function startSession(sid, data)

    sid = tonumber(sid)

    local sql = "UPDATE `eco_caching_session` SET `next_award` = 1, `active` = '1' ";

    if data then

        if data.state_allocation then

            sql = sql .. ", `state_allocation` = '" .. data.state_allocation .. "'"
            ECO.SESSION[sid].state_allocation = data.state_allocation
        end

        if data.expire then

            sql = sql .. ", `expire` = NOW() + INTERVAL " .. data.expire .. " HOUR"
            ECO.SESSION[sid].expire = os.time() + data.expire * 60 * 60
        end
    end

    sql = sql .. " WHERE `id` = @id"

    ECO.LOADED['startSession'] = false

    MySQL.Async.execute(sql, {
        ["@id"] = sid
    }, function()

        MySQL.Async.execute('DELETE FROM eco_caching_state WHERE sid = @sid', {
            ['@sid'] = sid
        }, function()

            if sid == 2 then

                MySQL.Async.execute("UPDATE eco_caching_stats SET event = 0", {})
            end
        end)

        ECO.SESSION[sid].next_award = 1
        ECO.SESSION[sid].active = '1'

        TriggerClientEvent('eco_caching:startSession', -1, sid, ECO.SESSION[sid])

        ECO.LOADED['startSession'] = true
    end)

    while not ECO.LOADED['startSession'] do Citizen.Wait(10) end
end


-- SHOP
RegisterNetEvent('eco_caching:buy')
AddEventHandler('eco_caching:buy', function(data)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    if xPlayer then

        local piece = tonumber(data.piece)
        local price = tonumber(data.price)
        local currency = data.currency
        local item = data.item

        if currency ~= 'point' and currency ~= 'coin' then currency = nil end

        if data.currency and data.item and piece and price and price > 0 then

            local sumPrice = price * piece

            MySQL.Async.fetchAll('SELECT * FROM eco_caching_stats WHERE identifier = @identifier', {
                ['@identifier'] = identifier
            }, function(result)

                if result[1] then

                    local stats = result[1]

                    if stats[currency] >= sumPrice then

                        MySQL.Async.execute('UPDATE eco_caching_stats SET ' .. currency .. ' = ' .. currency .. ' - @sumPrice WHERE identifier = @identifier', {
                            ['@sumPrice'] = sumPrice,
                            ['@identifier'] = identifier
                        }, function(rowChange)

                            if rowChange > 0 then

                                xPlayer.addInventoryItem(item, piece)

                                TriggerClientEvent('eco_caching:showNotification', _source, {
                                    type = 'success',
                                    text = _('purchased', piece, data.label)
                                })


                                -- UPDATE STATS & HUD
                                TriggerClientEvent('eco_caching:statsUpdate', _source, {
                                    [currency] = sumPrice * -1
                                })
                            end
                        end)
                    else

                        TriggerClientEvent('eco_caching:showNotification', _source, {
                            type = 'warning',
                            text = _('not_enough_money')
                        })
                    end
                end
            end)

        else

            TriggerClientEvent('eco_caching:showNotification', _source, {
                type = 'error',
                text = _('incomplete_data')
            })
        end
    end
end)


-- CONTROLLER
RegisterCommand('geoadmin', function(source, args, rawCommand)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then

        local group = xPlayer.getGroup()

        if group == 'admin' or group == 'superadmin' then

            TriggerClientEvent('eco_caching:geoadmin', _source, {
                sessionData = ECO.SESSION,
                osTime = os.time()
            })
        end
    end
end)


ESX.RegisterServerCallback('eco_caching:setSession', function(source, cb, data)

    local sid = tonumber(data.sid)
    local active = tostring(data.active)

    if active == '0' then

        endSession(sid)

    elseif active == '1' then

        startSession(sid, data)
    end

    -- EVENT START BROADCAST
    if sid == 2 and active == '1' then

        TriggerClientEvent('chat:addMessage', -1, { args = { "^2[ECO CACHING] ", _('event_started') } })
    end

    cb({
        sessionData = ECO.SESSION,
        osTime = os.time()
    })
end)


ESX.RegisterServerCallback('eco_caching:getBalance', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    if xPlayer then

        getStats(identifier, function(stats)

            cb({
                stats = stats
            })
        end)
    end
end)

