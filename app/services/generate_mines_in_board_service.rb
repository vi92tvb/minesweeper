class GenerateMinesInBoardService < ApplicationService
  def initialize(board)
    @board = board
  end

  def call
    mines = generate_mines(@board.width, @board.height, @board.num_mines)
    create_mines(mines)
  end

  private

  def generate_mines(width, height, num_mines)
    mines_pos = []
    available_pos = (0...height).to_a.product((0...width).to_a)
    
    selected_pos = available_pos.sample(num_mines)
    
    selected_pos.each do |row, col|
      mines_pos << { board_id: @board.id, x: row, y: col }
    end

    mines_pos
  end

  def create_mines(mines_arr)
    ActiveRecord::Base.transaction do
      mines_arr.each_slice(10000) do |batch|
        Mine.insert_all(batch)
      end
    end
  end
end
