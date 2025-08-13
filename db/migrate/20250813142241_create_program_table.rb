class CreateProgramTable < ActiveRecord::Migration[8.0]
  def change
    create_table :programs do |t|
      t.references :content_type, null: false
      t.string   :title, null: false
      t.text     :description
      t.string   :language_code, null: false, default: 'ar'
      t.integer  :status, null: false, default: 1
      t.datetime :published_at
      t.string   :cover_image_url
      t.timestamps
      t.index :language_code
      t.index :published_at
    end
  end
end
