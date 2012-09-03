class User < ActiveRecord::Base
  # attr_accessible :title, :body
  extend FriendlyId
  friendly_id :username, :use => :slugged
  serialize :data
  
  def update_instagram_data(data)
    self.username = data[:username]
    self.data = data
    self.save
  end
  
end
