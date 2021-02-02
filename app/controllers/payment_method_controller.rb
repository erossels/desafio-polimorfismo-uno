class PaymentMethodController < ApplicationController
  def form
    @payment = Payment.new
    @payment_methods = PaymentMethod.all
  end
end
