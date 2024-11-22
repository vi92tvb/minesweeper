class CreateBoardForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name
  attribute :email
  attribute :width
  attribute :height
  attribute :num_mines

  validates :num_mines, numericality: { 
    less_than_or_equal_to: ->(form) { form.width.to_i * form.height.to_i }, 
    message: ->(form, data) { 
      "Number of mines cannot be greater than the total number of cells on the board"
    }
  }  

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      board_name = name || Board.default_name

      user = User.find_or_initialize_by(email: email)
      user.save

      board = Board.new(
        user_id: user.id,
        name: board_name,
        width: width.to_i,
        height: height.to_i,
        num_mines: num_mines.to_i
      )

      return [true, board] if board.save

      errors.merge!(board.errors)
      raise ActiveRecord::Rollback
    end

    [false, nil]
  end
end
