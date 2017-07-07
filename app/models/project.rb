class Project < ApplicationRecord

  # Associations
  belongs_to :team

  has_many :activities, dependent: :destroy
  has_many :project_sprints, dependent: :destroy
  has_many :sprints, through: :project_sprints

  has_many :macro_activities, dependent: :destroy
  has_many :progresses, dependent: :destroy

  has_many :hours_registries, dependent: :destroy


  # Validations
  validates_presence_of :description, :team_id

  # Nested Attributes
  accepts_nested_attributes_for :progresses, allow_destroy: true
end
