class Transaction < ApplicationRecord
  enum :transaction_type, { expense: 0, income: 1 }
  before_save :set_sign

  belongs_to :user
  belongs_to :category
  validates :transaction_type, presence: true
  validates :amount, :description, :date, :category_id, presence: true
  scope :expenses, -> { where(transaction_type: :expense) }
  scope :incomes, -> { where(transaction_type: :income) }

  def self.ransackable_attributes(auth_object = nil)
    %w[amount category_id created_at date description id paid updated_at user_id category_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category user]
  end

  private

  def set_sign
    if self.transaction_type == "expense"
      self.amount = -self.amount if self.amount > 0
    elsif self.transaction_type == "income"
      self.amount = -self.amount if self.amount < 0
    end
  end
end
