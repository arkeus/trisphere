module CharacterHelper
	def profession_panel(image, name, level, min, max, color)
		render partial: "profession_panel", locals: { image: image, name: name, level: level, min: min, max: max, color: color }
	end
end
