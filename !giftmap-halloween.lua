require 'lib.moonloader'

script_name("/giftmaph")
script_version("31.10.2021")
script_author("Serhiy_Rubin", "qrlk")
script_properties("work-in-pause")
script_url("https://github.com/qrlk/giftmap-halloween")

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

  -- вырежи тут, если хочешь отключить проверку обновлений
  update("http://qrlk.me/dev/moonloader/giftmap-halloween/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods", "giftmapchangelog")
  openchangelog("giftmapchangelog", "http://qrlk.me/changelog/giftmap-halloween")
  -- вырежи тут, если хочешь отключить проверку обновлений

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
      sampShowDialog(5557, "\t"..chatTag.." by {2f72f7}Serhiy_Rubin{ffffff}, {348cb2}qrlk", "{FF5F5F}Активация{ffffff}:\nВведите {2f72f7}/giftmaph{ffffff}, чтобы включить/выключить скрипт.\n\n{FF5F5F}Event{ffffff}:\nНа карте есть 90 точек, где спавнятся тыквы. Одновременно активны 15/90 тыкв.\nТыквы дают HW coins, их можно менять на призы.\nСейчас скрипт знает о "..count.." / 90 тыквах.\nКогда вы заметите тыкву, она добавится в вашу локальную базу.\n\n{FF5F5F}Как это работает?{ffffff}\nНа радаре появятся метки точек спавна подарков в пределах 600м.\nС помощью чекпоинтов вы сможете сориентироваться.\nВыйдя в меню и открыв карту, вы сможете увидеть все подарки.\n\n{FF5F5F}Важно{ffffff}:\nЕсли точка занята, не надо захватывать её/толпиться на ней.\nЕсли вы займете свободную точку, подарки будут появляться быстрее.\nЗахватив точку силой, вы только замедлите процесс их спавна.\nПодарков на карте всего 15/90, так что нужно занять 76 точек для быстрейшего фарма.\n\n{FF5F5F}Обозначения:{ffffff}\n* Маленькая белая метка - вне зоны прорисовки.\n* Большая красная метка - точка занята игроками.\n* Большая зелёная метка - точка свободна.\n* Большая голубая метка - на точке есть подарок.\n\n{FF5F5F}Синхронизации точек не будет и вот почему{ffffff}:\nЧтобы у админов не было возможности отследить юзеров.\n\n{FF5F5F}Ссылки:{ffffff}\n* https://github.com/qrlk/giftmap-halloween\n* https://vk.com/rubin.mods", "OK")
    end



    printStringNow((wh and "ON, DB: " .. count .. "/90" or "OFF, DB: " .. count .. "/90"), 1000)
  end
  sampRegisterChatCommand(
    "giftmap-h",
    switch
  )

  sampRegisterChatCommand(
    "giftmaph",
    switch
  )

  map_ico = inicfg.load(
    {
      [10542604980469] = {
        x = 1054.2604980469,
        y = 667.39440917969,
        z = 6.8215999603271
      },
      [10643829345703] = {
        x = 1064.3829345703,
        y = -1605.9029541016,
        z = 13.614899635315
      },
      [10845853271484] = {
        x = 1084.5853271484,
        y = 2252.7521972656,
        z = 10.820300102234
      },
      [10946165771484] = {
        x = 1094.6165771484,
        y = -1876.4768066406,
        z = 13.546899795532
      },
      [109798046875] = {
        x = 1097.98046875,
        y = 1685.0634765625,
        z = 6.6328001022339
      },
      [11316096191406] = {
        x = 1131.6096191406,
        y = 1934.3009033203,
        z = 10.820300102234
      },
      [11657855224609] = {
        x = 1165.7855224609,
        y = 1353.3137207031,
        z = 10.921899795532
      },
      [11953638916016] = {
        x = 1195.3638916016,
        y = -889.97149658203,
        z = 43.137599945068
      },
      [123080078125] = {
        x = 1230.80078125,
        y = -1268.2622070313,
        z = 13.517600059509
      },
      [13300426025391] = {
        x = 1330.0426025391,
        y = 1089.77734375,
        z = 14.822199821472
      },
      [13384038085938] = {
        x = 1338.4038085938,
        y = 2079.8713378906,
        z = 14.00030040741
      },
      [13853421630859] = {
        x = 1385.3421630859,
        y = -1464.0867919922,
        z = 13.546899795532
      },
      [14063690185547] = {
        x = 1406.3690185547,
        y = -2194.9353027344,
        z = 13.539099693298
      },
      [14310020751953] = {
        x = -1431.0020751953,
        y = 988.43170166016,
        z = 7.1875
      },
      [14321945800781] = {
        x = 1432.1945800781,
        y = 1366.1315917969,
        z = 10.820300102234
      },
      [15722403564453] = {
        x = 1572.2403564453,
        y = 1681.1552734375,
        z = 14.822199821472
      },
      [15902918701172] = {
        x = -1590.2918701172,
        y = 783.89178466797,
        z = 6.6163997650146
      },
      [16591888427734] = {
        x = 1659.1888427734,
        y = -995.70501708984,
        z = 29.747900009155
      },
      [16876492919922] = {
        x = 1687.6492919922,
        y = -1335.49609375,
        z = 17.437099456787
      },
      [16959821777344] = {
        x = -1695.9821777344,
        y = 429.46029663086,
        z = 7.1875
      },
      [17022270507813] = {
        x = -1702.2270507813,
        y = 1369.4232177734,
        z = 7.1722002029419
      },
      [17515684814453] = {
        x = 1751.5684814453,
        y = 2344.6354980469,
        z = 10.820300102234
      },
      [17519343261719] = {
        x = 1751.9343261719,
        y = 1429.0908203125,
        z = 10.820300102234
      },
      [17982034912109] = {
        x = -1798.2034912109,
        y = 753.38751220703,
        z = 24.890600204468
      },
      [181868359375] = {
        x = -1818.68359375,
        y = 1146.6304931641,
        z = 45.452201843262
      },
      [18386323242188] = {
        x = -1838.6323242188,
        y = -73,
        z = 15.109399795532
      },
      [18536171875] = {
        x = 1853.6171875,
        y = 2381.201171875,
        z = 10.979900360107
      },
      [18594056396484] = {
        x = 1859.4056396484,
        y = -1572.9185791016,
        z = 13.625699996948
      },
      [18641501464844] = {
        x = 1864.1501464844,
        y = -1861.6173095703,
        z = 13.581700325012
      },
      [18818182373047] = {
        x = 1881.8182373047,
        y = 1012.6522216797,
        z = 10.820300102234
      },
      [18836663818359] = {
        x = -1883.6663818359,
        y = -650.38659667969,
        z = 24.593799591064
      },
      [18875124511719] = {
        x = 1887.5124511719,
        y = -1362.8204345703,
        z = 13.54909992218
      },
      [18989802246094] = {
        x = -1898.9802246094,
        y = 501.48040771484,
        z = 35.171901702881
      },
      [19054018554688] = {
        x = -1905.4018554688,
        y = 302.7001953125,
        z = 41.046901702881
      },
      [19409119873047] = {
        x = -1940.9119873047,
        y = 708.13732910156,
        z = 46.5625
      },
      [19447525634766] = {
        x = 1944.7525634766,
        y = 2779.0915527344,
        z = 10.820300102234
      },
      [19466696777344] = {
        x = -1946.6696777344,
        y = 884.29107666016,
        z = 38.507801055908
      },
      [19555513916016] = {
        x = 1955.5513916016,
        y = 741.58221435547,
        z = 14.273400306702
      },
      [19693957519531] = {
        x = 1969.3957519531,
        y = -1235.6829833984,
        z = 20.053899765015
      },
      [19750806884766] = {
        x = 1975.0806884766,
        y = 2061.3962402344,
        z = 10.820300102234
      },
      [19858507080078] = {
        x = 1985.8507080078,
        y = -2136.1882324219,
        z = 13.546899795532
      },
      [19871030273438] = {
        x = 1987.1030273438,
        y = 1802.1163330078,
        z = 12.078300476074
      },
      [20067614746094] = {
        x = 2006.7614746094,
        y = 2322.2897949219,
        z = 10.820300102234
      },
      [20480705566406] = {
        x = -2048.0705566406,
        y = 773.091796875,
        z = 60.625
      },
      [20794016113281] = {
        x = -2079.4016113281,
        y = 1067.9931640625,
        z = 65.565803527832
      },
      [21314768066406] = {
        x = -2131.4768066406,
        y = 159.08009338379,
        z = 35.317199707031
      },
      [21533833007813] = {
        x = 2153.3833007813,
        y = -1348.35546875,
        z = 25.539100646973
      },
      [21974020996094] = {
        x = 2197.4020996094,
        y = 941.10540771484,
        z = 10.820300102234
      },
      [22008330078125] = {
        x = -2200.8330078125,
        y = 605.45812988281,
        z = 35.164100646973
      },
      [22044326171875] = {
        x = -2204.4326171875,
        y = 958.79888916016,
        z = 80
      },
      [22486613769531] = {
        x = 2248.6613769531,
        y = 1746.9122314453,
        z = 10.820300102234
      },
      [22540864257813] = {
        x = 2254.0864257813,
        y = -1704.7490234375,
        z = 17.609199523926
      },
      [22606015625] = {
        x = 2260.6015625,
        y = 1399.6184082031,
        z = 17.218799591064
      },
      [22663098144531] = {
        x = 2266.3098144531,
        y = -1027.9636230469,
        z = 59.284698486328
      },
      [2269748046875] = {
        x = 2269.748046875,
        y = -2263.3579101563,
        z = 14.764699935913
      },
      [22751625976563] = {
        x = 2275.1625976563,
        y = 2037.6953125,
        z = 10.820300102234
      },
      [22941296386719] = {
        x = 2294.1296386719,
        y = 546.77899169922,
        z = 1.7943999767303
      },
      [23693513183594] = {
        x = 2369.3513183594,
        y = -2175.3039550781,
        z = 24.305000305176
      },
      [23802534179688] = {
        x = 2380.2534179688,
        y = -1906.4975585938,
        z = 13.546899795532
      },
      [23843745117188] = {
        x = 2384.3745117188,
        y = -1186.0891113281,
        z = 36.882801055908
      },
      [24065732421875] = {
        x = 2406.5732421875,
        y = 2529.9387207031,
        z = 10.820300102234
      },
      [24507395019531] = {
        x = -2450.7395019531,
        y = 977.12109375,
        z = 45.296901702881
      },
      [24585153808594] = {
        x = -2458.5153808594,
        y = -94.240501403809,
        z = 25.990900039673
      },
      [24765139160156] = {
        x = 2476.5139160156,
        y = -1537.13671875,
        z = 29.09289932251
      },
      [24902041015625] = {
        x = -2490.2041015625,
        y = 381.99499511719,
        z = 27.765600204468
      },
      [25091290283203] = {
        x = 250.91290283203,
        y = -1471.5588378906,
        z = 23.71369934082
      },
      [25126628417969] = {
        x = -2512.6628417969,
        y = 770.29681396484,
        z = 35.171901702881
      },
      [25141513671875] = {
        x = -2514.1513671875,
        y = 134.67349243164,
        z = 22.273399353027
      },
      [25416411132813] = {
        x = 2541.6411132813,
        y = 2854.0698242188,
        z = 10.820300102234
      },
      [25468083496094] = {
        x = -2546.8083496094,
        y = 1215.9879150391,
        z = 37.421901702881
      },
      [25589047851563] = {
        x = -2558.9047851563,
        y = 979.09613037109,
        z = 78.322601318359
      },
      [26400825195313] = {
        x = 2640.0825195313,
        y = 2384.1162109375,
        z = 10.820300102234
      },
      [26515932617188] = {
        x = 2651.5932617188,
        y = 807.27191162109,
        z = 5.3158001899719
      },
      [26654086914063] = {
        x = -2665.4086914063,
        y = 1262.1973876953,
        z = 16.997800827026
      },
      [26993583984375] = {
        x = 2699.3583984375,
        y = -2143.3681640625,
        z = 13.548800468445
      },
      [27496691894531] = {
        x = -2749.6691894531,
        y = 198.91499328613,
        z = 7.0917000770569
      },
      [27626865234375] = {
        x = -2762.6865234375,
        y = 764.21228027344,
        z = 52.781299591064
      },
      [27720747070313] = {
        x = -2772.0747070313,
        y = -48.828899383545,
        z = 7.1875
      },
      [27893449707031] = {
        x = 2789.3449707031,
        y = -1077.2036132813,
        z = 30.718799591064
      },
      [27947082519531] = {
        x = 2794.7082519531,
        y = 2228.060546875,
        z = 10.820300102234
      },
      [28020349121094] = {
        x = -2802.0349121094,
        y = 375.57308959961,
        z = 6.3343000411987
      },
      [28197189941406] = {
        x = 2819.7189941406,
        y = -1464.7370605469,
        z = 20.218799591064
      },
      [28276623535156] = {
        x = -2827.6623535156,
        y = 1134.0517578125,
        z = 25.97080039978
      },
      [28432121582031] = {
        x = 2843.2121582031,
        y = 1634.8486328125,
        z = 10.820300102234
      },
      [28781076660156] = {
        x = 2878.1076660156,
        y = -1877.7054443359,
        z = 8.8022003173828
      },
      [70162847900391] = {
        x = 701.62847900391,
        y = -1199.6973876953,
        z = 15.286700248718
      },
      [72127349853516] = {
        x = 721.27349853516,
        y = -1296.3836669922,
        z = 17.648399353027
      },
      [87109832763672] = {
        x = 871.09832763672,
        y = 1975.5882568359,
        z = 11.460900306702
      },
      [94021252441406] = {
        x = 940.21252441406,
        y = -1086.5916748047,
        z = 24.296199798584
      },
      [95057971191406] = {
        x = 950.57971191406,
        y = -1430.056640625,
        z = 16.835899353027
      }
  }, "giftmap-halloween-final")

  --print(require'inspect'(map_ico))

  inicfg.save(map_ico, "giftmap-halloween-final")

  sampAddChatMessage((chatTag.." by {2f72f7}Serhiy_Rubin{ffffff} & {348cb2}qrlk{ffffff} successfully loaded!"), - 1)

  while true do
    wait(100)
    if wh then
      for key, coord in pairs(map_ico) do
        local x, y, z = getCharCoordinates(PLAYER_PED)
        local distance = getDistanceBetweenCoords2d(coord.x, coord.y, x, y)
        if not isPauseMenuActive() then
          if distance < 600 then
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
  if model == 19320 then
    gift_string = string.gsub(tostring(math.abs(pos.x)), "%.", "")
		gift_string = math.modf(tonumber(gift_string),10)
    gift[id] = gift_string
    if map_ico[gift[id]] == nil then
      local message = {
        gift_string = gift_string,
        x = pos.x,
        y = pos.y,
        z = pos.z,
      }
      if wh then
        addOneOffSound(0.0, 0.0, 0.0, 1139)
      end
      downloadUrlToFile("http://qrlk.me:1662/"..encodeJson(message))
      map_ico[gift[id]] = {x = pos.x, y = pos.y, z = pos.z}
      inicfg.save(map_ico, "giftmap-halloween-final")
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
