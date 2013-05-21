class ForumsController < ApplicationController
	before_filter :set_category#, :only => [:category, :topic, :post, :make_post]
	before_filter :set_topic#, :only => [:topic, :post]
	
	def index
		@categories = ForumCategory
			.joins("LEFT OUTER JOIN forum_posts ON forum_categories.last_post_id = forum_posts.id")
			.all
	end
	
	def category
		@topics = ForumPost
			.where(:category_id => params[:category_id])
			.order("touch_date DESC")
	end
	
	def topic
		@posts = ForumPost
			.where(:category_id => params[:category_id], :topic_id => params[:topic_id])
			.joins("INNER JOIN users ON forum_posts.user_id = users.id")
			.order("post_date ASC")
			.select("users.*, forum_posts.*")
		p "LOG #{@posts.length}"
	end
	
	def post
		p "LOG #{params.inspect}"
		if !params[:message].blank?
			@preview_post = OpenStruct.new(
				message: params[:message],
				username: @user.username,
				avatar: @user.avatar,
				posts: @user.posts,
				signature: @user.signature,
				post_date: Time.now
			)
		end
	end
	
	def make_post
		if !params[:preview].blank?
			redirect_to action: "post", category_id: @category.id, topic_id: @topic ? @topic.id : nil, subject: params[:subject], message: params[:message] and return
		end
		
		post = ForumPost.new
		post.post_type = @topic ? PostType::REPLY : PostType::TOPIC
		post.category_id = @category.id
		post.topic_id = @topic.id if @topic
		post.user_id = @user.id
		post.subject = params[:subject] || nil
		post.raw_message = params[:message]
		post.message = params[:message]
		post.post_date = Time.now
		post.touch_date = Time.now
		
		ActiveRecord::Base.transaction do
			post.save!
			if post.post_type == PostType::TOPIC
				post.topic_id = post.id
				post.save!
			end
		end
		
		redirect_to action: "topic", category_id: @category.id, topic_id: @topic ? @topic.id : post.id and return
	end
	
	private
	
	def set_category
		@category = ForumCategory.find(params[:category_id]) unless params[:category_id].blank?
	end
	
	def set_topic
		@topic = ForumPost.find(params[:topic_id]) unless params[:topic_id].blank?
	end
	
	module PostType
		TOPIC = 0
		REPLY = 1
	end
end
