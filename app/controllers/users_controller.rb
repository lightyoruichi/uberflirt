class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @likes_me = @user.likes_me    
    @i_like = @user.i_like
    #create array of instagram ids
    @all = @likes_me.slice(0,19) + @i_like.slice(0,19)
    @ids = @all.collect{|c| c["id"]}
    @profiles = User.select("username, data, instagram_id").find_all_by_instagram_id(@ids)
  end
  
end
