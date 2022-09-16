class Spreadsheet
  attr_accessor :worksheet

  SALARY_VERBIAGE = ["Total Payroll", "Against Salary Cap", "Against Luxury Tax",
                     "Against Apron", "MLE Remaining", "BAE Remaining",
                     "Luxury Tax Offender"]

  def initialize
    @worksheet = load_spreadsheet
  end

  def update_players
    current_team_name = nil

    @worksheet.rows.each do |row|
      current_player = Player.new
      # Updates team name only when a cell containing an NBA team name is encountered.
      current_team_name = is_team_name?(row[0]) ? team_name(row[0]) : current_team_name
    
      # Skip cell if not a player name
      next unless is_player_name?(row[0])
      
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
      next unless is_player_name?(row[0])

      i = 1
      contract = Contract.new
      player_name = row[0].downcase.split
      # Find player by name and set contract ID to player ID.
      contract.player_id = Player.find_by(first_name: player_name[0], last_name: player_name[1]).id

      # Check if adjacent cell contains a value until empty cell is reached, as salaries occur in consecutive years
      until row[i] == ""
        # Updates current player's salary for the year corresponding to the value of i 
        contract.update_salary(generate_salary(row[i]), i)
        i += 1
      end

      contract.save
    end
  end

  private

  def generate_salary(num)
    num[1..-1].gsub(",", "").to_i 
  end

  def remove_waived_tag(arr)
    arr.include?("(waived)") ? arr.pop : arr
  end

  def is_team_name?(str)
    Team.pluck(:name).include?(team_name(str))
  end

  def team_name(name)
    return name unless name.split.length > 1

    name.downcase.split[-1].gsub(/\s+/, "-")
  end

  def is_player_name?(str)
    # Returns false if string is a team name, empty space, or salary cap jargon
    return false if is_team_name?(str) || str.split.length < 2

    return false if SALARY_VERBIAGE.include?(str)

    true
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
