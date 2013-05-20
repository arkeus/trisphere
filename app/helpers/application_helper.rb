module ApplicationHelper
	def navigation_tag(url, icon, text, options = {})
		icon_url = image_url("layout/nav_icon_#{icon}.png")
		link_to(text, url, class: ["nav-tag"] | Array(options[:class]), style: "background-image: url('#{icon_url}');")
	end
	
	def character_bar(label, image, color, value, min, max, show_progress = false, short = false)
		render :partial => "shared/character_bar", locals: { label: label, image: image, color: color, value: value, min: min, max: max, show_progress: show_progress, short: short }
	end
end
