class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username, null: false, limit: 16
    	t.string :password_digest, null: false
    	t.string :email, null: false, limit: 64
    	t.integer :ip, limit: 8
    	
    	t.integer :gold, default: 500
    	t.integer :shards, default: 0
    	
    	t.integer :posts, default: 0
    	t.string :avatar
    	t.string :signature
    	
    	t.datetime :active_at
    	t.timestamps
    	
    	t.index :username
    	t.index :active_at
    end
  end
end
