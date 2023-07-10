module Admin
  class UsersController < ApplicationController
    before_action :admin_only

    def index
      @users = User.all

      render json: @users
    end
  end
end