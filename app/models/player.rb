require 'open-uri'
require 'fileutils'

class Player < ApplicationRecord
  belongs_to :team
  has_one :asset, as: :assetable
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
    image_urls = self.image_url

    if self.suffix
      image_path = Rails.root.join('app', 'assets', 'images', 'players', "#{self.first_name}-#{self.last_name}-#{self.suffix}.jpg")
    else
      image_path = Rails.root.join('app', 'assets', 'images', 'players', "#{self.first_name}-#{self.last_name}.jpg")
    end
    
    image_urls.each do |image_url|
      begin
        content = URI.open(image_url).read
        File.open(image_path, 'wb') do |file|
          file.write(content)
        end
  
        # Update the image attribute with the path where the image is saved
        self.update(image: image_path.to_s)
        
        # Break the loop when an image is successfully downloaded
        break
      rescue OpenURI::HTTPError => e
        puts "Failed to download image from URL #{image_url}. Error: #{e.message}"
      rescue Errno::ENOENT => e
        puts "Failed to create file. Error: #{e.message}"
      rescue StandardError => e
        puts "An error occurred. Error: #{e.message}"
      end
    end
  end

  # Search function to search players
  def self.search(search)
    if search
      search_terms = search.split
      query = search_terms.map { |term| "first_name LIKE :#{term} OR last_name LIKE :#{term}" }.join(' OR ')
      query_params = search_terms.each_with_object({}) { |term, hash| hash[term.to_sym] = "%#{term}%" }
      players = Player.where(query, query_params)
      players.empty? ? Player.all : players
    else
      Player.all.order("last_name desc")
    end
  end
  
  private

  def standardize_player_name(name)
    self.update(first_name: name[0], last_name: name[1])    
    self.update(suffix: name[2]) if name[2]
  end

  def standardize_suffix(suffix)
    suffix == "jr." || suffix == "sr." ? suffix.titleize : suffix.upcase
  end

  def remove_dots(str)
    str.delete('.')
  end

  def image_url
    base = "https://www.2kratings.com/wp-content/uploads/#{first_name.titleize.gsub(' ', '-')}-#{last_name.titleize.gsub(' ', '-')}"
  
    if suffix.nil? || suffix == ""
      base 
    elsif suffix == "jr." || suffix == "sr."
      base += "-#{suffix.titleize}"
    else
      base += "-#{suffix.upcase}"
    end

    url_array = [base + '-2K-Rating-547x400.png', base + '-2K-Rating-550x400.png', base + '-2K-Rating-600x400.png',
                 base + '-2K-Rating-547x400.webp', base + '-2K-Rating-550x400.webp', base + '-2K-Rating-600x400.webp']

    # Some urls differ slightly due to missing suffixes and an alternate size.
    ['Jr.', 'Sr.', 'II', 'III', 'IV'].each do |suffix|
      url_array.append(base + '-' + suffix + '-2K-Rating-547x400.png')
      url_array.append(base + '-' + suffix + '-2K-Rating-550x400.png')
    end
  
    url_array
  end
end
