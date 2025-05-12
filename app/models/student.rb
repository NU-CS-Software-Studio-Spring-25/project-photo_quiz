class Student < ActiveRecord::Base
    has_one_attached :profile_picture
  end