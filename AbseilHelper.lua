script_name('AbseilHelper')
script_author("Patlatuk")

status = false

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    while true do
        wait(0)
		if testCheat('JJ') then
			if status then
			status = false
			else 
			status = true
			end
		end
            if(getCarHeight()) then
				if(status) then
				drawLine()
				end
			end

    end
end

function getCarHeight()
    if not isCharInAnyCar(PLAYER_PED) then return false end
	if getCarModel(storeCarCharIsInNoSave(PLAYER_PED)) ~= 497 then return false end
	
	local carX, carY, carZ = getCarCoordinates(getCarCharIsUsing(PLAYER_PED))
    local height = math.floor(carZ - getGroundZFor3dCoord(carX, carY, carZ))
    if height <= 100 then
        return true
    elseif height > 100 then
        return false
    end
end

function drawLine()
    local carX, carY, carZ = getCarCoordinates(getCarCharIsUsing(PLAYER_PED))
    local height = math.floor(getGroundZFor3dCoord(carX, carY, carZ))
	local landX, landY = convert3DCoordsToScreen(carX,carY,height)
	local heliX, heliY = convert3DCoordsToScreen(carX,carY,carZ)
	if isPointOnScreen(carX, carY, height, 1.0) then
    renderDrawLine(heliX, heliY, landX, landY, 2.0, 0xFFD00000)
	end
end