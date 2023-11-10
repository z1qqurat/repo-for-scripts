script_name('oopList')
script_author('Patlatuk')

local encoding = require('lib.encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8

local imgui = require 'imgui'
local key = require 'vkeys'
local SE = require 'lib.samp.events'


local main_window_state = imgui.ImBool(false)
local OOPmessage = {}
local count = 0
function imgui.OnDrawFrame()
  if main_window_state.v then
    imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver) 
    imgui.Begin('OOP List', main_window_state)
   if count > 0 then
    for i=0, #OOPmessage do    
    imgui.Text(u8(OOPmessage[i]))
    end
   else 
    imgui.Text("Pusto")
   end
  imgui.End()
  end
end

function SE.onServerMessage(color, text)
	if((text:find('[Poliñe SF]') or text:find('[Poliñe LS]') or text:find('[Poliñe LV]') or text:find('[FBI]')) and (text:find('ÎÎÏ') or text:find('ÎÎÏ.'))) then
	   OOPmessage[count] = text
		count = count + 1
		return true
	end
end

function main()
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand('oop',function ()
        main_window_state.v = not main_window_state.v
    end)
    while true do
        wait(0)
        imgui.Process = main_window_state.v
    end
end
