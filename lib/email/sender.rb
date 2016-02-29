module Email
  class Sender
    require 'mailgun'

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

      client = Mailgun::Client.new ENV['MAILGUN_API_KEY']

      mailer = Mandrill::API.new ENV['MANDRILL_API_KEY']
      config = {
        :html => body,
        :from => "Backtracks <feedback@backtracks.co>",
        :subject => subject,
        :to => email_address
      }

      result = client.send_message "backtracks.co", config
      (result.first)[:status] == "sent"
    end
  end
end
