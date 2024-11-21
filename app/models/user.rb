class User < ApplicationRecord
  has_one :board, inverse_of: :user

  accepts_nested_attributes_for :board, allow_destroy: true
end
