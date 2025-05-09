class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :student
  belongs_to :course
end
