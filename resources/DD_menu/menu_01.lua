-- Import the NativeUI library
--local NativeUI = require('NativeUI')

-- Create a new menu pool
local menuPool = NativeUI.CreatePool()

-- Create a new menu
local mainMenu = NativeUI.CreateMenu("Dev Menu", "Select an option")
menuPool:Add(mainMenu)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
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

-- Function to teleport player to waypoint
function TeleportToWaypoint()
    local waypointBlip = GetFirstBlipInfoId(8) -- 8 is the blip id for waypoint
    if DoesBlipExist(waypointBlip) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()) -- GetBlipInfoIdCoord
        local groundZ = GetGroundZFor_3dCoord(coord.x, coord.y, coord.z+0.2)
        SetEntityCoords(PlayerPedId(), coord.x, coord.y, groundZ)
    else
        print("No waypoint set!")
    end
end

-- Function to toggle a translucent black window with player info
function ToggleInfoWindow()
    local windowOptionChecked = false
    Citizen.CreateThread(function()
        while windowOptionChecked do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local networkId = NetworkGetNetworkIdFromEntity(playerPed)
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
        end
    end)
    windowOptionChecked = not windowOptionChecked
end


-- Function to spawn a weapon pickup
function SpawnWeaponPickup()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local pickupPos = coords + GetEntityForwardVector(playerPed) * 2.0 -- calculate the position in front of the player

    -- create the weapon pickup
    -- replace "weapon_pistol" and 10 with the weapon hash and ammo count you want
    local pickup = CreatePickupRotate(GetHashKey("PICKUP_WEAPON_PISTOL"), pickupPos.x, pickupPos.y, pickupPos.z, 0, 0, 0, 2, 50, 2, true, 0x3656C8C1)
    Notify("Weapon pickup spawned!")
end

-- Function to spawn a money pickup
function SpawnMoneyPickup()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local pickupPos = coords + GetEntityForwardVector(playerPed) * 2.0 -- calculate the position in front of the player

    -- create the money pickup
    local pickup = CreatePickup(GetHashKey("PICKUP_MONEY_CASE"), pickupPos.x, pickupPos.y, pickupPos.z, 0, 200, true, 0x6847F130)
    Notify("Money pickup spawned!")
end

-- Function to spawn a vehicle
function SpawnVehicle(vehicleModel)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local spawnPos = coords + GetEntityForwardVector(playerPed) * 5.0 -- calculate the position in front of the player

    local vehicleHash = GetHashKey(vehicleModel)
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(1)
    end
    local vehicle = CreateVehicle(vehicleHash, spawnPos.x, spawnPos.y, spawnPos.z, GetEntityHeading(playerPed), true, false)

    -- set the player into the vehicle
    SetPedIntoVehicle(playerPed, vehicle, -1)

    Notify(vehicleModel .. " spawned!")
end

-- Add new menu items
addMenuItem(mainMenu, "Spawn Weapon Pickup", function() SpawnWeaponPickup() end)
addMenuItem(mainMenu, "Spawn Money Pickup", function() SpawnMoneyPickup() end)
addMenuItem(mainMenu, "Spawn Vehicle", function() SpawnVehicle("adder") end) -- Replace "adder" with the vehicle model you want to spawn
addMenuItem(mainMenu, "Teleport to Waypoint", TeleportToWaypoint)
addMenuItem(mainMenu, "Toggle Info Window", ToggleInfoWindow)

-- Display the menu
menuPool:RefreshIndex()
mainMenu:Visible(true)

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
