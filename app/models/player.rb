require 'open-uri'
require 'fileutils'

class Player < ApplicationRecord
  belongs_to :team
  has_one :contract, dependent: :destroy
  accepts_nested_attributes_for :contract

  validates :first_name, presence: true
  validates :last_name, presence: true

  def print_full_name
    return full_name unless full_name.nil? || full_name == ""

    f_name = "#{first_name.titleize} #{last_name.titleize}"
    f_name = suffix.nil? ? f_name : "#{f_name} #{standardize_suffix(suffix)}"
  end

  def print_waived_name
    return print_full_name if Contract.find_by(player_id: id).nil?

    Contract.find_by(player_id: id).waived ? "#{print_full_name} (waived)" : print_full_name
  end

  def ratings_url
    base = "https://www.2kratings.com/#{remove_dots(first_name)}-#{remove_dots(last_name)}"
    (suffix.nil? || suffix == "") ? base : base + "-#{remove_dots(suffix)}"
  end

  def update_player_name(player_name)
    standardize_player_name(player_name)
  end

  def show_player_team
    team = Team.find_by(id: self.team_id)

    team.titleize_name
  end

  def update_image
    image_url = self.image_url
    image_path = Rails.root.join('app', 'assets', 'images', 'players', "#{self.id}.jpg")

    begin
      content = URI.read(image_url)
      File.write(image_path, content)

      # Update the image attribute with the path where the image is saved
      self.update(image: "players/#{self.id}.jpg")

    rescue OpenURI::HTTPError => e
      puts "Failed to download image. Error: #{e.message}"
    rescue Errno::ENOENT => e
      puts "Failed to create file. Error: #{e.message}"
    rescue StandardError => e
      puts "An error occurred. Error: #{e.message}"
    end
  end

  private

  def standardize_player_name(name)
    self.update(first_name: name[0], last_name: name[1])

    # Removes NTC deadline dates from player names
    if name.length > 3
      name.pop if name[3].include?('(')
    elsif name[2].include?('(')
      name.pop
    end
    
    self.update(suffix: name[2]) if name[2]
  end

  def standardize_suffix(suffix)
    suffix == "jr." || suffix == "sr." ? suffix.titleize : suffix.upcase
  end

  def remove_dots(str)
    str.delete('.')
  end

  def image_url
    base = "https://www.2kratings.com/wp-content/uploads/#{first_name.titleize}-#{last_name.titleize}"

    if suffix.nil? || suffix == ""
      base 
    elsif suffix == "jr." || suffix == "sr."
      base += "-#{suffix.titleize}"
    else
      base += "-#{suffix.upcase}"
    end

    base + '-2K-Rating-547x400.png'
  end
end
