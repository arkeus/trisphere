require "tsml"

class ForumsController < ApplicationController
	before_filter :set_category#, :only => [:category, :topic, :post, :make_post]
	before_filter :set_topic#, :only => [:topic, :post]
	before_filter :set_post
	
	def index
		@categories = ForumCategory
			.joins("LEFT OUTER JOIN forum_posts fp1 ON forum_categories.last_post_id = fp1.id LEFT OUTER JOIN forum_posts fp2 ON fp1.topic_id = fp2.id")
			.select("forum_categories.*, fp1.user_id, fp1.topic_id, fp1.id as post_id, fp1.post_date AS last_post_date, fp2.subject")
		@users = get_users(@categories.map { |c| c.user_id })
	end
	
	def category
		@topics = ForumPost
			.where(:category_id => params[:category_id], :post_type => PostType::TOPIC)
			.order("sticky DESC, touch_date DESC")
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
				message: TSML::Parser.parse(params[:message]),
				user_id: @user.id,
				avatar: @user.avatar,
				posts: @user.posts,
				signature: @user.signature,
				post_date: Time.now
			)
			@preview = true
		end
		@users = get_users([@user.id])
	end
	
	def delete
		raise "Could not delete post" unless params[:id] && params[:category_id] && params[:topic_id]
		post = ForumPost.where(id: params[:id]).first
		raise "Post could not be found" unless post
		raise "This is not your post" unless post.user_id == @user.id
		
		ActiveRecord::Base.transaction do			
			# Do we want to lower reply owner's post counts? Should topic owner have that power?
			if post.post_type == PostType::TOPIC
				num_deleted = ForumPost.delete_all(["topic_id = ?", post.id])
				@category.topics -= 1
				@category.replies -= (num_deleted - 1)
				@user.posts -= num_deleted if post.user_id == @user.id
			else
				post.destroy!
				last_reply = ForumPost.where(category_id: @category.id, topic_id: @topic.id, post_type: PostType::REPLY).select("user_id, post_date").last
				@topic.last_post_user_id = last_reply ? last_reply.user_id : nil
				@topic.touch_date = last_reply ? last_reply.post_date : @topic.created_at
				@topic.replies -= 1
				@topic.save!
				@user.posts -= 1 if post.user_id == @user.id
			end
			
			last_category_post = ForumPost.where(category_id: @category.id).select("id").last
			@category.last_post_id = last_category_post ? last_category_post.id : nil
			@category.save!
		end
		
		redirect_to action: "topic", category_id: @category.id, topic_id: @topic.id and return if post.post_type == PostType::REPLY
		redirect_to action: "category", category_id: @category.id and return
	end
	
	def make_post
		raise "You must fill out the entire form" if params[:message].blank? || (params[:subject].blank? && params[:post_type].to_i == PostType::TOPIC)
		post_type = !params[:post_id].blank? ? PostType::EDIT : @topic ? PostType::REPLY : PostType::TOPIC
		raise "This topic is locked" if @topic.try(:locked)
		# TODO: user permissions for edit and posting in locked category
		
		if post_type == PostType::EDIT
			post = @post
			raise "Could not find post" unless post
			raise "You cannot edit this post" unless post.user_id = @user.id
			post.raw_message = params[:message]
			post.message = TSML::Parser.parse(params[:message])
			post.edit_date = Time.now
		else
			post = ForumPost.new
			post.post_type = post_type
			post.category_id = @category.id
			post.topic_id = @topic.id if @topic
			post.user_id = @user.id
			post.subject = params[:subject] || nil
			post.raw_message = params[:message]
			post.message = TSML::Parser.parse(params[:message])
			post.post_date = Time.now
			post.touch_date = Time.now
		end
		
		ActiveRecord::Base.transaction do
			post.save!
			
			unless post_type == PostType::EDIT
				@user.posts += 1
				
				if post_type == PostType::TOPIC
					post.topic_id = post.id
					post.save!
				end
				
				if @topic
					@topic.replies += 1
					@topic.touch_date = Time.now
					@topic.last_post_user_id = @user.id
					@topic.save!
				end
				
				if @category
					@category.topics +=1 if post.post_type == PostType::TOPIC
					@category.replies +=1 if post.post_type == PostType::REPLY
					@category.last_post_id = post.id
					@category.save!
				end
			end
		end
		
		redirect_to action: "topic", category_id: @category.id, topic_id: @topic ? @topic.id : post.id and return
	end
	
	def alter
		# TODO: user permission
		@topic.sticky = true if params[:alter_type] == "sticky"
		@topic.sticky = false if params[:alter_type] == "unsticky"
		@topic.locked = true if params[:alter_type] == "lock"
		@topic.locked = false if params[:alter_type] == "unlock"
		@topic.save!
		
		redirect_to action: "topic", category_id: @category.id, topic_id: @topic and return
	end
	
	private
	
	def set_category
		@category = ForumCategory.find(params[:category_id]) unless params[:category_id].blank?
	end
	
	def set_topic
		@topic = ForumPost.find(params[:topic_id]) unless params[:topic_id].blank?
	end
	
	def set_post
		@post = ForumPost.find(params[:post_id]) unless params[:post_id].blank?
	end
	
	def get_users(ids)
		processed_ids = ids.flatten.compact.uniq
		p "USER IDS: #{processed_ids}"
		User.where(:id => processed_ids).select("id, username").inject({}) { |acc, user| acc[user.id] = user; acc }
	end
	
	module PostType
		TOPIC = 0
		REPLY = 1
		EDIT = 2
	end
end
