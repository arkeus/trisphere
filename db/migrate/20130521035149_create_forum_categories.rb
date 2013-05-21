class CreateForumCategories < ActiveRecord::Migration
  def change
   	create_table :forum_categories do |t|
			t.string :name, null: false
			t.string :description, null: false
			t.integer :topics, default: 0
			t.integer :replies, default: 0
			t.integer :last_post_id, default: 0
			t.integer :order, default: 0
			
      t.timestamps
    end
  end
end
