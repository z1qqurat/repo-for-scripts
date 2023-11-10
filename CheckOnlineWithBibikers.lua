script_name("CheckOnline")
script_author("checkdasound")
script_version(1.0)

local clists = {
	{
		0xAA09A400, -- grove.
		0xAAC515FF, -- ballas.
		0xAAFFDE24, -- vagos.
		0xAA2EA07B, -- rifa.
		0xAA0DEDFF, -- aztec.
		0xAAF4B800, -- lcn.
		0xAAFF0606, -- yakuza.
		0xAAB8B6B6, -- russian mafia.
		0xAA383838, -- masked.
		0x00FFFFFF, -- bomj.
	}
}
-- local HAMC = 2863800866
-- local MONGOLS = 2853968924
-- local PAGANS = 2852126859
-- local OUTLAWS = 2864035253
-- local SOS = 2861253888
-- local WARLOCKS = 2867754529
-- local HIGHWAYMAN = 2853113615
-- local BANDIDOS = 2868880640
-- local FREE_SOULS = 2853195403
-- local VAGOS = 2852162304
local bclists = {
	{
		2863800866,
		2853968924,
		2852126859,
		2864035253,
		2861253888,
		2867754529,
		2853113615,
		2868880640,
		2853195403,
		2852162304,
	}
}

local texts = {
	'Grove: $CNT | Ballas: $CNT | Vagos: $CNT | Rifa: $CNT | Aztecas: $CNT\nLCN: $CNT | Yakuza: $CNT | Russian Mafia: $CNT\nMasked: $CNT | Bomj: $CNT',
}

local btexts = {
	'HAMC: $CNT | Mongols: $CNT | Pagans: $CNT | Outlaws: $CNT | SOS: $CNT\nWarlocks: $CNT | Highwayman: $CNT | Bandidos: $CNT\nFree souls: $CNT | VAGOS: $CNT',
}
function main()
	while not isSampAvailable() do wait(0) end
	while sampGetGamestate() ~= 3 do wait(0) end
	sampRegisterChatCommand('cho', function()
		local text = texts[1]
		for i = 1, #clists[1] do
			local online = 0
			for l = 0, 1004 do
				if sampIsPlayerConnected(l) then
					if sampGetPlayerColor(l) == clists[1][i] then online = online + 1 end
				end
			end
			text = text:gsub('$CLR', ('%06X'):format(bit.band(clists[1][i], 0xFFFFFF)), 1)
			text = text:gsub('$CNT', online, 1)
		end
		for w in text:gmatch('[^\r\n]+') do sampAddChatMessage(w, -1)end
	end)
	
	sampRegisterChatCommand('bcho', function()
		local text = btexts[1]
		for i = 1, #bclists[1] do
			local online = 0
			for l = 0, 1004 do
				if sampIsPlayerConnected(l) then
					if sampGetPlayerColor(l) == bclists[1][i] then online = online + 1 end
				end
			end
			text = text:gsub('$CLR', ('%06X'):format(bit.band(bclists[1][i], 0xFFFFFF)), 1)
			text = text:gsub('$CNT', online, 1)
		end
		for w in text:gmatch('[^\r\n]+') do sampAddChatMessage(w, -1)end
	end)
	wait(-1)
end