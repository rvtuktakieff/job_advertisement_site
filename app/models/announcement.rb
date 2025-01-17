class Announcement < ApplicationRecord
  include AASM

  belongs_to :user
  has_many :responses

  validates :description, :status, presence: true
  validates :description, length: { maximum: 1000 }

  aasm column: 'status' do
    state :active, initial: true
    state :cancelled, before_enter: -> { responses.each(&:decline!) }
    state :closed, before_enter: -> { responses.each { |resp| resp.decline! if resp.may_decline? } }

    event :cancel do
      transitions from: :active, to: :cancelled
    end

    event :close do
      transitions from: :active, to: :closed
    end
  end
end
