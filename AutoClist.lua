script_name('AutoClist')
script_author('Modified by Patlatuk')
script_version("1.2")

local SE = require 'samp.events'
local imgui, ffi = require 'mimgui', require 'ffi'
local new, str = imgui.new, ffi.string
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local imMenu = new.bool()
local mainc = imgui.ImVec4(0.0, 0.52, 0.74, 1.0)
local inicfg = require 'inicfg'
local cfg = inicfg.load({
    main = {
        active = true,
        activeOnFirstSpawn = true,
        clist = "0",
    }
}, "AutoClist.ini")
local scriptActive = new.bool(cfg.main.active)
local firstSpawnActive = new.bool(cfg.main.activeOnFirstSpawn)
local isWar = false
local firstSpawnClist = true
-- local clistList = {}
-- clistList[16777215] = "0";
-- clistList[2852758528] = "1";
-- clistList[2857893711] = "2";
-- clistList[2857434774] = "3";
-- clistList[2855182459] = "4";
-- clistList[2863589376] = "5";
-- clistList[2854722334] = "6";
-- clistList[2858002005] = "7";
-- clistList[2868839942] = "8";
-- clistList[2868810859] = "9";
-- clistList[2868137984] = "10";
-- clistList[2864613889] = "11";
-- clistList[2863857664] = "12";
-- clistList[2862896983] = "13";
-- clistList[2868880928] = "14";
-- clistList[2868784214] = "15";
-- clistList[2868878774] = "16";
-- clistList[2853375487] = "17";
-- clistList[2853039615] = "18";
-- clistList[2853411820] = "19";
-- clistList[2855313575] = "20";
-- clistList[2853260657] = "21";
-- clistList[2861962751] = "22";
-- clistList[2865042943] = "23";
-- clistList[2860620717] = "24";
-- clistList[2868895268] = "25";
-- clistList[2868899466] = "26";
-- clistList[2868167680] = "27";
-- clistList[2868164608] = "28";
-- clistList[2864298240] = "29";
-- clistList[2863640495] = "30";
-- clistList[2864232118] = "31";
-- clistList[2855811128] = "32";
-- clistList[2866272215] = "33";
-- local playerClist = "0"
function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("aClist", showMainMenu)
    local fi
    -- while true do
        -- wait(0)
        -- if cfg.main.active then
            -- local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            -- local clist = sampGetPlayerColor(id)
            -- -- playerClist = clistList[clist]
        -- end
    -- end
    while true do
        wait(0)
        if cfg.main.active and isCharDead(PLAYER_PED) and not sampTextdrawIsExists(815) then
            if not isWarActiveModern() then
                -- if not isWarActiveClassic() and not isWarActiveModern() then
                wait(5000)
                sampSendChat("/clist "..cfg.main.clist)
            end
        end
    end
end

function isWarActiveModern()
    for id = 300, 400 do
        if sampTextdrawIsExists(id) then
			x, y = sampTextdrawGetPos(id)
			if x == 64 and y == 273 then
                if(string.find(sampTextdrawGetString(id), "personal_score")) then
                    return true
                else
                    return false
                end
            end
        end
    end
    return false
end

function isWarActiveClassic()
    for id = 700, 800 do
        if sampTextdrawIsExists(id) then
			x, y = sampTextdrawGetPos(id)
			if x == 39 and y == 204 then
                if(string.find(sampTextdrawGetString(id), "TIME:~w~")) then
                    return true
                else
                    return false
                end
            end
        end
    end
    return false
end

function showMainMenu(arg)
    imMenu[0] = not imMenu[0]
end

function SE.onServerMessage(color, text)
    if (text == " Рабочий день начат" or text == " Сработала антирассинхронизация. Вы были заспавнены.") and cfg.main.active then
        lua_thread.create(function()
            wait(500)
            sampSendChat("/clist "..cfg.main.clist)
        end)
    end
end


function SE.onDisplayGameText(style, time, text)
	if cfg.main.activeOnFirstSpawn and firstSpawnClist then
		if string.find(text,"Welcome") then
            lua_thread.create(function()
                wait(1000)
                sampSendChat("/clist "..cfg.main.clist)
                firstSpawnClist = false
            end)
		end
	end
end

