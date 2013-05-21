class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
    	t.integer :user_id, null: false
    	t.boolean :active, default: false
    	
    	t.string :name, null: false, limit: 16
    	
    	t.integer :energy, default: 1000
    	t.integer :fatigue, default: 1000
    	
    	t.integer :strength, default: 10
    	t.integer :wisdom, default: 10
    	t.integer :defense, default: 10
    	t.integer :agility, default: 10
    	t.integer :stamina, default: 10
    	t.integer :spirit, default: 10
    	
    	t.string :surclass, default: "Peasant"
    	t.string :subclass, default: "Peasant"
    	
    	t.integer :wins, default: 0
    	t.integer :losses, default: 0
    	t.integer :draws, default: 0
    	
    	t.integer :hpc, default: 100
    	t.integer :hpm, default: 100
    	t.integer :mpc, default: 100
    	t.integer :mpm, default: 100
    	
    	t.integer :combat_level, default: 1
    	t.integer :combat_xpc, default: 0
    	t.integer :combat_xpm, default: 100
    	
    	t.integer :mining_level, default: 1
    	t.integer :mining_xpc, default: 0
    	t.integer :mining_xpm, default: 100
    	
    	t.integer :blacksmithing_level, default: 1
    	t.integer :blacksmithing_xpc, default: 0
    	t.integer :blacksmithing_xpm, default: 100
    	
    	t.integer :woodcutting_level, default: 1
    	t.integer :woodcutting_xpc, default: 0
    	t.integer :woodcutting_xpm, default: 100
    	
    	t.integer :crafting_level, default: 1
    	t.integer :crafting_xpc, default: 0
    	t.integer :crafting_xpm, default: 100
    	
    	t.integer :herbalism_level, default: 1
    	t.integer :herbalism_xpc, default: 0
    	t.integer :herbalism_xpm, default: 100
    	
    	t.integer :enchanting_level, default: 1
    	t.integer :enchanting_xpc, default: 0
    	t.integer :enchanting_xpm, default: 100
    	
    	t.index [:user_id, :active]
    	
    	t.timestamps
    end
  end
end
