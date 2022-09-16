class Spreadsheet
  attr_accessor :worksheet

  def initialize
    @worksheet = load_spreadsheet
  end

  def load_spreadsheet
    session = GoogleDrive::Session.from_service_account_key(Rails.root + "app/assets/api/client_secret1.json")
    spreadsheet = session.spreadsheet_by_title("IGNBA Roster 2")

    spreadsheet.worksheets.first
  end
end
