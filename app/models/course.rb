class Course < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :students, through: :memberships
  has_many :users, through: :memberships
end
