class ContentItem < ApplicationRecord
  include Publishable

  belongs_to :program

  enum :status, { draft: 1, scheduled: 2, published: 3, archived: 4 }, prefix: true

  validate :parent_program_must_be_published, if: :publishing_now?

  after_initialize do
    self.status ||= :draft if new_record?
  end

  private

  def publishing_now?
    will_save_change_to_status? && status_published?
  end

  def parent_program_must_be_published
    errors.add(:base, 'Program must be published before publishing items') unless program&.status_published?
  end
end
