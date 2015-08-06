class AddSendWeeklyEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_weekly_email, :boolean, default: true
  end
end
