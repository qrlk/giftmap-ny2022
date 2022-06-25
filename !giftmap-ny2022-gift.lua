require 'lib.moonloader'

script_name("/giftmap-ny2022-gift")
script_version("08.01.2022")
script_author("Serhiy_Rubin", "qrlk")
script_properties("work-in-pause")
script_url("https://github.com/qrlk/giftmap-ny2022")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://02b85a96369c49528b55d50140438367@o1272228.ingest.sentry.io/6529849" })
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
      Update.json_url = "https://raw.githubusercontent.com/qrlk/giftmap-ny2022/main/version-gift.json?" .. tostring(os.clock())
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
      sampShowDialog(5557, "\t" .. chatTag .. " by {2f72f7}Serhiy_Rubin{ffffff}, {348cb2}qrlk", "{FF5F5F}Активация{ffffff}:\nВведите {2f72f7}/giftmap-ny2022-gift{ffffff}, чтобы включить/выключить скрипт.\n\n{FF5F5F}Event{ffffff}:\nНа карте есть точки, где спавнятся подарки. Они спавнятся каждые 60-90 минут.\nТочное количество точек спавна не известно, респавнятся они не на всех точках, а на части.\nКогда точку подберут, она пропадёт и нужно ждать респавна.\nПодбирать их начав сюжетную линию 'Дом санты' (/nygps - [0]).\nподарки дают какие-то монетки, их можно менять на призы: аксессуары и мелочь всякую.\nСейчас скрипт знает о " .. count .. " точках спавна.\nКогда вы заметите подарок, он добавится в вашу локальную базу.\n\n{FF5F5F}Как это работает?{ffffff}\nНа радаре появятся метки точек спавна подарков.\nБольшая точка означает самую ближайшую точку.\nС помощью чекпоинтов вы сможете сориентироваться.\nВыйдя в меню и открыв карту, вы сможете увидеть все подарки.\nЕсли на точке ничего нет/не подбирается, значит, что подарок подобрали и надо ждать пока они респавнятся.\n\n{FF5F5F}Обозначения:{ffffff}\n* Маленькая белая метка - вне зоны прорисовки.\n* Большая красная метка - точка занята игроками.\n* Большая голубая метка - на точке есть подарок (надо подойти на 25м).\n\n{FF5F5F}Ссылки:{ffffff}\n* https://github.com/qrlk/giftmap-ny2022\n* https://vk.com/rubin.mods", "OK")
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
    "giftmap-ny2022-gift",
    switch
  )

  map_ico = inicfg.load({
    x1000241027832 = {
      x = 1000.241027832,
      y = 1176.50390625,
      z = 10.820300102234
    },
    x10243544921875 = {
      x = 1024.3544921875,
      y = 2141.6198730469,
      z = 10.820300102234
    },
    x10769595947266 = {
      x = 1076.9595947266,
      y = -1207.5045166016,
      z = 17.819000244141
    },
    x1125248046875 = {
      x = 1125.248046875,
      y = 2468.9384765625,
      z = 10.749799728394
    },
    x11573841552734 = {
      x = 1157.3841552734,
      y = 1895.4323730469,
      z = 9.057900428772
    },
    x11680328369141 = {
      x = 1168.0328369141,
      y = 1384.8908691406,
      z = 10.495800018311
    },
    x12122590332031 = {
      x = 1212.2590332031,
      y = -1125.3395996094,
      z = 24.162599563599
    },
    x12172922363281 = {
      x = 1217.2922363281,
      y = 1150.0004882813,
      z = 6.7813000679016
    },
    x12689699707031 = {
      x = 1268.9699707031,
      y = -908.23577880859,
      z = 42.882801055908
    },
    x13377551269531 = {
      x = 1337.7551269531,
      y = 937.16271972656,
      z = 17.913400650024
    },
    x15189167480469 = {
      x = 1518.9167480469,
      y = -1452.306640625,
      z = 14.203100204468
    },
    x15387069702148 = {
      x = 153.87069702148,
      y = -1749.8588867188,
      z = 5.061900138855
    },
    x15451694335938 = {
      x = 1545.1694335938,
      y = -2119.7941894531,
      z = 15.01159954071
    },
    x15498674316406 = {
      x = 1549.8674316406,
      y = -1101.9918212891,
      z = 25.0625
    },
    x15664093017578 = {
      x = -1566.4093017578,
      y = 1061.228515625,
      z = 7.1875
    },
    x15815205078125 = {
      x = 1581.5205078125,
      y = 2265.41796875,
      z = 10.820300102234
    },
    x16109099121094 = {
      x = 1610.9099121094,
      y = 2026.4315185547,
      z = 10.820300102234
    },
    x16262952880859 = {
      x = 1626.2952880859,
      y = 631.30041503906,
      z = 10.820300102234
    },
    x16714774169922 = {
      x = -1671.4774169922,
      y = -545.51281738281,
      z = 11.50030040741
    },
    x17197578125 = {
      x = 1719.7578125,
      y = 1443.1971435547,
      z = 10.817999839783
    },
    x17379807128906 = {
      x = 1737.9807128906,
      y = -1478.3648681641,
      z = 13.401900291443
    },
    x17656154785156 = {
      x = 1765.6154785156,
      y = 614.95037841797,
      z = 10.820300102234
    },
    x18248041992188 = {
      x = -1824.8041992188,
      y = -176.32339477539,
      z = 9.3984003067017
    },
    x18609171142578 = {
      x = 1860.9171142578,
      y = 639.12359619141,
      z = 10.820300102234
    },
    x18691881103516 = {
      x = 1869.1881103516,
      y = 926.51470947266,
      z = 10.820300102234
    },
    x18813537597656 = {
      x = -1881.3537597656,
      y = 299.96780395508,
      z = 41.046901702881
    },
    x18877141113281 = {
      x = 1887.7141113281,
      y = 1704.6481933594,
      z = 10.820300102234
    },
    x19128227539063 = {
      x = 1912.8227539063,
      y = 2129.6271972656,
      z = 10.820300102234
    },
    x19161011962891 = {
      x = -1916.1011962891,
      y = 897.53717041016,
      z = 35.414100646973
    },
    x19408044433594 = {
      x = 1940.8044433594,
      y = -1979.3780517578,
      z = 13.546899795532
    },
    x19518975830078 = {
      x = 1951.8975830078,
      y = 2535.3605957031,
      z = 6.7701997756958
    },
    x19710637207031 = {
      x = 1971.0637207031,
      y = -1177.1212158203,
      z = 20.023399353027
    },
    x19968145751953 = {
      x = -1996.8145751953,
      y = -722.66259765625,
      z = 32.171901702881
    },
    x20091549072266 = {
      x = 2009.1549072266,
      y = 2493.9807128906,
      z = 10.820300102234
    },
    x20417525634766 = {
      x = 2041.7525634766,
      y = -1639.7175292969,
      z = 13.546899795532
    },
    x20818642578125 = {
      x = -2081.8642578125,
      y = 825.98870849609,
      z = 69.5625
    },
    x2096529296875 = {
      x = 2096.529296875,
      y = 1287.533203125,
      z = 10.820300102234
    },
    x21075070800781 = {
      x = 2107.5070800781,
      y = 1004.719909668,
      z = 11.047499656677
    },
    x21221198730469 = {
      x = -2122.1198730469,
      y = 417.58889770508,
      z = 35.171901702881
    },
    x21251232910156 = {
      x = -2125.1232910156,
      y = 654.42950439453,
      z = 52.367198944092
    },
    x21603723144531 = {
      x = 2160.3723144531,
      y = 705.66351318359,
      z = 10.820300102234
    },
    x21666447753906 = {
      x = -2166.6447753906,
      y = 910.47131347656,
      z = 80.007797241211
    },
    x21940187988281 = {
      x = 2194.0187988281,
      y = 1686.884765625,
      z = 12.367199897766
    },
    x22052395019531 = {
      x = 2205.2395019531,
      y = -1161.1060791016,
      z = 25.735300064087
    },
    x22089018554688 = {
      x = 2208.9018554688,
      y = -1260.6893310547,
      z = 23.881000518799
    },
    x22172097167969 = {
      x = 2217.2097167969,
      y = -2163.2487792969,
      z = 13.546899795532
    },
    x22467243652344 = {
      x = 2246.7243652344,
      y = 2050.0944824219,
      z = 10.820300102234
    },
    x228047265625 = {
      x = -2280.47265625,
      y = -244.87120056152,
      z = 42.34700012207
    },
    x22822180175781 = {
      x = -2282.2180175781,
      y = 1242.9476318359,
      z = 45.345401763916
    },
    x22858603515625 = {
      x = -2285.8603515625,
      y = 32.052299499512,
      z = 35.3125
    },
    x22907370605469 = {
      x = -2290.7370605469,
      y = -340.90948486328,
      z = 40.006500244141
    },
    x23150095214844 = {
      x = -2315.0095214844,
      y = 101.03869628906,
      z = 35.398399353027
    },
    x23791796875 = {
      x = 2379.1796875,
      y = -2015.2934570313,
      z = 14.832900047302
    },
    x24080168457031 = {
      x = -2408.0168457031,
      y = 897.96752929688,
      z = 45.533798217773
    },
    x24329609375 = {
      x = 2432.9609375,
      y = -1415.8920898438,
      z = 24.036699295044
    },
    x24606403808594 = {
      x = -2460.6403808594,
      y = 402.56820678711,
      z = 35.117198944092
    },
    x24610305175781 = {
      x = 2461.0305175781,
      y = 928.04852294922,
      z = 10.820300102234
    },
    x24888955078125 = {
      x = 2488.8955078125,
      y = -1310.9243164063,
      z = 34.859699249268
    },
    x24898171386719 = {
      x = -2489.8171386719,
      y = 91.685897827148,
      z = 25.61720085144
    },
    x25203852539063 = {
      x = 2520.3852539063,
      y = 2428.8488769531,
      z = 10.820300102234
    },
    x25248032226563 = {
      x = 2524.8032226563,
      y = 1852.4324951172,
      z = 10.820300102234
    },
    x25456958007813 = {
      x = 2545.6958007813,
      y = 2177.8796386719,
      z = 10.820300102234
    },
    x25509453125 = {
      x = 2550.9453125,
      y = 1216.3070068359,
      z = 10.820300102234
    },
    x26147004394531 = {
      x = -2614.7004394531,
      y = 989.40411376953,
      z = 78.285003662109
    },
    x26557580566406 = {
      x = -2655.7580566406,
      y = 1211.9415283203,
      z = 55.578098297119
    },
    x26805048828125 = {
      x = 2680.5048828125,
      y = -1398.7889404297,
      z = 30.578699111938
    },
    x26913315429688 = {
      x = 2691.3315429688,
      y = 2415.9665527344,
      z = 6.7031002044678
    },
    x27194061279297 = {
      x = 271.94061279297,
      y = -1462.7429199219,
      z = 28.238700866699
    },
    x27549653320313 = {
      x = 2754.9653320313,
      y = -1176.9409179688,
      z = 69.404998779297
    },
    x27612841796875 = {
      x = 2761.2841796875,
      y = 1425.3240966797,
      z = 10.397500038147
    },
    x27741079101563 = {
      x = -2774.1079101563,
      y = -484.74560546875,
      z = 6.9706001281738
    },
    x27879426269531 = {
      x = -2787.9426269531,
      y = 229.31719970703,
      z = 7.0606999397278
    },
    x27957922363281 = {
      x = -2795.7922363281,
      y = -203.09379577637,
      z = 6.9706001281738
    },
    x44228158569336 = {
      x = 442.28158569336,
      y = -1301.4577636719,
      z = 15.176099777222
    },
    x48731518554688 = {
      x = 487.31518554688,
      y = -1644.6047363281,
      z = 23.703100204468
    },
    x73642370605469 = {
      x = 736.42370605469,
      y = -1797.6545410156,
      z = 13.09850025177
    },
    x82268420410156 = {
      x = 822.68420410156,
      y = -1699.6176757813,
      z = 13.546899795532
    },
    x82955438232422 = {
      x = 829.55438232422,
      y = -1061.4376220703,
      z = 25.129899978638
    },
    x89310552978516 = {
      x = 893.10552978516,
      y = 2014.6312255859,
      z = 11.733699798584
    },
    x91746362304688 = {
      x = 917.46362304688,
      y = 2385.6049804688,
      z = 10.820300102234
    }
  }, "giftmap-ny2022-gift")

  inicfg.save(map_ico, "giftmap-ny2022-gift")
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

