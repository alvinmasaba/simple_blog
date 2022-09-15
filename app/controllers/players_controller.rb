class PlayersController < ApplicationController
  http_basic_authenticate_with name: "alvin", 
  password: "secret", except: [:index, :show]

  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
    @team = Team.find(@player.team_id)
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
      redirect_to "/teams/#{params[:team_id]}/players/#{@player.id}"
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
      redirect_to "/teams/#{params[:team_id]}/players/#{@player.id}"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    @team = Team.find(params[:team_id])

    redirect_to @team, status: :see_other
  end

  private

  def player_params
    params.require(:player).permit(:first_name, :last_name, :age, :height, :school, :position, :country, :years_in_league, :draft_class)
  end
end
