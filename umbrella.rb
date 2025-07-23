require "http"
require "json"
require "dotenv/load"
require "http"

# Hidden variables
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_API_KEY")

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/Fuh1WZEWsG2BYST9ddTFgt9Vp2dV2TNt/41.8887,-87.6355"

# Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)

require "json"

parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")
pp "========================================
    Will you need an umbrella today?    
========================================
Where are you?"

their_city = gets

puts "Checking the weather at " + their_city.to_s + "...."
puts "Your coordintes are " COORDINATES
puts "It is currently " + current_temp.to_s + "."
puts "Next hour: Rain is stopping in " + MINUTES + " min."
puts "In 0 hours, there is a " + PERCENTAGE + "chance of precipitation."
If PERCENTAGE >= 15
  pp "You might want to take an umbrella!"
else
  pp "You don't need an umbrella."
end
pp

