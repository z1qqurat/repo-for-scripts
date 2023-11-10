script_name("RPBreath")
script_version("1.0")
script_author("Patlatuk")

local state = false

function main()
    while not isSampAvailable() do wait(100) end
	
	sampRegisterChatCommand('breath',function()
		state = not state
		notf('Script is ' .. (state and '{FF9C00}ON' or '{FF9C00}OFF'))
	end)
	
	while true do
		if state
			sampSendChat("/me сделал вдох")
			wait(3750)
			sampSendChat("/me сделал выдох")
			wait(3750)	
		end
	end
end

function notf(text)
    sampAddChatMessage('[RP_Breath] {ffffff}'..text, 0xFF9C00)
end