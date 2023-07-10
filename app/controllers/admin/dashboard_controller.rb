module Admin
  class DashboardController < ApplicationController
    before_action :admin_only

    def index
      @teams = Team.order('city asc')
      @users = User.all
      @players = Player.all
    end
  end
end
  
