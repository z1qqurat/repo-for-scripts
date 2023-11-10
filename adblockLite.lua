script_name("Adblock Lite")
script_version("30.06.2023")
script_author("Patlatuk")
script_description("/tads")

local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local data = inicfg.load({
  options =
  {
    toggle = true,
  },
}, 'adblockLite')

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end

  sampRegisterChatCommand("tads",
    function()
      data.options.toggle = not data.options.toggle
      inicfg.save(data, "adblockLite")
      sampAddChatMessage("Скрытие объяв в чате: "..tostring(data.options.toggle), 0x348cb2)
    end
  )

  while true do
    wait(0)
  end
end

function sampev.onServerMessage(color, text)
    if color == 14221567 and string.find(text, "^ Объявление: ") or string.find(text, "^        Редакция News (.+). Отредактировал") or string.find(text, "^        Редакция News (.+). Проверку произвел") then
      if data.options.toggle == true then return false end
    end
end