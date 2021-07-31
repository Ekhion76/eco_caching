--
-- Created by IntelliJ IDEA.
-- User: ekhion
-- Date: 2021. 07. 12.
-- Time: 16:27
--


RegisterCommand('geoshop', function()

    if Config.shopCommand then

        TriggerEvent('eco_caching:openShop')
    else

        TriggerEvent("chat:addMessage", { args = { "^2[ECO CACHING] ", _('shopcommand_not_active') } })
    end
end)


RegisterNetEvent('eco_caching:openShop')
AddEventHandler('eco_caching:openShop', function()

    SetNuiFocus(true, true)

    ESX.TriggerServerCallback('eco_caching:getBalance', function(result)

        ECO.STATS = result.stats

        SendNUIMessage({
            subject = 'SHOP',
            operation = 'open',
            userData = result,
            shopData = Config.shopItem
        })
    end)
end)


RegisterNUICallback('buy', function(data, cb)

    TriggerServerEvent('eco_caching:buy', data)
    cb('ok')
end)