function sampev.onCreatePickup(id, model, pickupType, pos)
  if serverAddress == '95.181.158.64' or serverAddress == '95.181.158.77' or serverAddress == '95.181.158.69' or serverAddress == '95.181.158.74' then
    local x, y, z = getCharCoordinates(playerPed)
    if model == 19055 or model == 19058 or model == 19057 or model == 19056 or model == 19054 then
      if getDistanceBetweenCoords3d(x, y, z, pos.x, pos.y, pos.z) < 40 then
        lua_thread.create(
          function()
            local gift_string = string.gsub(tostring(math.abs(pos.x)), "%.", "")
            gift_string = math.modf(tonumber(gift_string), 10)
            if map_ico["x" .. tostring(gift_string)] == nil then
              print("Обнаружен подарок", model, pos.x, pos.y, pos.z)
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

                map_ico["x" .. tostring(gift_string)] = { x = pos.x, y = pos.y, z = pos.z }
                map["x" .. tostring(gift_string)] = addBlipForCoord(pos.x, pos.y, pos.z)
                checkpoints["x" .. tostring(gift_string)] = createCheckpoint(1, pos.x, pos.y, pos.z, pos.x, pos.y, pos.z, 5)

                changeBlipScale(map["x" .. tostring(gift_string)], 1)
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

function sampev.onServerMessage(color, text)
  if wh and text == " [New Year 2022]{FFFFFF} Подарки Санты были разбросаны по штату!" then
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
