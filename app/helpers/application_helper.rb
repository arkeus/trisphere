module ApplicationHelper
	def navigation_tag(url, icon, text, options = {})
		icon_url = image_url("layout/nav_icon_#{icon}.png")
		link_to(text, url, class: ["nav-tag"] | Array(options[:class]), style: "background-image: url('#{icon_url}');")
	end
	
	def character_bar(label, image, color, value, min, max, show_progress = false, short = false)
		render partial: "shared/character_bar", locals: { label: label, image: image, color: color, value: value, min: min, max: max, show_progress: show_progress, short: short }
	end
	
	def slotted_bar(name, value, color, width, percent)
		render partial: "shared/slotted_bar", locals: { name: name, value: value, color: color, width: width, percent: percent }
	end
	
	# Name link a user by id. In order to use, @users must have an entry keyed by id that responds to #username.
	def name_link(user_id, options = {})
		Rails.logger.fatal @users
		Rails.logger.fatal @users[user_id]
		Rails.logger.fatal user_id
		return "Unknown" unless @users && @users[user_id]
		badge = ["blue", "gold", "red"].sample
		name_tag = "#{image_tag("badges/#{badge}.png")}#{@users[user_id].username}".html_safe
		classes = ["user-tag"]
		classes << options[:class] if options[:class]
		return link_to name_tag, { action: "index", id: user_id }, class: [classes]
	end
	
	# Takes a time or time string and returns the duration since then, colored via item colors.
	def duration_ago(time, options = {})
		return "Unknown" unless time
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
	
	# Returns a font-awesome icon tag for the given icon name (do not include icon- in the name)
	def icon(name, options = {})
		classes = ["icon-#{name}"] + Array(options[:class])
		return content_tag(:i, nil, class: "icon-#{name}")
	end
end
