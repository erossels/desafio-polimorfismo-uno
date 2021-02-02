require 'test_helper'

class PaymentMethodControllerTest < ActionDispatch::IntegrationTest
  test "should get form" do
    get payment_method_form_url
    assert_response :success
  end

end
