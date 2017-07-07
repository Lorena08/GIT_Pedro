class CreateProjectSprints < ActiveRecord::Migration[5.0]
  def change
    create_table :project_sprints do |t|
      t.references :project, foreign_key: true
      t.references :sprint, foreign_key: true

      t.timestamps
    end
  end
end
