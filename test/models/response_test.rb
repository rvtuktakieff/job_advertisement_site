require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  setup do
    @response = create(:response)
  end

  attributes = [:price, :status]

  attributes.each do |attr|
    test "should have #{attr}" do
      @response.send("#{attr}=", nil)

      assert_equal @response.valid?, false
    end
  end

  test 'should have default value pending in status' do
    response_params = @response.attributes.except('id')
    response = Response.create(response_params)

    assert_equal response.status, 'pending'
  end

  test 'price must be between 100..10000' do
    @response.price = 99

    assert_equal @response.valid?, false

    @response.price = 10001

    assert_equal @response.valid?, false
  end

  test 'user must not be the announcement owner' do
    @response.user_id = @response.announcement.user_id

    assert_equal @response.valid?, false
  end
end
