namespace :db do
	# Override db:reset to drop development database and run migrations to make testing easier
	task :reset do
		ENV['ENV'] = "development"
		ENV['VERSION']= "0"
		Rake::Task['db:migrate'].invoke
		Rake::Task['db:migrate'].reenable
		ENV.delete 'VERSION'
		Rake::Task["db:migrate"].invoke
		Rake::Task["db:seed"].invoke
	end
end