require 'open-uri'
require 'nokogiri'

namespace :update do
  desc "Update database from spreadsheet"
  task :spreadsheet => :environment do    
    class String
      def is_team_name?
        Team.pluck(:name).include?(self.team_name)
      end

      def team_name
        return self unless self.split.length > 1

        self.generate_team_name
      end

      def generate_team_name
        if self == "Portland Trail Blazers"
          return "trail-blazers"
        else
          self.downcase.split[-1].gsub(/\s+/, "-")
        end
      end

      def is_player_name?(verbiage)
        # Returns false if string is a team name, empty space, or salary cap jargon
        return false if self.is_team_name? || self.split.length < 2
        return false if verbiage.include?(self)
        return false if self.split.include?("GM:")

        true
      end
    end

    Rails.logger.info "Starting updater..."
    spreadsheet = Spreadsheet.new

    Rails.logger.info "Deleting non-players..."
    Player.where(first_name: "veteran").destroy_all

    Rails.logger.info "Deleting duplicates..."
    # This will keep the first record and delete all others with the same name
    Player.group(:first_name, :last_name).having("count(*) > 1").pluck(:first_name, :last_name).each do |first_name, last_name|
      duplicates = Player.where(first_name: first_name, last_name: last_name)
      duplicates[1..].each(&:destroy)
    end

    Rails.logger.info "Updating salary cap info..."
    spreadsheet.update_cap_figures

    Rails.logger.info "Updating players..."
    spreadsheet.update_players
    spreadsheet.update_draft_rights

    Rails.logger.info "Updating contracts..."
    spreadsheet.update_contracts

    Rails.logger.info "Updating images..."
    Rails.logger.info "Deleting corrupt images first..."

    Rails.logger.info "Attempting to download new working images..."
    Player.where(image: nil).find_each(&:update_image)

    Rails.logger.info "Finished updating database!"
  end

  desc "Add assets to teams"
  task :assets => :environment do
    Team.find_each do |team|
      i = 1
      team.players.each do |player|
        Rails.logger.info "#{i}. #{player.first_name}_#{player.last_name}"
        Asset.create!(assetable: player, team: team)
        i += 1
      end
    
      [2024, 2025, 2026].each do |year|
        DraftPick.create!(year: year, round: 1, team: team, owned_by_id: team.id)
        DraftPick.create!(year: year, round: 2, team: team, owned_by_id: team.id)
      end
    end    
  end
  
  desc "Add ratings to players"
  task :ratings => :environment do
    i = 1
    Player.find_each do |player|
      rating = fetch_player_rating(player.ratings_url)

      next unless player.rating.nil? || player.rating != rating 
      player.update!(rating: rating)
      Rails.logger.info "#{i}. #{player.first_name}_#{player.last_name}: #{rating}"
      i += 1
    end
  end
end

def fetch_player_rating(url)
   # Sanitize the URL
   sanitized_url = URI.encode(url.strip)

   begin
     html_content = URI.open(sanitized_url).read
   rescue OpenURI::HTTPError => e
     Rails.logger.error "#{sanitized_url} returned an error: #{e.message}"
     return nil
   rescue URI::InvalidURIError => e
     Rails.logger.error "Invalid URL: #{sanitized_url}. Error: #{e.message}"
     return nil
   end

  doc = Nokogiri::HTML(html_content)
  rating_element = doc.at('.attribute-box-player') # Using the class to find the element

  if rating_element
    return rating_element.text.strip.to_i
  else
    # Handle cases where the rating element isn't found
    Rails.logger.error "Rating not found for URL: #{url}"
    return nil
  end
end