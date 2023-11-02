class GeneratePostsController < ApplicationController
  def index
    @images = GeneratePost.all
  end
  def create
    @generate_post = GeneratePost.new(generate_post_params)
    # @image = stability(@generate_post)
    @image = post

    sleep 2

    respond_to do |format|
      if @generate_post.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(:results, partial: "generated",
            locals: { image: @image, post: @generate_post }, status: :accepted)
        end
        # format.html { redirect_to generate_posts_url}
        # format.html { render partial: 'generated' }
        # format.json { render json: @generate_post, status: :created }
        # format.js   # Render a JavaScript response (used for AJAX)
      else
        format.html { render :new }
        format.json { render json: @generate_post.errors, status: :unprocessable_entity }
        format.js   { render :errors } # Create a partial for displaying errors via JavaScript
      end
    end

  end

  def post
    image_path = ActionController::Base.helpers.asset_path('favicon2.svg')
    html_content =
      "<html>
        <body>
          <div class=\"element\">
            <div class=\"element-x\">
                <p class=\"how-to-develop-a\">-HOW TO DEVELOP A STARTUPPERS MINDSET &amp; NOTICE IDEAS AROUND YOU?</p>
                <div class=\"text-wrapper\">Interview</div>
                <div class=\"div\">John Wain</div>
                <div class=\"text-wrapper-2\">EMOJI IMG</div>
                <div class=\"group\">
                    <img class=\"img\" src=\"#{image_path}\" alt=\"Image Description\">
                </div>
            </div>
          </div>
        </body>
      </html>"


    @kit = IMGKit.new(html_content)
    @kit.stylesheets << '/home/mikececco/rails-newsjack/app/assets/stylesheets/search_preferences/_new.scss'

    image_path = 'public/images/image.png'
    @kit.to_file(image_path)

    # Now you can pass the image path to your view
    image_path
  end

  def stability(input)
    # @input = input
    # # Set the API token
    # api_token = ENV["STABILITY_KEY"]

    # # Define the request parameters
    # url = URI.parse('https://api.replicate.com/v1/predictions')
    # headers = { 'Content-Type' => 'application/json', 'Authorization' => "Token #{api_token}" }
    # data = {
    #   version: '8beff3369e81422112d93b89ca01426147de542cd4684c244b673b105188fe5f',
    #   input: {
    #     prompt: "Giraffe with black skin"
    #   }
    # }

    # # Send the POST request
    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true
    # request = Net::HTTP::Post.new(url.path, headers)
    # request.body = data.to_json
    # response = http.request(request)

    # unless response.is_a?(Net::HTTPSuccess)
    #   raise StandardError, "HTTP request failed with status code #{response.code}. Response body: #{response.body}"
    # end

    # puts "Response code: #{response.code}"
    # puts "Response body: #{response.body}"

    # # Extract the response id
    # if response.code == '200' || response.code == '201'
    #   parsed_response = JSON.parse(response.body)
    #   prediction_id = parsed_response['id']

    #   # Make a GET request to get the response based on the id
    #   response_url = "https://api.replicate.com/v1/predictions/#{prediction_id}"
    #   response_request = Net::HTTP::Get.new(response_url, 'Authorization' => "Token #{api_token}")
    #   response = http.request(response_request)

    #   # Print the response
    #   response_hash = JSON.parse(response.body)
    #   output_url = response_hash['output'] # Assuming 'output' is an array with one URL

    #   puts "OUTPUT URUL #{output_url}"

    # # Check if output_url is nil and assign a default URL if needed
    #   output_url = 'https://pbxt.replicate.delivery/mx7Jb91MfwzPZSCgMjC5CpKbRpX2B0bEu4UD6LaxfT9rWOoRA/out-0.png' if output_url.nil?
    # else
    #   output_url = 'https://pbxt.replicate.delivery/R51v7QaXfMTJdibt0IO56BObyFeCAtwQ1rqhjJJLke5Me3gGB/out-0.png'
    # end
    output_url = 'https://pbxt.replicate.delivery/R51v7QaXfMTJdibt0IO56BObyFeCAtwQ1rqhjJJLke5Me3gGB/out-0.png'
    output_url
  end

  private

  def generate_post_params
    params.require(:generate_post).permit(:company_website_url, :trend)
  end
end
