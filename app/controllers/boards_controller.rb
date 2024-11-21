class BoardsController < ApplicationController
  before_action :set_board, only: [:show]
  before_action :redirect_new, only: [:new]

  def index
    @boards = Board.includes(:user).order(created_at: :desc)

    @board = Board.new
  end

  def new
  end

  def create
    form = CreateBoardForm.new(**board_params)
    saved_success, board = form.save

    if saved_success
      GenerateMinesInBoardService.call(board)

      redirect_to board
    else
      render :new
    end
  end

  def show
    @rows_per_page = 20
    @cols_per_page = 20

    @page_row = params[:page_row] || 0
    @page_col = params[:page_col] || 0

    @rows = (0..@board.height-1).to_a[@page_row.to_i * @rows_per_page, @rows_per_page]
    @cols = (0..@board.width-1).to_a[@page_col.to_i * @cols_per_page, @cols_per_page]
  end

  private

  def set_board
    @board = Board.find(params[:id])
    @user = @board.user
    @mines = @board.mines
  end

  def board_params
    params.require(:board).permit(:name, :email, :width, :height, :num_mines)
  end

  def redirect_new
    redirect_to boards_path
  end
end
