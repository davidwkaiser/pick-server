require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "Controller should render user profile" do
    get(:show, {'id' => users(:jimi).id})
    assert_response :success
    # assert_not_nil assigns(:posts)
  end

test "controller should create a user" do
  assert_difference('User.count') do
   post :create, {
      :username => 'Beyonce',
      :password => 'password',
      :zipcode => '60601'
    }
    end
  # assert_redirected_to post_path(assigns(:post))
  end
end
