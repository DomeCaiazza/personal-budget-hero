class Transaction < ApplicationRecord
  enum :transaction_type, { expense: 0, income: 1 }

  belongs_to :user
  belongs_to :category
  validates :transaction_type, presence: true
  validates :amount, :description, :date, :category_id, presence: true
  scope :expenses, -> { where(transaction_type: :expense) }
  scope :incomes, -> { where(transaction_type: :income) }

  def self.ransackable_attributes(auth_object = nil)
    %w[amount category_id created_at date description fixed id paid updated_at user_id category_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category user]
  end
end
