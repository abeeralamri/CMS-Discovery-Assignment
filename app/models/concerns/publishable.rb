# app/models/concerns/publishable.rb
module Publishable
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where(status: 'published') }

    after_commit :enqueue_publish_job_if_needed, on: [:create, :update]
  end

  # Schedule for the future
  def schedule_publish!(at)
    return unless at.present? && at > Time.current

    update!(status: 'scheduled', published_at: at)
  end

  # Publish immediately
  def publish_now!
    raise 'Record archived' if respond_to?(:status_archived?) && status_archived?

    update!(status: 'published', published_at: Time.current)
  end


  private

  def enqueue_publish_job_if_needed
    return unless published_at.present?
    if (respond_to?(:status_scheduled?) && status_scheduled?) || published_at.future?
      PublishJob.set(wait_until: published_at).perform_later(self)
    end
  end
end
