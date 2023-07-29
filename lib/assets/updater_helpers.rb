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