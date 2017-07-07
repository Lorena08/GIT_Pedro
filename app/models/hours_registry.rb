class HoursRegistry < ApplicationRecord
  belongs_to :week
  belongs_to :user
  belongs_to :project
end
