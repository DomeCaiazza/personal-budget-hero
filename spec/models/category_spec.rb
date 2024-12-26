require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryBot.create(:category) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:costs) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:hex_color) }
  end

  describe 'validations' do
    it "has a valid factory" do
      expect(category).to be_valid
    end

    it "is valid with valid attributes" do
      expect(category).to be_valid
    end

    it "is invalid without name" do
      category.name = nil
      expect(category).to be_invalid
    end

    it "is invalid without hex_color" do
      category.hex_color = nil
      expect(category).to be_invalid
    end
  end

  describe 'before destroy callback' do
    it 'prevents deletion if there are associated costs' do
      category_with_costs = FactoryBot.create(:category)
      FactoryBot.create(:cost, category: category_with_costs)
      expect { category_with_costs.destroy }.not_to change(Category, :count)
      expect(category_with_costs.errors[:base]).to include("Cannot delete category with associated costs")
    end

    it 'allows deletion if there are no associated costs' do
      category_without_costs = FactoryBot.create(:category)
      expect { category_without_costs.destroy }.to change(Category, :count).by(-1)
    end
  end

  describe 'ransackable attributes' do
    it 'returns the correct attributes' do
      expect(Category.ransackable_attributes).to match_array(%w[created_at hex_color id name updated_at user_id])
    end
  end
end
