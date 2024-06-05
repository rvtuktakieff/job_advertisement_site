require 'test_helper'

class ResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_announcement = User.create
    @announcement = create(:announcement, user_id: @user_announcement.id)
    @user_response = User.create
    @resp = create(:response, announcement_id: @announcement.id, user_id: @user_response.id)
  end

  test 'post /announcements/:id/responses with token' do
    response_params = { price: 2000 }
    post "/announcements/#{@announcement.id}/responses", params: { response: response_params },
                                                         headers: { "Authorization": "Bearer #{@user_response.id}" }

    data = JSON.parse(response.body)
    resp = data.merge(response_params.stringify_keys)

    assert_response :created
    assert_equal data, resp
  end

  test 'post /announcements/:id/responses with invalid params' do
    post "/announcements/#{@announcement.id}/responses", params: { response: {} },
                                                         headers: { "Authorization": "Bearer #{@user_response.id}" }

    assert_response :bad_request
  end

  test 'post /announcements/:id/responses on non active announcement' do
    response_params = { price: 2000 }
    non_active_announcement = create(:announcement)
    non_active_announcement.cancel!

    post "/announcements/#{non_active_announcement.id}/responses", params: { response: response_params },
                                                                   headers: { "Authorization": "Bearer #{@user_response.id}" }

    assert_response :bad_request
  end

  test 'post /announcements/:id/responses witn invalid token' do
    response_params = { price: 2000 }
    post "/announcements/#{@announcement.id}/responses", params: { response: response_params },
                                                         headers: { "Authorization": "Bearer #{@user_announcement.id}" }

    assert_response :bad_request
  end

  test 'post /announcements/:id/responses without token' do
    response_params = { price: 2000 }
    post "/announcements/#{@announcement.id}/responses", params: { response: response_params }

    assert_response :unauthorized
  end

  # accept

  test 'post /announcements/:announcements_id/responses/:id/accept with token' do
    post "/announcements/#{@announcement.id}/responses/#{@resp.id}/accept",
         headers: { "Authorization": "Bearer #{@user_announcement.id}" }

    @announcement.reload
    @resp.reload

    assert_response :ok
    assert_equal @resp.accepted?, true
    assert_equal @announcement.closed?, true
  end

  test 'post /announcements/:announcements_id/responses/:id/accept with invalid token' do
    post "/announcements/#{@announcement.id}/responses/#{@resp.id}/accept",
         headers: { "Authorization": "Bearer #{@user_announcement.id + 1}" }

    assert_response :bad_request
  end

  test 'post /announcements/:announcements_id/responses/:id/accept without token' do
    post "/announcements/#{@announcement.id}/responses/#{@resp.id}/accept"

    assert_response :unauthorized
  end

  # cancel

  test 'post /announcements/:announcements_id/responses/:id/cancel with token' do
    post "/announcements/#{@announcement.id}/responses/#{@resp.id}/cancel",
         headers: { "Authorization": "Bearer #{@user_response.id}" }

    @resp.reload

    assert_response :ok
    assert_equal @resp.cancelled?, true
  end

  test 'post /announcements/:announcements_id/responses/:id/cancel with invalid token' do
    post "/announcements/#{@announcement.id}/responses/#{@resp.id}/cancel",
         headers: { "Authorization": "Bearer #{@user_announcement.id}" }

    assert_response :bad_request
  end

  test 'post /announcements/:announcements_id/responses/:id/cancel without token' do
    post "/announcements/#{@announcement.id}/responses/#{@resp.id}/cancel"

    assert_response :unauthorized
  end
end
