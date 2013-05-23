class ForumsController < ApplicationController
	before_filter :set_category#, :only => [:category, :topic, :post, :make_post]
	before_filter :set_topic#, :only => [:topic, :post]
	
	def index
		@categories = ForumCategory
			.joins("LEFT OUTER JOIN forum_posts fp1 ON forum_categories.last_post_id = fp1.id LEFT OUTER JOIN forum_posts fp2 ON fp1.topic_id = fp2.id")
			.select("forum_categories.*, fp1.user_id, fp1.topic_id, fp1.id as post_id, fp1.post_date AS last_post_date, fp2.subject")
		@users = get_users(@categories.map { |c| c.user_id })
	end
	
	def category
		@topics = ForumPost
			.where(:category_id => params[:category_id], :post_type => PostType::TOPIC)
			.order("touch_date DESC")
			.page(params[:page] || 1)
			.per_page(15)
		@users = get_users(@topics.map { |t| [t.user_id, t.last_post_user_id] })
	end
	
	def topic
		@posts = ForumPost
			.where(:category_id => params[:category_id], :topic_id => params[:topic_id])
			.joins("INNER JOIN users ON forum_posts.user_id = users.id")
			.order("post_date ASC")
			.select("users.*, forum_posts.*")
			.page(params[:page] || 1)
			.per_page(15)
		@users = get_users(@posts.map { |p| p.user_id })
		
		ip = IPAddr.new(request.remote_ip).to_i
		if @topic.last_view_ip != ip
			@topic.last_view_ip = ip
			@topic.views += 1
			@topic.save!
		end
	end
	
	def post
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
		raise "You must fill out the entire form" if params[:message].blank? || (params[:subject].blank? && params[:post_type].to_i == PostType::TOPIC)
		
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
			
			if @topic
				@topic.replies += 1
				@topic.touch_date = Time.now
				@topic.last_post_user_id = @user.id
				p "SET THE LAST POST USER ID"
				@topic.save!
			end
			
			if @category
				@category.topics +=1 if post.post_type == PostType::TOPIC
				@category.replies +=1 if post.post_type == PostType::REPLY
				@category.last_post_id = post.id
				@category.save!
			end
		end
		
		@user.posts += 1
		
		redirect_to action: "topic", category_id: @category.id, topic_id: @topic ? @topic.id : post.id and return
	end
	
	private
	
	def set_category
		@category = ForumCategory.find(params[:category_id]) unless params[:category_id].blank?
	end
	
	def set_topic
		@topic = ForumPost.find(params[:topic_id]) unless params[:topic_id].blank?
	end
	
	def get_users(ids)
		processed_ids = ids.flatten.compact.uniq
		p "USER IDS: #{processed_ids}"
		User.where(:id => processed_ids).select("id, username").inject({}) { |acc, user| acc[user.id] = user; acc }
	end
	
	module PostType
		TOPIC = 0
		REPLY = 1
	end
end
