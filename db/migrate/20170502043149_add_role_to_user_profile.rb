class AddRoleToUserProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :user_profiles, :role, :integer
  end
end
