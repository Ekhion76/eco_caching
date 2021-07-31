--
-- Created by IntelliJ IDEA.
-- User: ekhion
-- Date: 2021. 07. 16.
-- Time: 2:23
--

RegisterNetEvent('eco_caching:geoadmin')
AddEventHandler('eco_caching:geoadmin', function(data)

    SetNuiFocus(true, true)

    SendNUIMessage({
        subject = 'CONTROL',
        operation = 'open',
        data = data
    })
end)

RegisterNUICallback('control', function(data, cb)

    ESX.TriggerServerCallback('eco_caching:setSession', function(result)

        cb(result)
    end, data)
end)