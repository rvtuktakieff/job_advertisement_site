class Response < ApplicationRecord
  include AASM

  belongs_to :announcement
  belongs_to :user

  validates :price, :status, presence: true
  validates :price, numericality: { in: 100..10000 }

  aasm column: 'status' do
    state :pending, initial: true
    state :cancelled
    state :declined
    state :accepted

    event :cancel do
      transitions from: :pending, to: :cancelled
    end

    event :decline do
      transitions from: :pending, to: :declined
    end

    event :accept do
      transitions from: :pending, to: :accepted
    end
  end
end
