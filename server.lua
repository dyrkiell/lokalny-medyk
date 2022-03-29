
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cenaLeczenia = 1000

RegisterNetEvent('dyrkiel:log')
AddEventHandler('dyrkiel:log', function()
	local _source      = source
    local xPlayer      = ESX.GetPlayerFromId(_source)
    local identifiers = getIdentifiers(source)
    local discordID = "\n**Discord:** <@" .. identifiers.discord .. ">"
		wyslijlogbaska('Dyrkiel - Baśka', '**Gracz:** ' .. '[' .. source .. '] ' .. GetPlayerName(source) .. '\n**Hex:** ' .. GetPlayerIdentifier(source) .. ''.. discordID ..'\n**Zapłacił:** ' .. cenaLeczenia .. '$', 5763719)
end)

ESX.RegisterServerCallback('esx_baska:kupLeczenie', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source

	local result = MySQL.Sync.fetchAll("SELECT * FROM user_licenses WHERE type = @type and owner = @owner",
    {
      ['@owner']   = xPlayer.identifier,
	  ['@type'] = 'ems_insurance',

    })


	if result[1] ~= nil then
		TriggerClientEvent('esx:showNotification', _source, '~g~Posiadasz Ubezpieczenie NW wiec nie placisz za leczenie')
		cb(false)
	else
		if xPlayer.getMoney() >= cenaLeczenia then
			xPlayer.removeMoney(cenaLeczenia)
			TriggerClientEvent('esx:showNotification', source, 'Zapłaciłeś za leczenie ~g~$'..cenaLeczenia)
			cb(true)
		end
	end
end)

function getIdentifiers(player)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(player) - 1 do
        local raw = GetPlayerIdentifier(player, i)
        local tag, value = raw:match("^([^:]+):(.+)$")
        if tag and value then
            identifiers[tag] = value
        end
    end
    return identifiers
end

function wyslijlogbaska (name,message,color)
    local date = os.date('*t')
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
  
  local embeds = {
    {
          ["title"] = 'DyrkielBaśka',
		  ["description"]=message,
          ["type"]="rich",
          ["color"] =color,
          ["footer"]=  {
              ["text"]= "" ..date.."",
             
         },
    }
}
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(Config.Baskalogi, function(...)end, 'POST', json.encode({ username = name,embeds = embeds,avatar_url = Config.Avatarwebhoka}), { ['Content-Type'] = 'application/json' })
end
