class Spreadsheet
  attr_accessor :worksheet

  def initialize
    @worksheet = load_spreadsheet
  end

  def load_spreadsheet
    session = GoogleDrive::Session.from_service_account_key(Rails.root + "app/assets/api/client_secret.json")
    spreadsheet = session.spreadsheet_by_title("IGNBA Roster 2")

    spreadsheet.worksheets.first
  end
end

class String
  def is_team_name?
    Team.pluck(:name).include?(team_name)
  end

  def team_name
    return self unless self.split.length > 1

    self.downcase.split[1].gsub(/\s+/, "-")
  end

  def is_player_name?(verbiage)
    # Returns false if string is a team name, empty space, or salary cap jargon
    return false if self.is_team_name? || self.split.length < 2

    return false if verbiage.include?(self)

    true
  end
end

current_team_name = nil

SALARY_VERBIAGE = ["Total Payroll", "Against Salary Cap", "Against Luxury Tax",
  "Against Apron", "MLE Remaining", "BAE Remaining",
  "Luxury Tax Offender"]

spreadsheet = Spreadsheet.new

spreadsheet.worksheet.rows.each do |row|
  current_player = Player.new
  # Updates team name only when a cell containing an NBA team name is encountered.
  current_team_name = row[0].is_team_name? ? row[0].team_name : current_team_name

  # Skip cell if not a player name
  next unless row[0].is_player_name?(SALARY_VERBIAGE)

  full_name = row[0].downcase.split

  # Skip cell if full player name is already in the database
  next unless !Player.pluck(:first_name, :last_name).include?(full_name)

  current_player.first_name, current_player.last_name = full_name[0], full_name[1]

  current_team = Team.find_by name: current_team_name
  current_player.team_id = current_team.id

  current_player.save
end
