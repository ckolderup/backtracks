namespace :email do
  desc "Send a one-off email for a last_fm username (EMAIL=, USERNAME=)"
  task :send_one => :environment do |t, args|
    subject = 'Backtracks Email'
    Email::Sender.send_email(ENV['EMAIL'], subject,
                             Email::Compiler.chart_v1(ENV['USERNAME']))
  end
end
