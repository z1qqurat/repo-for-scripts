script_name('autoRunAndDrive')
script_author('Patlatuk')

local toggle = false
local runcode = {'walk', 'run', 'sprint'}
local code = 2
local vkeys = require 'vkeys'
-- local key = vkeys.VK_L
local key = 189

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	
	while true do wait(0)
	if isKeyJustPressed(key) and not sampIsChatInputActive()  and not sampIsDialogActive() and not isSampfuncsConsoleActive() 
		then
			toggle = not toggle  
			printStringNow(tostring(toggle), 2000)
		end
		if toggle then
            if isCharInAnyCar(PLAYER_PED) then
				if  (wasKeyPressed(0x57) or wasKeyPressed(0x53)) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
					toggle = false
				end
				if isKeyDown(0x20) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
				else
                -- setGameKeyState(1, -255)
				 setGameKeyState(16, 255)
				 end
            end
            
			if isCharOnFoot(PLAYER_PED) then
				if  (wasKeyPressed(0x57) or wasKeyPressed(0x53)) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
					toggle = false
				end
				if isKeyJustPressed(82) and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then
					code = code + 1
					if code > 3 then code = 1 end
					printStringNow(tostring(runcode[code]), 2000)
				end
				if runcode[code] == 'run' then
					setGameKeyState(1, -255) 
				end
				if runcode[code] == 'walk' then
					setGameKeyState(1, 65535) 
				end
				if runcode[code] == 'sprint' then
					setGameKeyState(1, -255)
					setGameKeyState(16, 255)
				end
			end
		end
	end
end