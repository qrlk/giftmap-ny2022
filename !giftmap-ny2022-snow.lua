require 'lib.moonloader'

script_name("/giftmap-ny2022-gift")
script_version("31.10.2022-final")
script_author("Serhiy_Rubin", "qrlk")
script_properties("work-in-pause")
script_url("https://github.com/qrlk/giftmap-ny2022")

local sampev = require "lib.samp.events"
local inicfg = require "inicfg"
local map, checkpoints = {}, {}
local gift, wh = {}, false

local chatTag = "{FF5F5F}"..thisScript().name.."{ffffff}"

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then
    return
  end
  while not isSampAvailable() do
    wait(0)
  end

  ---- вырежи тут, если хочешь отключить проверку обновлений
  --update("http://qrlk.me/dev/moonloader/giftmap-ny2022-gift/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods", "giftmapchangelog")
  --openchangelog("giftmapchangelog", "http://qrlk.me/changelog/giftmap-halloween")
  ---- вырежи тут, если хочешь отключить проверку обновлений


  serverAddress = sampGetCurrentServerAddress()

  function switch()
    wh = not wh
    local count = 0
    for k, v in pairs(map_ico) do
      count = count + 1
    end
    if not wh then
      if map_ico ~= nil then
        for id, data in pairs(map_ico) do
          removeBlip(map[id])
          deleteCheckpoint(checkpoints[id])
        end
        map, checkpoints = {}, {}
      end
    else
      sampShowDialog(5557, "\t"..chatTag.." by {2f72f7}Serhiy_Rubin{ffffff}, {348cb2}qrlk", "{FF5F5F}Активация{ffffff}:\nВведите {2f72f7}/giftmap-ny2022-gift{ffffff}, чтобы включить/выключить скрипт.\n\n{FF5F5F}Event{ffffff}:\nНа карте есть точки, где спавнятся подарки. Они спавнятся каждые 60-90 минут.\nПодбирать их можно пройдя какое-то задание и выбрав какую-то линию.\nПодарки дают какие-то монетки, их можно менять на какие-то призы.\nСейчас скрипт знает о "..count.." точках спавна.\nКогда вы заметите подарок, она добавится в вашу локальную базу.\n\n{FF5F5F}Как это работает?{ffffff}\nНа радаре появятся метки точек спавна подарков в пределах 1200м.\nС помощью чекпоинтов вы сможете сориентироваться.\nВыйдя в меню и открыв карту, вы сможете увидеть все подарки.\nЕсли на точке ничего нет/не подбирается, значит, что подарок подобрали и надо ждать пока они респавнятся.\n\n{FF5F5F}Обозначения:{ffffff}\n* Маленькая белая метка - вне зоны прорисовки.\n* Большая красная метка - точка занята игроками.\n* Большая зелёная метка - точка свободна.\n* Большая голубая метка - на точке есть подарок.\n\n{FF5F5F}Синхронизации точек не будет и вот почему{ffffff}:\nЧтобы у админов не было возможности отследить юзеров.\n\n{FF5F5F}Ссылки:{ffffff}\n* https://github.com/qrlk/giftmap-ny2022\n* https://vk.com/rubin.mods", "OK")
    end



    printStringNow((wh and "ON, DB: " .. count  or "OFF, DB: " .. count), 1000)
  end

  sampRegisterChatCommand(
      "giftmap-ny2022-gift",
      switch
  )
  str = [[{"10243544921875": {"x": 1024.3544921875, "y": 2141.6198730469, "z": 10.820300102234}, "15189167480469": {"x": 1518.916748046875, "y": -1452.306640625, "z": 14.203100204467773}, "17656154785156": {"x": 1765.6154785156, "y": 614.95037841797, "z": 10.820300102234}, "19161011962891": {"x": -1916.1011962891, "y": 897.53717041016, "z": 35.414100646973}, "19710637207031": {"x": 1971.0637207031, "y": -1177.1212158203, "z": 20.023399353027}, "19968145751953": {"x": -1996.8145751953, "y": -722.66259765625, "z": 32.171901702881}, "20091549072266": {"x": 2009.1549072266, "y": 2493.9807128906, "z": 10.820300102234}, "26147004394531": {"x": -2614.7004394531, "y": 989.40411376953, "z": 78.285003662109}, "44228158569336": {"x": 442.28158569336, "y": -1301.4577636719, "z": 15.176099777222}}]]

  map_ico = inicfg.load(decodeJson(str), "giftmap-ny2022-gift")

  --print(require'inspect'(map_ico))

  inicfg.save(map_ico, "giftmap-ny2022-gift")

  sampAddChatMessage((chatTag.." by {2f72f7}Serhiy_Rubin{ffffff} & {348cb2}qrlk{ffffff} successfully loaded!"), - 1)

  while true do
    wait(500)
    if wh then
      for key, coord in pairs(map_ico) do
        local x, y, z = getCharCoordinates(PLAYER_PED)
        local distance = getDistanceBetweenCoords2d(coord.x, coord.y, x, y)
        if not isPauseMenuActive() then
          if distance < 1200 then
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
                  changeBlipColour(map[key], 0x00FFFFFF)
                else
                  changeBlipColour(map[key], 0x00FF00FF)
                end
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
            changeBlipColour(map[key], 0xFF2138eb)
          end
        end
      end
    end
  end
