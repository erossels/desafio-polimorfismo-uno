class PaymentMethodController < ApplicationController
  def form
    @payment = Payment.new
  end
end
