module Email
  class Sender
    require 'mandrill'

    @queue = 'weekly'

    def self.perform(user, subject)
      raise "no email address" unless user["email"].present?
      raise "no lastfm username" unless user["lastfm_username"].present?

      body = Email::Compiler.chart_v1(user['lastfm_username'])
      send_email(user["email"], subject, body)
      user.update(last_email_contents: body)
    end

    def self.send_email(email_address, subject, body)
      raise "empty email" if body.nil?

      mailer = Mandrill::API.new ENV['MANDRILL_API_KEY']
      config = {
        :html => body,
        :from_email => "feedback@backtracks.co",
        :from_name => "BackTracks",
        :subject => subject,
        :to => [ {:email => email_address} ],
        :async => true
      }
      result = mailer.messages.send(config)
      (result.first)[:status] == "sent"
    end
  end
end
