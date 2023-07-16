
-- Register 'lbg-chardone' as a networked event
RegisterNetEvent('lbg-chardone')

-- Event handler for 'lbg-chardone'
AddEventHandler('lbg-chardone', function(character)
    -- Do something with the character data
    print('lbg-chardone event triggered with character data:')
    print(character)
end)

-- Register 'saveCharacterInfo' as a networked event
RegisterNetEvent('saveCharacterInfo')

-- Event handler for 'saveCharacterInfo'
AddEventHandler('saveCharacterInfo', function(character)
    -- Save the character data
    print('saveCharacterInfo event triggered with character data:')
    print(character)

    -- Define the CouchDB endpoint
    local couchdb_endpoint = "http://192.168.1.127:5984/fivem_player_stats" -- replace "mydatabase" with your actual database name

    -- Convert the character data to JSON
    local character_json = json.encode(character)

    -- Perform the HTTP request
    PerformHttpRequest(couchdb_endpoint, function(statusCode, response, headers)
        print("CouchDB response: " .. response)
    end, 'POST', character_json, {["Content-Type"] = 'application/json'})
end)