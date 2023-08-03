class UsersController < ApplicationController
  def show
  end

  def request_team
    team = Team.find(params[:user][:team_id])
    current_user.update(team: team)
    redirect_to current_user, notice: 'Team request submitted. Waiting for approval.'
  end
end