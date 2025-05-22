class Student < ActiveRecord::Base
    has_many :memberships, dependent: :destroy
    has_many :courses, through: :memberships
    accepts_nested_attributes_for :memberships

    has_one_attached :profile_picture
end
