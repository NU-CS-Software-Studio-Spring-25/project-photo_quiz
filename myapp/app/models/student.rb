class Student < ActiveRecord::Base
    has_many :memberships, dependent: :destroy
    has_many :courses, through: :memberships
    accepts_nested_attributes_for :memberships
    validates :first_name, :last_name, presence: true
    validates :first_name, length: { maximum: 25 }
    validates :last_name, length: { maximum: 25 }
    VALID_NAME_REGEX = /\A[a-zA-Z\s\-']+\z/
    validates :first_name, format: { with: VALID_NAME_REGEX, message: "only allows letters, spaces, hyphens, and apostrophes" }
    validates :last_name, format: { with: VALID_NAME_REGEX, message: "only allows letters, spaces, hyphens, and apostrophes" }
    has_one_attached :profile_picture
    validate :profile_picture_size

    def profile_picture_size
        if profile_picture.attached? && profile_picture.blob.byte_size > 5.megabytes
            errors.add(:profile_picture, "must be less than 5MB")
        end
    end




end
