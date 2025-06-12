class Course < ApplicationRecord
  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :students, through: :memberships
  has_many :users, through: :memberships

  before_create :generate_unique_code

  validates :name, presence: true
  validates :name, length: { maximum: 25 }
  VALID_COURSE_NAME_REGEX = /\A[a-zA-Z0-9\s\-\']+\z/
  validates :name, format: { with: VALID_COURSE_NAME_REGEX, message: "only allows letters, numbers, spaces, hyphens, and apostrophes" }

  private

  def generate_unique_code
    self.code = loop do
      random_code = SecureRandom.alphanumeric(6).upcase
      break random_code unless Course.exists?(code: random_code)
    end
  end
end
