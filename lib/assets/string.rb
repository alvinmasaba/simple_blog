class String
    def is_team_name?
        Team.pluck(:name).include?(self.team_name)
    end

    def team_name
        return self unless self.split.length > 1

        self.generate_team_name
    end

    def generate_team_name
        if self == "Portland Trail Blazers"
        return "trail-blazers"
        else
        self.downcase.split[-1].gsub(/\s+/, "-")
        end
    end

    def is_player_name?(verbiage)
        # Returns false if string is a team name, empty space, or salary cap jargon
        return false if self.is_team_name? || self.split.length < 2
        return false if verbiage.include?(self)
        return false if self.split.include?("GM:")

        true
    end
end