require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  setup do
    @announcement = create(:announcement)
  end

  attributes = [:description, :user_id, :status]

  attributes.each do |attr|
    test "should have #{attr}" do
      @announcement.send("#{attr}=", nil)

      assert_equal @announcement.valid?, false
    end
  end

  test 'should have default value active in status' do
    announcement_params = @announcement.attributes.except('id')
    announcement = Announcement.create(announcement_params)

    assert_equal announcement.status, 'active'
  end

  test 'description must be less than 1000 characters' do
    @announcement.description = '1' * 1001

    assert_equal @announcement.valid?, false
  end
end
