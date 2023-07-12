module Admin
  class PlayersController < ApplicationController
    before_action :admin_only

    def index
      @players = Player.includes(:team).all
      
      render json: @players.as_json(include: { team: { only: [:name, :id] } })
    end

    def show
      @player = Player.find(params[:id])
      @team = Team.find(@player.team_id)
      @contract = Contract.find_by(player_id: params[:id])
    end

    def new
      @player = Player.new
    end

    def create
      @player = Player.new(player_params)
      @player.first_name = @player.first_name.downcase.strip
      @player.last_name = @player.last_name.downcase.strip
      @player.school = @player.school.downcase.strip
      @player.height = @player.height.strip
      @player.position = @player.position.downcase.strip
      @player.team_id = params[:team_id]

      respond_to do |format|
        if @player.save
          format.json { render json: { status: 'success', player: @player }, status: :created }
          format.html { redirect_to admin_team_player_path(params[:team_id], @player.id) }
        else
          format.json { render json: { status: 'error', errors: @player.errors }, status: :unprocessable_entity }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
      
    def edit
      @player = Player.find(params[:id])
    end
    
    def update
      @player = Player.find(params[:id])
      @team = Team.find(params[:team_id])
    
      respond_to do |format|
        if @player.update(player_params)
          format.json { render json: { status: 'success', player: @player }, status: :ok } 
          format.html { redirect_to admin_team_player_path(@team, @player) }
        else
          format.json { render json: { status: 'error', errors: @player.errors }, status: :unprocessable_entity }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end
    
    def destroy
      @team = Team.find(params[:team_id])
      @player = Player.find(params[:id])
    
      respond_to do |format|      
        if @player.destroy
          format.json { render json: { status: 'success', message: 'Player successfully deleted.' }, status: :ok }
        else
          format.json { render json: { status: 'error', message: 'Player could not be deleted.' }, status: :unprocessable_entity }
        end
    
        format.html { redirect_to admin_team_path(params[:team_id]), status: :see_other }
      end
    end

    private

    def player_params
      params.require(:player).permit(:first_name, :last_name, :suffix, :full_name, :age, :height, :school, :position, 
                                    :country, :years_in_league, :draft_class, contract_attributes: [:two_way, :id, :waived])
    end
  end
end
