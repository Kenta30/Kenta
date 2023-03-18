local DISCORD_WEBHOOK = ''
local DISCORD_NAME = ""
local STEAM_KEY = ""
local DISCORD_IMAGE = "https://i.imgur.com/nOwaI24.png"


RegisterCommand("ck", function(source, args, rawCommand)
	if source ~= 0 then
		local source = source
  		local xPlayer = ESX.GetPlayerFromId(source)
  		if havePermission(xPlayer) then
    		  if args[1] and tonumber(args[1]) then
      			local targetId = tonumber(args[1])
      			local xTarget = ESX.GetPlayerFromId(targetId)
      			if xTarget then
                                local identifier = ESX.GetIdentifier(targetId)
                                DropPlayer(xTarget.source, 'CK Sikeres')
                                CreateThread(function()
                                    Wait(200)
                                    exports.oxmysql:execute('DELETE FROM users WHERE identifier = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM owned_vehicles WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM user_documents WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM addon_inventory_items WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM datastore_data WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM user_licenses WHERE owner = ?', { identifier })
				    exports.oxmysql:execute('DELETE FROM phone_users_contacts WHERE identifier = ?', { identifier })
				    exports.oxmysql:execute('DELETE FROM billing WHERE identifier = ?', { identifier })
	                            xPlayer.showNotification('CK sikeres')
                                    print('Ck sikeres')
                                    sendToDiscord('CK', 'Admin License: ' ..xPlayer.identifier.. '\n Admin: ' ..xPlayer.name.. '\n Törlés: ' ..xTarget.identifier.. '\n Név: ' ..xTarget.getName())
                                end)
    		        else
	                        xPlayer.showNotification('Nem található játékos')
                                print('Ck sikertelen')
    		        end
                  end
                else
	                xPlayer.showNotification('Nincs hozzá jogosultságod')
                end
	end 
end, false)

RegisterCommand("ckoffline", function(source, args, rawCommand)
	if source ~= 0 then
        if args ~= "" then
	   local source = source
  	   local xPlayer = ESX.GetPlayerFromId(source)
  	   if havePermission(xPlayer) then
	        MySQL.query('SELECT * FROM users WHERE identifier = ?', {args}, function(result)
		      if result[1] then
                                local identifier = args
                                CreateThread(function()
                                    Wait(200)
                                    exports.oxmysql:execute('DELETE FROM users WHERE identifier = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM owned_vehicles WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM user_documents WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM addon_inventory_items WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM datastore_data WHERE owner = ?', { identifier })
                                    exports.oxmysql:execute('DELETE FROM user_licenses WHERE owner = ?', { identifier })
				    exports.oxmysql:execute('DELETE FROM phone_users_contacts WHERE identifier = ?', { identifier })
				    exports.oxmysql:execute('DELETE FROM billing WHERE identifier = ?', { identifier })
	                            xPlayer.showNotification('CK sikeres')
                                    print('Ck sikeres')
                                    sendToDiscord('CK Offline', 'Admin License: '.. xPlayer.identifier .. '\n Admin: ' ..GetPlayerName(source).. '\n Törölt license: ' ..args[1])
                                end)
    		      else
	                        xPlayer.showNotification('Nem található játékos')
				print('Ck sikertelen')
    		      end
                end)
	   else
	              xPlayer.showNotification('Nincs hozzá jogosultságod')
           end
        end
	end 
end, false)

function havePermission(xPlayer, exclude)
	if exclude and type(exclude) ~= 'table' then exclude = nil;print("^3[esx_characterkill] ^1ERROR ^0exclude argument is not table..^0") end

	local playerGroup = xPlayer.getGroup()
	for k,v in pairs(Config.adminRangok) do
		if v == playerGroup then
			if not exclude then
				return true
			else
				for a,b in pairs(exclude) do
					if b == v then
						return false
					end
				end
				return true
			end
		end
	end
	return false
end

function sendToDiscord(name, message, color)
  local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "",
            },
        }
    }
  PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end
