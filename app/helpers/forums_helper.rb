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
	
	def duration_ago(time, options = {})
		time = "#{time} UTC" if time.is_a?(String) && !time.include?("UTC") # TODO: Fix ugly hack
		duration = Time.now - (time.is_a?(String) ? Time.parse(time) : time)
		value, tag_class = case
			when duration > 1.year.seconds then [(duration / 1.year.seconds).floor, :year]
			when duration > 1.month.seconds then [(duration / 1.month.seconds).floor, :month]
			when duration > 1.day.seconds then [(duration / 1.day.seconds).floor, :day]
			when duration > 1.hour.seconds then [(duration / 1.hour.seconds).floor, :hour]
			when duration > 1.minute.seconds then [(duration / 1.minute.seconds).floor, :minute]
			else [duration.floor, :second]
		end
		
		return "#{value} <span class='duration #{tag_class}'>#{tag_class.to_s.pluralize(value).capitalize}</span> Ago".html_safe
	end
end
