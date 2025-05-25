class Course < ApplicationRecord
  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :students, through: :memberships
  has_many :users, through: :memberships
  validates :name, presence: true
qui  VALID_COURSE_NAME_REGEX = /\A[a-zA-Z0-9\s\-\']+\z/
  validates :name, format: { with: VALID_COURSE_NAME_REGEX, message: "only allows letters, numbers, spaces, hyphens, and apostrophes" }
end
