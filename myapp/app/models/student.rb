class Student < ActiveRecord::Base
    has_many :memberships, dependent: :destroy
    has_many :courses, through: :memberships
    accepts_nested_attributes_for :memberships

    # # Optional: If a student has a profile picture, name_mastery, and learned
    has_one_attached :profile_picture  # if using Active Storage
end
