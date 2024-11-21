class Board < ApplicationRecord
  belongs_to :user, inverse_of: :board
  has_many :mines, inverse_of: :board, dependent: :destroy

  def self.default_name
    return "Board name"
  end
end
