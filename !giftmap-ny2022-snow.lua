require 'lib.moonloader'

script_name("/giftmap-ny2022-snow")
script_version("25.06.2022")
script_author("Serhiy_Rubin", "qrlk")
script_properties("work-in-pause")
script_url("https://github.com/qrlk/giftmap-ny2022")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://cdab6d3dfe424b8190545f25a6feb3b7@o1272228.ingest.sentry.io/6529851" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/giftmap-ny2022/main/version-snow.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/giftmap-ny2022"
    end
  end
end

local sampev = require "lib.samp.events"
local inicfg = require "inicfg"
local map, checkpoints = {}, {}
local gift, wh = {}, false

local chatTag = "{FF5F5F}" .. thisScript().name .. "{ffffff}"

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then
    return
  end
  while not isSampAvailable() do
    wait(0)
  end

  -- вырежи тут, если хочешь отключить проверку обновлений
  if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
  end
  -- вырежи тут, если хочешь отключить проверку обновлений


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
      sampShowDialog(5557, "\t" .. chatTag .. " by {2f72f7}Serhiy_Rubin{ffffff}, {348cb2}qrlk", "{FF5F5F}Активация{ffffff}:\nВведите {2f72f7}/giftmap-ny2022-snow{ffffff}, чтобы включить/выключить скрипт.\n\n{FF5F5F}Event{ffffff}:\nНа карте есть точки, где спавнятся снеговики. Они спавнятся каждые 60-90 минут.\nТочное количество точек спавна не известно, респавнятся они не на всех точках, а на части.\nКогда точку подберут, она пропадёт и нужно ждать респавна.\nПодбирать их начав сюжетную линию 'Дом чёрной линии' (/nygps - [1]).\nСнеговики дают какие-то монетки, их можно менять на призы: аксессуары и мелочь всякую.\nСейчас скрипт знает о " .. count .. " точках спавна.\nКогда вы заметите снеговик, он добавится в вашу локальную базу.\n\n{FF5F5F}Как это работает?{ffffff}\nНа радаре есть.\nС помощью чекпоинтов вы сможете сориентироваться.\nВыйдя в меню и открыв карту, вы сможете увидеть все снеговики.\nЕсли на точке ничего нет/не подбирается, значит, что снеговик подобрали и надо ждать пока они респавнятся.\nЕсли снеговик не подбирается и в чат ничего не пишет, но он есть, это баг (это нормально для срп).\n\n{FF5F5F}Обозначения:{ffffff}\n* Маленькая белая метка - вне зоны прорисовки.\n* Большая красная метка - точка занята игроками.\n* Большая голубая метка - на точке есть снеговик (надо подойти на 25м).\n\n{FF5F5F}Ссылки:{ffffff}\n* https://github.com/qrlk/giftmap-ny2022\n* https://vk.com/rubin.mods", "OK")
      for key, coord in pairs(map_ico) do
        if map[key] == nil then
          map[key] = addBlipForCoord(coord.x, coord.y, coord.z)
          changeBlipScale(map[key], 1)
        end
      end
    end

    printStringNow((wh and "ON, DB: " .. count or "OFF, DB: " .. count), 1000)
  end

  sampRegisterChatCommand(
    "giftmap-ny2022-snow",
    switch
  )

  map_ico = inicfg.load({
    x10618156738281 = {
      x = 1061.8156738281,
      y = 1938.0877685547,
      z = 11.652695655823
    },
    x11076389160156 = {
      x = 1107.6389160156,
      y = -1050.876953125,
      z = 31.874296188354
    },
    x11537053222656 = {
      x = 1153.7053222656,
      y = -2377.1130371094,
      z = 12.354496002197
    },
    x11550653076172 = {
      x = 1155.0653076172,
      y = 1834.9652099609,
      z = 11.590695381165
    },
    x11749951171875 = {
      x = 1174.9951171875,
      y = 1046.7196044922,
      z = 11.66029548645
    },
    x1236009765625 = {
      x = 1236.009765625,
      y = -1923.7003173828,
      z = 32.210296630859
    },
    x12896507568359 = {
      x = 1289.6507568359,
      y = 2196.46484375,
      z = 12.200595855713
    },
    x14272525634766 = {
      x = 1427.2525634766,
      y = 2268.6220703125,
      z = 12.137095451355
    },
    x1437515625 = {
      x = 1437.515625,
      y = 1987.2475585938,
      z = 11.855795860291
    },
    x14478836669922 = {
      x = 1447.8836669922,
      y = 2599.6796875,
      z = 12.012895584106
    },
    x15142000732422 = {
      x = 1514.2000732422,
      y = -2336.6103515625,
      z = 14.379295349121
    },
    x15736665039063 = {
      x = 1573.6665039063,
      y = 2418.1137695313,
      z = 11.652695655823
    },
    x16059542236328 = {
      x = -1605.9542236328,
      y = 810.53497314453,
      z = 7.4417958259583
    },
    x16094976806641 = {
      x = 1609.4976806641,
      y = -1552.12109375,
      z = 14.416095733643
    },
    x16122650146484 = {
      x = -1612.2650146484,
      y = 1262.3055419922,
      z = 7.8792958259583
    },
    x16328168945313 = {
      x = 1632.8168945313,
      y = -951.48822021484,
      z = 33.742198944092
    },
    x16860035400391 = {
      x = 1686.0035400391,
      y = -1366.6007080078,
      z = 18.274194717407
    },
    x16899577636719 = {
      x = 1689.9577636719,
      y = 1944.6916503906,
      z = 11.652695655823
    },
    x16902087402344 = {
      x = 1690.2087402344,
      y = -1127.3674316406,
      z = 25.027395248413
    },
    x17435432128906 = {
      x = 1743.5432128906,
      y = -1768.5711669922,
      z = 14.466095924377
    },
    x17455816650391 = {
      x = 1745.5816650391,
      y = 1292.1767578125,
      z = 11.755095481873
    },
    x17472399902344 = {
      x = 1747.2399902344,
      y = 1610.2017822266,
      z = 10.113195419312
    },
    x17954422607422 = {
      x = 1795.4422607422,
      y = -2179.5881347656,
      z = 14.387095451355
    },
    x18132995605469 = {
      x = 1813.2995605469,
      y = -1946.4128417969,
      z = 14.379295349121
    },
    x18409519042969 = {
      x = 1840.9519042969,
      y = 1475.1389160156,
      z = 11.652695655823
    },
    x18427388916016 = {
      x = 1842.7388916016,
      y = 2297.1203613281,
      z = 11.812295913696
    },
    x18444296875 = {
      x = 1844.4296875,
      y = 2073.34375,
      z = 11.72699546814
    },
    x18607260742188 = {
      x = -1860.7260742188,
      y = -214.2357635498,
      z = 19.209594726563
    },
    x18740317382813 = {
      x = -1874.0317382813,
      y = 135.72734069824,
      z = 27.285495758057
    },
    x18907053222656 = {
      x = 1890.7053222656,
      y = 1111.2684326172,
      z = 11.660195350647
    },
    x18945521240234 = {
      x = 1894.5521240234,
      y = 2680.1496582031,
      z = 11.652695655823
    },
    x18945731201172 = {
      x = 1894.5731201172,
      y = -1570.9226074219,
      z = 14.45289516449
    },
    x19286439208984 = {
      x = 1928.6439208984,
      y = -1358.9818115234,
      z = 16.162696838379
    },
    x19376175537109 = {
      x = 1937.6175537109,
      y = -1082.763671875,
      z = 25.479795455933
    },
    x19435179443359 = {
      x = -1943.5179443359,
      y = -360.81085205078,
      z = 29.236995697021
    },
    x20157054443359 = {
      x = 2015.7054443359,
      y = 2306.5617675781,
      z = 11.652695655823
    },
    x20833439941406 = {
      x = -2083.3439941406,
      y = 482.79092407227,
      z = 36.004299163818
    },
    x2088408203125 = {
      x = 2088.408203125,
      y = 1984.8162841797,
      z = 12.36149597168
    },
    x20940266113281 = {
      x = 2094.0266113281,
      y = 2635.7182617188,
      z = 11.652695655823
    },
    x20964572753906 = {
      x = 2096.4572753906,
      y = 2143.6169433594,
      z = 11.652695655823
    },
    x20990185546875 = {
      x = -2099.0185546875,
      y = 1351.8814697266,
      z = 7.9700961112976
    },
    x2111708984375 = {
      x = 2111.708984375,
      y = -1127.4621582031,
      z = 27.54069519043
    },
    x21230744628906 = {
      x = 2123.0744628906,
      y = -1920.5068359375,
      z = 14.379295349121
    },
    x21482006835938 = {
      x = 2148.2006835938,
      y = 1747.9493408203,
      z = 11.652695655823
    },
    x21770532226563 = {
      x = -2177.0532226563,
      y = -565.39562988281,
      z = 49.406497955322
    },
    x21943344726563 = {
      x = -2194.3344726563,
      y = 178.78472900391,
      z = 36.160297393799
    },
    x22011450195313 = {
      x = 2201.1450195313,
      y = 762.98004150391,
      z = 11.64039516449
    },
    x22130849609375 = {
      x = -2213.0849609375,
      y = 1036.74609375,
      z = 80.840194702148
    },
    x2227951171875 = {
      x = 2227.951171875,
      y = 2549.8132324219,
      z = 11.652695655823
    },
    x22384519042969 = {
      x = -2238.4519042969,
      y = 904.10394287109,
      z = 67.492599487305
    },
    x22498903808594 = {
      x = 2249.8903808594,
      y = 1343.919921875,
      z = 11.652695655823
    },
    x22670788574219 = {
      x = 2267.0788574219,
      y = -1041.1356201172,
      z = 52.191596984863
    },
    x23047236328125 = {
      x = -2304.7236328125,
      y = 727.09735107422,
      z = 50.262096405029
    },
    x23091369628906 = {
      x = 2309.1369628906,
      y = 1914.8197021484,
      z = 11.808995246887
    },
    x23183000488281 = {
      x = 2318.3000488281,
      y = 1066.3820800781,
      z = 11.652695655823
    },
    x23678383789063 = {
      x = -2367.8383789063,
      y = -210.67655944824,
      z = 43.529895782471
    },
    x2377900390625 = {
      x = -2377.900390625,
      y = 1276.6633300781,
      z = 24.876596450806
    },
    x24008186035156 = {
      x = 2400.8186035156,
      y = 1659.7005615234,
      z = 11.652695655823
    },
    x2408365234375 = {
      x = -2408.365234375,
      y = 945.35394287109,
      z = 46.138896942139
    },
    x24554367675781 = {
      x = 2455.4367675781,
      y = 1274.5472412109,
      z = 11.652695655823
    },
    x24660280761719 = {
      x = -2466.0280761719,
      y = 1274.9245605469,
      z = 27.330095291138
    },
    x24690478515625 = {
      x = -2469.0478515625,
      y = 691.59027099609,
      z = 35.685195922852
    },
    x24827692871094 = {
      x = 2482.7692871094,
      y = -1387.1846923828,
      z = 29.668294906616
    },
    x24858024902344 = {
      x = 2485.8024902344,
      y = 2514.2861328125,
      z = 11.652695655823
    },
    x25444736328125 = {
      x = -2544.4736328125,
      y = -55.271167755127,
      z = 17.378395080566
    },
    x255568359375 = {
      x = 2555.68359375,
      y = 1540.8525390625,
      z = 11.652695655823
    },
    x25561435546875 = {
      x = -2556.1435546875,
      y = 934.09893798828,
      z = 65.816795349121
    },
    x2569716796875 = {
      x = 2569.716796875,
      y = -1503.0327148438,
      z = 24.286396026611
    },
    x2601740234375 = {
      x = 2601.740234375,
      y = -1061.9582519531,
      z = 70.412895202637
    },
    x2614857421875 = {
      x = 2614.857421875,
      y = 2333.3312988281,
      z = 11.652695655823
    },
    x26204157714844 = {
      x = -2620.4157714844,
      y = 822.1259765625,
      z = 50.816799163818
    },
    x26229074707031 = {
      x = 2622.9074707031,
      y = 2001.2800292969,
      z = 11.652695655823
    },
    x2624787109375 = {
      x = 2624.787109375,
      y = 2609.1110839844,
      z = 11.652695655823
    },
    x2651322265625 = {
      x = -2651.322265625,
      y = 61.912734985352,
      z = 4.9198961257935
    },
    x26634313964844 = {
      x = -2663.4313964844,
      y = -224.82817077637,
      z = 5.3947958946228
    },
    x26913869628906 = {
      x = -2691.3869628906,
      y = 1205.8684082031,
      z = 56.065898895264
    },
    x26975422363281 = {
      x = -2697.5422363281,
      y = 512.751953125,
      z = 9.2301959991455
    },
    x27802841796875 = {
      x = -2780.2841796875,
      y = 1312.5122070313,
      z = 8.0873956680298
    },
    x28154482421875 = {
      x = -2815.4482421875,
      y = 837.18829345703,
      z = 45.558197021484
    },
    x28323344726563 = {
      x = 2832.3344726563,
      y = 2029.1240234375,
      z = 11.652695655823
    },
    x28370461425781 = {
      x = -2837.0461425781,
      y = -422.35537719727,
      z = 9.5590953826904
    },
    x28404162597656 = {
      x = -2840.4162597656,
      y = 88.579833984375,
      z = 12.882195472717
    },
    x28546135253906 = {
      x = 2854.6135253906,
      y = 2381.2331542969,
      z = 11.652695655823
    },
    x29090518188477 = {
      x = 290.90518188477,
      y = -1373.1340332031,
      z = 14.820595741272
    },
    x38176019287109 = {
      x = 381.76019287109,
      y = -1883.4664306641,
      z = 2.9834959506989
    },
    x55661389160156 = {
      x = 556.61389160156,
      y = -1640.0729980469,
      z = 18.503894805908
    },
    x61654040527344 = {
      x = 616.54040527344,
      y = -1377.5219726563,
      z = 14.629595756531
    },
    x77044995117188 = {
      x = 770.44995117188,
      y = -1864.9260253906,
      z = 5.0558958053589
    },
    x86519696044922 = {
      x = 865.19696044922,
      y = 2050.1911621094,
      z = 11.652695655823
    },
    x86628967285156 = {
      x = 866.28967285156,
      y = -1700.5556640625,
      z = 14.387095451355
    },
    x93152276611328 = {
      x = 931.52276611328,
      y = -1161.357421875,
      z = 25.246496200562
    },
    x96222338867188 = {
      x = 962.22338867188,
      y = 2308.2048339844,
      z = 11.652695655823
    },
    x9717488861084 = {
      x = 97.17488861084,
      y = -1655.7399902344,
      z = 11.542195320129
    },
    x97655419921875 = {
      x = 976.55419921875,
      y = 2570.0695800781,
      z = 11.569396018982
    }
  }, "giftmap-ny2022-snow")

  --print(require'inspect'(map_ico))

  inicfg.save(map_ico, "giftmap-ny2022-snow")

  sampAddChatMessage((chatTag .. " by {2f72f7}Serhiy_Rubin{ffffff} & {348cb2}qrlk{ffffff} successfully loaded!"), -1)
  local bliz = 0
  while true do
    wait(500)
    if wh then
      local dist = 99999
      for key, coord in pairs(map_ico) do
        if map[key] ~= nil then
          local x, y, z = getCharCoordinates(PLAYER_PED)
          local distance = getDistanceBetweenCoords2d(coord.x, coord.y, x, y)
          if not isPauseMenuActive() then
            if distance < 400 then
              if checkpoints[key] == nil then
                checkpoints[key] = createCheckpoint(1, coord.x, coord.y, coord.z, coord.x, coord.y, coord.z, 5)
              end
            else
              if checkpoints[key] ~= nil then
                deleteCheckpoint(checkpoints[key])
                checkpoints[key] = nil
              end
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
                if findAllRandomObjectsInSphere(coord.x, coord.y, coord.z, 0.2, false) then
                  changeBlipColour(map[key], 0x00FFFFFF)
                else
                  changeBlipColour(map[key], 0x00FF00FF)
                end
              end
            else
              changeBlipScale(map[key], 1)
              changeBlipColour(map[key], 0xFFFFFFFF)
            end
            if distance < dist then
              bliz = key
              dist = distance
            end
            if distance < 10 then
              removeBlip(map[key])
              deleteCheckpoint(checkpoints[key])
              map[key] = nil

              local cnt = 0
              for key, coord in pairs(map) do
                cnt = cnt + 1
              end
              local count = 0
              for key, coord in pairs(map_ico) do
                count = count + 1
              end
              printStringNow(cnt .. "/" .. count, 1000)

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
      changeBlipScale(map[bliz], 8)
    end
  end
