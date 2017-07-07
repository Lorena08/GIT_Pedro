class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :description
      t.float :pontos_cadastrados
      t.references :status, foreign_key: true
      t.references :label, foreign_key: true
      t.references :sprint, foreign_key: true

      t.timestamps
    end
  end
end
