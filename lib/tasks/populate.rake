namespace :db do
	desc "Erase and fill database"
	task populate: :environment do
		Rake::Task['db:reset'].invoke
		require 'populator'
		require 'faker'
		# call populate function
		populate_users
		populate_fliter
	end
end

	def populate_users
		User.create(
			username: 'yungchih',
			email: 'yungchih.chen@dmsva.com',
			password: 'foobar',
			password_confirmation: 'foobar')

		10.times do
			username = Faker::Internet.user_name
			email = Faker:: Internet.email
			password = 'foobar'
			User.create!(
					username: username,
					email: email,
					password: password,
					password_confirmation: password
				)

		end


#		User.populate(10) do |user|
#			user.username = Faker::Internet.user_name
#			user.email = Faker::Internet.email
#			user.password = 'foobar'
#			user.password_confirmation = 'foobar'
#		end
	end

	def populate_fliter
		User.all.each do |user|
			Flit.populate(5..10) do |flit|
				flit.user_id = user.id
				flit.message = Faker::Lorem.sentence
			end

			3.times do
				user.add_friend(User.all[rand(User.count)])
			end
		end
	end
