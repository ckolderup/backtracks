class AddPublicChartToUser < ActiveRecord::Migration
  def change
    add_column :users, :public_chart, :boolean
  end
end
