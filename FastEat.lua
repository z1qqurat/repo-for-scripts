script_name("FastEat")
script_version("1.0")
script_author("Patlatuk")

local vkeys = require 'vkeys'
local key = vkeys.VK_Z
local state = true

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	sampRegisterChatCommand("togglefe",function()
    state = not state 
    printStringNow("FastEat is ".. tostring(state), 1000)
  end)

	while true do wait(0)
		if state and isKeyJustPressed(key) and not sampIsChatInputActive()
    and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
      sampSendChat("/fish eat")
		end
	end
end
