class AddProjectReferencesToActivity < ActiveRecord::Migration[5.0]
  def change
    add_reference :activities, :project, foreign_key: true, on_delete: :cascade
  end
end
