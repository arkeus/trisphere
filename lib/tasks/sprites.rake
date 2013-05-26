require "chunky_png"
require "base_item"

namespace :sprite do
	task :split, :source, :target_dir, :width, :height, :cols, :rows, :names do |task, args|
		image = ChunkyPNG::Image.from_file(args[:source])
		width, height = args[:width], args[:height]
		index = 0
		0.upto(args[:rows] - 1) do |row|
			0.upto(args[:cols] - 1) do |col|
				x, y = col * width, row * height
				item = image.crop(x, y, width, height)
				name = name_to_filename args[:names][index] + ".png"
				item.save args[:target_dir].join(name)
				index += 1
			end
		end
	end
	
	task :split_drops do
		source_file = Rails.root.join("lib/tasks/items/source/base_items.png")
		target_dir = Rails.root.join("public/images/items")
		Rake::Task["sprite:split"].invoke(source_file, target_dir, 20, 20, 40, 9, monster_drops_map)
	end
	
	def monster_drops_map
		map = []
		BaseItem::MonsterDrops::TIERS.each do |tier_id, tier, tier_level|
			BaseItem::MonsterDrops::ITEMS.each do |item_id, name, item_level, type, subtype, data|
				map << "#{tier} #{name}"
			end
		end
		map
	end
	
	def name_to_filename(name)
		name.gsub(/ /, "_").downcase
	end
end