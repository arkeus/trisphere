class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.integer :character_id
			t.integer :base_id
			t.integer :prefix_id
			t.integer :suffix_id
			t.integer :enchant_id
			t.text :data
      t.timestamps
    end
  end
end
