--[[
-- HELPER FUNCTIONS
-- ]]

function createBlip(coords, sprite, color, scale, blipname)

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipname)
    EndTextCommandSetBlipName(blip)

    return blip
end


function deleteBlip(blipType, id)

    if type(ECO[blipType]) ~= 'table' or next(ECO[blipType]) == nil or id == nil then

        return
    end

    if id == 'all' then

        for _, v in pairs(ECO[blipType]) do

            RemoveBlip(v)
        end

        ECO[blipType] = {}
    else

        id = tonumber(id)
        RemoveBlip(ECO[blipType][id])

        ECO[blipType][id] = nil
    end
end


function modelLoader(model)

    if not HasModelLoaded(model) then

        RequestModel(model)
        Citizen.Wait(100)
        while not HasModelLoaded(model) do Citizen.Wait(10) end
    end
end