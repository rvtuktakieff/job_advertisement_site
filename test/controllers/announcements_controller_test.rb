require 'test_helper'

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create
    @announcement = create(:announcement, user_id: @user.id)
  end

  test 'get /announcements/my' do
    get '/announcements/my', headers: { "Authorization": "Bearer #{@user.id}" }

    announcements = Announcement.where(user_id: @user.id).
      map do |el|
      el.attributes.except('updated_at', 'created_at').
        merge({ responses: el.responses })
    end

    data = JSON.parse(response.body)

    assert_response :ok
    assert_equal data, JSON.parse(announcements.to_json)
  end

  test 'get /announcements/my without token' do
    get '/announcements/my'

    assert_response :unauthorized
  end

  test 'get /announcements/my when announcement not created' do
    user = User.create

    get '/announcements/my', headers: { "Authorization": "Bearer #{user.id}" }

    assert_response :forbidden
  end

  test 'get /announcements/active' do
    get '/announcements/active'

    announcements = Announcement.active.map { |el| el.attributes.except('updated_at', 'created_at') }.to_json
    data = JSON.parse(response.body)

    assert_response :ok
    assert_equal data, JSON.parse(announcements)
  end

  test 'post /announcements with token' do
    announcement_params = { description: 'Тестовое объявление' }
    post '/announcements', params: { announcement: announcement_params },
                           headers: { 'Authorization': "Bearer #{@user.id}" }

    data = JSON.parse(response.body)
    announcement = data.merge(announcement_params.stringify_keys)

    assert_response :created
    assert_equal data, announcement
  end

  test 'post /announcements with token and invalid attributes' do
    announcement_params = {}
    post '/announcements', params: { announcement: announcement_params },
                           headers: { 'Authorization' => "Bearer #{@user.id}" }

    assert_response :bad_request
  end

  test 'post /announcements withot token' do
    announcement_params = { description: 'Тестовое объявление' }
    post '/announcements', params: { announcement: announcement_params }

    assert_response :unauthorized
  end

  test 'post /announcements/:id/cancel with token' do
    create(:response, announcement_id: @announcement.id)

    post "/announcements/#{@announcement.id}/cancel", headers: { 'Authorization': "Bearer #{@user.id}" }

    @announcement.responses.each do |resp|
      assert_equal resp.declined?, true
    end

    @announcement.reload

    assert_response :ok
    assert_equal @announcement.cancelled?, true
  end

  test 'post /announcements/:id/cancel with invalid token' do
    create(:response, announcement_id: @announcement.id)

    post "/announcements/#{@announcement.id}/cancel", headers: { 'Authorization': "Bearer #{@user.id + 1}" }

    assert_response :forbidden
  end

  test 'post /announcements/:id/cancel without token' do
    create(:response, announcement_id: @announcement.id)

    post "/announcements/#{@announcement.id}/cancel"

    assert_response :unauthorized
  end
end
