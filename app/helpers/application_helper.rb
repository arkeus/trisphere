module ApplicationHelper
	def navigation_tag(url, icon, text)
		icon_url = image_url("layout/nav_icon_#{icon}.png")
		link_to(text, url, class: "nav-tag", style: "background-image: url('#{icon_url}');")
	end
end
