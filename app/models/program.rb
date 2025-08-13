class Program < ApplicationRecord
  include Publishable

  belongs_to :content_type
  has_many :content_items, dependent: :destroy

  enum :status, { draft: 1, scheduled: 2, published: 3, archived: 4 }, prefix: true

  after_initialize do
    self.status ||= :draft if new_record?
  end
end
