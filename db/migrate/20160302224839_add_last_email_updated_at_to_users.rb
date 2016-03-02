class AddLastEmailUpdatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_email_updated_at, :timestamp
  end
end
