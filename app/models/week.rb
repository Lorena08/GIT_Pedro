class Week < ApplicationRecord
  belongs_to :sprint
  has_many :hours_registries, dependent: :destroy

  accepts_nested_attributes_for :hours_registries
end