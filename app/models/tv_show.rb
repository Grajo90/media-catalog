class TvShow < ApplicationRecord
  has_many :seasons

  validates :title, presence: true
  validates :original_title, presence: true
  validates :year, presence: true
end
