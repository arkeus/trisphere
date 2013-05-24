require "rack/utils"

module TSML
	class Parser
		private_class_method :new
		
		def self.parse(input, options = {})
			output = input.dup
			options = options.reverse_merge! DEFAULT_OPTIONS
			
			escape(output) if options[:sanitize]
			nl2br(output) if options[:nl2br]
			replace_emoticons(output) if options[:emoticons]
			replace_tags(output) if options[:tags]
			
			output
		end
		
		private
		
		def self.nl2br(str)
			replace(str, NL2BR_MAP)
		end
		
		def self.escape(str)
			replace(str, ESCAPE_MAP)
		end
		
		def self.replace_emoticons(str)
			replace(str, EMOTICONS)
		end
		
		def self.replace_tags(str)
			replace(str, TAGS)
		end
		
		def self.replace(str, replacement_map)
			replacement_map.each { |from, to| str.gsub!(from, to) }
		end
		
		ESCAPE_MAP = {
			"&" => "&amp;",
		  "<" => "&lt;",
		  ">" => "&gt;",
		}.freeze
		
		NL2BR_MAP = {
			/\r\n|\r|\n/ => "<br>"
		}.freeze
		
		EMOTICONS = {}.freeze # No emoticons? They suck.
		
		TAGS = {
			/\[b\](.*?)\[\/b\]/im => "<b>\\1</b>",
			/\[u\](.*?)\[\/u\]/im => "<u>\\1</u>",
			/\[i\](.*?)\[\/i\]/im => "<i>\\1</i>",
			/\[s\](.*?)\[\/s\]/im => "<del>\\1</del>",
			/\[small\](.*?)\[\/small\]/im => "<span class=\"tsml small\">\\1</span>",
			/\[large\](.*?)\[\/large\]/im => "<span class=\"tsml large\">\\1</span>",
			/\[img\](.*?)\[\/img\]/i => "<img src=\"\\1\">",
			/\[url="?(.*?)"?\](.*?)\[\/url\]/i => "<a href=\"\\1\">\\2</a>",
			/\[left\](.*?)\[\/left\]/im => "<div class=\"tsml left\">\\1</div>",
			/\[right\](.*?)\[\/right\]/im => "<div class=\"tsml right\">\\1</div>",
			/\[center\](.*?)\[\/center\]/im => "<div class=\"tsml center\">\\1</div>",
			/\[hr\]/i => "<div class=\"tsml hr\"></div>",
			/\[color="?([^;"']{1,10}?)"?\](.*?)\[\/color\]/im => "<span class=\"tsml color\" style=\"color:\\1\">\\2</span>",
			/\[quote\](.*?)\[\/quote\]/im => "<div class=\"tsml quote\">\\1</div>",
			/\[quote="?(.*?)"?\](.*?)\[\/quote\]/im => "<div class=\"tsml quote\"><div class=\"tsml quote-header\"><strong>\\1</strong> wrote:</div>\\2</div>",
		}.freeze
		
		DEFAULT_OPTIONS = {
			sanitize: true,
			emoticons: true,
			tags: true,
			nl2br: true,
		}.freeze
	end
end

=begin
":)" => image
":(" => image
"[b]$1[/b]" => <strong>etc
[img]
[u]
[i]
[s]
[color]
[small][large]
[left][center][right]
=end