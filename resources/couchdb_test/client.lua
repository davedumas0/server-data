http = require('socket.http')

-- CouchDB URL
url = 'http://192.168.1.127:5984/database_name'

-- GET request
response, status, headers = http.request(url)

if status == 200 then
  print(response)
else
  print("Error: " .. status)
end
