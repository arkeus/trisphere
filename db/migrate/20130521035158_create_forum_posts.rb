class CreateForumPosts < ActiveRecord::Migration
  def change
    create_table :forum_posts do |t|
			t.integer :post_type, null: false
      t.integer :category_id, null: false
      t.integer :topic_id
      t.integer :user_id
      t.string :subject, limit: 64
      t.text :raw_message, null: false
      t.text :message, null: false
      t.datetime :post_date, null: false
      t.datetime :touch_date, null: false
      t.datetime :edit_date
      t.integer :replies, default: 0
      t.integer :views, default: 0
      t.integer :last_view_ip, limit: 8
      t.integer :last_post_user_id
      
      t.index [:category_id, :post_type]
      t.index [:category_id, :topic_id]
      
      t.timestamps
    end
  end
end
