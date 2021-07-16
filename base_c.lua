local inTargetingMode = false
local currentTarget = {element=nil,type=nil,showingInformation=false}
LOCAL_PEDS = {}
LOCAL_VEHS = {}

-- @function GetPedInFront()
-- Get Entity(Ped) in front of LocalPlayer
function GetPedInFront()
	local plyPos = GetEntityCoords(PlayerPedId(), false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, Config.range.person, 12, PlayerPedId(), 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

-- @function GetVehicleInFront()
-- Get Entity(Vehicle) in front of LocalPlayer
function GetVehicleInFront()
    local plrPos = GetEntityCoords(PlayerPedId(),false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(plrPos.x, plrPos.y, plrPos.z, plyOffset.x, plyOffset.y, plyOffset.z, Config.range.vehicle, 10, PlayerPedId(),7)
    local _,_,_,_,vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

-- @function GetObjectInFront()
-- Get Entity(Object) in front of LocalPlayer
function GetObjectInFront()
    return nil
end

function HighlightObject(object)
    x, y, z = table.unpack(GetEntityCoords(object, true))
    SetDrawOrigin(x, y, z, 0)
    RequestStreamedTextureDict("helicopterhud", false)
    DrawSprite("helicopterhud", "hud_corner", -0.01, -0.01, 0.006, 0.006, 0.0, 0, 195, 255, 255)
    DrawSprite("helicopterhud", "hud_corner", 0.01, -0.01, 0.006, 0.006, 90.0, 0, 195, 255, 255)
    DrawSprite("helicopterhud", "hud_corner", -0.01, 0.01, 0.006, 0.006, 270.0, 0, 195, 255, 255)
    DrawSprite("helicopterhud", "hud_corner", 0.01, 0.01, 0.006, 0.006, 180.0, 0, 195, 255, 255)
    ClearDrawOrigin()
end
--[[
    Thread for targetting entities
]]--
Citizen.CreateThread(function()
    while true do
        
        if (inTargetingMode == 'ped') then
            local ped = GetPedInFront()
            local pedType = GetPedType(ped)
            if (ped>0) then
                if (not Config.disallowed.pedTypes[pedType]) then
                    local pedID = NetworkGetNetworkIdFromEntity(ped)
                    while pedID < 1 do 
                        pedID = NetworkGetNetworkIdFromEntity(ped)
                    end

                    currentTarget = {element=ped,type='ped',netID=pedID,elementType=pedType}
                    
                    if (currentTarget.type == 'ped' and not LOCAL_PEDS[netID]) then
                        
                        ctOS.initPersonProfile(currentTarget)
                    end
                end
            end
        end
        if (inTargetingMode == 'vehicle') then
            local vehicle = GetVehicleInFront()
            if (vehicle>0 and IsEntityAVehicle(vehicle)) then
                currentTarget = {element=vehicle,type='vehicle',netID=nil}
                if (currentTarget.type == 'vehicle' and not LOCAL_VEHS[vehicle]) then
                    ctOS.initVehicleProfile(currentTarget)
                end
            end
        end
        Citizen.Wait(0)
    end
end)

--[[

    Second Thread only for drawing lines to entities, 

]]--
Citizen.CreateThread(function()
    while true do
        local plrCoords = GetEntityCoords(PlayerPedId())
        local targetCoords = false
        local targetElement = nil
        if (inTargetingMode == 'ped') then
            local ped = GetPedInFront()
            local pedType = GetPedType(ped)
            if (ped>0) then
                if (not Config.disallowed.pedTypes[pedType]) then
                    targetCoords = GetEntityCoords(ped)
                    targetElement = ped
                    Notifications.showHelp("Press ~INPUT_7A535563~ to hack bank account")
                end
            end
        end
        if (inTargetingMode == 'object') then
            local object = GetObjectInFront()
            if (object~=0) then
                targetCoords = GetEntityCoords(object)
                targetElement = object
            end
        end
        if (inTargetingMode == 'vehicle') then
            local vehicle = GetVehicleInFront()
            if (vehicle>0 and IsEntityAVehicle(vehicle)) then
                targetCoords = GetEntityCoords(vehicle)
                targetElement = vehicle
            end
        end

        if (targetCoords and targetElement) then
            DrawLine(plrCoords.x,plrCoords.y,plrCoords.z+0.5,targetCoords.x,targetCoords.y,targetCoords.z,255,255,255,255)
            HighlightObject(targetElement)
        end
        Citizen.Wait(0)
    end
end)

RegisterCommand("+ct_os_bankaccount",function() -- Wired with RegisterKeyMapping
    if (currentTarget.type ~="ped") then return end
    TriggerServerEvent("ctos_injectBankAccount",currentTarget.netID)
end)

RegisterCommand("target",function(_,args)
    local targetMode = string.lower(args[1])
    if (targetMode == "off") then
        inTargetingMode = false
        Phone.removePhoneFromPed(PlayerPedId())
        print("Disabled targetting..")
        return
    end
    if (Config.targettingModes[targetMode]) then
        inTargetingMode = targetMode
        print(string.format("Enabling %s targetting mode..",targetMode))
        Notifications.init()
        Phone.addPhoneToPed(PlayerPedId())
    else
        print("Provided wrong targetting mode")
    end
end)

RegisterKeyMapping("+ct_os_bankaccount","ctOS: Hack bank account of selected person","keyboard","g")