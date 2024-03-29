class TeamsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :table]

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
    @cap = CapFigure.find_by(year: "2023-24")
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.name = @team.name.downcase.strip.gsub(/\s+/, "-")
    @team.city = @team.city.downcase.strip.gsub(/\s+/, "-")
    
    if @team.save
      redirect_to @team
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])

    if @team.update(team_params)
      redirect_to @team
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    redirect_to root_path, status: :see_other
  end

  def table
    @teams = Team.all.order(city: :asc).page(params[:page]).per(10)
  end

  private

  def team_params
    params.require(:team).permit(:city, :name)
  end
end
