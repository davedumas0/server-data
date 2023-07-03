-- Event when a player is connecting to the server
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
  local playerId = source
  local identifiers = GetPlayerIdentifiers(playerId)
  local steamId = identifiers[1] -- assuming first identifier is always Steam ID
  local url = 'http://192.168.1.127:5984/fivem_player_stats/' .. steamId -- replace with your actual URL and DB name

  -- GET request to fetch player's data
  PerformHttpRequest(url, function(statusCode, response, headers)
      if statusCode == 200 then
          -- If statusCode is 200, the player is in the database
          print(playerName .. " is already in the database.")
      elseif statusCode == 404 then
          -- If statusCode is 404, the player is not found in the database. Let's add them.
          local data = {
            _id = steamId,
            steamId = steamId,
            name = playerName,
            -- Add more fields as needed
          }
          -- Use the general database URL without a specific ID to let CouchDB generate an ID
          url = 'http://192.168.1.127:5984/fivem_player_stats'

          PerformHttpRequest(url, function(postStatusCode, postResponse, postHeaders)
              if postStatusCode == 201 then
                  print(playerName .. " has been added to the database.")
              else
                  print("Error: " .. postStatusCode)
              end
          end, 'POST', json.encode(data), {["Content-Type"] = 'application/json'})
      else
          print("Error: " .. statusCode)
      end
  end, 'GET', '', {})
end)

-- Event when a player spawns
AddEventHandler('playerSpawned', function(spawnInfo)
  local playerId = source
  local identifiers = GetPlayerIdentifiers(playerId)
  local steamId = identifiers[1] -- assuming first identifier is always Steam ID
  local url = 'http://192.168.1.127:5984/fivem_player_stats/' .. steamId -- replace with your actual URL and DB name

  local coords = GetEntityCoords(GetPlayerPed(playerId))
  local data = {
      _id = steamId,
      pos = {
          x = coords.x,
          y = coords.y,
          z = coords.z
      },
  }
  PerformHttpRequest(url, function(statusCode, response, headers)
      if statusCode == 200 then
          print("Player position has been updated in the database.")
      else
          print("Error: " .. statusCode)
      end
  end, 'PUT', json.encode(data), {["Content-Type"] = 'application/json'})
end)
