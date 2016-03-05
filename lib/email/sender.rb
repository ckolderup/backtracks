module Email
  class Sender
    @queue = 'weekly'

    def self.perform(user, subject)
      raise "no email address" unless user["email"].present?
      raise "no lastfm username" unless user["lastfm_username"].present?

      compiled = Email::Compiler.chart_v1(user['lastfm_username'])
      send_email(user["email"], subject, compiled[:email])
      user.update(last_email_contents: compiled[:chart])
    end

    def self.send_email(email_address, subject, body)
      raise "empty email" if body.nil?

      Mailgun.configure do |config|
        config.api_key = ENV['MAILGUN_API_KEY']
        config.domain = 'mailer.backtracks.co'
      end

      mailgun = Mailgun()

      config = {
        :html => body,
        :from => "Backtracks <feedback@backtracks.co>",
        :subject => subject,
        :to => email_address
      }

      mailgun.messages.send_email(config)
    end
  end
end
