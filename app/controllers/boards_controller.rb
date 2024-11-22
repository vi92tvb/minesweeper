class BoardsController < ApplicationController
  before_action :set_board, only: %i[show]
  before_action :set_ten_boards, only: %i[home new create]
  before_action :set_default_form, only: %i[home new]
  before_action :redirect_new, only: [:new]

  def home
  end

  def index
    @boards = Board.includes(:user)
                   .order(created_at: :desc)
                   .page(params[:page]).per(10)
  end

  def new
  end

  def create
    @form = CreateBoardForm.new(**board_params)
    saved_success, board = @form.save

    if saved_success
      GenerateMinesInBoardService.call(board)

      redirect_to boards_path
    else
      render :home, status: :unprocessable_entity
    end
  end

  def show
    @rows = (0..@board.height-1).to_a[@page_row.to_i * @limit_cell, @limit_cell]
    @cols = (0..@board.width-1).to_a[@page_col.to_i * @limit_cell, @limit_cell]

    if @rows.empty? || @cols.empty?
      redirect_to board_path(@board, page_row: 0, page_col: 0)
      return
    end

    @mines = @board.mines.where(x: @rows, y: @cols)
  end

  private

  def set_board
    @limit_cell = 20
    @page_row = (params[:page_row] || 0).to_i
    @page_col = (params[:page_col] || 0).to_i

    @board = Board.find(params[:id])
    @user = @board.user
  end  
  
  def set_ten_boards
    @boards = Board.includes(:user)
                   .order(created_at: :desc)
                   .page(1).per(10)
  end

  def set_default_form
    @form = CreateBoardForm.new
  end

  def board_params
    params.require(:create_board_form).permit(:name, :email, :width, :height, :num_mines)
  end

  def redirect_new
    redirect_to root_path
  end
end
