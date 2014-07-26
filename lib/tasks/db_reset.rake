namespace :db do
	# task :kill do
		# ENV['ENV'] = "development"
		# ENV['VERSION']= "0"
		# Rake::Task['db:migrate'].invoke
		# Rake::Task['db:migrate'].reenable
		# ENV.delete 'VERSION'
		# Rake::Task["db:migrate"].invoke
		# load File.join(Rails.root, "db", "seeds.rb")
	# end
	
	task kill: ["environment", "db:drop", "db:create", "db:migrate", "db:seed"]
end