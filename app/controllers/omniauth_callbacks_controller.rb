class OmniauthCallbacksController < ApplicationController
  def discord
    Rails.logger.info auth

    discord_account = current_user.discord_accounts.where(username: auth.info.username).first_or_initialize
    discord_account.update(
      name: auth.info.name,
      username: auth.info.username,
      image: auth.info.image,
      token: auth.credentials.token,
      secret: auth.credentials.secret,
    )

    redirect_to root_path, notice: "Successfully connected your Discord account."
  end

  def auth
    request.env['omniauth.auth']
  end
end
