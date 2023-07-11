class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @team = Team.find(@user.team_id)
  end
end