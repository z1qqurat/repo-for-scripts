script_name("Players in stream")
script_version("1.1")
script_author("Corvet. Modified by Patlatuk")

local pos_x = 175
local pos_y = 1010
local state = true
local font_name = "Molot"
local font_size = 12
local font_flags = 12
local sx, sy = getScreenResolution()
local font = renderCreateFont(font_name, font_size, font_flags)

function main()
  if not isSampLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end

  sampRegisterChatCommand('ped',function()
  state = not state
  end)

  while true do
      if state then
          renderFontDrawText(font, "PedSlotsUsed: {DC143C}"..sampGetPlayerCount(true) - 1, pos_x, pos_y + 20, - 1)
      end
      wait(0)
  end
  wait(-1)
end