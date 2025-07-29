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

user_location = gets.chomp.gsub(" ", "%20")

pp user_location

   maps_url =
    "https://maps.googleapis.com/maps/api/geocode/json?" +
    "address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

require "http"

resp = HTTP.get(maps_url)

pp resp.to_s

raw_response = resp.to_s

require "json"

parsed_response = JSON.parse(raw_response)

results = parsed_response.fetch("results")

pp parsed_response.fetch("results")

first_result = results.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

parsed = JSON.parse(raw_response.to_s)
 hourly = parsed.fetch("hourly")
 data   = hourly.fetch("data")

next_hour    = data.at(1)
 precip_prob  = next_hour.fetch("precipProbability")

 percentage   = (precip_prob * 100).round  

 minutely_hash = parsed_response.fetch("minutely", false)

if minutely_hash
  # Option 1: print the summary string
  summary = minutely_hash.fetch("summary")
  puts "Next hour: #{summary}"

  # Option 2: compute the exact minute it stops
  minutely_data = minutely_hash.fetch("data")
  # drop the current minute so index 0 → 1 minute from now
  upcoming     = minutely_data[1..-1]
  stop_index   = upcoming.find_index { |minute_hash|
    minute_hash.fetch("precipIntensity") <= 0.0
  }

end

puts "Checking the weather at " + user_location.to_s + "...."
puts "Your coordintes are #{latitude}, #{longitude}"
puts "It is currently " + #{current_temp} + "."
puts "Next hour: Rain is stopping in " + #{minutes_until_stop} + " min."
puts "In 0 hours, there is a " + #{percentage} + "chance of precipitation."
If percentage >= 15
  pp "You might want to take an umbrella!"
else
  pp "You don't need an umbrella."
end
