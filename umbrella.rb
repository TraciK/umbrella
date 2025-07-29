require "http"
require "json"
require "dotenv/load"

puts "========================================"
puts "    Will you need an umbrella today?"
puts "========================================"
puts
puts "Where are you?"
raw_location      = gets.chomp
encoded_location  = raw_location.gsub(" ", "%20")

# 1) Geocode the location
maps_url =
  "https://maps.googleapis.com/maps/api/geocode/json?" +
  "address=#{encoded_location}&" +
  "key=#{ENV.fetch("GMAPS_KEY")}"

maps_resp     = HTTP.get(maps_url)
maps_data     = JSON.parse(maps_resp.to_s)
results       = maps_data.fetch("results")
first_result  = results.at(0)
loc_hash      = first_result.fetch("geometry").fetch("location")
latitude      = loc_hash.fetch("lat")
longitude     = loc_hash.fetch("lng")

puts "Checking the weather at #{raw_location}...."
puts "Your coordinates are #{latitude}, #{longitude}."

# 2) Fetch the weather
pirate_weather_api_key = ENV.fetch("PIRATE_WEATHER_API_KEY")
pirate_weather_url =
  "https://api.pirateweather.net/forecast/" +
  "#{pirate_weather_api_key}/#{latitude},#{longitude}"

weather_resp  = HTTP.get(pirate_weather_url)
weather_data  = JSON.parse(weather_resp.to_s)

# 3) Current temperature
currently_hash = weather_data.fetch("currently")
current_temp   = currently_hash.fetch("temperature")
puts "It is currently #{current_temp}°F."

# 4) Minute-by-minute summary (if available)
minutely_hash = weather_data.fetch("minutely", false)

if minutely_hash
  summary          = minutely_hash.fetch("summary")
  puts "Next hour: #{summary}"

  minutely_data    = minutely_hash.fetch("data")
  upcoming_minutes = minutely_data[1..-1]
  stop_index       = upcoming_minutes.find_index do |m|
    m.fetch("precipIntensity") <= 0.0
  end

  if stop_index
    minutes_until_stop = stop_index + 1
    puts "Rain stops in #{minutes_until_stop} minutes."
  else
    puts "Rain continues for the next hour."
  end
end

# 5) Hourly precipitation check
hourly_data = weather_data.fetch("hourly").fetch("data")[1..12]
any_precip  = false

hourly_data.each do |hour_hash|
  precip_prob   = hour_hash.fetch("precipProbability")
  if precip_prob > 0.10
    any_precip     = true
    hours_from_now = ((Time.at(hour_hash.fetch("time")) - Time.now) / 3600).round
    percentage     = (precip_prob * 100).round
    puts "In #{hours_from_now} hours, there is a #{percentage}% chance of precipitation."
  end
end

if any_precip
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella today."
end
