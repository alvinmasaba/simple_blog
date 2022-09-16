SALARY_VERBIAGE = ["Total Payroll", "Against Salary Cap", "Against Luxury Tax",
  "Against Apron", "MLE Remaining", "BAE Remaining",
  "Luxury Tax Offender"]

current_team_name = nil
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

  current_player.add_name(full_name)

  current_team = Team.find_by name: current_team_name
  current_player.team_id = current_team.id

  current_player.save
end