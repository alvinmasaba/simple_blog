module Admin
  class TeamsController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

    def index
      @teams = Team.all

      render json: @teams
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
      
      respond_to do |format|
        if @team.save
          format.json { render json: status: 'success', team: @team , status: :created }
          format.html { redirect_to @team }
        else
          format.json { render json: status: 'error', errors: @team.errors , status: :unprocessable_entity }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit
      @team = Team.find(params[:id])
    end

    def update
      @team = Team.find(params[:id])

      respond_to do |format|
        if @team.update(team_params)
          format.json { render json: status: 'success', team: @team , status: :ok } 
          format.html { redirect_to @team }
        else
          format.json { render json: status: 'error', errors: @team.errors, status: :unprocessable_entity }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @team = Team.find(params[:id])
      @team.destroy

      redirect_to root_path, status: :see_other
      respond_to do |format|      
        if @team.destroy
          format.json { render json: status: 'success', message: 'Player successfully deleted.', status: :ok }
          format.html { redirect_to admin_dashboard_path }
        else
          format.json { render json: status: 'error', message: 'Team could not be deleted.', status: :unprocessable_entity }
          format.html { redirect_to @team, status: :see_other }
        end
      end
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