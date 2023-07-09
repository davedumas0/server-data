--dofile("keys.lua")
--dofile("menu.lua")

function TeleportToWaypoint()
    local waypointBlip = GetFirstBlipInfoId(8) -- 8 is the blip id for waypoint
    if DoesBlipExist(waypointBlip) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()) -- GetBlipInfoIdCoord
        local groundZ = GetGroundZFor_3dCoord(coord.x, coord.y, coord.z)
        SetEntityCoords(PlayerPedId(), coord.x, coord.y, groundZ)
    else
        Notify("~r~No waypoint has been set!")
    end
end

function SpawnWeaponPickup()
    local playerPed = GetPlayerPed(-1) -- get the local player ped
    local playerPos = GetEntityCoords(playerPed) -- get the player's coordinates
    local pickupPos = playerPos + GetEntityForwardVector(playerPed) * 2.0 -- calculate the position in front of the player

    -- create the weapon pickup
    -- replace WEAPON_PISTOL and 10 with the weapon hash and ammo count you want
    local pickup = CreatePickupRotate(GetHashKey("PICKUP_WEAPON_PISTOL"), pickupPos.x, pickupPos.y, pickupPos.z, 0, 0, 0, 2, 10, 2, true, GetHashKey("WEAPON_PISTOL"))

    Notify("Weapon pickup spawned!")
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end

local options = {
    x = 0.88,
    y = 0.2,
    width = 0.22,
    height = 0.04,
    scale = 0.4,
    font = 2,
    menu_title = "Main obj Menu",
    menu_subtitle = "Categories",
    color_r = 30,
    color_g = 144,
    color_b = 255,
}

function Main()
    DisplayHelpText("Use ~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_DOWN~ to ~y~move~w~ and ~y~Enter~w~ to ~r~select")
	Notify("Press ~r~F7 ~w~to ~g~open~w~/~r~close~w~!")
    options.menu_title = "my menyoo"
    options.menu_subtitle = "~o~main menu"
    ClearMenu()
    Menu.addButton("Spawn Weapon Pickup", "SpawnWeaponPickup", nil)
    Menu.addButton("Teleport to Waypoint", "TeleportToWaypoint", nil) 

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, 168) then -- INPUT_CELLPHONE_DOWN
            Main() -- Menu to draw
            Menu.hidden = not Menu.hidden -- Hide/Show the menu
        end
        Menu.renderGUI(options) -- Draw menu on each tick if Menu.hidden = false
    end       
end)
