--
-- Created by IntelliJ IDEA.
-- User: ekhion
-- Date: 2020. 11. 14.
-- Time: 10:36
--

function setHud()

    if ECO.activeSession then

        SendNUIMessage({
            subject = "GEO_INFO",
            geoData = ECO.STATS,
            itemList = ECO.ITEMLIST
        })
    else

        SendNUIMessage({
            subject = "CLOSE_INFO",
        })
    end
end


function sendHudLiveData(value)

    SendNUIMessage({
        subject = "UPDATE",
        value = value
    })
end


function sendHudActionData(actionData, operation)

    SendNUIMessage({
        subject = "ACTION_INFO",
        operation = operation, -- append, close
        actionData = actionData
    })
end


function DoCustomHudText(type, text, length, style)

    SendNUIMessage({
        subject = "NOTIFICATION",
        type = type,
        text = text,
        length = length,
        style = style
    })
end


RegisterNetEvent('eco_caching:showNotification')
AddEventHandler('eco_caching:showNotification', function(data)

    DoCustomHudText(data.type, data.text, data.length, data.style)
end)


RegisterNetEvent('eco_caching:showPopupNotification')
AddEventHandler('eco_caching:showPopupNotification', function(data)

    SendNUIMessage({
        subject = 'POPUP_NOTIFICATION',
        data = data
    })
end)