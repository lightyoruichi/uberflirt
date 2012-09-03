class User < ActiveRecord::Base
  # attr_accessible :title, :body
  extend FriendlyId
  friendly_id :username, :use => :slugged
  serialize :data
  serialize :likes
  
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
  
end
