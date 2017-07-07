class CreateWeeks < ActiveRecord::Migration[5.0]
  def change
    create_table :weeks do |t|
      t.string :description
      t.date :start_w
      t.date :end_w
      t.string :expected_hours
      t.references :sprint, foreign_key: true

      t.timestamps
    end
  end
end
