class SessionsController < ApplicationController

  def create
    if params[:message] == "invalid_credentials"
      flash[:error] = "Login failed"
    end

    auth = request.env["omniauth.auth"]

    unless Rails.env.test?
      puts "OmniAuth received:"
      puts auth.to_yaml
    end

    if auth
      session.clear
      session["current_user"] = { 
        provider: auth["provider"], 
        uid:      auth["uid"],
        name:     auth["info"]["name"] || auth["info"]["nickname"]
      }
    end

    redirect_to root_path
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
