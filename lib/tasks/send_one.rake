namespace :email do
  desc "Queue a one-off email for a user (EMAIL=)"
  task :send_one => :environment do |t, args|
    Resque.enqueue(ResqueJobs::EmailChart, User.find_by(email: ENV['EMAIL']))
  end

  desc "Send a test email for a given lastfm username (EMAIL=, USERNAME=)"
  task :send_test => :environment do |t, args|
    user = User.find_by_lastfm_username(ENV['USERNAME'])
    ChartMailer.v1(user, ENV['EMAIL']).deliver
  end
end
