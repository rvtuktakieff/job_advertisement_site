class ResponseSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :price, :status
end
