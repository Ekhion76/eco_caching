--
-- Created by IntelliJ IDEA.
-- User: ekhion
-- Date: 2021. 06. 28.
-- Time: 12:12
--

function stateDistribution(state, piece, sid, zid)

    piece = tonumber(piece)
    zid = tonumber(zid)
    sid = tonumber(sid)

    if not piece or piece == 0 then return end

    local allowPid = {}
    local idx, pid


    for pid, v in pairs(Config.point) do

        if v[1] == zid then

            table.insert(allowPid, pid)

            ECO.POINT[pid] = {
                sid = sid,
                zid = v[1],
                pos = v[2]
            }
        end
    end

    for i = 1, piece do

        idx = math.random(#allowPid)
        pid = allowPid[idx]

        ECO.POINT[pid].state = state
        ECO.NEWSTATE[pid] = {
            sid = sid,
            zid = zid,
            state = state
        }

        table.remove(allowPid, idx)
    end
end


function bonusStateDistribution(state, piece, sid)

    if piece == 0 then return end

    local allowPid = {}
    local idx, pid


    for pid, v in pairs(Config.point) do

        if sid == 1 and v[1] < 10 and ECO.POINT[pid] and not ECO.POINT[pid].state then

            table.insert(allowPid, pid)
        end

        if sid == 2 and v[1] == 10 then

            table.insert(allowPid, pid)

            ECO.POINT[pid] = {
                sid = sid,
                zid = v[1],
                pos = v[2]
            }
        end
    end

    piece = #allowPid >= piece and piece or #allowPid

    for i = 1, piece do

        idx = math.random(#allowPid)
        pid = allowPid[idx]

        ECO.POINT[pid].state = state

        ECO.NEWSTATE[pid] = {
            sid = sid,
            zid = ECO.POINT[pid].zid,
            state = state
        }
        table.remove(allowPid, idx)
    end
end


function loadPoint(state)

    ECO.POINT = {}
    local allowZid, point = {}, {}
    local zid

    if type(state) == 'table' and next(state) then

        for _, v in pairs(state) do allowZid[v.zid] = true end


        for pid, v in pairs(Config.point) do

            if allowZid[v[1]] then

                point[pid] = {
                    sid = v[1] < 10 and 1 or 2,
                    zid = v[1],
                    pos = v[2],
                    state = state[pid] and state[pid].state or nil
                }
            end
        end


        for pid, v in pairs(point) do

            if v.state ~= "-" then ECO.POINT[pid] = v end
        end

        point = {}
    end
end


function deleteZoneState(pid, zid)

    ECO.POINT[pid] = nil

    -- POINTLIST CHECK
    for _, v in pairs(ECO.POINT) do

        if v.zid and v.zid == zid then

            return false
        end
    end

    return true
end


function loadedSession(sid)

    if sid == 2 and ECO.STATS.event > 0 then return true end

    for _, v in pairs(ECO.POINT) do

        if v.sid and v.sid == sid then return true end
    end

    return false
end


function serverSync()

    if not ECO.LOADED.serverSync then

        ESX.TriggerServerCallback('eco_caching:serverSync', function(result)

            ECO.SESSION = result.session
            ECO.STATS = result.stats

            loadPoint(result.state)

            ECO.LOADED.serverSync = true
        end)

        while not ECO.LOADED.serverSync do Citizen.Wait(100) end
    end
end


function resetSessionData(sid)

    local tmp = {}

    for k, v in pairs(ECO.POINT) do

        if v.sid == sid then

            deleteBlip('BOXBLIP', k)
        else

            tmp[k] = v
        end
    end

    ECO.POINT = tmp

    if sid == 2 then ECO.STATS.event = 0 end
end


function animPlay(ped, dict, anim, duration)

    if not ped or type(ped) ~= 'number' or ECO.inAnim[ped] then return end

    if not HasAnimDictLoaded(dict) then

        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Citizen.Wait(10) end
    end

    ECO.inAnim[ped] = true
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

    Citizen.Wait(duration or 4000)

    ClearPedTasks(ped)
    ECO.inAnim[ped] = nil
end


function getClosestNpc()

    local coords = GetEntityCoords(PlayerPedId())
    local distance, minDistance = 0, 0
    local npc

    if next(ECO.NPC) then

        for _, handle in pairs(ECO.NPC) do

            distance = #(coords - GetEntityCoords(handle))

            if minDistance == 0 or minDistance > distance then

                npc = handle
            end
        end
    end

    return npc
end
