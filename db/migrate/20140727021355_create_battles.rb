class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
    	t.integer :user_id, null: false
    	t.text :player, null: false
    	t.text :enemy, null: false
    	
    	t.index [:user_id]
    end
  end
end
