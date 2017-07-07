class AddColorReferencesToStatus < ActiveRecord::Migration[5.0]
  def change
    add_reference :statuses, :color, foreign_key: true
  end
end
