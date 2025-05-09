class Course < ApplicationRecord
  has_many :memberships
  has_many :students, through: :memberships
  has_many :users, through: :memberships
end
