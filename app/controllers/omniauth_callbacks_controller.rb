class OmniauthCallbacksController < ApplicationController
  def discord
    current_user.discord_accounts.create(
      name: ,
      username: ,
      image: ,
      token: ,
      secret: ,
    )
  end
end
