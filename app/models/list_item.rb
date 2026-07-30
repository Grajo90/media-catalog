class ListItem < ApplicationRecord
  belongs_to :list
  belongs_to :content, polymorphic: true

  validates :position, presence: true, uniqueness: { scope: :list_id }
end
