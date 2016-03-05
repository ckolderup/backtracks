class ResqueJobs::EmailChart
  @queue = :weekly

  def self.perform(user)
    contents = ChartMailer.v1(user).deliver
    user.update(last_email_contents: contents)
  end
end
