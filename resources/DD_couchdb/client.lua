-- Event to load player data
RegisterNetEvent('loadPlayerData')
AddEventHandler('loadPlayerData', function(playerData)
    -- Use the playerData to initialize your game variables
    -- For example:
    PlayerData = playerData

    -- Set player position
    if PlayerData.pos then
        SetEntityCoords(PlayerPedId(), PlayerData.pos.x, PlayerData.pos.y, PlayerData.pos.z)
    end

    -- Set player model
    if PlayerData.model then
        SetPlayerModel(PlayerId(), PlayerData.model)
    end

    -- Set player weapons
    if PlayerData.weapons then
        for _, weapon in ipairs(PlayerData.weapons) do
            GiveWeaponToPed(PlayerPedId(), weapon, 999, false, false) -- Replace 999 with actual ammo count
        end
    end
end)
