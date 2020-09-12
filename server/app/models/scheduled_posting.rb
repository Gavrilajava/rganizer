class ScheduledPosting < ApplicationRecord
  

  scope :next, -> (count){where(status: 'new').first(count)}
  scope :not_done, -> {where(status: ['new', "parsing"]).count}
  scope :stats, -> {group(:status).count}
  
end
