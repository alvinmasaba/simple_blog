require 'nokogiri'
require 'open-uri'
require_relative '../assets/updater_helpers'

class Spreadsheet
  attr_accessor :worksheet


  SALARY_VERBIAGE = ["Total Payroll", "Against Salary Cap", "Against Luxury Tax",
                     "Against Apron", "Against 2nd Apron", "MLE Remaining", "BAE Remaining",
                     "Luxury Tax Offender", "Cap hold", "cap hold", "Draft Rights",
                     "Player Option", "Team Option", "Qualifying Offer",
                     "Veteran Mininum Exception", "Bi-Annual Exception",
                     "Non-Tax Payer Exception", "Payroll Information", "Salary Cap",
                     "Luxury Tax", "Apron", "2nd Apron", "Minimum Payroll"]
  
  CAP_FIGURES = ["Bi-Annual Exception", "Salary Cap",
    "Luxury Tax", "Apron", "2nd Apron", "Minimum Payroll"]


  def initialize
    @worksheet = load_spreadsheet
  end


  def update_players(current_team_name = nil)
    @worksheet.rows.each do |row|
      current_team_name = row[0].is_team_name? ? row[0].generate_team_name : current_team_name
      do_the_thing(row[0], current_team_name)
    end
  end


  def update_draft_rights(current_team_name = nil)
    @worksheet.rows.each do |row|
      current_team_name = row[0].is_team_name? ? row[0].generate_team_name : current_team_name
      do_the_thing(row[7], current_team_name)
    end
  end


  def do_the_thing(cell, current_team_name)
    return unless cell.is_player_name?(SALARY_VERBIAGE)
    name = cell.downcase.split
    return unless !waived?(name)

    find_or_create_player(name, current_team_name)
  end



  def update_contracts
    @worksheet.rows.each do |row|
      next unless row[0].is_player_name?(SALARY_VERBIAGE)
      player_name = row[0].downcase.split
      next unless !waived?(player_name)
      
      i = 1
      contract = Contract.new

      p player_name
      # Find player by name and set contract ID to player ID.
      player = Player.find_by(first_name: player_name[0], last_name: player_name[1])

      next unless player
      
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

  def update_cap_figures
    year = @worksheet.rows[0][1]
    cap_figures = CapFigure.find_by(year: year)
  
    if cap_figures.nil?
      puts "No CapFigure found for year: #{year}"
      return
    end
  
    @worksheet.rows.each do |row|
      next if row[0] == 'Payroll Information'
      break if row[0] == ''
  
      if cap_figures.has_attribute?(row[0])
        cap_figures.update(row[0].to_sym => row[1].to_i)
      else
        puts "Attribute #{row[0]} does not exist on CapFigure"
      end
    end
  end


  private


  def generate_salary(num)
    num == "Two-Way" ? num : num[1..-1].gsub(",", "").to_i
  end


  def waived?(name_array)
    return true if name_array.include?("(waived)")

    false
  end

  def remove_ntc_tag(name_array)
    # Removes NTC deadline dates from player names
    if name_array[-1].include?('(')
      name_array.pop
    end

    name_array
  end

  def player_in_db?(player_name)
    if player_name.length < 3
      Player.pluck(:first_name, :last_name).include?(player_name)
    else
      Player.pluck(:first_name, :last_name, :suffix).include?(player_name)
    end
  end


  def load_spreadsheet
    puts "Accessing spreadsheet.."
    session = GoogleDrive::Session.from_service_account_key(Rails.root + "app/assets/api/client_secret1.json")
    spreadsheet = session.spreadsheet_by_title("IGNBA Roster 24")

    if spreadsheet
      puts "Spreadsheet accessed!"
      spreadsheet.worksheets.first
    end
  end


  def update_team(player, team)
    player = Player.find_by(first_name: player[0], last_name: player[1])

    if !player
      player = Player.find_by(first_name: player[0], last_name: player[1], suffix: player[2])
    end

    current_team = Team.find(player.team_id)
    new_team = Team.find_by(name: team)

    if current_team != new_team
      player.update(team_id: new_team.id)
    end
  end


  def find_free_agents
    player_names = []
    
    url = "https://basketball.realgm.com/nba/players"
    doc = Nokogiri::HTML(URI.open(url))
  
    rows = doc.css("table tr")
  
    rows[1..-1].each do |row|
      name = row.css("a").text.strip
      player_names << name
    end
  
    player_names
  end

  def fix_problematic_names(name)
    if name.include?("vleet") && name.include?("van")
      return ["fred", "vanvleet"]
    elsif name == ["g.", "g.", "jackson"]
      return ["gregory", "jackson", "ii"]
    elsif name == ["carson", "wallace"]
      return ["cason", "wallace"]
    elsif name == ["robert", "williams"]
      return ["robert", "williams", "iii"]
    elsif name == ["greg", "brown"]
      return ["greg", "brown", "iii"]
    elsif name == ["mo", "bamba"]
      return ["mohamed", "bamba"]
    elsif name.include?("pippin")
      return ["scotty", "pippen", "jr."]
    elsif name == ["justice", "winslow"]
      return ["justise", "winslow"]
    elsif name == ["john", "walll"]
      return ["john", "wall"]
    elsif name == ["derek", "lively", "ii"]
      return ["dereck", "lively", "ii"]
    elsif name == ["george", "niang"]
      return ["georges", "niang"]
    elsif name == ["svi", "mykhailiuk"]
      return ["sviatoslav", "mykhailiuk"]
    elsif name == ["dwayne", "dedmon"]
      return ["dewayne", "dedmon"]
    elsif name == ["louis", "williams"]
      return ["lou", "williams"]
    elsif name == ["victor", "wembayama"]
      return ["victor", "wembanyama"]
    elsif name == ["joshua", "minott"]
      return ["josh", "minott"]
    elsif name == ["jaquori", "mclaughin"]
      return ["jaquori", "mclaughlin"]
    elsif name == ["yam", "mader"]
      return ["yam", "madar"]
    elsif name == ["colin", "castleon"]
      return ["colin", "castleton"]
    elsif name == ["bones", "hyland"]
      return ["nahshon", "hyland"]
    end

    name
  end

  def find_or_create_player(player_name, team_name)
    player_name = remove_ntc_tag(player_name)

    player_name = fix_problematic_names(player_name)
    # Skip cell if full player name is already in the database
    if player_in_db?(player_name)
      update_team(player_name, team_name)
    else
      player = Player.new( team_id: Team.find_by(name: team_name).id )
      player.update_player_name(player_name)
      player.save
      update_player_info(player)
      puts "#{player.first_name} #{player.last_name} saved to Database!"
    end
  end
end