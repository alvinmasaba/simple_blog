class Spreadsheet
  attr_accessor :worksheet

  SALARY_VERBIAGE = ["Total Payroll", "Against Salary Cap", "Against Luxury Tax",
                     "Against Apron", "MLE Remaining", "BAE Remaining",
                     "Luxury Tax Offender"]

  def initialize
    @worksheet = load_spreadsheet
  end

  def load_spreadsheet
    session = GoogleDrive::Session.from_service_account_key(Rails.root + "app/assets/api/client_secret1.json")
    spreadsheet = session.spreadsheet_by_title("IGNBA Roster 2")

    spreadsheet.worksheets.first
  end

  def update_players(current_team = nil)
    @worksheet.rows.each do |row|
      current_player = Player.new
      # Updates team name only when a cell containing an NBA team name is encountered.
      current_team_name = row[0].is_team_name? ? row[0].team_name : current_team_name
    
      # Skip cell if not a player name
      next unless row[0].is_player_name?(SALARY_VERBIAGE)
    
      # Skip cell if full player name is already in the database
      next unless !Player.pluck(:first_name, :last_name).include?(row[0].downcase.split)
    
      current_player.update_player_name(row[0])
    
      current_team = Team.find_by name: current_team_name
      current_player.team_id = current_team.id
    
      current_player.save
    end
  end

  def update_contracts
    @worksheet.rows.each do |row|
      next unless row[0].is_player_name?(SALARY_VERBIAGE)

      i = 1

      # Checks value of the adjacent cell until an empty cell is reached
      until row[i] == ""
        # Finds 


      
    end
  end
end
