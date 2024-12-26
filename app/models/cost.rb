class Cost < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates :amount, :description, :date, :category_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[amount category_id created_at date description fixed id paid updated_at user_id category_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category user]
  end

end
