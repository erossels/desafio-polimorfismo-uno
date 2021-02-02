class PaymentMethod < ApplicationRecord
  has_many :options, as: :optionable
end