function apply_custom_style()
   local style = imgui.GetStyle()
   local colors = style.Colors
   local clr = imgui.Col
   local ImVec4 = imgui.ImVec4
   style.WindowRounding = 1.5
   style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
   style.FrameRounding = 1.0
   style.ItemSpacing = imgui.ImVec2(4.0, 4.0)
   style.ScrollbarSize = 13.0
   style.ScrollbarRounding = 0
   style.GrabMinSize = 8.0
   style.GrabRounding = 1.0
   style.WindowBorderSize = 1.0
   style.WindowPadding = imgui.ImVec2(4.0, 4.0)
   style.FramePadding = imgui.ImVec2(2.5, 3.5)
   style.ButtonTextAlign = imgui.ImVec2(0.5, 0.35)
   style.WindowMinSize = imgui.ImVec2(100, 10)
 
 
   colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)--
   colors[clr.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 1.00)--ImVec4(0.7, 0.7, 0.7, 1.0)
   colors[clr.WindowBg]               = ImVec4(0.07, 0.07, 0.07, 1.0)
   colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
   colors[clr.Border]                 = ImVec4(mainc.x, mainc.y, mainc.z, 0.4)
   colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
   colors[clr.FrameBg]                = ImVec4(mainc.x, mainc.y, mainc.z, 0.7)
   colors[clr.FrameBgHovered]         = ImVec4(mainc.x, mainc.y, mainc.z, 0.4)
   colors[clr.FrameBgActive]          = ImVec4(mainc.x, mainc.y, mainc.z, 0.9)
   colors[clr.TitleBg]                = ImVec4(mainc.x, mainc.y, mainc.z, 1.0)
   colors[clr.TitleBgActive]          = ImVec4(mainc.x, mainc.y, mainc.z, 1.0)
   colors[clr.TitleBgCollapsed]       = ImVec4(mainc.x, mainc.y, mainc.z, 0.79)
   colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
   colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
   colors[clr.ScrollbarGrab]          = ImVec4(mainc.x, mainc.y, mainc.z, 0.8)
   colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
   colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
   colors[clr.CheckMark]              = ImVec4(mainc.x + 0.13, mainc.y + 0.13, mainc.z + 0.13, 1.00)
   colors[clr.SliderGrab]             = ImVec4(0.28, 0.28, 0.28, 1.00)
   colors[clr.SliderGrabActive]       = ImVec4(0.35, 0.35, 0.35, 1.00)
   colors[clr.Button]                 = ImVec4(mainc.x, mainc.y, mainc.z, 0.8)
   colors[clr.ButtonHovered]          = ImVec4(mainc.x, mainc.y, mainc.z, 0.63)
   colors[clr.ButtonActive]           = ImVec4(mainc.x, mainc.y, mainc.z, 1.0)
   colors[clr.Header]                 = ImVec4(mainc.x, mainc.y, mainc.z, 0.6)
   colors[clr.HeaderHovered]          = ImVec4(mainc.x, mainc.y, mainc.z, 0.43)
   colors[clr.HeaderActive]           = ImVec4(mainc.x, mainc.y, mainc.z, 0.8)
   colors[clr.Separator]              = colors[clr.Border]
   colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
   colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
   colors[clr.ResizeGrip]             = ImVec4(mainc.x, mainc.y, mainc.z, 0.8)
   colors[clr.ResizeGripHovered]      = ImVec4(mainc.x, mainc.y, mainc.z, 0.63)
   colors[clr.ResizeGripActive]       = ImVec4(mainc.x, mainc.y, mainc.z, 1.0)
   colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
   colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
   colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
   colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
   colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
 end

-- imgui.OnInitialize() вызывается всего раз, перед первым показом рендера
imgui.OnInitialize(function()
	apply_custom_style() -- применим кастомный стиль
	local defGlyph = imgui.GetIO().Fonts.ConfigData.Data[0].GlyphRanges
	imgui.GetIO().Fonts:Clear() -- очистим шрифты
	local font_config = imgui.ImFontConfig() -- у каждого шрифта есть свой конфиг
	font_config.SizePixels = 14.0;
   font_config.GlyphExtraSpacing.x = 0.1
   -- основной шрифт
	local def = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\arialbd.ttf', font_config.SizePixels, font_config, defGlyph)
   
   local config = imgui.ImFontConfig()
   config.MergeMode = true
   config.PixelSnapH = true
   config.FontDataOwnedByAtlas = false
   config.GlyphOffset.y = 1.0 -- смещение на 1 пиксеот вниз
   imgui.GetIO().ConfigWindowsMoveFromTitleBarOnly = true
	
end)

imgui.OnFrame(function () return imMenu[0] end,
function ()
    local w, h = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(w / 2, h / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin(u8"AutoClist ", imMenu, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize )
    if imgui.Checkbox("Enable script", scriptActive) then
        cfg.main.active = scriptActive[0]
        inicfg.save(cfg, "AutoClist")
    end
    if imgui.Checkbox(u8("Apply aclist after connection to the server"), firstSpawnActive) then
        cfg.main.activeOnFirstSpawn = firstSpawnActive[0]
        inicfg.save(cfg, "AutoClist")
    end
    imgui.PushItemWidth(40)
    local buf1 = new.char[255](u8(cfg.main.clist))
    if imgui.InputText("/clist number((digits only)", buf1, ffi.sizeof(buf1)) then
        cfg.main.clist = u8:decode(ffi.string(buf1))
        inicfg.save(cfg, "AutoClist")
    end
    imgui.Separator()
    if imgui.Button("Reload script", imgui.ImVec2(350, 20)) then
        thisScript():reload()
    end
    imgui.Separator()
    imgui.End()
end)