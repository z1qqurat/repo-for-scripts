script_name('AutoAmmo')
script_author('Patlatuk')
script_version("1.3")

local SE = require 'lib.samp.events'
local imgui, ffi = require 'mimgui', require 'ffi'
local inicfg = require 'inicfg'

local cfg = inicfg.load({
    settings = {
		state = true,
		fraction = 3,
        isLoadMessageEnabled = true,
		isArmorTimerEnabled = false,
		deagle = true,
		shotgun = false,
		smg = false,
		m4a1 = true,
		ak47 = false,
		rifle = true,
		armor = true,
		special = false,
		deagle_ammo = 2,
		shotgun_ammo = 1,
		smg_ammo = 1,
		m4a1_ammo = 1,
		ak47_ammo = 1,
		rifle_ammo = 1,
		timerW = 120,
		timerH = 225,
		fontSize = 10,
		armorTimer = 0,
    },
}, "AutoAmmo.ini")

local sw, sh = getScreenResolution()
local isArmorTaken = false
local isGettingAmmo = false
local new = imgui.new
local mainMenu = new.bool()
local isLoadMessageEnabled = new.bool(cfg.settings.isLoadMessageEnabled)
local fraction = new.int(cfg.settings.fraction)
local state = new.bool(cfg.settings.state)
local deagle = new.bool(cfg.settings.deagle)
local shotgun = new.bool(cfg.settings.shotgun)
local smg = new.bool(cfg.settings.smg)
local ak47 = new.bool(cfg.settings.ak47)
local m4a1 = new.bool(cfg.settings.m4a1)
local rifle = new.bool(cfg.settings.rifle)
local armor = new.bool(cfg.settings.armor)
local special = new.bool(cfg.settings.special)
local isArmorTimerEnabled = new.bool(cfg.settings.isArmorTimerEnabled)

local renderFont = renderCreateFont("Arial", cfg.settings.fontSize, FCR_BORDER + FCR_BOLD)
local armorTimer = cfg.settings.armorTimer
local reserve_x, reserve_y

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		return
	end
	while not isSampAvailable() do wait(100) end

	if isLoadMessageEnabled[0] then
		notf("Script is loaded. Open menu: /aa. Quick toggle - /aaa")
	end
	lua_thread.create(drawArmorTimer)


    sampRegisterChatCommand('aa', showMainMenu)
	sampRegisterChatCommand('aaa', toggleStatus)

	sampRegisterChatCommand('aa.timerpos', function()
		reserve_x, reserve_y = cfg.settings.timerW, cfg.settings.timerH
		notf("Open chat to move cursor. LMB - Save position. RMB - Cancel.")
        showCursor(true, true)
		lua_thread.create(changeTimerPosition)
	end)

	while true do
		wait(0)
	end
end

function showMainMenu()
    mainMenu[0] = not mainMenu[0]
end

function toggleStatus()
	state[0] = not state[0]
    cfg.settings.state = state[0]
	notf("Script is"..(state[0] and "{00FF00} enabled" or "{FF0000} disabled"))
    inicfg.save(cfg, "AutoAmmo")
end

