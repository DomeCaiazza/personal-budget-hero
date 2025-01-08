require 'rails_helper'

RSpec.describe TransactionPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:guest) { create(:user, role: 'guest') }
  let(:scope) { Transaction.all }

  describe 'Scope' do
    it 'returns all transactions for admin' do
      expect(TransactionPolicy::Scope.new(admin, scope).resolve).to match_array(scope)
    end

    it 'returns all transactions for user' do
      expect(TransactionPolicy::Scope.new(user, scope).resolve).to match_array(scope)
    end

    it 'returns no transactions for guest' do
      expect(TransactionPolicy::Scope.new(guest, scope).resolve).to be_empty
    end
  end

  describe 'index?' do
    it 'allows access for admin' do
      expect(TransactionPolicy.new(admin, Transaction).index?).to be true
    end

    it 'allows access for user' do
      expect(TransactionPolicy.new(user, Transaction).index?).to be true
    end

    it 'denies access for guest' do
      expect(TransactionPolicy.new(guest, Transaction).index?).to be false
    end
  end

  describe 'generate_slug?' do
    it 'allows access for admin' do
      expect(TransactionPolicy.new(admin, Transaction).generate_slug?).to be true
    end

    it 'allows access for user' do
      expect(TransactionPolicy.new(user, Transaction).generate_slug?).to be true
    end

    it 'denies access for guest' do
      expect(TransactionPolicy.new(guest, Transaction).generate_slug?).to be false
    end
  end
end
