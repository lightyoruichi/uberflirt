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
    likes = []
    data.each do |like|
      likes << like[:user]
    end
    self.save
  end
  
  def i_like
    #returns a ranked list of people I'm stalking

  end
  
end
