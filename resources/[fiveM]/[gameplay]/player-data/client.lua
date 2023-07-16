-- Client-side script
RegisterNetEvent('receiveCharacterData')
AddEventHandler('receiveCharacterData', function(characterData)
    -- Do something with the character data
    print('Received character data from server:')
    print(characterData)
end)
