class CreateListItems < ActiveRecord::Migration[8.1]
  def change
    create_table :list_items do |t|
      t.references :list, null: false, foreign_key: true
      t.references :content, polymorphic: true, null: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :list_items, [ :list_id, :position ], unique: true
  end
end
