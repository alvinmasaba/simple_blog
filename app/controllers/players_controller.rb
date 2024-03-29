class PlayersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]

  def index
    @players = Player.order(last_name: :asc).page(params[:page]).per(20)
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

    if @player.save
      redirect_to team_player_path(params[:team_id], @player.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    @team = Team.find(params[:team_id])

    if @player.update(player_params)
      redirect_to team_player_path(@team, @player)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find(params[:team_id])
    @player = Player.find(params[:id])

    @player.destroy

    redirect_to team_path(params[:team_id]), status: :see_other
  end

  def search
    @players = Player.search(params[:search]).order(last_name: :asc).page(params[:page]).per(20)
    render :index
  end

  private

  def player_params
    params.require(:player).permit(:first_name, :last_name, :suffix, :full_name, :age, :height, :school, :position, 
                                  :country, :years_in_league, :draft_class, :image, contract_attributes: [:two_way, :id, :waived])
end
end
