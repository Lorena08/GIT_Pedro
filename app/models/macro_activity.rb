class MacroActivity < ApplicationRecord

  # Associations
  belongs_to :project

  # Validations
  validates_presence_of :description, :project_id
end
