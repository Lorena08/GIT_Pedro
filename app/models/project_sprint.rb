class ProjectSprint < ApplicationRecord
  belongs_to :project
  belongs_to :sprint

  validates_presence_of :project_id, :sprint_id
end
