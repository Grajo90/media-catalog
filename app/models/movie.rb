class Movie < ApplicationRecord
  validates :title, presence: true
  validates :original_title, presence: true
  validates :year, presence: true
end
