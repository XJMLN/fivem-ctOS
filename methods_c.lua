Phone = {}
Notifications = {}
ctOS = {}
Persons = {}

-- Phone Methods 

-- @function Phone.createModel(Entity ped)
-- Create phone prop for entity
Phone.createModel = function(ped)
    RequestModel(Config.props.phone)
    while not HasModelLoaded(Config.props.phone) do
        Citizen.Wait(100)
    end
    return CreateObject(Config.props.phone,1.0,1.0,1.0,1,1,0)
end

-- @function Phone.addPhoneToPed(Entity ped)
-- Attach phone and play animation to given entity
Phone.addPhoneToPed = function(ped)
    if (IsPedDeadOrDying(ped)) then return end
    local bone = GetPedBoneIndex(ped, 28422)
    RequestAnimDict(Config.animations.phone.idle.dict)
    while not HasAnimDictLoaded(Config.animations.phone.idle.dict) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped,Config.animations.phone.idle.dict,Config.animations.phone.idle.anim,4.0,-1,-1,50,0,false,false,false)
    Phone[ped] = Phone.createModel()
    SetEntityAsMissionEntity(Phone[ped],true,true)
    AttachEntityToEntity(Phone[ped], GetPlayerPed(-1),bone, 0.0,0.0,0.0,0.0,0.0,0.0,1,1,0,0,2,1) 
end

-- @function Phone.removePhoneFromPed(Entity ped)
-- Detach and delete phone from given entity
Phone.removePhoneFromPed = function(ped)
    if (IsPedDeadOrDying(ped)) then return end
    if (not Phone[ped]) then return end
    DetachEntity(Phone[ped],false,false)
    DeleteEntity(Phone[ped])
    DeleteObject(Phone[ped])
    Phone[ped] = nil
    ClearPedTasksImmediately(PlayerPedId())
end
-- Notifications methods

-- @function Notifications.init
-- Register Text Entries for client
Notifications.init = function()
    AddTextEntry("ctos_person","Works at ~a~\n~w~Age: ~b~~a~\n~w~Income: ~b~$~a~")
    AddTextEntry("ctos_vehicle","Model: ~b~~a~\n~w~Plate: ~b~~a~")
end

-- @function ctOS.showPersonProfile(Array data)
-- Show Notification above map filled with informations about selected Entity (ped)

ctOS.showPersonProfile = function(data)
    if (not LOCAL_PEDS[data.netID]) then
        LOCAL_PEDS[data.netID] = data
    end
    local handle = RegisterPedheadshot(NetworkGetEntityFromNetworkId(data.netID))
    while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
        Citizen.Wait(500)
    end
    local txd = GetPedheadshotTxdString(handle)
    BeginTextCommandThefeedPost("ctos_person")
    AddTextComponentString(tostring(data.work))
    AddTextComponentString(tostring(data.age)) -- age
    AddTextComponentString(tostring(data.income)) -- income
    EndTextCommandThefeedPostMessagetext(txd,txd,false,0,data.fName..", "..data.lName,data.fact)
    EndTextCommandThefeedPostTicker(true,true)
    UnregisterPedheadshot(handle)
end

-- @function ctOS.showVehicleProfile(Array data)
-- Show Notification above map filled with informations about selected Entity (vehicle)
ctOS.showVehicleProfile = function(data)
    if (not data) then return end
    BeginTextCommandThefeedPost("ctos_vehicle")
    AddTextComponentString(tostring(data.modelName))
    AddTextComponentString(tostring(data.plate))
    EndTextCommandThefeedPostMessagetext("CHAR_CARSITE","CHAR_CARSITE",false,0,"Vehicle information","")
    EndTextCommandThefeedPostTicker(true,true)
end
-- @function ctOS.initPersonProfile(Array data)
-- Used to load ped profile, if profile doesn't exist it will call server for generating data
ctOS.initPersonProfile = function(data)
    local data = data
    if (not LOCAL_PEDS[data.netID]) then
        TriggerServerEvent("ctos_getPedData",data)
    else
        ctOS.showPersonProfile(LOCAL_PEDS[data.netID])
    end
end

-- @function ctOS.initVehicleProfile(Array data)
-- Used to show vehicle profile for given data
ctOS.initVehicleProfile = function(data)
    if (not LOCAL_VEHS[data.element]) then
        LOCAL_VEHS[data.element] = {
            modelName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(data.element))),
            plate = GetVehicleNumberPlateText(data.element),
        }
    end
    ctOS.showVehicleProfile(LOCAL_VEHS[data.element])
end
RegisterNetEvent("ctos_client_returnPedData")
AddEventHandler("ctos_client_returnPedData",ctOS.showPersonProfile)
