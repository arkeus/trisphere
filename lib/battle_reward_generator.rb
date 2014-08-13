class BattleRewardGenerator
	ITEM_HANDLERS = {
		equipment: EquipmentHandler,
		# potion: PotionHandler,
		# card: CardHandler,
		# material: MaterialHandler,
		# gem: GemHandler,
		# thread: ThreadHandler,
		# chest: ChestHandler,
	}.freeze
	
	def initialize(enemy)
		@enemy = enemy
	end
	
	def generate_gold
		min = @enemy.level
		max = @enemy.level * 2 + 2
		rand(min..max).ceil
	end
	
	def generate_exp
		min = (@enemy.level / 2) ** 3
		max = min * 1.1 + 1
		rand(min..max).ceil
	end
	
	def generate_item
		max = @enemy.level + 2
		min = case
			when @enemy.level < 11 then 1
			when @enemy.level < 20 then @enemy.level - 10
			when @enemy.level < 40 then @enemy.level - 20
			else @enemy.level / 2
		end
		ItemGenerator.new.equipment(min, max)
	end
end