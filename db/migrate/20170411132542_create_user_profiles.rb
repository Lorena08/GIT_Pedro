class CreateUserProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_profiles do |t|
      t.string :name
      t.string :student_number

      t.timestamps
    end
  end
end
