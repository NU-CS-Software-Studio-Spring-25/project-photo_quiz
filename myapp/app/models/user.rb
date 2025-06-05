class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :owned_courses, class_name: "Course"
  has_many :courses, through: :memberships
  has_many :students, through: :memberships
  validates :full_name, presence: true
  validates :full_name, length: { maximum: 50 }
  VALID_NAME_REGEX = /\A[a-zA-Z\s\-']+\z/
  validates :full_name, format: { with: VALID_NAME_REGEX, message: "only allows letters, spaces, hyphens, and apostrophes" }
end
