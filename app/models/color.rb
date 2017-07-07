class Color < ApplicationRecord
  has_many :label, dependent: :nullify
  has_many :status, dependent: :nullify
end
