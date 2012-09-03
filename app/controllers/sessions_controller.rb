class SessionsController < ApplicationController
  
  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => Rails.application.config.callback_url)
  end
  
  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => Rails.application.config.callback_url)
    session[:access_token] = response.access_token
    client = Instagram.client(:access_token => session[:access_token])
    u = User.find_or_create_by_instagram_id(client.user[:id])
    u.update_instagram_data(client.user)
    redirect_to u
  end
  
end
