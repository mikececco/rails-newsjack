require 'net/http'
require 'uri'
require 'json'

# Set the API token
api_token = ENV["STABILITY_KEY"]

# Define the request parameters
url = URI.parse('https://api.replicate.com/v1/predictions')
headers = { 'Content-Type' => 'application/json', 'Authorization' => "Token #{api_token}" }
data = {
  version: '8beff3369e81422112d93b89ca01426147de542cd4684c244b673b105188fe5f',
  input: {
    prompt: 'An astronaut riding a rainbow unicorn'
  }
}

# Send the POST request
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
request = Net::HTTP::Post.new(url.path, headers)
request.body = data.to_json
response = http.request(request)

# Extract the response id
if response.code == '200' || response.code == '201'
  parsed_response = JSON.parse(response.body)
  prediction_id = parsed_response['id']

  # Make a GET request to get the response based on the id
  response_url = "https://api.replicate.com/v1/predictions/#{prediction_id}"
  response_request = Net::HTTP::Get.new(response_url, 'Authorization' => "Token #{api_token}")
  response = http.request(response_request)

  # Print the response
  response_hash = JSON.parse(response.body)
  output_url = response_hash['output'] # Assuming 'output' is an array with one URL

  output_url = response_hash['output']

# Check if output_url is nil and assign a default URL if needed
  output_url = 'https://www.newsjack.me/' if output_url.nil?
else
  output_url = 'https://www.newsjack.me/resources'
end
