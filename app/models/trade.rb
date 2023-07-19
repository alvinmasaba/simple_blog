class Trade
    attr_reader :traded_assets

    # TRADE RULES

    # Under 1st Apron:
    # 1. Outgoing up to 7.5M can take back 200% + 250k
    # 2. Outgoing greater than 7.5M up to 30M can take back 100% + 7.5M
    # 3. Outgoing greater than 30M can take back 125% + 250k

    # Above 1st Apron:
    # 1. Can take back 110% of outgoing salary


    def initialize(traded_assets)
        @traded_assets = traded_assets
    end

    def valid?
        valid = true
        # Assuming traded_assets is in format { team1: {outgoing => [Player, DraftPick...], incoming => [DraftPick...]},  team2: {outgoing => [], incoming => []}...}
        traded_assets.each do |team|
            # For each team, their incoming salary must be within the range allowable by their outgoing salary
            incoming = sum_salary(team[incoming])
            outgoing = sum_salary(team[outgoing])

            # A team with enough room (current cap space + salary they're sending out) to absorb the salary and still be under the cap
            if (team.cap_room + outgoing) >= incoming
                valid = true
            else
                valid = team.over_apron? ? valid_incoming_over_apron?(incoming, outgoing) : valid_incoming_under_apron?(incoming, outgoing)
            end
        end

        valid
    end

    private

    def sum_salary(assets)
        sum = 0

        assets.each do |asset|
            begin
               sum += asset 
            rescue => exception
                next
            end
        end

        sum
    end

    def valid_incoming_under_apron?(incoming, outgoing)
        # 1. Outgoing up to 7.5M can take back 200% + 250k
        if outgoing <= 7500000
            incoming <= (outgoing * 2 + 250000) ? true : false

        # 2. Outgoing greater than 7.5M up to 30M can take back 100% + 7.5M
        elsif outgoing <= 30000000
            incoming <= (outgoing + 7500000) ? true : false
        
        # 3. Outgoing greater than 30M can take back 125% + 250k
        else
            incoming <= (outgoing * 1.25 + 250000) ? true : false
        end
    end

    def valid_incoming_over_apron?(incoming, outgoing)
        # 1. Can take back 110% of outgoing salary
        incoming <= (outgoing * 1.1) ? true : false
    end
end
