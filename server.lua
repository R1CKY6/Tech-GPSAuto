ESX = exports.es_extended.getSharedObject()


ESX.RegisterUsableItem(Config.GPSItem, function(source)
    TriggerClientEvent('ricky:gps', source)
end)

