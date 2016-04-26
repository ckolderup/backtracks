namespace :jobs do
  desc "Finds the users to send the weekly email to and queues a job for each"
  task :queue_todays, [:day] => :environment do |t, args|
    p = args[:day] || Time.now.wday
    users = User.where('id % ? = 0 AND send_weekly_email IS ?', p, true)

    users.each do |u|
      Resque.enqueue(EmailChart, u.id)
    end
  end
end
