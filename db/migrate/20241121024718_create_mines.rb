class CreateMines < ActiveRecord::Migration[8.0]
  def change
    create_table :mines do |t|
      t.integer :board_id
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
