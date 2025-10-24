class Account < ApplicationRecord
  has_many :account_users, dependent: :destroy
  has_many :users, through: :account_users

  has_many :transactions, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true
end
