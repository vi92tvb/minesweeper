
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
    placed_mines = 0
    existed_pos = {}
    mines_pos = []

    while placed_mines < num_mines
      loop do
        row = rand(0...height)
        col = rand(0...width)

        pos_key = [row, col]

        next if existed_pos[pos_key]

        existed_pos[pos_key] = true

        mines_pos << { board_id: @board.id, x: row, y: col }
        placed_mines += 1
        break;
      end
    end

    mines_pos
  end

  def create_mines(mines_arr)
    Mine.insert_all(mines_arr)
  end
end
