class Scourse < ApplicationRecord
  scope :scourse_findbypin ,-> (uid,pin){
         joins(:room).where(:rooms => {:room_pin => pin},:user_id => uid)
  }  
  scope :scourse_findbyuser ,-> (uid){
         joins(:course,:room).select("*").where(:user_id => uid)
  }
  scope :scourse_approved,-> (cid,rid){
         joins(:course,:room,:user).select("*").where(:room_id => rid,:course_id => cid,:status => "approved")
  }
  scope :scourse_pending ,-> (cid,rid){
         joins(:course,:room,:user).select("*,scourses.id scid").where(:room_id => rid,:course_id => cid,:status => "pending")
  }
  enum role: [:approved, :pending, :rejected]
  after_initialize :set_default_status, :if => :new_record?

  def set_default_status
    self.status ||= :pending
  end
  
  belongs_to :room 
  belongs_to :user 
  belongs_to :course 
end
