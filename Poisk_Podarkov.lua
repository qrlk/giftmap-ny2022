script_name('Поиск_Подарков')
script_author("Serhiy_Rubin")
script_properties("work-in-pause")
require 'lib.sampfuncs'
require 'lib.moonloader'
local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local cook, sleep, arenda, gift, time, wh, auto = false, 400, false, {}, os.clock() * 1000, false, false
local map = {}

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(0) end
	sampRegisterChatCommand('gift', function()
		wh = not wh
		printStringNow((wh and 'ON' or 'OFF'), 1000)
	end)
	map_ico = inicfg.load({ })
	inicfg.save(map_ico)
	while true do
		wait(0)
		if wh then
			for key, coord in pairs(map_ico) do
				local x, y, z = getCharCoordinates(PLAYER_PED)
				local distance = getDistanceBetweenCoords2d(coord.x, coord.y, x, y)
				if not isPauseMenuActive() then
					if distance < 400 then
						if map[key] == nil then
							map[key] = addBlipForCoord(coord.x, coord.y, coord.z)
							changeBlipScale(map[key], 2)
							changeBlipColour(map[key], (coord.new and 0xFF2138eb or 0xFFFFFFFF))
						end
					else
						if map[key] ~= nil then
							removeBlip(map[key])
							map[key] = nil
						end
					end
				else
					if map[key] == nil then
						map[key] = addBlipForCoord(coord.x, coord.y, coord.z)
						changeBlipScale(map[key], 2)
						changeBlipColour(map[key], 0xFF2138eb)
					end
				end
			end
		end
	end
end


function sampev.onCreatePickup(id, model, pickupType, pos)
	if model == 19055 or model == 19058 or model == 19057 or model == 19056 or model == 19054 then
		gift[id] = string.format('%d%d%d', pos.x, pos.y, pos.z)
		if map_ico[gift[id]] == nil then
			map_ico[gift[id]] = { x = pos.x, y = pos.y, z = pos.z, new = true }
			inicfg.save(map_ico)
		else
			map_ico[gift[id]].new = true
			inicfg.save(map_ico)		
		end
		if map[gift[id]] ~= nil then
			changeBlipColour(map[gift[id]], (map_ico[gift[id]].new and 0xFF2138eb or 0xFFFFFFFF))
		end
	end
end

function sampev.onDestroyPickup(id)
	if gift[id] ~= nil then
		map_ico[gift[id]].new = false
		inicfg.save(map_ico)
		if map[gift[id]] ~= nil then
			changeBlipColour(map[gift[id]], (map_ico[gift[id]].new and 0xFF2138eb or 0xFFFFFFFF))
		end
		gift[id] = nil
	end
end

function isKeyCheckAvailable()
	if not isSampfuncsLoaded() then
		return true
	end
	return not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive()
end

function onScriptTerminate()
	if map_ico ~= nil then
		for id,data in pairs(map_ico) do
			removeBlip(map[id])
		end
	end
end