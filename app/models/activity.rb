class Activity < ApplicationRecord
  belongs_to :status
  belongs_to :label
  belongs_to :sprint
  belongs_to :project
  belongs_to :user

  validates_presence_of :description, :project_id, :sprint_id, :user_id
end
