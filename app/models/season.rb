class Season < ApplicationRecord
  belongs_to :tv_show
  has_many :episodes

  validates :title, presence: true
  validates :original_title, presence: true
  validates :year, presence: true
  validates :number, presence: true, uniqueness: { scope: :tv_show_id }
end
