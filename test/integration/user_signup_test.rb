require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "user should be able to sign up with username, email, and password" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {
          username: "John Doe",
          email: "johndoe@example.com",
          password: "password"
      }
    end
    assert_template 'users/show'
    assert_match "John Doe", response.body
  end

end