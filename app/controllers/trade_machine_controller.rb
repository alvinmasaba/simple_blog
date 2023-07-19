class TradeMachineController < ActionController::Base
    before_action :authenticate_user!

    def show
    end

    def load_assets
        @team = Team.find(params[:team_id])
        @team_number = params[:team_number]
        
        respond_to do |format|
          format.turbo_stream
        end
    end
end