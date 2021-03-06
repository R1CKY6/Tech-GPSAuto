ESX = exports.es_extended.getSharedObject()
local attivata = false
local hash = nil


RegisterNetEvent('ricky:gps')
AddEventHandler('ricky:gps', function()
    ESX.UI.Menu.Open('default',GetCurrentResourceName(), 'menu_gps4',
    { 
    title = Ricky_Lang['title_menu'], 
    align = 'top-left', 
    elements = {
        {label = Ricky_Lang['menu_option'], value = 'attaccagps'},
    } 
    }, function(data, menu)
      local valore = data.current.value
      if valore == "attaccagps" then
            AttivaGPS()
      end
    end, function(data, menu) 
    menu.close() 
    end)
end)

AttivaGPS = function()
    local veicolo = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId(), true))
    attivata = not attivata
    coords = GetEntityCoords(veicolo, true)
    local utente = PlayerPedId()

    local posizione = #vector3(coords - GetEntityCoords(PlayerPedId()))

    if posizione > 3.0 then
        return ESX.ShowNotification(Ricky_Lang['nessun_veicolo_vicino'])
    end

    if attivata and PlayerPedId() == utente then
        ESX.ShowNotification(Ricky_Lang['gps_attaccato'])
        hash = GetHashKey(veicolo)
        SetBlip(coords)
    Citizen.CreateThread(function()
        while attivata do
            Citizen.Wait(Config.UpdateTime)
             coords = GetEntityCoords(veicolo, true)
             if PlayerPedId() == utente then 
             SetBlip(coords)
             end
        end
    end)
  else
    if GetHashKey(ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId(), true))) == hash then
        ESX.ShowNotification(Ricky_Lang['gps_tolto'])
        attivata = false
    else
        ESX.ShowNotification(Ricky_Lang['auto_sbagliata'])
        attivata = true
    end
  end
end



function SetBlip(coords)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, Config.Sprite)
    SetBlipColour(blip, Config.BlipColor)
    SetBlipScale(blip, Config.BlipSize)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(blip)
    Citizen.SetTimeout(Config.UpdateTime, function()
       RemoveBlip(blip)
    end)
end
