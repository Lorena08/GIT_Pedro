class Status < ApplicationRecord
  belongs_to :color
  has_many :activities, dependent: :nullify
end
