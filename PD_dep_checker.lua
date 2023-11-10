script_name('PD_dep_checker')
script_author('Patlatuk')

local encoding = require('lib.encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8

local imgui = require 'imgui'
local key = require 'vkeys'
local SE = require 'lib.samp.events'


local main_window_state = imgui.ImBool(false)
local PDmessage = {}
local count = 0
function imgui.OnDrawFrame()
  if main_window_state.v then
    imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver) 
    imgui.Begin('PD_dep_checker', main_window_state)
   if count > 0 then
    for i=0, #PDmessage do    
    imgui.Text(u8(PDmessage[i]))
    end
   else 
    imgui.Text("Empty")
   end
  imgui.End()
  end
end

function SE.onServerMessage(color, text)
	if((text:find('[Poliсe SF]') or text:find('[Poliсe LS]') or text:find('[Poliсe LV]') or text:find('[FBI]')) 
        and (text:find('юрисдикции') or text:find('юрисдикцию') or text:find('юрисдикцию.') or text:find('юрисдикции.') or text:find('юрисдикцию,') or text:find('юрисдикции,') or text:find('границы'))) then
	   PDmessage[count] = text
		count = count + 1
		return true
	end
end

function main()
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand('pdlist',function ()
        main_window_state.v = not main_window_state.v
    end)
    while true do
        wait(0)
        imgui.Process = main_window_state.v
    end
end
