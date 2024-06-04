class AnnouncementSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :description, :status
  has_many :responses
end
