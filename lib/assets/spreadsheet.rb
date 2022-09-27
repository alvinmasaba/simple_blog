class Spreadsheet
  attr_accessor :worksheet

  SALARY_VERBIAGE = ["Total Payroll", "Against Salary Cap", "Against Luxury Tax",
                     "Against Apron", "MLE Remaining", "BAE Remaining",
                     "Luxury Tax Offender", "Cap hold", 
                     "Non-Tax Payer Exception"]

  def initialize
    @worksheet = load_spreadsheet
  end

  def update_players
    current_team_name = nil

    @worksheet.rows.each do |row|
      current_player = Player.new
      # Updates team name only when a cell containing an NBA team name is encountered.
      current_team_name = row[0].is_team_name? ? row[0].generate_team_name : current_team_name
    
      # Skip cell if not a player name
      next unless row[0].is_player_name?(SALARY_VERBIAGE)
      
      full_name = remove_waived_tag(row[0].downcase.split)
      # Skip cell if full player name is already in the database
      next unless !player_in_db?(full_name)

      current_player.update_player_name(full_name)
    
      current_team = Team.find_by(name: current_team_name)

      current_player.team_id = current_team.id
    
      current_player.save
    end
  end

  def update_contracts
    @worksheet.rows.each do |row|
      next unless row[0].is_player_name?(SALARY_VERBIAGE)

      i = 1
      contract = Contract.new
      player_name = row[0].downcase.split

      p player_name
      # Find player by name and set contract ID to player ID.
      player = Player.find_by(first_name: player_name[0], last_name: player_name[1])
      contract.player_id = player.id
      contract.team_id = player.team_id

      next unless !Contract.where(player_id: contract.player_id).exists?

      # Check if adjacent cell contains a value until empty cell is reached, as salaries occur in consecutive years
      until row[i] == ""
        # Updates current player's salary for the year corresponding to the value of i 
        contract.update_salary(generate_salary(row[i]), i)
        contract.two_way = true if row[i] == "Two-Way"
        i += 1
      end

      contract.save!
    end
  end

  private

  def generate_salary(num)
    num == "Two-Way" ? num : num[1..-1].gsub(",", "").to_i
  end

  def remove_waived_tag(arr)
    if arr.include?("(waived)") 
      arr.pop
      arr
    else
      arr
    end
  end

  def player_in_db?(player_name)
    if player_name.length < 3
      Player.pluck(:first_name, :last_name).include?(player_name)
    else
      Player.pluck(:first_name, :last_name, :suffix).include?(player_name)
    end
  end

  def load_spreadsheet
    session = GoogleDrive::Session.from_service_account_key(Rails.root + "app/assets/api/client_secret1.json")
    spreadsheet = session.spreadsheet_by_title("IGNBA Roster 2")

    spreadsheet.worksheets.first
  end
end
