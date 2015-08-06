class AddLastFmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lastfm_username, :string
  end
end
