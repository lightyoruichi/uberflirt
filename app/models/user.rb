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
    likes_array = []
    data.each do |like|
      likes_array << like[:user]
    end
    self.likes = likes_array
    self.save
  end
  
end
