namespace :jobs do
  desc "Finds the users to send the weekly email to and queues a job for each"
  task :queue_todays, [:day] => :environment do |t, args|
    p = args[:day] || Time.now.wday
    users = Users.where('id % ? = 0', p).and(send_weekly_email: true)

    users.each do |u|
      Resque.enqueue(EmailChart, u)
    end
  end
end
