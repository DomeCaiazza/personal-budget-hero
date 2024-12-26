require 'rails_helper'
require 'devise'

RSpec.describe Cost, type: :model do
  let(:cost) { FactoryBot.create(:cost) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:category_id) }

    it "has a valid factory" do
      expect(cost).to be_valid
    end

    it "is invalid without an amount" do
      cost.amount = nil
      expect(cost).to be_invalid
    end

    it "is invalid without a description" do
      cost.description = nil
      expect(cost).to be_invalid
    end

    it "is invalid without a date" do
      cost.date = nil
      expect(cost).to be_invalid
    end

    it "is invalid without a category_id" do
      cost.category_id = nil
      expect(cost).to be_invalid
    end

    it "is invalid without a user_id" do
      cost.user_id = nil
      expect(cost).to be_invalid
    end
  end
end
