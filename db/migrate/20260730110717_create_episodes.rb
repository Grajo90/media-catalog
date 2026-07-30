class CreateEpisodes < ActiveRecord::Migration[8.1]
  def change
    create_table :episodes do |t|
      t.string :title, null: false
      t.string :original_title, null: false
      t.integer :year, null: false
      t.integer :number, null: false
      t.references :season, null: false, foreign_key: true

      t.timestamps
    end

    add_index :episodes, [ :season_id, :number ], unique: true
  end
end
