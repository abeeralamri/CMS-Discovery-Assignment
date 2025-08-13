class CreateContentTypesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :content_types do |t|
      t.string  :ar_name, null: false
      t.string  :en_name, null: false
      t.timestamps
      t.index :en_name
      t.index :ar_name
    end
  end
end
