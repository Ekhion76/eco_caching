--
-- Created by IntelliJ IDEA.
-- User: ekhion
-- Date: 2021. 07. 04.
-- Time: 19:12
--

function objectHandler(pids)

    local pid, zid, pos, zone, prop, point, state, offset, data
    local tmp = {}

    if not ECO.activeSession then return end

    for _, pid in pairs(pids) do

        if not ECO.OBJECT[pid] then

            pos = Config.point[pid][2]
            state = ECO.POINT[pid] and ECO.POINT[pid].state or 'x'
            data = Config.action[state] and Config.action[state] or Config.action['x']

            modelLoader(data.object)

            ECO.OBJECT[pid] = CreateObject(data.object, pos + data.offset)
            PlaceObjectOnGroundProperly(ECO.OBJECT[pid])
            FreezeEntityPosition(ECO.OBJECT[pid], true)
        end
    end

    for pid, handle in pairs(ECO.OBJECT) do

        local del = true

        for i = 1, #pids do

            if pids[i] == pid then del = false; tmp[pid] = handle end
        end

        if del then DeleteObject(handle) end
    end

    ECO.OBJECT = tmp
end


function objectDeleter()

    for _, handle in pairs(ECO.OBJECT) do DeleteObject(handle) end
    ECO.OBJECT = {}
end

-- NPC
function npcHandler(ids)

    local pos, modelHash, heading
    local tmp = {}

    for _, id in pairs(ids) do

        if not ECO.NPC[id] then

            pos = Config.npc[id].pos
            modelHash = Config.npc[id].modelHash
            heading = Config.npc[id].heading

            modelLoader(modelHash)

            local npc = CreatePed(6, modelHash, pos, heading, false, false)

            SetEntityInvincible(npc, true)
            SetEntityProofs(npc, true, true, true, true, true, true, 1, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            FreezeEntityPosition(npc, true)
            SetPedDiesWhenInjured(npc, false)
            SetEntityCanBeDamaged(npc, false)
            SetPedCanRagdollFromPlayerImpact(npc, false)
            SetPedCanRagdoll(npc, false)
            SetEntityAsMissionEntity(npc, true, true)
            SetEntityDynamic(npc, false)

            ECO.NPC[id] = npc
        end
    end


    for id, handle in pairs(ECO.NPC) do

        local del = true

        for i = 1, #ids do

            if ids[i] == id then

                del = false
                tmp[id] = handle
            end
        end

        if del then DeletePed(handle) end
    end

    ECO.NPC = tmp
end


function npcDeleter()

    for _, handle in pairs(ECO.NPC) do DeletePed(handle) end
    ECO.NPC = {}
end