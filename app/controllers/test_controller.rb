class TestController < ApplicationController
	include ChunkyPNG
	
	def index; end
	
	def colorize
		start = Time.now
		grays = Image.from_file("C:/Dev/Workspace/Rails/Trisphere/public/images/misc/lunar_wand.png").grayscale!

		@images = []
		50.times do
			color1 = Color.rgb(rand_int, rand_int, rand_int)
			color2 = Color.rgb(rand_int, rand_int, rand_int)
			color3 = Color.rgb(rand_int, rand_int, rand_int)
			colors = Image.from_file("C:/Dev/Workspace/Rails/Trisphere/public/images/misc/lunar_template.png")
			colors.change_theme_color! Color.from_hex("d59bf2"), color1
			colors.change_theme_color! Color.from_hex("9bf2a9"), color2
			colors.change_theme_color! Color.from_hex("9bb8f2"), color3
			
			result = Image.new 20, 20
			0.upto(grays.width - 1) do |x|
				0.upto(grays.height - 1) do |y|
					colors_color = colors.get_pixel(x, y)
					next if colors_color == Color::WHITE
					grays_color = grays.get_pixel(x, y)
					grays_rgb = ColorMath::hex_color(Color.to_hex(grays_color, false))
					colors_rgb = ColorMath::hex_color(Color.to_hex(colors_color, false))
					new_color = ColorMath::HSL.new(colors_rgb.hue, colors_rgb.saturation, grays_rgb.luminance)
					result.set_pixel(x, y, Color.from_hex(new_color.hex))
				end
			end
			
			@images << result.to_data_url
		end
		
		@time = (Time.now - start)
	end
	
	private
	
	def rand_int(max = 255)
		(max * rand).ceil
	end
end