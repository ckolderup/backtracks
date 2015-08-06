module Email
  class WeeklySender
    @queue = 'weekly'

    def self.perform(user, subject)
      raise "no email address" unless user.email.present?
      raise "no lastfm username" unless user.lastfm_username.present?

      send_email(user.email, subject, Email::Compiler.chart_v1(user.lastfm_username))
    end

    def self.send_email(email_address, subject, body)
      raise "empty email" if body.nil?

      mailer = Mandrill::API.new
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
