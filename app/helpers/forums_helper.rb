require "tsml"

module ForumsHelper
	HEADLINE_LENGTH = 100
	
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
	
	def headline(message)
		message.gsub(/(<|&lt;).*?(>|&gt;)/, " ").gsub(/&.*?;/, "")[0..HEADLINE_LENGTH]
	end
end
