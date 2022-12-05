require "test_helper"

class ConvosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get convos_index_url
    assert_response :success
  end
end
