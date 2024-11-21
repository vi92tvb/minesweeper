class CreateBoardForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name
  attribute :email
  attribute :width
  attribute :height
  attribute :num_mines

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      board_name = name || Board.default_name

      resource = User.new(email: email, board_attributes: { name: board_name,
                                                            width: width.to_i,
                                                            height: height.to_i,
                                                            num_mines: num_mines.to_i })

      return [true, resource.board] if resource.save

      errors.merge!(resource.errors)
      raise ActiveRecord::Rollback
    end

    [false, nil]
  end
end
