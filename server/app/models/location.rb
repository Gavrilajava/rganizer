class Location < ApplicationRecord

  scope :active, -> {where(isActive: true)}
end
