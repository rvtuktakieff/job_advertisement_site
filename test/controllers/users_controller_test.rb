require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'post /users' do
    assert_difference 'User.count', 1 do
      User.create
    end
  end
end
