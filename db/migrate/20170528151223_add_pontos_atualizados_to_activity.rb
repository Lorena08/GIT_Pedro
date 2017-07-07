class AddPontosAtualizadosToActivity < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :pontos_atualizados, :float
  end
end
