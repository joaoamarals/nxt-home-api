# frozen_string_literal: true

class User
  validates :email, presence: true, uniqueness: true
end
