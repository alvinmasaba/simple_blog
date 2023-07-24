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

    puts "Starting updater..."
    spreadsheet = Spreadsheet.new

    puts "Deleting non-players..."
    Player.where(first_name: "veteran").destroy_all

    puts "Deleting duplicates..."
    # This will keep the first record and delete all others with the same name
    Player.group(:first_name, :last_name).having("count(*) > 1").pluck(:first_name, :last_name).each do |first_name, last_name|
      duplicates = Player.where(first_name: first_name, last_name: last_name)
      duplicates[1..].each(&:destroy)
    end

    puts "Updating salary cap info..."
    spreadsheet.update_cap_figures

    puts "Updating players..."
    spreadsheet.update_players
    spreadsheet.update_draft_rights

    puts "Updating contracts..."
    spreadsheet.update_contracts

    puts "Updating images..."
    puts "Deleting corrupt images first..."
    # Player.update_all(image: nil)

    puts "Attempting to download new working images..."
    Player.where(image: nil).find_each(&:update_image)

    puts "Finished updating database!"
  end

  desc "Add assets to teams"
  task :assets => :environment do
    Team.find_each do |team|
      team.players.each do |player|
        Asset.create(assetable: player, team: team)
      end
    
      [2024, 2025, 2026].each do |year|
        first_pick = DraftPick.create(year: year, round: 1, team: team, owned_by_id: team.id)
        second_pick = DraftPick.create(year: year, round: 2, team: team, owned_by_id: team.id)
        Asset.create(assetable: first_pick, team: team)
        Asset.create(assetable: second_pick, team: team)
      end
    end    
  end 
end
