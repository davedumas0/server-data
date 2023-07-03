-- Event triggers when player's game has loaded and they are spawned in the world
AddEventHandler('playerSpawned', function(spawnInfo)
    -- Table of blip details
    local blipDetails = {
        {
            coords = {x = 1693.44, y = 3759.46, z = 34.7},
            sprite = 110, -- AmmuNation icon
            color = 1, -- Red color
            scale = 1.0,
            name = "AmmuNation"
        },
        {
            coords = {x = 252.89, y = -50.14, z = 69.94},
            sprite = 110, -- AmmuNation icon
            color = 1, -- Red color
            scale = 1.0,
            name = "AmmuNation"
        },
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
