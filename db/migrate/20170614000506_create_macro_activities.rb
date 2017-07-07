class CreateMacroActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :macro_activities do |t|
      t.string :description
      t.string :completeness # Modificado
      t.references :project, foreign_key: true # Modificado

      t.timestamps
    end
  end
end
