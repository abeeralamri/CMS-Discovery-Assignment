class CreateContentItemsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :content_items do |t|
      t.references :program, null: false, foreign_key: true
      t.string   :title,        null: false
      t.text     :description
      t.string   :language_code, null: false, default: 'ar'
      t.integer  :duration_seconds
      t.datetime :published_at
      t.integer  :status, null: false, default: 1
      t.string   :audio_video_url
      t.timestamps
    end
    add_index :content_items, [:program_id, :status, :published_at]
    add_index :content_items, :published_at
  end
end
