require 'uri'
require 'net/http'
require 'json'


url = URI("https://twitter-trends5.p.rapidapi.com/twitter/request.php")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Post.new(url)
request["content-type"] = 'application/x-www-form-urlencoded'
request["X-RapidAPI-Key"] = 'd0b234fca2msh13cd8d70484e26fp1473e2jsnea0cb42a106e'
request["X-RapidAPI-Host"] = 'twitter-trends5.p.rapidapi.com'

world = "woeid=1"
us = "woeid=23424977"
request.body = world

response = http.request(request)
trying = response.read_body

response_dict = JSON.parse(trying)

data = response_dict["trends"]

# Extract "name" and "volume" attributes from each hash
name_volume_list = []
data.each do |key, value|
  name = value["name"]
  volume = value["volume"]
  name_volume_list << { "name" => name, "volume" => volume }
end

# Specify the file name
file_name = "name_volume.json"

# Convert the list to JSON format
json_data = JSON.pretty_generate(name_volume_list)

# Write the JSON data to the file
File.open(file_name, "w") do |file|
  file.write(json_data)
end

puts "Name and volume data has been stored in '#{file_name}'."
