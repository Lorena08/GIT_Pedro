class AddSemesterToSprint < ActiveRecord::Migration[5.0]
  def change
    add_column :sprints, :semester, :string
  end
end
