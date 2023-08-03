require 'date'

def associate_player_with_badges(doc, player)
  doc.css('.badge-box .card-body').each do |badge_node|
    name = badge_node.at('h4').text.strip
    description = badge_node.at('.badge-description').text.strip

    # Find or create the badge
    badge = Badge.find_or_create_by(name: name, description: description)

    # Associate the badge with the player unless already associated
    player.badges << badge unless player.badges.include?(badge)
  end
end
  
def fetch_player_data(url, player)
  doc = Nokogiri::HTML(fetch_html_content_from_url(url))

  # Fetch player rating
  rating = fetch_player_rating(doc)

  # Fetch and associate badges
  associate_player_with_badges(doc, player)

  rating
end

def fetch_html_content_from_url(url)
  # Sanitize the URL
  sanitized_url = url.gsub(/[^\x00-\x7F]/, '').strip

  begin
    URI.open(sanitized_url).read
  rescue OpenURI::HTTPError => e
    Rails.logger.error "#{sanitized_url} returned an error: #{e.message}"
    return nil
  rescue URI::InvalidURIError => e
    Rails.logger.error "Invalid URL: #{sanitized_url}. Error: #{e.message}"
    return nil
  end
end

def fetch_player_rating(doc)
  rating_element = doc.at('.attribute-box-player') # Using the class to find the element
  
  if rating_element
    return rating_element.text.strip.to_i
  else
    Rails.logger.error "Rating not found in the document"
    return nil
  end
end

def fetch_player_bio(url)
  begin
    doc = Nokogiri::HTML(fetch_html_content_from_url(url))
    return {} unless doc  # Return an empty hash if the doc is nil

    info = doc.css('.player-info p')

    {
      country: info[1].css('a').text.strip,
      position: extract_positions(info[4]),
      height: extract_height(info[5]),
      weight: extract_weight(info[5]),
      years_in_league: info[7].text.strip.scan(/\d+/).first.to_i,
      age: calculate_age(extract_dob(info[8])).to_i,
      school: extract_school(info[10])
    }
  
  rescue => e
    Rails.logger.error "Error fetching player bio from #{url}: #{e.message}"
    puts "Error fetching player bio from #{url}: #{e.message}"
    nil  # Return nil if there's an error
  end
end

def extract_positions(element)
  # Extract all the positions from the links within the element
  element.css('a').map(&:text).join('/').strip
end

def extract_height(element)
  # Extract the height text from the first span with class `text-light`
  height_text = element.css('span.text-light').first&.text&.strip

  # Match for height pattern (e.g., 6'11") and return the matched height
  height_value = height_text&.match(/(\d+'\d+")/)&.captures&.first
end

def extract_weight(element)
  # Extract the weight text from the second span with class `text-light`
  weight_text = element.css('span.text-light')[1]&.text&.strip

  # Match for weight pattern (e.g., 260lbs) and return the matched weight as integer
  weight_value = weight_text&.match(/(\d+)lbs/)&.captures&.first&.to_i
end

def update_player_info(player)
  begin
    info = fetch_player_bio(player.ratings_url)
    return if info.nil?  # Skip the player if info couldn't be fetched

    puts "Updating #{player.first_name} #{player.last_name}'s info..."
    player.update!(
      age: (player.age == 0 ? false : player.age) || info[:age],
      country: player.country || info[:country], 
      position: player.position || info[:position],
      height: player.height || info[:height],
      weight: player.weight || info[:weight],
      years_in_league: player.years_in_league || info[:years_in_league],
      school: player.school || info[:school]
    )

  rescue => e
    Rails.logger.error "Error updating info for player #{player.id}: #{e.message}"
  end
end

def extract_dob(element)
  dob_text = element.text.strip
  dob_match = dob_text.match(/Date of Birth: ([\w\s,]+)/)
  dob_match ? dob_match[1] : nil
end

def calculate_age(dob_string)
  return nil unless dob_string

  dob = Date.strptime(dob_string, '%B %d, %Y')
  today = Date.today

  age = today.year - dob.year
  age -= 1 if today.month < dob.month || (today.month == dob.month && today.day < dob.day)
  
  age
end

def extract_school(element)
  school_text = element.text.strip
  school_match = school_text.split(":\n ")[1]
  school_match
end