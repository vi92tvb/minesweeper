class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.string :name
      t.integer :width
      t.integer :height
      t.integer :num_mines
      t.integer :user_id

      t.timestamps
    end
  end
end
