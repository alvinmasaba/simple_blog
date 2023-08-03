module Admin
  class ArticlesController < ApplicationController
    before_action :admin_only

    def index
      @team_requests = Team.where.not(user_id: nil).where(co_gm_id: nil)
    end

    def approve
      team_request = Team.find(params[:id])
      role = params[:role] # This will contain either 'gm' or 'co_gm'

    if role == 'gm'
      team_request.update(user_id: current_user.id)
      redirect_to team_requests_path, notice: 'Team request approved. User added as GM.'
    elsif role == 'co_gm'
      team_request.update(co_gm_id: current_user.id)
      redirect_to team_requests_path, notice: 'Team request approved. User added as Co-GM.'
    else
      redirect_to team_requests_path, alert: 'Invalid role selected.'
    end
  end      
end