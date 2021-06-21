PEDS = {}
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
-- @function ctos_createPed(NetID ped, PedType gender)
-- Assign random data from config files to given NetID (Ped)
function ctos_createPed(ped,gender)
    local sex = "male"
    if (gender == 5) then
        sex = "female"
    end
    PEDS[ped] = {
        netID = ped, 
        fName = string.gsub(Config.import.firstNames[sex][math.random(1,#Config.import.firstNames[sex])],"[\n\r]",""),
        lName = string.gsub(Config.import.lastNames[math.random(1,#Config.import.lastNames)],"[\n\r]",""),
        gender = sex,
        age = math.random(Config.peds.minAge,Config.peds.maxAge),
        income = math.random(Config.peds.minIncome, Config.peds.maxIncome),
        work = string.gsub(Config.import.workplaces[math.random(1,#Config.import.workplaces)],"[\n\r]",""),
        fact = string.gsub(Config.import.facts[math.random(1,#Config.import.facts)],"[\n\r]","")
    }
end
-- @function ctos_getPed(Array ped)
-- Return ped data to client, if data doesn't exist - it will generate new data set
function ctos_getPed(ped)
    local source = source
    if (not PEDS[ped.netID]) then
        ctos_createPed(ped.netID,ped.elementType)
    end
    TriggerClientEvent("ctos_client_returnPedData",source,PEDS[ped.netID])
end

-- @function ctos_injectBankAccount(netID pedID)
-- Give player (source) cash for hacking ped bank account
function ctos_injectBankAccount(pedID)
    local source = source
    if (PEDS[pedID].hacked) then return end
    PEDS[pedID].hacked = true
    local givenMoney = round(math.random(Config.peds.minHackCash,Config.peds.maxHackCash)/Config.peds.divHackCash,0)

    -- Here insert code for adding money to player (source)
    -- I dont want to use natives like StatSetInt because its kinda risky,
    -- So if you wanna use it on public server add here code from framework u are using
    -- or implement your own money script :)
    -- After you save player money use trigger under this comment to inform player 
    -- about amount of money that he was given or use ur own notification system for that

    TriggerClientEvent("ctos_client_showNotification",source,givenMoney)
end
-- @function printError(String message)
-- Print error message in server console
function printError(message)
    print(string.format("^8[ctOS] %s",message))
end

-- @function ctos_starutp(String resname)
-- Called on resource start, it will load all config files from config directory
function ctos_startup(resname)
    if (GetCurrentResourceName() ~= resname) then return end

    print("^2[ctOS] Loading Config...")

    local lastNamesFile = LoadResourceFile(GetCurrentResourceName(), "config/last-names.txt")
    if (not lastNamesFile) then
        printError("Can't find config/last-names.txt file.\nResource will be not working correctly.")
    end
    local firstNamesFemaleFile = LoadResourceFile(GetCurrentResourceName(), "config/female-first-names.txt")
    if (not firstNamesFemaleFile) then
        printError("Can't find config/female-first-names.txt file.\nResource will be not working correctly.")
    end
    local firstNamesMaleFile = LoadResourceFile(GetCurrentResourceName(), "config/male-first-names.txt")
    if (not firstNamesFemaleFile) then
        printError("Can't find config/male-first-names.txt file.\nResource will be not working correctly.")
    end
    local workplacesFile = LoadResourceFile(GetCurrentResourceName(), "config/workplaces.txt")
    if (not workplacesFile) then
        printError("Can't find config/workplaces.txt file.\nResource will be not working correctly.")
    end
    local factsFile = LoadResourceFile(GetCurrentResourceName(), "config/facts.txt")
    if (not factsFile) then
        printError("Can't find config/facts.txt file.\nResource will be not working correctly.")
    end
    local firstNamesFemaleLines = stringsplit(firstNamesFemaleFile, "\n")
    local firstNamesMaleLines = stringsplit(firstNamesMaleFile, "\n")
    local lastNamesLines = stringsplit(lastNamesFile,"\n")
    local workplacesLines = stringsplit(workplacesFile,"\n")
    local factsLines = stringsplit(factsFile,"\n")
    for i,v in ipairs(lastNamesLines) do
        table.insert(Config.import.lastNames,v)
    end
    for i,v in ipairs(firstNamesMaleLines) do
        table.insert(Config.import.firstNames['male'],v)
    end
    for i,v in ipairs(firstNamesFemaleLines) do
        table.insert(Config.import.firstNames['female'],v)
    end
    for i,v in ipairs(workplacesLines) do
        table.insert(Config.import.workplaces,v)
    end
    for i,v in ipairs(factsLines) do
        table.insert(Config.import.facts, v)
    end
end

AddEventHandler("onResourceStart",ctos_startup)

RegisterNetEvent("ctos_getPedData")
AddEventHandler("ctos_getPedData",ctos_getPed)

RegisterNetEvent("ctos_injectBankAccount")
AddEventHandler("ctos_injectBankAccount",ctos_injectBankAccount)
