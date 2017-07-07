class CreateProgresses < ActiveRecord::Migration[5.0]
  def change
    create_table :progresses do |t|
      t.string :completeness
      t.string :advance
      t.references :project, foreign_key: true # Modificado
      t.references :sprint, foreign_key: true # Modificado

      t.timestamps
    end
  end
end
