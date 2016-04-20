namespace :migration do
  desc "Import users (email, lastfm username) into a database from a CSV (FILE=)"
  task :create_users => :environment do |t, args|
    IO.readlines(ENV['FILE']).each do |line|
      email, username = line.chomp.split(',')
      user = User.create(
        email: email,
        password: SecureRandom.urlsafe_base64,
        lastfm_username: username,
        display_name: username
      )
      if user.persisted?
        Rails.logger.info("User #{username} created. User id: #{user.id}")
      else
        Rails.logger.info("Couldn't create user #{username} with email #{email}")
      end
    end
  end
end
