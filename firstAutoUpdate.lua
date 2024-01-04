script_name('firstAutoUpdate')
script_author('Patlatuk')
script_version("1.0")

function updateFunction()
    return {
        check = function(update_url, script_url, script_repo_url)
            local dlstatus = require('moonloader').download_status; local update_file = os.tmpname()
            local timeout_timer = os.clock()
            if doesFileExist(update_file) then os.remove(update_file) end; downloadUrlToFile(update_url, update_file,
                function(index, status, current, total)
                    if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if doesFileExist(update_file) then
                            local file_content = io.open(update_file, 'r')
                            if file_content then
                                local update_json = decodeJson(file_content:read('*a'))
                                remote_version = update_json.version; file_content:close()
                                os.remove(update_file)
                                if remote_version > tonumber(thisScript().version) then
                                    lua_thread.create(
                                        function()
                                            wait(250)
                                            downloadUrlToFile(script_url, thisScript().path,
                                                function(index, status, current, total)
                                                    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                                                        notf("Update completed")
                                                        goupdatestatus = true; lua_thread.create(function()
                                                            wait(500)
                                                            thisScript():reload()
                                                        end)
                                                    end; if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                                                        if goupdatestatus == nil then
                                                            notf("Update failed")
                                                            update = false
                                                        end
                                                    end
                                                end)
                                        end)
                                else
                                    update = false
                                end
                            end
                        else
                            notf("Can't check for update. Check new version by yourself(link in console)")
                            print("Check update here: " .. script_repo_url)
                            update = false
                        end
                    end
                end)
            while update ~= false and os.clock() - timeout_timer < 10 do wait(100) end; if os.clock() - timeout_timer >= 10 then
                notf("Update timeout. Check new version by yourself(link in console).")
                print("Check update here: " .. script_repo_url)
            end
        end
    }
end

local autoupdate_loaded = false
local updater = nil
local updater_loaded = pcall(updateFunction)
if updater_loaded then
    autoupdate_loaded, updater = pcall(updateFunction)
    if autoupdate_loaded then
        updater.update_url = "https://github.com/z1qqurat/repo-for-scripts/raw/main/firstAutoUpdate_update.json"
        updater.script_repo_url = "https://github.com/z1qqurat/repo-for-scripts"
        updater.script_url = "https://github.com/z1qqurat/repo-for-scripts/raw/main/firstAutoUpdate.lua"
    end
end

local imgui = require 'mimgui'
local inicfg = require 'inicfg'

local cfg = inicfg.load({
    settings = {
		state = true,
        isLoadMessageEnabled = true,
    },
}, "firstAutoUpdate.ini")

local sw, sh = getScreenResolution()

local new = imgui.new
local mainMenu = new.bool()
local isLoadMessageEnabled = new.bool(cfg.settings.isLoadMessageEnabled)


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then
		return
	end
	while not isSampAvailable() do wait(100) end

	if autoupdate_loaded and updater then
        pcall(updater.check, updater.update_url, updater.script_url, updater.script_repo_url)
    end

    sampRegisterChatCommand('aa', showMainMenu)
	sampRegisterChatCommand('aaa', toggleStatus)

	while true do
		wait(0)
	end
end

function showMainMenu()
    mainMenu[0] = not mainMenu[0]
end

imgui.OnFrame(function () return mainMenu[0] end,
function ()
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin("firstAutoUpdate by Patlatuk v"..thisScript().version, mainMenu, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

	if imgui.Checkbox("Show welcome message on script load", isLoadMessageEnabled) then
    	cfg.settings.isLoadMessageEnabled = isLoadMessageEnabled[0]
    	inicfg.save(cfg, "firstAutoUpdate")
    end
    imgui.End()
end)


function notf(msg)
    sampAddChatMessage('[firstAutoUpdate] {ffffff}'..msg, 0xFF5B00)
end