end

function sampev.onCreatePickup(id, model, pickupType, pos)
  if serverAddress == '95.181.158.64' or serverAddress == '95.181.158.77' or serverAddress == '95.181.158.69' or serverAddress == '95.181.158.74' then
    local x, y, z = getCharCoordinates(playerPed)
    if model == 19055 or model == 19058 or model == 19057 or model == 19056 or model == 19054 then
      if getDistanceBetweenCoords3d(x, y, z, pos.x, pos.y, pos.z) < 40 then
        print("Обнаружен подарок", model,pos.x, pos.y, pos.z)
        lua_thread.create(
            function()
              local gift_string = string.gsub(tostring(math.abs(pos.x)), "%.", "")
              gift_string = math.modf(tonumber(gift_string), 10)
              gift[id] = gift_string
              if map_ico[gift[id]] == nil then
                local message = {
                  gift_string = gift_string,
                  typ = "gift",
                  x = pos.x,
                  y = pos.y,
                  z = pos.z,
                  rand = os.time()
                }
                if wh then
                  addOneOffSound(0.0, 0.0, 0.0, 1139)
                  downloadUrlToFile("http://qrlk.me:16622/" .. encodeJson(message))

                  map_ico[gift[id]] = {x = pos.x, y = pos.y, z = pos.z}
                  inicfg.save(map_ico, "giftmap-ny2022-gift")
                end
              end
              --print("http://qrlk.me:16622/" .. encodeJson(message))
            end
        )
      end
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
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
--автообновление в обмен на статистику использования
function update(php, prefix, url, komanda)
  komandaA = komanda
  local dlstatus = require("moonloader").download_status
  local json = getWorkingDirectory() .. "\\" .. thisScript().name .. "-version.json"
  if doesFileExist(json) then
    os.remove(json)
  end
  local ffi = require "ffi"
  ffi.cdef [[
      int __stdcall GetVolumeInformationA(
              const char* lpRootPathName,
              char* lpVolumeNameBuffer,
              uint32_t nVolumeNameSize,
              uint32_t* lpVolumeSerialNumber,
              uint32_t* lpMaximumComponentLength,
              uint32_t* lpFileSystemFlags,
              char* lpFileSystemNameBuffer,
              uint32_t nFileSystemNameSize
      );
      ]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  serial = serial[0]
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  if thisScript().name == "ADBLOCK" then
    if mode == nil then
      mode = "unsupported"
    end
    php =
    php ..
        "?id=" ..
        serial ..
        "&n=" ..
        nickname ..
        "&i=" ..
        sampGetCurrentServerAddress() ..
        "&m=" .. mode .. "&v=" .. getMoonloaderVersion() .. "&sv=" .. thisScript().version
  elseif thisScript().name == "pisser" then
    php =
    php ..
        "?id=" ..
        serial ..
        "&n=" ..
        nickname ..
        "&i=" ..
        sampGetCurrentServerAddress() ..
        "&m=" ..
        tostring(data.options.stats) ..
        "&v=" .. getMoonloaderVersion() .. "&sv=" .. thisScript().version
  else
    php =
    php ..
        "?id=" ..
        serial ..
        "&n=" ..
        nickname ..
        "&i=" ..
        sampGetCurrentServerAddress() ..
        "&v=" .. getMoonloaderVersion() .. "&sv=" .. thisScript().version
  end
  downloadUrlToFile(
      php,
      json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, "r")
            if f then
              local info = decodeJson(f:read("*a"))
              if info.stats ~= nil then
                stats = info.stats
              end
              updatelink = info.updateurl
              updateversion = info.latest
              if info.changelog ~= nil then
                changelogurl = info.changelog
              end
              f:close()
              os.remove(json)
              if updateversion ~= thisScript().version then
                lua_thread.create(
                    function(prefix, komanda)
                      local dlstatus = require("moonloader").download_status
                      local color = -1
                      sampAddChatMessage(
                          (prefix ..
                              "Обнаружено обновление. Пытаюсь обновиться c " ..
                              thisScript().version .. " на " .. updateversion),
                          color
                      )
                      wait(250)
                      downloadUrlToFile(
                          updatelink,
                          thisScript().path,
                          function(id3, status1, p13, p23)
                            if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                              print(string.format("Загружено %d из %d.", p13, p23))
                            elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                              print("Загрузка обновления завершена.")
                              if komandaA ~= nil then
                                sampAddChatMessage(
                                    (prefix ..
                                        "Обновление завершено! Подробнее об обновлении - /" ..
                                        komandaA .. "."),
                                    color
                                )
                              end
                              goupdatestatus = true
                              lua_thread.create(
                                  function()
                                    wait(500)
                                    thisScript():reload()
                                  end
                              )
                            end
                            if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                              if goupdatestatus == nil then
                                sampAddChatMessage(
                                    (prefix ..
                                        "Обновление прошло неудачно. Запускаю устаревшую версию.."),
                                    color
                                )
                                update = false
                              end
                            end
                          end
                      )
                    end,
                    prefix
                )
              else
                update = false
                print("v" .. thisScript().version .. ": Обновление не требуется.")
              end
            end
          else
            print(
                "v" ..
                    thisScript().version ..
                    ": Не могу проверить обновление. Смиритесь или проверьте самостоятельно на " .. url
            )
            update = false
          end
        end
      end
  )
  while update ~= false do
    wait(100)
  end
end

function openchangelog(komanda, url)
  sampRegisterChatCommand(
      komanda,
      function()
        lua_thread.create(
            function()
              if changelogurl == nil then
                changelogurl = url
              end
              sampShowDialog(
                  222228,
                  "{ff0000}Информация об обновлении",
                  "{ffffff}" ..
                      thisScript().name ..
                      " {ffe600}собирается открыть свой changelog для вас.\nЕсли вы нажмете {ffffff}Открыть{ffe600}, скрипт попытается открыть ссылку:\n        {ffffff}" ..
                      changelogurl ..
                      "\n{ffe600}Если ваша игра крашнется, вы можете открыть эту ссылку сами.",
                  "Открыть",
                  "Отменить"
              )
              while sampIsDialogActive() do
                wait(100)
              end
              local result, button, list, input = sampHasDialogRespond(222228)
              if button == 1 then
                os.execute('explorer "' .. changelogurl .. '"')
              end
            end
        )
      end
  )
end
