class AddUserReferencesToUserProfile < ActiveRecord::Migration[5.0]
  def change
    # add_reference :user_profiles, :user, foreign_key: true
    add_reference :user_profiles, :user, foreign_key: true, on_delete: :cascade
  end
end
