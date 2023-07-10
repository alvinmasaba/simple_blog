module Admin
  class TeamsController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      @teams = Team.all
    end

    def show
      @team = Team.find(params[:id])
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

    private

    def admin_only
      unless current_user.admin?
        redirect_to root_path, :alert => "Access denied."
      end
    end

    def team_params
      params.require(:team).permit(:city, :name)
    end
  end
end