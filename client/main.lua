-- Variable
local currVeh = 0; 
local seatbeltEnabled = false;
local vehData = {
    hasBelt = false,
    engineRunning = false,

    currSpd = 0.0,
    cruiseSpd = 0.0,
    prevVelocity = {x = 0.0, y = 0.0, z = 0.0}, 
};

local playerPed = nil;
-- functions
Citizen.CreateThread(function()
    while true do
        if (currVeh ~= 0) then
            local position = GetEntityCoords(playerPed);

            local EntityHealth = GetEntityHealth(currVeh);
            local maxEntityHealth = GetEntityMaxHealth(currVeh);
            local vehicleHealth = (EntityHealth / maxEntityHealth) * 100;

            SetPlayerVehicleDamageModifier(PlayerId(), 100);
            -- SetVehicleEngineHealth(currVeh, (EntityHealth + 0.00) * 1.5); -- //Note: Comment as suggested by #issuecomment-797556881

            local maxSpeed = 100 - ((100 - ((GetVehicleEngineHealth(currVeh) / maxEntityHealth) * 100)) / 1.5);
            if (vehicleHealth <= 30) then 
                SetVehicleMaxSpeed(currVeh, maxSpeed);
            else 
                SetVehicleMaxSpeed(currVeh, 200.0);
            end

            if (vehicleHealth == 0) then
                SetVehicleEngineOn(currVeh, false, false)
            end
            triggerNUI("updateInfo", {
                -- Vehicle Status
                carHealth = vehicleHealth,
                carFuel = math.floor(GetVehicleFuelLevel(currVeh)),
            })
        end

        Citizen.Wait(currVeh == 0 and 500 or 100);
    end
end)

Citizen.CreateThread(function()
    while true do
        if (currVeh ~= 0) then
            local position = GetEntityCoords(playerPed);

            -- Seat Belt Text
            if (IsControlJustReleased(0, Config['seatbeltInput']) and vehData['hasBelt']) then 
                seatbeltEnabled = not seatbeltEnabled;
                --print(vehData['hasBelt'], seatbeltEnabled)
                triggerNUI("toggleBelt", { hasBelt = vehData['hasBelt'], beltOn = seatbeltEnabled })
            end
            
            if (not vehData['hasBelt'] or not seatbeltEnabled) then
                seatbeltEnabled = false;
        end
    end
        Citizen.Wait(currVeh == 0 and 500 or 5);
    end
end)

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId();
        local veh = GetVehiclePedIsIn(playerPed, false);

        if (veh ~= currVeh) then
            currVeh = veh;
            triggerNUI("toggleUI", veh ~= 0);

            if (veh == 0) then
               seatbeltEnabled = false;
            else
                local vehicleClass = GetVehicleClass(veh);
                vehData['hasBelt'] = isVehicleClassHasBelt(vehicleClass);
            end
        end

        Citizen.Wait(500);
    end
end)




Citizen.CreateThread(function()
	Citizen.Wait(1000*30)
	if GetCurrentResourceName() ~= 'RedSkull_veh_dem_indicator' then
		while true do
			Citizen.Wait(1)
			print("Please don't rename the script! Please rename it back to 'RedSkull_veh_dem_indicator'")
		end
	end
end)
