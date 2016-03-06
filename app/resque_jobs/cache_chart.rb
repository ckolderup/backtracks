class CacheChart
  @queue = :housekeeping

  def self.perform(user_id)
    user = User.find(user_id)
    chart = Charts.v1(user.lastfm_username)
    user.update(last_email_contents: chart)
  end
end
