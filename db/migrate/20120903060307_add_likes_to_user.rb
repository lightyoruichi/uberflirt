class AddLikesToUser < ActiveRecord::Migration
  def change
    add_column :users, :likes, :text
    add_column :users, :received_likes, :text
  end
end
