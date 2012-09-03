class User < ActiveRecord::Base
  # attr_accessible :title, :body
  extend FriendlyId
  friendly_id :username, :use => :slugged
  serialize :data
  serialize :likes
  serialize :received_likes
  
  def update_instagram_data(data)
    self.username = data[:username]
    self.data = data
    self.save
  end
  
  def update_likes(data)
    self.likes = []
    data.each do |like|
      self.likes << like[:user]
    end
    self.save
  end
  
  def update_received_likes(data)
    self.received_likes = data
    self.save
  end
  
  def i_like
    #returns a ranked list of people I'm stalking
    i_like_array = []
    if likes.size > 0
      likes.each do |user|
        id = user["id"].to_i
        existing = nil
        i_like_array.each_with_index do |l,i|
          existing = i if l["id"] == id
        end      
        if existing
          i_like_array[existing]["count"] = i_like_array[existing]["count"] + 1
        else
          result = {}
          result["id"] = id
          result["user"] = {}
          result["user"] = user
          result["count"] = 1
          i_like_array << result
        end    
      end
    end
    i_like_array = i_like_array.sort_by { |k| [k["count"]] }.reverse
    return i_like_array
  end
  
  def likes_me
    #returns a ranked list of people stalking me
    likes_me_array = []
    if received_likes.size > 0
      received_likes.each do |user|
        id = user["id"].to_i
        existing = nil
        likes_me_array.each_with_index do |l,i|
          existing = i if l["id"] == id
        end      
        if existing
          likes_me_array[existing]["count"] = likes_me_array[existing]["count"] + 1
        else
          result = {}
          result["id"] = id
          result["user"] = {}
          result["user"] = user
          result["count"] = 1
          likes_me_array << result
        end    
      end
    end
    likes_me_array = likes_me_array.sort_by { |k| [k["count"]] }.reverse
    return likes_me_array
  end
  
end
