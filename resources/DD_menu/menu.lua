-- Import the NativeUI library
--local NativeUI = require('NativeUI')

-- Create a new menu pool
local menuPool = NativeUI.CreatePool()

-- Create a new menu
local mainMenu = NativeUI.CreateMenu("Main obj Menu", "Categories")
menuPool:Add(mainMenu)

-- Function to load an IPL
function LoadIPL(iplName)
    if not IsIplActive(iplName) then
        RequestIpl(iplName)
        while not IsIplActive(iplName) do
            Citizen.Wait(100) -- wait for the IPL to load
        end
        Notify(iplName .. " loaded!")
    else
        Notify(iplName .. " is already loaded!")
    end
end

-- Function to spawn a vehicle
function SpawnVehicle()
    local playerPed = GetPlayerPed(-1) -- get the local player ped
    local playerPos = GetEntityCoords(playerPed) -- get the player's coordinates
    local spawnPos = playerPos + GetEntityForwardVector(playerPed) * 5.0 -- calculate the position in front of the player

    -- create the vehicle
    -- replace "adder" with the model name of the vehicle you want to spawn
    local vehicleHash = GetHashKey("adder")
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(1)
    end
    local vehicle = CreateVehicle(vehicleHash, spawnPos.x, spawnPos.y, spawnPos.z, GetEntityHeading(playerPed), true, false)

    -- set the player into the vehicle
    SetPedIntoVehicle(playerPed, vehicle, -1)

    Notify("Vehicle spawned!")
end

-- Function to toggle a translucent black window with player info
function ToggleInfoWindow()
    local showInfo = false
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if showInfo then
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local heading = GetEntityHeading(playerPed)
                local networkId = NetworkGetNetworkIdFromEntity(playerPed)
                local pedModel = GetEntityModel(playerPed)

                -- Draw the translucent black window
                DrawRect(0.9, 0.2, 0.2, 0.2, 0, 0, 0, 150)

                -- Draw the text
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.35)
                SetTextColour(255, 255, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("Coords: " .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. "\nHeading: " .. heading .. "\nNetwork ID: " .. networkId)
                DrawText(0.8, 0.1)

                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.35)
                SetTextColour(255, 255, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("Ped Model: " ..  pedModel)
                DrawText(0.8, 0.3)
            end
        end
    end)
    showInfo = not showInfo
end


function SpawnWeaponPickup()
    local playerPed = GetPlayerPed(-1) -- get the local player ped
    local playerPos = GetEntityCoords(playerPed) -- get the player's coordinates
    local pickupPos = playerPos + GetEntityForwardVector(playerPed) * 2.0 -- calculate the position in front of the player

    -- create the weapon pickup
    -- replace WEAPON_PISTOL and 10 with the weapon hash and ammo count you want
    local pickup = CreatePickupRotate(GetHashKey("PICKUP_WEAPON_PISTOL"), pickupPos.x, pickupPos.y, pickupPos.z, 0, 0, 0, 2, 100, 2, true, GetHashKey("WEAPON_PISTOL"))

    Notify("Weapon pickup spawned!")
end

function TeleportToWaypoint()
    local waypointBlip = GetFirstBlipInfoId(8) -- 8 is the blip id for waypoint
    if DoesBlipExist(waypointBlip) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()) -- GetBlipInfoIdCoord
        local groundZ = GetGroundZFor_3dCoord(coord.x, coord.y, coord.z+0.2)
        SetEntityCoords(PlayerPedId(), coord.x, coord.y, groundZ)
    else
        Notify("~r~No waypoint has been set!")
    end
end

-- Function to add a menu item
function addMenuItem(menu, text, func)
    local item = NativeUI.CreateItem(text, "")
    item.Activated = function(sender, item)
        if item == item then
            func()
        end
    end
    menu:AddItem(item)
end

-- Function to display the notification
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local ipls = {
    {name = "Trevor's Trailer", ipl = "TrevorsTrailer", x = 1985.7, y = 3815.2, z = 32.2},
    {name = "Bahama Mamas", ipl = "bh1_16_refurb", x = -1388.0, y = -618.3, z = 30.8},
    {name = "O'Neil Ranch", ipl = "farm", x = 2441.2, y = 4958.5, z = 51.7},
    {name = "FIB Lobby", ipl = "FIBlobby", x = 105.4, y = -745.5, z = 44.7},
    {name = "Life Invader Office", ipl = "facelobby", x = -1047.9, y = -233.0, z = 39.0},
    {name = "Bunker", ipl = "gr_entrance_placement", x = 892.6384, y = -3245.8664, z = -98.2645},
    -- add more IPLs as needed
}

-- Function to load an IPL and teleport the player
function LoadIPLAndTeleport(ipl, x, y, z)
    LoadIPL(ipl)
    SetEntityCoords(PlayerPedId(), x, y, z)
end

-- Create a new submenu for IPLs
local iplMenu = menuPool:AddSubMenu(mainMenu, "Load IPL and Teleport")

-- Add known IPLs to the submenu
for i=1, #ipls do
    addMenuItem(iplMenu, ipls[i].name, function() LoadIPLAndTeleport(ipls[i].ipl, ipls[i].x, ipls[i].y, ipls[i].z) end)
end



addMenuItem(mainMenu, "Spawn Weapon Pickup", SpawnWeaponPickup)
addMenuItem(mainMenu, "Teleport to Waypoint", TeleportToWaypoint)
addMenuItem(mainMenu, "Spawn Vehicle", SpawnVehicle)
addMenuItem(mainMenu, "Toggle Info Window", ToggleInfoWindow)


-- This function will be called every frame to keep the menu updated
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        menuPool:ProcessMenus()
        if IsControlJustReleased(0, 244) then -- INPUT_CELLPHONE_DOWN
            
            mainMenu:Visible(not mainMenu:Visible())
            SetCursorLocation(0.5, 0.5)
        end
    end
end)
