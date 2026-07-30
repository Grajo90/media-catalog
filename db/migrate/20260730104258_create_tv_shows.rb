class CreateTvShows < ActiveRecord::Migration[8.1]
  def change
    create_table :tv_shows do |t|
      t.string :title, null: false
      t.string :original_title, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
