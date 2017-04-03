require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get rankings" do
    get pages_rankings_url
    assert_response :success
  end

end
