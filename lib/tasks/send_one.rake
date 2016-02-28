namespace :email do
  desc "Queue a one-off email for a user (EMAIL=)"
  task :send_one => :environment do |t, args|
    subject = 'Backtracks Email'
    Resque.enqueue(Email::Sender, User.find_by(email: ENV['EMAIL']), subject)
  end

  desc "Send a test email for a given lastfm username (EMAIL=, USERNAME=)"
  task :send_test => :environment do |t, args|
    subject = 'Backtracks Email'
    Email::Sender.send_email(ENV['EMAIL'], subject,
                             Email::Compiler.chart_v1(ENV['USERNAME']))
  end
end
