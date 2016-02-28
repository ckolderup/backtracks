class AddLastEmailContentsToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_email_contents, :text
  end
end