end

function sampev.onCreateObject(f, ff)
  if serverAddress == '95.181.158.64' or serverAddress == '95.181.158.77' or serverAddress == '95.181.158.69' or serverAddress == '95.181.158.74' then
    if ff.modelId == 19352 then
      local x, y, z = getCharCoordinates(playerPed)
      if ff.drawDistance == 25 and getDistanceBetweenCoords3d(x, y, z, ff.position.x, ff.position.y, ff.position.z) < 30 then
        lua_thread.create(
          function()
            local gift_string = string.gsub(tostring(math.abs(ff.position.x)), "%.", "")
            gift_string = math.modf(tonumber(gift_string), 10)
            if map_ico["x" .. tostring(gift_string)] == nil then
              print("Обнаружен снеговик", f, ff.position.x, ff.position.y, ff.position.z)
              --print(require('inspect')(map_ico), map_ico[gift_string], gift_string)

              local message = {
                gift_string = gift_string,
                typ = "snegovik",
                x = ff.position.x,
                y = ff.position.y,
                z = ff.position.z,
                rand = os.time()
              }
              if wh then
                addOneOffSound(0.0, 0.0, 0.0, 1139)
                downloadUrlToFile("http://qrlk.me:16622/" .. encodeJson(message))

                map_ico["x" .. tostring(gift_string)] = { x = ff.position.x, y = ff.position.y, z = ff.position.z }
                map["x" .. tostring(gift_string)] = addBlipForCoord(ff.position.x, ff.position.y, ff.position.z)
                checkpoints["x" .. tostring(gift_string)] = createCheckpoint(1, ff.position.x, ff.position.y, ff.position.z, ff.position.x, ff.position.y, ff.position.z, 5)
                changeBlipScale(map["x" .. tostring(gift_string)], 1)
                inicfg.save(map_ico, "giftmap-ny2022-snow")
              end
            end
            --print("http://qrlk.me:16622/" .. encodeJson(message))
          end
        )
      end
    end
  end
end

function sampev.onServerMessage(color, text)
  if wh and text == " [New Year 2022]{FFFFFF} Снеговики были разбросаны по штату!" then
    switch()
    switch()
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