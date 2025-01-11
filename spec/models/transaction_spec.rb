require 'rails_helper'
require 'devise'

RSpec.describe Transaction, type: :model do
  let(:expense_transaction) { FactoryBot.create(:transaction) }
  let(:income_transaction) { FactoryBot.create(:transaction, transaction_type: 'income') }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:category_id) }

    it "has a valid expense_transaction factory" do
      expect(expense_transaction).to be_valid
    end

    it "has a valid expense_transaction factory" do
      expect(income_transaction).to be_valid
    end

    it "is invalid without an amount" do
      expense_transaction.amount = nil
      expect(expense_transaction).to be_invalid
    end

    it "is invalid without a description" do
      expense_transaction.description = nil
      expect(expense_transaction).to be_invalid
    end

    it "is invalid without a date" do
      expense_transaction.date = nil
      expect(expense_transaction).to be_invalid
    end

    it "is invalid without a category_id" do
      expense_transaction.category_id = nil
      expect(expense_transaction).to be_invalid
    end

    it "is invalid without a user_id" do
      expense_transaction.user_id = nil
      expect(expense_transaction).to be_invalid
    end

    it "is invalid with wrong transaction_type" do
      expect { expense_transaction.transaction_type = 'wrong' }.to raise_error(ArgumentError)
    end
  end

  describe 'scopes' do
    it "returns only expense transactions" do
      expense_transaction = FactoryBot.create(:transaction, transaction_type: :expense)
      income_transaction = FactoryBot.create(:transaction, transaction_type: :income)
      expect(Transaction.expenses).to include(expense_transaction)
      expect(Transaction.expenses).not_to include(income_transaction)
    end

    it "returns only income transactions" do
      expense_transaction = FactoryBot.create(:transaction, transaction_type: :expense)
      income_transaction = FactoryBot.create(:transaction, transaction_type: :income)
      expect(Transaction.incomes).to include(income_transaction)
      expect(Transaction.incomes).not_to include(expense_transaction)
    end
  end

  describe 'ransackable attributes/associations' do
    it 'returns the correct attributes' do
      expect(Transaction.ransackable_attributes).to match_array(%w[amount category_id created_at date description id paid updated_at user_id category_name])
    end

    it 'returns the correct associations' do
      expect(Transaction.ransackable_associations).to match_array(%w[category user])
    end
  end

  describe 'before_save' do
    it "sets a positive amount to negative for expense transactions" do
      transaction = FactoryBot.build(:transaction, transaction_type: 'expense', amount: 100, category: FactoryBot.create(:category))
      transaction.save
      expect(transaction.amount).to eq(-100.to_d)
    end

    it "keeps a negative amount for expense transactions" do
      transaction = FactoryBot.build(:transaction, transaction_type: 'expense', amount: -100)
      transaction.save
      expect(transaction.amount).to eq(-100)
    end

    it "sets a negative amount to positive for income transactions" do
      transaction = FactoryBot.build(:transaction, transaction_type: 'income', amount: -100, category: FactoryBot.create(:category))
      transaction.save
      expect(transaction.amount).to eq(100)
    end

    it "keeps a positive amount for income transactions" do
      transaction = FactoryBot.build(:transaction, transaction_type: 'income', amount: 100)
      transaction.save
      expect(transaction.amount).to eq(100)
    end
  end
end
