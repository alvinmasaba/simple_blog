class TradeMachineController < ApplicationController
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

    def evaluate_trade
        teams_data = params[:teams]
        
        # Your trade evaluation logic here. 
        # You'll need to adapt your existing Ruby code to work with the provided data structure.
        
        result = evaluate_the_trade_logic(teams_data)  # This is a placeholder for your logic
      
        render json: { message: result ? "Trade is valid!" : "Trade is not valid." }
      end
      
end