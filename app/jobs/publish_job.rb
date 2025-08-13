class PublishJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 5, wait: :exponentially_longer

  def perform(record)
    return unless record.present?
    return if record.respond_to?(:status_archived?) && record.status_archived?
    return if record.respond_to?(:status_published?) && record.status_published?

    if record.published_at.present? && record.published_at > Time.current
      self.class.set(wait_until: record.published_at).perform_later(record)
      return
    end

    unless record.respond_to?(:ready_to_publish_now?) ? record.ready_to_publish_now? : true
      self.class.set(wait: 10.minutes).perform_later(record)
      return
    end

    record.publish_now!
  end
end
