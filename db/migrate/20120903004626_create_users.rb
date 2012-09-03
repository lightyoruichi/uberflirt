class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slug
      t.string :username
      t.text :data
      t.integer :instagram_id
      t.timestamps
    end
    add_index :users, :instagram_id
  end
end
