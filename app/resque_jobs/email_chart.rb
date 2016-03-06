class EmailChart
  @queue = :weekly

  def self.perform(user_id)
    message = ChartMailer.v1(user_id).deliver
  end
end
