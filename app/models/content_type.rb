class ContentType < ApplicationRecord
  has_many :programs
  validates :ar_name, presence: true
  validates :en_name, presence: true
end
