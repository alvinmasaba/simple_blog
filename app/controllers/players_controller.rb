class PlayersController < ApplicationController
  http_basic_authenticate_with name: "alvin", 
  password: "secret", except: [:index, :show]

  def index
    @players = Player.all
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    @player.first_name = @player.first_name.downcase.strip
    @player.last_name = @player.last_name.downcase.strip
    if @player.save
      redirect_to @player
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])

    if @player.update(player_params)
      redirect_to @player
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def player_params
    params.require(:player).permit(:first_name, :last_name, :age, :school, :draft_class, :country, :team, :years_in_league)
  end
end