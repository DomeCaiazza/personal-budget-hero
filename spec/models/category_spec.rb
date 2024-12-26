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
end
