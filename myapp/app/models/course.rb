class Course < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :students, through: :memberships
  has_many :users, through: :memberships
  before_create :generate_unique_code

  private
  def generate_unique_code
    self.code = loop do
      random_code = SecureRandom.alphanumeric(6).upcase 
      break random_code unless Course.exists?(code: random_code)
    end
  end
end
