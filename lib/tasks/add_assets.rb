Team.find_each do |team|
    team.players.each do |player|
      Asset.create(assetable: player, team: team)
    end
end