class SessionsController < ApplicationController
  
  def home
    
  end
  
  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => Rails.application.config.callback_url)
  end
  
  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => Rails.application.config.callback_url)
    session[:access_token] = response.access_token
    client = Instagram.client(:access_token => session[:access_token])
    #update basic data
    u = User.find_or_create_by_instagram_id(client.user[:id])
    u.update_instagram_data(client.user)
    
    #grab likes
    like_data = []
    #instagram only keeps 300 likes in the api history and can return about 50 each time...
    6.times do
      l = Instagram.user_liked_media(:access_token => session[:access_token], :count => 50, :max_like_id => @max_like_id)
      @max_like_id = l[:pagination][:next_max_like_id].to_i
      like_data = like_data + l[:data]
    end
    u.update_likes(like_data)
    
    #grab received likes
    received_like_data = []
    l = Instagram.user_recent_media(:access_token => session[:access_token], :count => 300)
    l.each do |media|
      media[:likes][:data].each do |like|
        received_like_data << like        
      end
    end
    u.update_received_likes(received_like_data)
    
    redirect_to u
  end
  
end
