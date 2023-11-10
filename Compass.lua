script_name("Compass")
script_version("1.1")
script_author("Modified by Patlatuk")

require "lib.moonloader"
require "lib.sampfuncs"
local sampev = require 'lib.samp.events'
local font_flag = require('moonloader').font_flag
local sx, sy = getScreenResolution()
local logo = renderCreateFont('BigNoodleTitlingCyr', 12, font_flag.BORDER)
local state = true
local coord = false
local compass = {x = "200", y = "770"} -- Тут редактируйте расположение инфы.
local coordination = {x = "180", y = "770"} -- на координацию в погони

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('compass',function()
		state = not state
  end)
  
  sampRegisterChatCommand('compassCoord',function()
		coord = not coord
  end)

    while true do
        if state then
            
            renderFontDrawText(logo, "Сектор: "..whereami(), compass.x, compass.y+renderGetFontDrawHeight(logo), 0xFFFFFFFF)
        end

        if coord then
          local naprav = ""
          if getCharHeading(playerPed) >= 337.5 or getCharHeading(playerPed) <= 22.5 then naprav = "Северное" end
          if getCharHeading(playerPed) > 22.5 and getCharHeading(playerPed) <= 67.5 then naprav = "Северо-западное" end
          if getCharHeading(playerPed) > 67.5 and getCharHeading(playerPed) <= 112.5 then naprav = "Западное" end
          if getCharHeading(playerPed) > 112.5 and getCharHeading(playerPed) <= 157.5 then naprav = "Юго-западное" end
          if getCharHeading(playerPed) > 157.5 and getCharHeading(playerPed) <= 202.5 then naprav = "Южное" end
          if getCharHeading(playerPed) > 202.5 and getCharHeading(playerPed) <= 247.5 then naprav = "Юго-восточное" end
          if getCharHeading(playerPed) > 247.5 and getCharHeading(playerPed) <= 292.5 then naprav = "Восточное" end
          if getCharHeading(playerPed) > 292.5 and getCharHeading(playerPed) <= 337.5 then naprav = "Северо-восточное" end
          renderFontDrawText(logo, "Направление: "..naprav, coordination.x, sy-coordination.y, 0xFFFFFFFF)
        end  
        wait(0)
    end
    wait(0)
end

function whereami()
    local KV = {
      [1] = "А",
      [2] = "Б",
      [3] = "В",
      [4] = "Г",
      [5] = "Д",
      [6] = "Ж",
      [7] = "З",
      [8] = "И",
      [9] = "К",
      [10] = "Л",
      [11] = "М",
      [12] = "Н",
      [13] = "О",
      [14] = "П",
      [15] = "Р",
      [16] = "С",
      [17] = "Т",
      [18] = "У",
      [19] = "Ф",
      [20] = "Х",
      [21] = "Ц",
      [22] = "Ч",
      [23] = "Ш",
      [24] = "Я",
    }
    local X, Y, Z = getCharCoordinates(playerPed)
    X = math.ceil((X + 3000) / 250)
    Y = math.ceil((Y * - 1 + 3000) / 250)
    Y = KV[Y]
    KVX = (Y.."-"..X)
    if getActiveInterior() == 0 then return KVX
    else return 0
    end
  end