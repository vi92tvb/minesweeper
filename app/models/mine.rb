class Mine < ApplicationRecord
  belongs_to :board, inverse_of: :mines
end
