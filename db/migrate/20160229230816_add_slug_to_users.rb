class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string, null: false
    User.where(slug: nil).each { |u| u.send(:generate_slug) && u.save }
  end
end
