require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get friends" do
    get :friends
    assert_response :success
  end

end
