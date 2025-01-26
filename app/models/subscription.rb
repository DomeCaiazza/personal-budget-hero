class Subscription < ApplicationRecord
  enum :subscription_type, { monthly: 0, annual: 1, quarterly: 2, semiannual: 3 }
  belongs_to :user
  validates :description, :default_amount, :subscription_type, presence: true
  validates :code, uniqueness: true
  before_create :create_subscription_code

  private

  def create_subscription_code
    self.code = SecureRandom.hex(10)
  end
end
