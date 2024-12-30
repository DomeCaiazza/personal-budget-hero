require 'rails_helper'

RSpec.describe CostPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:guest) { create(:user, role: 'guest') }
  let(:scope) { Cost.all }

  describe 'Scope' do
    it 'returns all costs for admin' do
      expect(CostPolicy::Scope.new(admin, scope).resolve).to match_array(scope)
    end

    it 'returns all costs for user' do
      expect(CostPolicy::Scope.new(user, scope).resolve).to match_array(scope)
    end

    it 'returns no costs for guest' do
      expect(CostPolicy::Scope.new(guest, scope).resolve).to be_empty
    end
  end

  describe 'index?' do
    it 'allows access for admin' do
      expect(CostPolicy.new(admin, Cost).index?).to be true
    end

    it 'allows access for user' do
      expect(CostPolicy.new(user, Cost).index?).to be true
    end

    it 'denies access for guest' do
      expect(CostPolicy.new(guest, Cost).index?).to be false
    end
  end

  describe 'generate_slug?' do
    it 'allows access for admin' do
      expect(CostPolicy.new(admin, Cost).generate_slug?).to be true
    end

    it 'allows access for user' do
      expect(CostPolicy.new(user, Cost).generate_slug?).to be true
    end

    it 'denies access for guest' do
      expect(CostPolicy.new(guest, Cost).generate_slug?).to be false
    end
  end
end
