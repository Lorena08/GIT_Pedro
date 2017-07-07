class CreateSprints < ActiveRecord::Migration[5.0]
  def change
    create_table :sprints do |t|
      t.string :description
      t.date :inicio
      t.date :fim
      t.integer :pontos_cadastrados
      t.integer :pontos_atualizados

      t.timestamps
    end
  end
end
