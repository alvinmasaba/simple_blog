class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :fetch_latest_tweets

  private
     
  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def fetch_latest_tweets
    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.credentials.dig(:twitter, :api_key)
        config.consumer_secret     = Rails.application.credentials.dig(:twitter, :api_secret_key)
        config.access_token        = Rails.application.credentials.dig(:twitter, :access_token)
        config.access_token_secret = Rails.application.credentials.dig(:twitter, :access_token_secret)
      end

      @tweets = client.user_timeline('IGNBA3', count: 3) # Fetch the last 3 tweets
    rescue StandardError => e
      @tweets = []
      @error = "Could not fetch tweets: #{e.message}"
    end
  end
end
