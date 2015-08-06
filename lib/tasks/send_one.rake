namespace :email do
  desc "Send a one-off email for a given last.fm username"
  task :send_one, [:email, :username] => :environment do |t, args|
    subject = 'Backtracks Email'
    Email::Sender.send_email(args[:email], subject,
                             Email::Compiler.chart_v1(args[:username]))
  end
end
