Team.find_each do |team|
  team.players.each do |player|
    Asset.create(assetable: player, team: team)
  end

  [2024, 2025, 2026].each do |year|
    first_pick = DraftPick.create(year: year, round: 1, team: team, owned_by_id: team.id)
    second_pick = DraftPick.create(year: year, round: 2, team: team, owned_by_id: team.id)
    Asset.create(assetable: first_pick, team: team)
    Asset.create(assetable: second_pick, team: team)
  end
end
