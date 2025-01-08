class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions
  validates :name, :hex_color, presence: true
  validates :name, uniqueness: true

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
