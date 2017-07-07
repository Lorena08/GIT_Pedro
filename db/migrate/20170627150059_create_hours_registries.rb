class CreateHoursRegistries < ActiveRecord::Migration[5.0]
  def change
    create_table :hours_registries do |t|
      t.datetime :start_hr
      t.datetime :end_hr
      t.float :hours_performed
      t.references :week, foreign_key: true, on_delete: :cascade
      t.references :user, foreign_key: true, on_delete: :cascade
      t.references :project, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
