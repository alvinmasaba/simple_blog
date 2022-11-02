class OmniauthCallbacksController < ApplicationController
  def discord
    render plain: "Success!"
  end
end
