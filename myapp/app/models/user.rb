class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :owned_courses, class_name: "Course"
  has_many :courses, through: :memberships
  has_many :students, through: :memberships
  # Apply validation for full_name only when creating or updating the user
  validates :full_name, presence: true, if: :new_record?
end
