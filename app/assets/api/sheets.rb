require 'bundler'
Bundler.require

session = GoogleDrive::Session.from_service_account_key("client_secret.json")

spreadsheet = session.spreadsheet_by_title("Pistons")
worksheet = spreadsheet.worksheets.first
worksheet.rows.first(10).each { |row| puts row.first(6).join(" | ")}


Team.all.each do |team|
  puts "#{@team.city.gsub("-", " ").titleize @team.name.gsub("-", " ").titleize}"
end
