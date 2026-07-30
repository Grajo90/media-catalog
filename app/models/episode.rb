class Episode < ApplicationRecord
  belongs_to :season

  validates :title, presence: true
  validates :original_title, presence: true
  validates :year, presence: true
  validates :number, presence: true, uniqueness: { scope: :season_id }
end
