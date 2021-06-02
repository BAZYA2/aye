local pt = 3
local worked = {22, 23, 24, 26, 27, 29, 32, 37, 38, 41, 42, 43}
local dlstatus = require('moonloader').download_status

function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
  downloadUrlToFile('https://api.jsonbin.io/b/60b735afb104de5acddd6d17', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- открывает файл
    if f then
      local info = decodeJson(f:read('*a')) -- читает
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
          lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
          update = false -- не даём обновиться
          sampAddChatMessage(('[Testing]: У вас и так последняя версия! Обновление отменено'), color)
        end
      end
    end
  end
end)
end
--скачивание актуальной версии
function goupdate()
sampAddChatMessage(('[Testing]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...'), color)
sampAddChatMessage(('[Testing]: Текущая версия: '..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Testing]: Обновление завершено!'), color)
  thisScript():reload()
end
end)
end

function main()
    while not isSampAvailable() do wait(0) end
   sampRegisterChatCommand("as", autoscroll)
    while true do
        wait(0)
        if enabled and getAmmoInClip() == pt then
            local gun = getCurrentCharWeapon(PLAYER_PED)
            for key, val in pairs(worked) do
              if val == gun and getAmmoInCharWeapon(PLAYER_PED, gun) ~= pt then
                    setCurrentCharWeapon(PLAYER_PED, 0)
                    sampForceOnfootSync()
                    wait(10)
                    setCurrentCharWeapon(PLAYER_PED, gun)
                end
            end
        end
    end
end

function getAmmoInClip()
    return memory.getuint32(getCharPointer(PLAYER_PED) + 0x5A0 + getWeapontypeSlot(getCurrentCharWeapon(PLAYER_PED)) * 0x1C + 0x8)
end

function autoscroll()
    enabled = not enabled
	if enabled then
    sampAddChatMessage("vzlom vkluchen ETAPUTIN", -1)
	else
	sampAddChatMessage("vzlom vvikluchen ETANEPUTIN", -1)
	end
end