imgui.OnFrame(function () return mainMenu[0] end,
function ()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin("AutoAmmo by Patlatuk v"..thisScript().version, mainMenu, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

	if imgui.Checkbox("Show welcome message on script load", isLoadMessageEnabled) then
    	cfg.settings.isLoadMessageEnabled = isLoadMessageEnabled[0]
    	inicfg.save(cfg, "AutoAmmo")
    end

	if imgui.Checkbox("Enable script", state) then
    	cfg.settings.state = state[0]
    	inicfg.save(cfg, "AutoAmmo")
    end
	if cfg.settings.fraction < 4 then
		if imgui.Checkbox("Enable armor timer", isArmorTimerEnabled) then
			cfg.settings.isArmorTimerEnabled = isArmorTimerEnabled[0]
			inicfg.save(cfg, "AutoAmmo")
		end
		imgui.Text("/aa.timerpos - change timer position")
	end
	imgui.Separator()
	imgui.Text("Select your fraction:")
	if imgui.RadioButtonIntPtr("PD", fraction, 1) then
    	cfg.settings.fraction = fraction[0]
    	inicfg.save(cfg, "AutoAmmo")
	end
	imgui.SameLine()
	if imgui.RadioButtonIntPtr("FBI", fraction, 2) then
    	cfg.settings.fraction = fraction[0]
    	inicfg.save(cfg, "AutoAmmo")
	end
	imgui.SameLine()
	if imgui.RadioButtonIntPtr("ARMY", fraction, 3) then
    	cfg.settings.fraction = fraction[0]
    	inicfg.save(cfg, "AutoAmmo")
	end

	imgui.SameLine()
	if imgui.RadioButtonIntPtr("MAFIA", fraction, 4) then
    	cfg.settings.fraction = fraction[0]
    	inicfg.save(cfg, "AutoAmmo")
	end

	imgui.SameLine()
	if imgui.RadioButtonIntPtr("BIBIKER", fraction, 5) then
    	cfg.settings.fraction = fraction[0]
    	inicfg.save(cfg, "AutoAmmo")
	end
	
	imgui.Separator()
	if imgui.Checkbox("Deagle", deagle) then
    	cfg.settings.deagle = deagle[0]
    	inicfg.save(cfg, "AutoAmmo")
    end
	if cfg.settings.fraction > 3 then
		imgui.SameLine(100.0)
		if (imgui.ArrowButton("##left_deagle", imgui.Dir.Left)) then
		   if cfg.settings.deagle_ammo > 1 then
			  cfg.settings.deagle_ammo = cfg.settings.deagle_ammo - 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
		imgui.SameLine();
		imgui.Text("%g", cfg.settings.deagle_ammo);
		imgui.SameLine();
		if (imgui.ArrowButton("##right_deagle", imgui.Dir.Right)) then
		   if cfg.settings.deagle_ammo < 5 then
			  cfg.settings.deagle_ammo = cfg.settings.deagle_ammo + 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
	end


	if imgui.Checkbox("Shotgun", shotgun) then
    	cfg.settings.shotgun = shotgun[0]
    	inicfg.save(cfg, "AutoAmmo")
    end
	if cfg.settings.fraction > 3 then
		imgui.SameLine(100.0)
		if (imgui.ArrowButton("##left_shotgun", imgui.Dir.Left)) then
		   if cfg.settings.shotgun_ammo > 1 then
			  cfg.settings.shotgun_ammo = cfg.settings.shotgun_ammo - 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
		imgui.SameLine();
		imgui.Text("%g", cfg.settings.shotgun_ammo);
		imgui.SameLine();
		if (imgui.ArrowButton("##right_shotgun", imgui.Dir.Right)) then
		   if cfg.settings.shotgun_ammo < 5 then
			  cfg.settings.shotgun_ammo = cfg.settings.shotgun_ammo + 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
	end


	if imgui.Checkbox("SMG", smg) then
    	cfg.settings.smg = smg[0]
    	inicfg.save(cfg, "AutoAmmo")
    end
	if cfg.settings.fraction > 3 then
		imgui.SameLine(100.0)
		if (imgui.ArrowButton("##left_smg", imgui.Dir.Left)) then
		   if cfg.settings.smg_ammo > 1 then
			  cfg.settings.smg_ammo = cfg.settings.smg_ammo - 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
		imgui.SameLine();
		imgui.Text("%g", cfg.settings.smg_ammo);
		imgui.SameLine();
		if (imgui.ArrowButton("##right_smg", imgui.Dir.Right)) then
		   if cfg.settings.smg_ammo < 5 then
			  cfg.settings.smg_ammo = cfg.settings.smg_ammo + 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
	end
	if cfg.settings.fraction > 3 then
		if imgui.Checkbox("AK47", ak47) then
    		cfg.settings.ak47 = ak47[0]
    		inicfg.save(cfg, "AutoAmmo")
   		 end
		imgui.SameLine(100.0)
		if (imgui.ArrowButton("##left_ak47", imgui.Dir.Left)) then
		   if cfg.settings.ak47_ammo > 1 then
			  cfg.settings.ak47_ammo = cfg.settings.ak47_ammo - 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
		imgui.SameLine();
		imgui.Text("%g", cfg.settings.ak47_ammo);
		imgui.SameLine();
		if (imgui.ArrowButton("##right_ak47", imgui.Dir.Right)) then
		   if cfg.settings.ak47_ammo < 5 then
			  cfg.settings.ak47_ammo = cfg.settings.ak47_ammo + 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
	end

	if imgui.Checkbox("M4A1", m4a1) then
    	cfg.settings.m4a1 = m4a1[0]
    	inicfg.save(cfg, "AutoAmmo")
    end
	if cfg.settings.fraction > 3 then
		imgui.SameLine(100.0)
		if (imgui.ArrowButton("##left_m4a1", imgui.Dir.Left)) then
		   if cfg.settings.m4a1_ammo > 1 then
			  cfg.settings.m4a1_ammo = cfg.settings.m4a1_ammo - 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
		imgui.SameLine();
		imgui.Text("%g", cfg.settings.m4a1_ammo);
		imgui.SameLine();
		if (imgui.ArrowButton("##right_m4a1", imgui.Dir.Right)) then
		   if cfg.settings.m4a1_ammo < 5 then
			  cfg.settings.m4a1_ammo = cfg.settings.m4a1_ammo + 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
	end

	if imgui.Checkbox("Rifle", rifle) then
    	cfg.settings.rifle = rifle[0]
    	inicfg.save(cfg, "AutoAmmo")
    end
	if cfg.settings.fraction > 3 then
		imgui.SameLine(100.0)
		if (imgui.ArrowButton("##left_rifle", imgui.Dir.Left)) then
		   if cfg.settings.rifle_ammo > 1 then
			  cfg.settings.rifle_ammo = cfg.settings.rifle_ammo - 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
		imgui.SameLine();
		imgui.Text("%g", cfg.settings.rifle_ammo);
		imgui.SameLine();
		if (imgui.ArrowButton("##right_rifle", imgui.Dir.Right)) then
		   if cfg.settings.rifle_ammo < 5 then
			  cfg.settings.rifle_ammo = cfg.settings.rifle_ammo + 1
			  inicfg.save(cfg, "AutoAmmo")
		   end
		end
	end

	if cfg.settings.fraction ~= 5 then
		if imgui.Checkbox("Armor", armor) then
			cfg.settings.armor = armor[0]
			inicfg.save(cfg, "AutoAmmo")
		end
	end
	
	if cfg.settings.fraction < 4 then
		if imgui.Checkbox("Special", special) then
    		cfg.settings.special = special[0]
    		inicfg.save(cfg, "AutoAmmo")
    	end
	end

	imgui.Separator()
	imgui.SetCursorPosX(imgui.GetWindowWidth() / 3.0);
    if imgui.Button("Save & Close", imgui.ImVec2(100, 20)) then
        mainMenu[0] = false
    end
    imgui.End()
end)

function SE.onServerMessage(color, text)
	if string.find(text, "^ Подождите немного$") or string.find(text, "^ Вы не можете взять больше патронов для этого оружия") then
		thisScript():reload()
		return true
	end
	if color == 162529535 and string.find(text, "^ Выдано: Броня$") then
		if cfg.settings.state and cfg.settings.isArmorTimerEnabled then
			armorTimer = os.time() + 30
			cfg.settings.armorTimer = armorTimer
			inicfg.save(cfg, "AutoAmmo")
		--	lua_thread.create(drawArmorTimer)
			return true
		end
	end
end

function SE.onShowDialog(dialogid, style, title, button1, button2, text)
notf(dialogid)
	if dialogid == 1166 and string.find(title, "Склад оружия") and cfg.settings.state then
		if cfg.settings.deagle then
			local a = getAmmoInCharWeapon(PLAYER_PED, 24)
			if a < 63 then
				sampSendDialogResponse(dialogid, 1, 0, "")
				return false
			end
		end

		if cfg.settings.shotgun then
			local a = getAmmoInCharWeapon(PLAYER_PED, 25)
			if a < 30 then
				sampSendDialogResponse(dialogid, 1, 1, "")
				return false
			end
		end

		if cfg.settings.smg then
			local a = getAmmoInCharWeapon(PLAYER_PED, 29)
			if a < 180 then
				sampSendDialogResponse(dialogid, 1, 2, "")
				return false
			end
		end

		if cfg.settings.m4a1 then
			local a = getAmmoInCharWeapon(PLAYER_PED, 31)
			if a < 300 then
				sampSendDialogResponse(dialogid, 1, 3, "")
				return false
			end
		end

		if cfg.settings.rifle then
			local a = getAmmoInCharWeapon(PLAYER_PED, 33)
			if a < 30 then
				sampSendDialogResponse(dialogid, 1, 4, "")
				return false
			end
		end

		
		if cfg.settings.armor and not isArmorTaken then
			sampSendDialogResponse(dialogid, 1, 5, "")
			isArmorTaken = true
			return false
		end

		if cfg.settings.special then
			if cfg.settings.fraction == 1 then
				local a = getAmmoInCharWeapon(PLAYER_PED, 3)
				if a ~= 1 then
					sampSendDialogResponse(dialogid, 1, 6, "")
					return false
				end
			elseif cfg.settings.fraction == 2 then
				local a = getAmmoInCharWeapon(PLAYER_PED, 17)
				if a < 10 then
					sampSendDialogResponse(dialogid, 1, 6, "")
					return false
				end
			else
				local a = getAmmoInCharWeapon(PLAYER_PED, 46)
				if a ~= 1 then
					sampSendDialogResponse(dialogid, 1, 6, "")
					return false
				end
			end
		end
		
		sampCloseCurrentDialogWithButton(0)
		isArmorTaken = false
		return false

	elseif dialogid == 123 and string.find(title, "Склад оружия") and cfg.settings.state then
		if not isGettingAmmo then
			isGettingAmmo = true
			lua_thread.create(getGun)
		end
	end
end

function getGun()
	if cfg.settings.deagle then
		for i=1, cfg.settings.deagle_ammo do
			wait(200)
			sampSendDialogResponse(123, 1, 0, -1)
			wait(200)
		end
	end

	if cfg.settings.shotgun then
		for i=1, cfg.settings.shotgun_ammo do
			wait(200)
			sampSendDialogResponse(123, 1, 1, -1)
			wait(200)
		end
	end

	if cfg.settings.smg then
		for i=1, cfg.settings.smg_ammo do
			wait(200)
			sampSendDialogResponse(123, 1, 2, -1)
			wait(200)
		end
	end

	if cfg.settings.ak47 then
		for i=1, cfg.settings.ak47_ammo do
			wait(200)
			sampSendDialogResponse(123, 1, 3, -1)
			wait(200)
		end
	end

	if cfg.settings.m4a1 then
		for i=1, cfg.settings.m4a1_ammo do
			wait(200)
			sampSendDialogResponse(123, 1, 4, -1)
			wait(200)
		end
	end

	if cfg.settings.rifle then
		for i=1, cfg.settings.rifle_ammo do
			wait(200)
			sampSendDialogResponse(123, 1, 5, -1)
			wait(200)
		end
	end

	if cfg.settings.fraction == 4 and cfg.settings.armor and getCharArmour(PLAYER_PED) < 100 then
		wait(200)
		sampSendDialogResponse(123, 1, 6, -1)
		wait(200)
	end

	isGettingAmmo = false
	sampCloseCurrentDialogWithButton(0)
	return
end

function drawArmorTimer()
	while true do
		wait(0)
		if cfg.settings.isArmorTimerEnabled and (armorTimer >= os.time()) then
			local timer = armorTimer - os.time()
			local text = ""
			local second = timer % 60
			text = string.format("Next Armor: %02d", second)
			if(second <= 5 and second % 2 > 0) then
				text = "{f4b800}" .. text
			end
			renderFontDrawText(renderFont, text, sw - cfg.settings.timerW, sh - cfg.settings.timerH, 0xFFFFFFC9)
		-- else
		-- 	return
		 end
	end
end

function changeTimerPosition()
	local pos = true
	while true do
		wait(0)
		if not isGamePaused() then
			if pos then
				local int_posX, int_posY = getCursorPos()
				cfg.settings.timerW, cfg.settings.timerH = sw - int_posX, sh - int_posY
				if isKeyDown(0x01) then
					showCursor(false, false)
					notf("Timer position changed.")
					pos = false
					inicfg.save(cfg, "AutoAmmo")
				elseif isKeyDown(0x02) then
					showCursor(false, false)
					pos = false
					cfg.settings.timerW, cfg.settings.timerH = sw - reserve_x, sh - reserve_y
					notf("Timer position change canceled.")
				end
			else
				return
			end
		end
	end
end

function notf(msg)
    sampAddChatMessage('[AutoAmmo] {ffffff}'..msg, 0xFF5B00)
end