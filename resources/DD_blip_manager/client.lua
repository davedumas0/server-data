-- Event triggers when player's game has loaded and they are spawned in the world
AddEventHandler('playerSpawned', function(spawnInfo)
    -- Table of blip details
    local blipDetails = {
        {
            coords = {x = -330.24, y = 6083.88, z = 31.45},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = -664.15, y = -935.47, z = 21.83},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = -1320.98, y = -389.43, z = 36.45},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = -1119.23, y = 2697.66, z = 18.55},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = 2569.17, y = 294.47, z = 108.73},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = -3172.68, y = 1087.10, z = 20.83},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = 21.70, y = -1107.41, z = 29.79},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = 810.15, y = -2156.88, z = 29.61},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = 1692.41, y = 3759.46, z = 34.70},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = 244.45, y = -45.84, z = 69.90},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = 843.28, y = -1014.36, z = 27.54},
            sprite = 110,
            color = 1,
            scale = 1.0,
            name = "AmmuNation"
        }
        ,
        -- Add more AmmuNation locations as needed
        -- Refer to online resources for a list of all AmmuNation coordinates
    }

    -- Loop through the table and create a blip at each set of coordinates
    for i, blipInfo in ipairs(blipDetails) do
        -- Create a new blip on the map
        local blip = AddBlipForCoord(blipInfo.coords.x, blipInfo.coords.y, blipInfo.coords.z)

        -- Set the properties of the blip
        SetBlipSprite(blip, blipInfo.sprite) -- Sets the blip's icon
        SetBlipColour(blip, blipInfo.color) -- Sets the blip's color
        SetBlipScale(blip, blipInfo.scale) -- Sets the blip's scale
        SetBlipAsShortRange(blip, true) -- Makes the blip only appear in short range on the minimap

        -- Add a friendly name for the blip
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipInfo.name)
        EndTextCommandSetBlipName(blip)
    end
end)
