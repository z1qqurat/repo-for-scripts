script_name("RpRadio")
script_version("1.0")
script_author("Patlatuk")

local SE = require 'lib.samp.events'

local inicfg = require 'inicfg'
local cfg = inicfg.load({
    settings = {
	  state = true,
    seeDoMsg = "/seedo Сообщает что-по рации",
    meMsg = "/me взял рацию тактического пояса",
    radioMsg = "",  -- {put_your_nickname_here} Example: Volodia_Patlatuk%[(%d+)%]
    hideseeme = true, -- true = hide (( Сообщение отправлено )) message on /seeme from command
    },
}, "RpRadio.ini")

local send_radio = false

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end

  if cfg.settings.radioMsg == "" then
    setRadioMsg()
  end

  sampRegisterChatCommand('rprad', toggleStatus)

  while true do
    wait(0)
    if send_radio then
      wait(250)
      sampSendChat(cfg.settings.meMsg)
      wait(300)
      sampSendChat(cfg.settings.seeDoMsg)
      wait(250)
      send_radio = false
    end
  end
end

function toggleStatus()
  cfg.settings.state = not cfg.settings.state
	notf("Script is"..(cfg.settings.state and "{00FF00} enabled" or "{FF0000} disabled"))
  inicfg.save(cfg, "RpRadio")
end

function SE.onServerMessage(color, text)
  if color == -1920073729 and cfg.settings.state then
    text = text:gsub("{......}", "")
    if string.find(text, cfg.settings.radioMsg) then
      send_radio = true
    end
  end
  if send_radio and cfg.settings.hideseeme and text == " (( Сообщение отправлено ))" then return false end
end

function setRadioMsg()
	local _, myID = sampGetPlayerIdByCharHandle(PLAYER_PED)
  cfg.settings.radioMsg = sampGetPlayerNickname(myID).."%[(%d+)%]"
  inicfg.save(cfg, "RpRadio")
end

function notf(msg)
  sampAddChatMessage('[RpRadio] {ffffff}'..msg, 0xdfff22)
end