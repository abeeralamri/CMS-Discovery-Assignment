# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
# db/seeds.rb
ApplicationRecord.transaction do
  now = Time.current

  podcast_type = ContentType.find_or_create_by!(en_name: 'podcast') { |t| t.ar_name = 'بودكاست' }
  docs_type    = ContentType.find_or_create_by!(en_name: 'documentary_series') { |t| t.ar_name = 'سلسلة وثائقية' }

  thmanyah_podcast = Program.find_or_create_by!(title: 'انتبه تصير ضفدع في وظيفتك') do |p|
    p.content_type   = podcast_type
    p.description    = 'برنامج حواري متنوع'
    p.language_code  = 'ar'
    p.status         = :published
    p.published_at   = now - 3.days
    p.cover_image_url= 'https://example.com/thmanyah-podcast.jpg'
  end

  thmanyah_docs = Program.find_or_create_by!(title: 'أيش علاقة القولون بنفسيتك') do |p|
    p.content_type   = docs_type
    p.description    = 'سلسلة أفلام وثائقية'
    p.language_code  = 'ar'
    p.status         = :published
    p.published_at   = now - 7.days
    p.cover_image_url= 'https://example.com/thmanyah-docs.jpg'
  end

  [
    { title: 'وش الحل مع الزعول والنفسية', duration: 1800, days_ago: 2 },
    { title: 'مع أو ضد العربي المكسّر',     duration: 2100, days_ago: 1 }
  ].each do |ep|
    thmanyah_podcast.content_items.find_or_create_by!(title: ep[:title]) do |item|
      item.description       = 'حلقة من بودكاست ثمانية.'
      item.language_code     = 'ar'
      item.duration_seconds  = ep[:duration]
      item.status            = :published
      item.published_at      = now - ep[:days_ago].days
      item.audio_video_url   = 'https://example.com/episode.mp4'
    end
  end

  thmanyah_docs.content_items.find_or_create_by!(title: 'تقنية خارقة ستنتهك خصوصية البيانات!') do |item|
    item.description       = 'فيلم وثائقي قصير'
    item.language_code     = 'ar'
    item.duration_seconds  = 2400
    item.status            = :published
    item.published_at      = now - 1.day
    item.audio_video_url   = 'https://example.com/documentary.mp4'
  end

  thmanyah_podcast.content_items.find_or_create_by!(title: 'أيش يصير في مخك وقت الصداع') do |item|
    item.description       = 'لم يتم نشرها بعد'
    item.language_code     = 'ar'
    item.duration_seconds  = 1500
    item.status            = :draft
    item.published_at      = nil
    item.audio_video_url   = nil
  end
end
