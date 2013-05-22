module ForumsHelper
	def format_date(date)
		date.strftime("%b %e, %Y %l:%m %P")
	end
	
	def pagination_options
		{
			previous_label: "Prev",
			next_label: "Next",
			inner_window: 1,
			outer_window: 0
		}
	end
	
	def name_link(user_id, options = {})
		return "Unknown" unless @users[user_id]
		name_tag = "#{image_tag("badges/blue.png")}#{@users[user_id].username}".html_safe
		classes = ["user-tag"]
		classes << options[:class] if options[:class]
		return link_to name_tag, { action: "index", id: user_id }, class: [classes]
	end
end
