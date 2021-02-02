class PaymentsController < ApplicationController
  before_action :set_payment, only: [:edit, :update]

  def new
    @payment = Payment.new
  end

  def edit
    @payment_methods = PaymentMethod.all
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.status = 'created'
    @payment.total = 10_000
    @payment.payment_method_id = params[:payment][:payment_method_id]
    @payment.save
    @payment.option = nil

    if @payment.payment_method_id == 3 && @payment.option.nil?
      redirect_to edit_payment_path(@payment.id) and return
    end

    respond_to do |format|
      if @payment.save
        format.html { redirect_to root_path, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { redirect_to root_path, notice: 'Payment failed' }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @payment.save
        format.html { redirect_to root_path, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { redirect_to root_path, notice: 'Payment failed' }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end 

  private
  # Only allow a list of trusted parameters through.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:id, :order_id, :payment_method_id, :options_id)
  end

end
