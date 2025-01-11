class Category < ApplicationRecord
  enum :category_type, { expenses: 0, incomes: 1 }
  belongs_to :user
  has_many :transactions
  validates :name, :hex_color, presence: true
  validates :name, uniqueness: true
  validates :hex_color, format: { with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/ }
  validates :category_type, presence: true

  scope :expenses, -> { where(category_type: :expenses) }
  scope :incomes, -> { where(category_type: :incomes) }

  class << self
    alias :expense :expenses
    alias :income :incomes
  end

  before_destroy :check_for_transactions


  def self.ransackable_attributes(auth_object = nil)
    %w[created_at hex_color id name updated_at user_id]
  end

  private

  def check_for_transactions
    if transactions.exists?
      errors.add(:base, "Cannot delete category with associated transactions")
      throw(:abort)
    end
  end
end
