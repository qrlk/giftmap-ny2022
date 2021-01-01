script_name("giftmap")
script_author("Serhiy_Rubin", "qrlk")
script_properties("work-in-pause")
require "lib.sampfuncs"
require "lib.moonloader"
local sampev = require "lib.samp.events"
local inicfg = require "inicfg"
local map, checkpoints = {}, {}

gift, wh = {}, false

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(0)
    end

    sampRegisterChatCommand(
        "giftmap",
        function()
            wh = not wh

            if not wh then
                if map_ico ~= nil then
                    for id, data in pairs(map_ico) do
                        removeBlip(map[id])
                        deleteCheckpoint(checkpoints[id])
                    end
                    map, checkpoints = {}, {}
                end
            end

            local count = 0
            for k, v in pairs(map_ico) do
                count = count + 1
            end

            printStringNow((wh and "ON, DB: " .. count .. "/90" or "OFF, DB: " .. count .. "/90"), 1000)
        end
    )

    map_ico = inicfg.load({}, "gift")
    inicfg.save(map_ico, "gift")

    while true do
        wait(100)
        if wh then
            for key, coord in pairs(map_ico) do
                local x, y, z = getCharCoordinates(PLAYER_PED)
                local distance = getDistanceBetweenCoords2d(coord.x, coord.y, x, y)
                if not isPauseMenuActive() then
                    if distance < 400 then
                        if map[key] == nil then
                            map[key] = addBlipForCoord(coord.x, coord.y, coord.z)
                            checkpoints[key] =
                                createCheckpoint(1, coord.x, coord.y, coord.z, coord.x, coord.y, coord.z, 5)
                        end
                        if distance < 200 then
                            changeBlipScale(map[key], 5)
                            if findAllRandomCharsInSphere(coord.x, coord.y, coord.z, 5, false, true) then
								if isAnyPickupAtCoords(coord.x, coord.y, coord.z) then
									changeBlipColour(map[key], 0x00FFFFFF)
								else
									changeBlipColour(map[key], 0xFF0000FF)
								end
                            else
								if isAnyPickupAtCoords(coord.x, coord.y, coord.z) then
									changeBlipColour(map[key], 0x00FF00FF)
								else
									changeBlipColour(map[key], 0xFF0000FF)
								end
                                changeBlipColour(map[key], 0x00FF00FF)
                            end
                        else
                            changeBlipScale(map[key], 2)
                            changeBlipColour(map[key], 0xFFFFFFFF)
                        end
                    else
                        if map[key] ~= nil then
                            removeBlip(map[key])
                            map[key] = nil

                            deleteCheckpoint(checkpoints[key])
                            checkpoints[key] = nil
                        end
                    end
                else
                    if map[key] == nil then
                        map[key] = addBlipForCoord(coord.x, coord.y, coord.z)
                        checkpoints[key] = createCheckpoint(1, coord.x, coord.y, coord.z, coord.x, coord.y, coord.z, 5)
                        changeBlipScale(map[key], 2)
                        changeBlipColour(map[key], 0xFFFFFFFF)
                    end
                end
            end
        end
    end
end

function sampev.onCreatePickup(id, model, pickupType, pos)
    if model == 19055 or model == 19058 or model == 19057 or model == 19056 or model == 19054 then
        gift[id] = string.format("%d%d%d", pos.x, pos.y, pos.z)
        if map_ico[gift[id]] == nil then
            map_ico[gift[id]] = {x = pos.x, y = pos.y, z = pos.z}
            inicfg.save(map_ico, "gift")
        end
    end
end

function onScriptTerminate()
    if map_ico ~= nil then
        for id, data in pairs(map_ico) do
            removeBlip(map[id])
            deleteCheckpoint(checkpoints[id])
        end
    end
end