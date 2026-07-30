class CreateSeasons < ActiveRecord::Migration[8.1]
  def change
    create_table :seasons do |t|
      t.string :title, null: false
      t.string :original_title, null: false
      t.integer :year, null: false
      t.integer :number, null: false
      t.references :tv_show, null: false, foreign_key: true

      t.timestamps
    end

    add_index :seasons, [ :tv_show_id, :number ], unique: true
  end
end
