class Keyword < ApplicationRecord
  scope :active, -> {where(isActive: true)}
end
