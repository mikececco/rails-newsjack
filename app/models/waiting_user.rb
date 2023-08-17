class WaitingUser < ApplicationRecord
  validates :email, presence: true, uniqueness: true
end
