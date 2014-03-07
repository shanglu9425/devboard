# Duration is an integer in minutes.
class Task < ActiveRecord::Base
  scope :active, -> { where(completed: nil) }
  
  belongs_to :developer
  belongs_to :project
  
  enum priority: [ :low_priority, :normal_priority, :high_priority ]
  
  validates_presence_of :project, :title
  
  # Difficulty is rated on a subjective scale from 1-10
  validates :difficulty, :numericality => { :greater_than => 0, :less_than_or_equal_to => 10 }, :allow_nil => true
end
