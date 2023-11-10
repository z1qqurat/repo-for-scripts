script_name('RenderTimer')
script_author('Patlatuk')
require 'lib.moonloader'
require 'lib.sampfuncs'

local setTimer = 0

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		return
	end
	while not isSampAvailable() do wait(100) end
	
	renderFont = renderCreateFont("Arial", 14, FCR_BORDER + FCR_BOLD)
	sw, sh = getScreenResolution()
	
	sampRegisterChatCommand('render', function(arg)
	local form,timer = string.match(arg, "(%S+) (.+)")
	if not(form == "" or form == nil or timer == nil or timer == "") then
        if(form == "sec") then
		setTimer = os.time() + timer
		lua_thread.create(drawKillTimer)
		end
		
		if(form == "min") then
			setTimer = os.time() + (timer*60)
			lua_thread.create(drawKillTimer)
		end
    end
	end)
	
	while true do
		wait(0)
	end
end

function drawKillTimer()
	while true do
		wait(0)
		if(setTimer >= os.time())then
			local timer = setTimer - os.time()
			local text = ""
			local minute, second = math.floor(timer / 60), timer % 60
			text = string.format("Timer: %02d:%02d", minute, second)
			if(minute < 1 and second <= 15 and second % 2 > 0) then
				text = "{f4b800}" .. text
			end
			renderFontDrawText(renderFont, text, sw * 0.47, sh * 0.95, 0xFFFFFFC9)
		end
		
		if setTimer < os.time() then
			return
		end
	end
end