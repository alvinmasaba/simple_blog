require 'open-uri'
require 'nokogiri'

namespace :update do
  desc "Update database from spreadsheet"
  task :spreadsheet => :environment do    
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

    Rails.logger.info "Attempting to download new working images..."
    Player.where(image: nil).find_each(&:update_image)
  end
  
  desc "Update ratings and badges"
  task :ratings => :environment do
    Rails.logger.info "Updating player ratings and badges..."

    i = 1
    Player.find_each do |player|
      rating = fetch_player_data(player.ratings_url, player)

      next unless player.rating.nil? || player.rating != rating 
      player.update!(rating: rating)
      Rails.logger.info "#{i}. #{player.first_name}_#{player.last_name}: #{rating}"
      i += 1
    end
  end

  # desc "Add assets to teams"
  # task :assets => :environment do
  #   Team.find_each do |team|
  #     team.players.each do |player|
  #       Asset.create!(assetable: player, team: team)
  #     end
    
  #     [2024, 2025, 2026].each do |year|
  #       DraftPick.create!(year: year, round: 1, team: team, owned_by_id: team.id)
  #       DraftPick.create!(year: year, round: 2, team: team, owned_by_id: team.id)
  #     end
  #   end    
  # end
end
