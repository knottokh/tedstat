class Room < ApplicationRecord
    #attr_accessible :course_id,:room_name,:room_pin,:attribute_point,:ratio_score,:ratio_grade
    scope :room_findbypin ,-> (pin){
         joins(:course).select("*,rooms.id roomid,courses.id courseid").where(:room_pin => pin)
    }  
    scope :room_course_user ,-> (cid,uid){
         joins(:course).select("*,rooms.id id,courses.id courseid").where(:course_id => cid, :courses => {:user_id => uid})
    }
    
    validates :course_id, presence: true
    validates :room_name, presence: true
    validates :room_pin, presence: true, uniqueness: true
    validates :point_attr, presence: false,numericality: { greater_than_or_equal_to: 0 }
    #validates :ratio_score, presence: true
    #validates :ratio_grade, presence: true
    after_initialize :set_default_point, :if => :new_record?

    def set_default_point
        self.point_attr ||= 0
    end
    
    belongs_to :course 
    has_many :scourses
    has_many :tasks
    has_many :emotions
end
