class Course < ActiveRecord::Base
  attr_accessible :avail_slots, :name, :online_id, :start_date, :teacher, :link, :course_schedule
  validates :name, presence: true


end
