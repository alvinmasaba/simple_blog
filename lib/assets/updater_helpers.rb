def associate_player_with_badges(doc, player)
    doc.css('.badge-box .card-body').each do |badge_node|
      name = badge_node.at('h4.text-content').text.strip
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