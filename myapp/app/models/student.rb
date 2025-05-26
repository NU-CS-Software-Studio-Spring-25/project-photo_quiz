# Student model for managing students in the application
# This model handles student associations with courses and validations for names.
class Student < ActiveRecord::Base
    has_many :memberships, dependent: :destroy
    has_many :courses, through: :memberships
    accepts_nested_attributes_for :memberships
    validates :first_name, :last_name, presence: true
    VALID_NAME_REGEX = /\A[a-zA-Z\s\-']+\z/
    validates :first_name, format: { with: VALID_NAME_REGEX, message: "only allows letters, spaces, hyphens, and apostrophes" }
    validates :last_name, format: { with: VALID_NAME_REGEX, message: "only allows letters, spaces, hyphens, and apostrophes" }
    has_one_attached :profile_picture
end
