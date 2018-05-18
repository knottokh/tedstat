class User < ApplicationRecord
  validates :school_id, presence: true
  validates :student_code, presence: true
  validates :prefix, presence: true
  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true
  validates_confirmation_of :password
  
  enum role: [:student, :teacher, :admin]
  after_initialize :set_default_role, :if => :new_record?
  
  def set_default_role
    self.role ||= :student
  end
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :school     
  has_many :courses
  has_many :scourses
  has_many :taskresults
  has_many :emotions
end
