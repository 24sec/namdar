class Tag < ApplicationRecord
  has_and_belongs_to_many :articles

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :name, length: {maximum: 30}
end
