class CreateLabels < ActiveRecord::Migration[5.0]
  def change
    create_table :labels do |t|
      t.string :description
      t.references :color, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
