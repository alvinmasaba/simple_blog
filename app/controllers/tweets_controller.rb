class TweetsController < ApplicationController
    def index
        client = Twitter::REST::Client.new do |config|
            config.consumer_key        = Rails.application.credentials.dig(:twitter, :api_key)
            config.consumer_secret     = Rails.application.credentials.dig(:twitter, :api_secret_key)
            config.access_token        = Rails.application.credentials.dig(:twitter, :access_token)
            config.access_token_secret = Rails.application.credentials.dig(:twitter, :access_token_secret)
        end

        @tweets = client.user_timeline('IGNBA3', count: 10) # Fetch last 10 tweets
    end
end